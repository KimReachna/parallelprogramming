using BenchmarkTools
using SpecialFunctions
using FLoops
BenchmarkTools.DEFAULT_PARAMETERS.seconds = 0.1

function trapez_formul(f, a, b, n)
    h = (b - a) / n
    integral = 0.5 * (f(a) + f(b))
    integral += sum(f(a + x * h) for x in 1:n-1)
    integral *= h
    return integral
end

function Gauss_Legendre_formul(f, a, b, n)
    x, w = Gauss_Legendre_polynomials(n)
    integral = 0.0
    @floop for i in 1:n
        t = ((b - a) * x[i] + (b + a)) / 2
        @reduce integral += w[i] * f(t)
    end
    integral *= (b - a) / 2
    return integral
end

function Gauss_Legendre_polynomials(n)
    x, w = Array{Float64}(undef, n), Array{Float64}(undef, n)
    m = div(n + 1, 2)
    for i in 1:m
        z, pp = cos(pi * (i - 0.25) / (n + 0.5)), 0.0
        while true
            p1, p2 = 1.0, 0.0
            for j in 1:n
                p3 = p2
                p2 = p1
                p1 = ((2.0 * j - 1.0) * z * p2 - (j - 1.0) * p3) / j
            end
            pp = n * (z * p1 - p2) / (z^2 - 1.0)
            z = z - p1 / pp
            if abs(p1 / pp) < 1e-12
                break
            end
        end
        x[i] = -z
        x[n + 1 - i] = z
        w[i] = 2.0 / ((1.0 - z^2) * pp^2)
        w[n + 1 - i] = w[i]
    end
    return x, w
end

f(x) = x^2 + 2*x
a1, b1, n1 = 0, 1, 200
a2, b2, n2 = 0, 1, 10
println("Функция x^2 + 2*x непрерывна на интервале и по формуле Ньютона-Лейбница ответ 4/3 = 1.(3)")
print("время работы метода Трапеций:")
result1, result2 = 0, 0
bm = BenchmarkGroup()
bm1 = @benchmarkable begin
    global result1 = trapez_formul(f, a1, b1, n1)
end
println("Результат интеграла методом Трапеций: ", result1)
print("время работы метода Гаусса-Лежандра:")
bm2 = @benchmarkable begin
    global result2 = Gauss_Legendre_formul(f, a2, b2, n2)
end
println("Результат интеграла методом Гаусса-Лежандра: ", result2)
bm["trapez"] = bm1
bm["Gauss_Legendre"] = bm2
tune!(bm);
run(bm, verbose=true)
