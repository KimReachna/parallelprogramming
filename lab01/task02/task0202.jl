using Base.Threads
using Test

function sum_subset(input::Vector{Int}, thread_num::Int)
    subset = input[thread_num:4:end]
    result = sum(subset)
    println("Thread $thread_num: Sum = $result")
    return result
end

function multithreaded_sum(arr)
    # Create an array to store the summation results
    results = Vector{Int}(undef, 4)
    threads = Vector{Task}(undef, 4)
    # Generate 4 threads
    for i in 1:4
        threads[i] = Threads.@spawn sum_subset(arr, i)
    end

    for i in 1:4
        results[i] = fetch(threads[i])
    end

    total_sum = sum(results)
    return total_sum
end

# Test the program with an example input array
input_array = [x for x in 1:12]
println(multithreaded_sum(input_array))


@test sum(input_array) == multithreaded_sum(input_array)