using Base.Threads

function spawn_threads()
    # spawrn 4 Threads
    for i in 1:4
        sleep(0.01)
        Threads.@spawn println("Threads", i)
    end
end

spawn_threads()

println("Number of thread created ", Threads.nthreads())