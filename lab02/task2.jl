using Folds

function trapezoid_integral(f, a, b, n)
    h = (b - a) / n
    x_i = [a + i * h for i in 1:n]

    integral = foldl(+, begin
        sum(f(x_i[i]) for i in 1:n-1) * h / 2
    end)

    return integral
end

# Define the function to be integrated
f(x) = x^2

# Define the integration limits and the number of subintervals
a = 0.0
b = 1.0
n = 1000000

# Calculate the integral using the trapezoid rule
result = trapezoid_integral(f, a, b, n)

# Analytical solution (for the example function x^2)
analytical_solution = 1/3

# Print the result and compare it to the analytical solution
println("Numerical Result: ", result)
println("Analytical Solution: ", analytical_solution)
