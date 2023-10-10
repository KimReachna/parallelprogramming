using Folds
using FoldsThreads
using FLoops
using BenchmarkTools

function folds_sum_max_min(input_array)
    sum_val = Folds.sum(input_array, ThreadedEx())
    max_val = Folds.maximum(input_array, ThreadedEx())
    min_val = Folds.minimum(input_array, ThreadedEx())
    println("Folds Results:")
    println("Sum: $sum_val")
    println("Max: $max_val")
    println("Min: $min_val")
    return (sum_val, max_val, min_val)
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
    println("FLoops Results:")
    println("Sum: $s")
    println("Max: $xmax")
    println("Min: $xmin")
    return (s, xmax, xmin)
end

input_array = 1:1e7

# Calculate and print results
folds_result = folds_sum_max_min(input_array)
floops_result = floops_sum_max_min(input_array)

println("\nComparison of Results:")
println("Sum: $(folds_result[1]) == $(floops_result[1])")
println("Max: $(folds_result[2]) == $(floops_result[2])")
println("Min: $(folds_result[3]) == $(floops_result[3])")
