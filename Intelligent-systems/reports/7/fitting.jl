using Plots
using LinearAlgebra
using StatsBase
using IterTools
using Printf

function rmse(yobs, ypred)
   sqrt(sum((yobs - ypred).^2)) 
end

function kernelLinear(x, y, h, l)
    n = size(x)[1]
    x2 = x.^2
    k = exp.(-(repeat(x2, 1, n) + repeat(x2', n, 1) - 2 .* (x * x')) ./ (2 * h^2))
    t = inv(k^2 + l .* I) * (k * y)
end

function calcValidation(X, x, t, h)
    X2 = X .^ 2
    x2 = x .^ 2
    hh = 2 * h .^ 2
    K = exp.(-(repeat(X2, 1, length(x)) + repeat(x2', length(X), 1) - 2 .* (X * x')) ./ hh)
    F = K * t
end

function getCVIndice(maxIndice, numCV)
    x = collect(1:maxIndice)
    train = []
    remains = copy(x)
    nsample = Int(maxIndice / numCV)
    for i in 1:numCV
        s = sample(remains, nsample, replace=false)
        append!(train, [s])
        remains = setdiff(remains, s)
    end
    valid = [setdiff(x, t) for t in train]
    indices = [(t, v) for (t, v) in zip(train, valid)]
end

function CV(X, Y, h, l, numCV)
    len = size(X)[1]
    indices = getCVIndice(len, numCV)
    loss_array = []
    for (train_indices, valid_indices) in indices
        x = X[train_indices]
        Xnew = X[valid_indices]
        y = Y[train_indices]
        Ynew = Y[valid_indices]
        t = kernelLinear(x, y, h, l)
        F = calcValidation(Xnew, x, t, h)
        loss = rmse(Ynew, F)
        append!(loss_array, loss)
    end
    sum(loss_array) / size(loss_array)[1]
end

N = 1000
X = range(-3, stop=3, length=N)
piX = pi .* X
Y = sin.(piX) ./ (piX) + 0.1 .* X + 0.2 .* randn(N, 1)
ytrue = sin.(piX) ./ (piX) + 0.1 .* X

h = 0.3
l = 0.3
l_mean = CV(X, Y, h, l, 10)

h_array = collect(range(0.01, stop=1.0, length=100))
l_array = collect(range(0.01, stop=1.0, length=100))
loss_array = []
param_array = [(h, l) for (h, l) in Iterators.product(h_array, l_array)]
for (h, l) in Iterators.product(h_array, l_array)
    l_mean = CV(X, Y, h, l, 10)
    append!(loss_array, l_mean)
end

min_idx = argmin(loss_array)
best = param_array[min_idx]

println("Best Parameters h: $(best[1]) l: $(best[2])")

h_sample = [0.1, 0.74, 2.0]
l_sample = [0.001, 0.11, 5.0]
plots_array = []
l_array
for (h, l) in Iterators.product(h_sample, l_sample)
    l_mean = CV(X, Y, h, l, 10)
    n = length(X)
    s = sample(1:n, 100, replace=false)
    x = X[s]
    y = Y[s]

    t = kernelLinear(x, y, h, l)
    F = calcValidation(X, x, t, h)
    str = @sprintf "Loss: %.3f" l_mean
    lstr = @sprintf "l: %.3f" l
    hstr = @sprintf "h: %.3f" h
    p = scatter(
        X, Y, 
        label="observed", 
        color=RGB(150/255, 150/255, 220/255), 
        legend=:top, 
        size=(360, 240),
        legendfontsize=6,
        annotations=[
            (2, 1.25, text("$(str)", 6)),
            (2, 1.15, text("$(lstr)", 6)),
            (2, 1.05, text("$(hstr)", 6))
        ]
    )
    plot!(p, X, F, xlabel="X", ylabel="Y", label="predicted", linewidth=3, color=:red)
    plot!(p, X, ytrue, label="actual", linewidth=3, color=:green)
    push!(plots_array, p)
    push!(l_array, l_mean)
end


p2 = plot(
    plots_array[1],
    plots_array[2],
    plots_array[3],
    plots_array[4],
    plots_array[5],
    plots_array[6],
    plots_array[7],
    plots_array[8],
    plots_array[9],
    size=(1080, 720)
)
png("fitting_")