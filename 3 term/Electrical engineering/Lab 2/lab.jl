# Электротехника, лаб. раб. №33, Г. Н. Анисимов

to_complex(a, ϕ) = a * exp(im * ϕ)

resistance_om(U) = U / I
voltage_om(z) = I * z
current_om(cU, z) = cU / z

function print_fmt(name, vec, digits=3)
    println("Alg. $name = $(string.(round.(vec; digits=digits)))")
    As = round.(abs.(vec); digits=digits)
    ϕs = round.(rad2deg.(angle.(vec)); digits=digits)
    pack(A, ϕ) = "A = $A, ϕ = $ϕ"
    nums = pack.(As, ϕs)
    println("Exp. $name = $(nums)")
end

function print_error(name, calculated, experimental)
    val = round(abs(experimental - calculated) / abs(experimental) * 100, digits=3)
    println("Error of $name = $val%")
end

function print_error_complex(name, calculated, experimental)
    calc_abs = abs(calculated)
    experim_abs = abs(experimental)

    calc_phase = angle(calculated)
    experim_phase = angle(experimental)

    print_error("|$name|", calc_abs, experim_abs)
    print_error("phase($name)", calc_phase, experim_phase)
end

I = 1

s_ϕs = deg2rad.([-2, -50, 32])
s_Us_real = [92, 111, 95]
s_Us = to_complex.(s_Us_real, s_ϕs)

s_zs = resistance_om.(s_Us)
s_Ys = map(r -> 1 / r, s_zs)
common_s_z = sum(s_zs)
common_s_U = common_s_z * I
s_U_experimental = 250 * exp(im * deg2rad(-9))

println("======== Serial ========")
print_fmt("zk", s_zs);
print_fmt("Yk", s_Ys, 15)
print_fmt("z", common_s_z)
print_fmt("U exp", s_U_experimental)
print_fmt("U", common_s_U)

m_U_real = 164
m_U_ϕ = deg2rad(-3)
m_U1_real = 94
m_U1_ϕ = deg2rad(-2)
m_U23_real = 69
m_U23_ϕ = deg2rad(-6)

m_U_exp = to_complex(m_U_real, m_U_ϕ)
m_U1_exp = to_complex(m_U1_real, m_U1_ϕ)
m_U23_exp = to_complex(m_U23_real, m_U23_ϕ)

m_z23 = (s_zs[2] * s_zs[3]) / (s_zs[2] + s_zs[3])
m_U1 = voltage_om(s_zs[1])
m_U23 = voltage_om(m_z23)
m_U = m_U1 + m_U23
m_Is = current_om.(m_U23, [s_zs[2], s_zs[3]])
m_I = sum(m_Is)

println()
println("======== Mixed ========")
print_fmt("U exp.", m_U_exp)
print_fmt("U1 exp.", m_U1_exp)
print_fmt("U23 exp.", m_U23_exp)
print_fmt("U", m_U)
print_fmt("U1", m_U1)
print_fmt("U23", m_U23)
print_fmt("Ik", m_Is)
print_fmt("I", m_I)

p_ϕ = deg2rad(-4)
p_U = 40 * exp(im * p_ϕ)
p_Is = current_om.(p_U, s_zs)
p_Y = sum(s_Ys)
p_I_fromY = p_U * p_Y
p_I_fromSum = sum(p_Is)

println()
println("======== Parallel ========")
print_fmt("U", p_U)
print_fmt("Ik", p_Is)
print_fmt("Y", p_Y, 6)
print_fmt("I from Y", p_I_fromY, 4)
print_fmt("I from sum", p_I_fromSum, 4)

println("======== Errors ========")
print_error_complex("Serial U", common_s_U, s_U_experimental)
print_error_complex("Mixed U", m_U_exp, m_U)
print_error_complex("Mixed U1", m_U1_exp, m_U1)
print_error_complex("Mixed U23", m_U23_exp, m_U23)
print_error_complex("Parallel I from Y", I, p_I_fromY)
print_error_complex("Parallel I from Sum", I, p_I_fromSum)
