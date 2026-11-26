include("expert_system.jl")

const CRITERIA = [
    Criterion(:segment, "Тип заказа", [
        :soldiers => "военнослужащие", :school => "школьный", :ordinary => "обычный",
    ]),
    Criterion(:season_design, "Сезонный дизайн", [
        :needed => "нужно разработать", :ready => "готов",
    ]),
    Criterion(:photos, "Фотографии для школьного макета", [
        :pending => "выбранные семьёй фотографии ещё не получены",
        :selected => "выбранные семьёй фотографии получены",
    ]),
    Criterion(:mockup, "Школьный макет", [
        :pending => "ещё не готов", :ready => "готов",
    ]),
    Criterion(:preview, "Предпросмотр школьного макета", [
        :unsent => "ещё не отправлен", :waiting => "отправлен, ждём ответ",
        :revision => "получены замечания", :approved => "согласован",
    ]),
    Criterion(:client_brief, "Требования обычного клиента", [
        :pending => "ещё не согласованы", :agreed => "согласованы",
    ]),
    Criterion(:design_source, "Дизайн обычного заказа", [
        :custom => "индивидуальный", :library => "из библиотеки",
    ]),
    Criterion(:design, "Готовность дизайна обычного заказа", [
        :pending => "ещё не готов", :ready => "готов",
    ]),
    Criterion(:production, "Состояние производства", [
        :pending => "материалы ещё не готовы к печати",
        :prepared => "материалы готовы к печати", :printed => "напечатано",
        :assembled => "изделия собраны",
    ]),
    Criterion(:video, "Видео готовых изделий для родителя", [
        :pending => "ещё не записано", :recorded => "записано", :sent => "отправлено",
    ]),
    Criterion(:dispatch, "Отправка заказа", [
        :unpacked => "ещё не упакован", :packed => "упакован",
        :dispatched => "передан на отправку или выдан",
    ]),
]

function photo_knowledge_base()
    school = [:segment => :school]
    season_ready = [school; :season_design => :ready]
    selected = [season_ready; :photos => :selected]
    mockup_ready = [selected; :mockup => :ready]
    approved = [mockup_ready; :preview => :approved]

    school_assembled = [approved; :production => :assembled]

    soldiers = [:segment => :soldiers]
    soldiers_assembled = [soldiers; :production => :assembled]
    soldiers_video_sent = [soldiers_assembled; :video => :sent]

    ordinary = [:segment => :ordinary]
    brief_agreed = [ordinary; :client_brief => :agreed]
    ordinary_ready = [brief_agreed; :design => :ready]
    ordinary_assembled = [ordinary_ready; :production => :assembled]

    pack = "Упаковать готовый заказ."
    dispatch = "Выдать или отправить заказ согласованным способом."
    complete = "Заказ передан получателю или отправлен."

    rules = [
        Rule(:school_season_design, [school; :season_design => :needed],
             "Разработать единый дизайн школьных фотокниг на сезон."),
        Rule(:school_select_photos, [season_ready; :photos => :pending],
             "Запросить у семьи выбранные фотографии для школьного макета."),
        Rule(:school_make_mockup, [selected; :mockup => :pending],
             "Подготовить макет из отобранных фотографий в сезонном дизайне."),
        Rule(:school_send_preview, [mockup_ready; :preview => :unsent],
             "Отправить родителям предпросмотр школьного макета на согласование."),
        Rule(:school_await_reply, [mockup_ready; :preview => :waiting],
             "Дождаться явного согласования предпросмотра родителями перед печатью."),
        Rule(:school_revise_mockup, [mockup_ready; :preview => :revision],
             "Исправить макет и отправить новый предпросмотр на согласование."),
        Rule(:school_print, [approved; :production => :prepared],
             "Напечатать согласованный школьный макет на фотолаборатории Fujitsu."),
        Rule(:school_prepare, [approved; :production => :pending],
             "Подготовить согласованный школьный макет к печати."),
        Rule(:school_assemble, [approved; :production => :printed],
             "Собрать и переплести фотокниги."),
        Rule(:school_pack, [school_assembled; :dispatch => :unpacked], pack),
        Rule(:school_dispatch, [school_assembled; :dispatch => :packed], dispatch),
        Rule(:school_complete, [school_assembled; :dispatch => :dispatched], complete),

        Rule(:soldiers_prepare, [soldiers; :production => :pending],
             "Отретушировать фотографии и подготовить макеты фотокниги и холста."),
        Rule(:soldiers_print, [soldiers; :production => :prepared],
             "Напечатать развороты фотокниги на фотолаборатории Fujitsu и холст на Epson."),
        Rule(:soldiers_assemble, [soldiers; :production => :printed],
             "Собрать и переплести фотокнигу. Натянуть холст на подрамник."),
        Rule(:soldiers_record, [soldiers_assembled; :video => :pending],
             "Записать для родителя видео, показывающее фотокнигу и холст его заказа."),
        Rule(:soldiers_send_video, [soldiers_assembled; :video => :recorded],
             "Отправить родителю в WhatsApp запись фотокниги и холста его заказа."),
        Rule(:soldiers_pack, [soldiers_video_sent; :dispatch => :unpacked],
             "Упаковать фотокнигу и холст одного заказа вместе."),
        Rule(:soldiers_dispatch, [soldiers_video_sent; :dispatch => :packed],
             "Отправить упаковку с фотокнигой и холстом через Казпочту."),
        Rule(:soldiers_complete, [soldiers_video_sent; :dispatch => :dispatched],
             "Заказ отправлен."),

        Rule(:ordinary_discuss, [ordinary; :client_brief => :pending],
             "Обсудить с клиентом требования, изделия и способ получения."),
        Rule(:ordinary_custom_design, [brief_agreed; :design_source => :custom; :design => :pending],
             "Подготовить индивидуальный дизайн по требованиям клиента."),
        Rule(:ordinary_library_design, [brief_agreed; :design_source => :library; :design => :pending],
             "Подобрать дизайн из библиотеки и адаптировать его под заказ."),
        Rule(:ordinary_prepare, [ordinary_ready; :production => :pending],
             "Подготовить фотографии и макет заказанных изделий к печати."),
        Rule(:ordinary_print, [ordinary_ready; :production => :prepared],
             "Напечатать заказанные развороты на Fujitsu или холст на Epson по составу заказа."),
        Rule(:ordinary_assemble, [ordinary_ready; :production => :printed],
             "Собрать изделия по заказу. Выполнить переплёт фотокниги и натяжку холста, если они заказаны."),
        Rule(:ordinary_pack, [ordinary_assembled; :dispatch => :unpacked], pack),
        Rule(:ordinary_dispatch, [ordinary_assembled; :dispatch => :packed], dispatch),
        Rule(:ordinary_complete, [ordinary_assembled; :dispatch => :dispatched], complete),
    ]

    return KnowledgeBase(CRITERIA, rules, photo_inconsistencies())
end

function photo_inconsistencies()
    school = [:segment => :school]
    soldiers = [:segment => :soldiers]
    inconsistencies = Rule[]
    unfinished_mockup = [:season_design => :needed, :photos => :pending, :mockup => :pending]
    for preview in (:waiting, :revision, :approved), prerequisite in unfinished_mockup
        push!(inconsistencies, Rule(:school_preview_requires_mockup,
            [school; prerequisite; :preview => preview],
            "Предпросмотр отмечен как отправленный до завершения подготовки школьного макета."))
    end
    for production in (:printed, :assembled), preview in (:unsent, :waiting, :revision)
        push!(inconsistencies, Rule(:school_output_requires_approval,
            [school; :production => production; :preview => preview],
            "Школьный заказ отмечен как напечатанный, а предпросмотр ещё не согласован."))
    end
    for production in (:pending, :prepared, :printed), video in (:recorded, :sent)
        push!(inconsistencies, Rule(:soldiers_video_requires_assembly,
            [soldiers; :production => production; :video => video],
            "Видео готовых изделий отмечено как записанное до завершения сборки."))
    end
    for dispatch in (:packed, :dispatched), video in (:pending, :recorded)
        push!(inconsistencies, Rule(:soldiers_packing_requires_video,
            [soldiers; :dispatch => dispatch; :video => video],
            "Заказ отмечен как упакованный, а видео для родителя ещё не отправлено."))
    end

    return inconsistencies
end
