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

input_array = 1:1e7 # change input result as you want, but this one is large enough to study

time_folds = @belapsed folds_sum_max_min(input_array)
time_floops = @belapsed floops_sum_max_min(input_array)
#@testset begin
    #@test folds_sum_max_min(input_array)[1] == floops_sum_max_min(input_array)[1]
    #@test folds_sum_max_min(input_array)[2] == floops_sum_max_min(input_array)[2]
    #@test folds_sum_max_min(input_array)[3] == floops_sum_max_min(input_array)[3]
#end

println([time_folds time_floops])