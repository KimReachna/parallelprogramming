using Folds
using FoldsThreads
using FLoops
using BenchmarkTools
using Test
using Base.Threads
using Plots
using OnlineStats

function folds_sum_max_min(input_array)
    sum = Folds.sum(input_array, ThreadedEx())
    max = Folds.maximum(input_array, ThreadedEx())
    min = Folds.minimum(input_array, ThreadedEx())
    return (sum, max, min)
end

function floops_sum_max_min(arr)
    @floop for x in arr
        @reduce(s += x)
        @reduce() do (xmax = -Inf; x)
            if xmax < x
                xmax = x
            end
        end
        @reduce() do (xmin = Inf; x)
            if xmin > x
                xmin = x
            end
        end
    end
    return (s, xmax, xmin)
end

# println(["Number of Thread", "Number of Trapezoids", "Folds Running Time", "FLoops Running Time", "Folds Test Result", "FLoops Test Result"])

n = parse(Int, ARGS[1])
input_array = 1:1e5 # change input result as you want, but this one is large enough to study

folds_running_time = @belapsed folds_sum_max_min(input_array)
floops_running_time = @belapsed floops_sum_max_min(input_array)
normal_sum = sum(input_array)
normal_max = maximum(input_array)
normal_min = minimum(input_array)
folds_test_result = @test folds_sum_max_min(input_array) == (normal_sum, normal_max, normal_min)
floops_test_result = @test floops_sum_max_min(input_array) == (normal_sum, normal_max, normal_min)
println([Threads.nthreads(), input_array, folds_running_time, floops_running_time, folds_test_result, floops_test_result])