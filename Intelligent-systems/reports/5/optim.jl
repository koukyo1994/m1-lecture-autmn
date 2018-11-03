using Plots

# Functions
f(x, y) = 10x^2 + y^2
df(x) = [20x[1], 2x[2]]

function backtrack(x, epsilon, alpha, beta)
    x_new = x - epsilon .* df(x)
    while f(x_new[1], x_new[2]) - f(x[1], x[2]) > -alpha * epsilon * sum(df(x).^2)
        epsilon *= beta
        x_new = x - epsilon .* df(x)
    end
    x_new
end

# Variables
x = y = range(-5, stop=5, length=100)
p = plot(x, y, f, st = [:contourf])

niter = 5
pos = 10 * rand(2) .- 5
epsilon = 1.0
alpha = 0.5
beta = 0.8
previous = [0.0, 0.0]
for i in 1:niter
    previous = copy(pos)
    pos = backtrack(pos, epsilon, alpha, beta)
    plot!(p[1], [previous[1], pos[1]], [previous[2], pos[2]], line = (:white, 1))
end
