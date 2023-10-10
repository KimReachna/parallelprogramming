using FLoops
using Folds
using FoldsThreads
using BenchmarkTools
using Base.Threads
using Test
using Printf

function folds_trapezoidal_rule(f, a, b, n)
    h = (b - a) / n
    F(x) = f(a+x*h)
    I = h * (0.5 * (f(a) + f(b)) + Folds.sum(F, 1:n-1, ThreadedEx()))
    return I
end

function floops_trapezoidal_rule(f, a, b, n)
    h = (b - a) / n
    @floop for i in 1:n-1
        @reduce(reduced_sum += f(a + i * h))        
    end 
    I = h * (0.5 * (f(a) + f(b)) + reduced_sum)
    return I
end


f(x) = x^2
a, b = 0, 1
analytic_result = 1/3 # for 1/3 * x^3 between 0, and 1

# println(["Number of Thread", "Number of Trapezoids", "Folds Running Time", "FLoops Running Time", "Folds Test Result", "FLoops Test Result"])

n = parse(Int, ARGS[1])
trapezoid_size = 10^5
epsilon = 1/trapezoid_size
folds_running_time = @belapsed folds_trapezoidal_rule(f, a, b, trapezoid_size)
folds_test_result = @test abs(analytic_result - folds_trapezoidal_rule(f, a, b, trapezoid_size)) <= epsilon
floops_running_time = @belapsed floops_trapezoidal_rule(f, a, b, trapezoid_size)
floops_test_result = @test abs(analytic_result - floops_trapezoidal_rule(f, a, b, trapezoid_size)) <= epsilon
println([Threads.nthreads(), trapezoid_size, folds_running_time, floops_running_time, folds_test_result, floops_test_result])