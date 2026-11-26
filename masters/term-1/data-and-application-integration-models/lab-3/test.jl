using Test
include("solve.jl")

const BASE = photo_knowledge_base()

@testset "Школьные заказы" begin
    @test infer(BASE, SCHOOL_3).criterion.key == :mockup
    @test infer(BASE, SCHOOL_4).criterion.key == :preview
    @test infer(BASE, SCHOOL_5).criterion.key == :production
    awaiting_photos = [:segment => :school, :season_design => :ready, :photos => :pending]
    @test infer(BASE, awaiting_photos).rule.action ==
          "Запросить у семьи выбранные фотографии для школьного макета."
    @test infer(BASE, [SCHOOL_3; :mockup => :pending]).rule.id == :school_make_mockup
    @test infer(BASE, [SCHOOL_4; :preview => :unsent]).rule.id == :school_send_preview
    @test infer(BASE, [SCHOOL_4; :preview => :waiting]).rule.id == :school_await_reply
    @test infer(BASE, [SCHOOL_4; :preview => :revision]).rule.id == :school_revise_mockup
    @test infer(BASE, [SCHOOL_4; :production => :prepared]).criterion.key == :preview
    @test infer(BASE, [SCHOOL_5; :production => :prepared]).rule.id == :school_print
    @test infer(BASE, [SCHOOL_5; :production => :printed]).rule.id == :school_assemble
    @test infer(BASE, [SCHOOL_3; :mockup => :pending; :preview => :approved]).status == :conflict
    @test infer(BASE, [SCHOOL_4; :preview => :waiting; :production => :printed]).status == :conflict
end

@testset "Заказы военнослужащих" begin
    soldiers = [:segment => :soldiers]
    @test infer(BASE, [soldiers; :production => :pending]).rule.id == :soldiers_prepare
    @test infer(BASE, [soldiers; :production => :prepared]).rule.id == :soldiers_print
    @test infer(BASE, [soldiers; :production => :printed]).rule.id == :soldiers_assemble
    assembled = [soldiers; :production => :assembled]
    @test infer(BASE, [assembled; :video => :pending]).rule.id == :soldiers_record
    @test infer(BASE, [assembled; :video => :recorded]).rule.id == :soldiers_send_video
    sent = [assembled; :video => :sent]
    @test infer(BASE, [sent; :dispatch => :unpacked]).rule.id == :soldiers_pack
    @test infer(BASE, [sent; :dispatch => :packed]).rule.id == :soldiers_dispatch
    @test infer(BASE, [sent; :dispatch => :dispatched]).rule.id == :soldiers_complete
    @test infer(BASE, [soldiers; :production => :printed; :video => :sent]).status == :conflict
    @test infer(BASE, [assembled; :video => :recorded; :dispatch => :packed]).status == :conflict
end

@testset "Обычные заказы" begin
    ordinary = [:segment => :ordinary]
    @test infer(BASE, [ordinary; :client_brief => :pending]).rule.id == :ordinary_discuss
    agreed = [ordinary; :client_brief => :agreed]
    @test infer(BASE, [agreed; :design_source => :custom; :design => :pending]).rule.id == :ordinary_custom_design
    @test infer(BASE, [agreed; :design_source => :library; :design => :pending]).rule.id == :ordinary_library_design
    @test infer(BASE, [agreed; :design => :ready; :production => :printed]).rule.id == :ordinary_assemble
    facts = [agreed; :design => :ready; :production => :assembled; :dispatch => :packed]
    @test infer(BASE, facts).rule.id == :ordinary_dispatch
end

@testset "Неполные и противоречивые наблюдения" begin
    @test infer(BASE, []).criterion.key == :segment
    @test infer(BASE, [:segment => :school, :segment => :ordinary]).status == :conflict
    @test infer(BASE, [SCHOOL_3; :segment => :school]).criterion.key == :mockup
    @test infer(BASE, [:segment => :other]).status == :invalid
    @test infer(BASE, [:extra => :value]).status == :invalid
end

@testset "Добавление критерия без изменения вывода" begin
    preview_is_approved = Rule(:print, SCHOOL_5, "Печатать.")
    initial_base = KnowledgeBase(BASE.criteria[1:5], [preview_is_approved], Rule[])
    @test infer(initial_base, SCHOOL_5).rule.id == :print

    materials = Criterion(:materials, "Материалы для печати", [:available => "в наличии"])
    print_conditions = [preview_is_approved.conditions; :materials => :available]
    extended_base = KnowledgeBase([initial_base.criteria; materials],
                                  [Rule(:print, print_conditions, "Печатать.")], Rule[])
    @test infer(extended_base, SCHOOL_5).criterion.key == :materials
    @test infer(extended_base, [SCHOOL_5; :materials => :available]).rule.id == :print

    overlap = KnowledgeBase(BASE.criteria[1:5],
                           [preview_is_approved, Rule(:different, SCHOOL_5, "Другое действие.")],
                           Rule[])
    @test infer(overlap, SCHOOL_5).status == :conflict
    @test infer(initial_base, [:segment => :soldiers]).status == :uncovered
end

@testset "Интерактивный ввод" begin
    input = IOBuffer("2\n2\n2\n2\n2\n")
    output = IOBuffer()
    interactive(input, output, BASE)
    @test occursin("Правило school_await_reply", String(take!(output)))
    @test parse_observations(["segment=school"]) == [:segment => :school]
    @test_throws ArgumentError parse_observations(["segment"])
end
