using Plots
using Printf


f(x, y) = 3x^2 + 2y^2
h(x, y) = 1 - x - y
nablaL(x, c) = [
    6x[1] + c * ifelse(max(h(x[1], x[2]), 0) == 0, 0, -2 * h(x[1], x[2])),
    4x[2] + c * ifelse(max(h(x[1], x[2]), 0) == 0, 0, -2 * h(x[1], x[2]))
]

function BFGS(x, epsilon, f, c...)
    Hinv = [1 0; 0 1]
    xold = copy(x)
    df = ifelse(length(c) == 0, f(xold, 0), f(xold, c[1]))
    xnew = xold - 0.01 .* Hinv * df
    while sum((xnew - xold).^2) > epsilon
        s = xnew - xold
        t = ifelse(length(c) == 0, f(xnew, 0) - f(xold, 0), f(xnew, c[1]) - f(xold, c[1]))
        xold = copy(xnew)
        Hinv = (
            Hinv + (s' * t + t' * Hinv * t) * s * s' ./ (s' * t)^2 -
            (Hinv * t * s' + s * t' * Hinv) ./ (s' * t)
        )
        df = ifelse(length(c) == 0, f(xold, 0), f(xold, c[1]))
        xnew = xold - 0.01 .* Hinv * df
    end
    xnew
end

function penalty(x, eps_penalty, eps_bfgs)
    xtrail = []
    ytrail = []
    append!(xtrail, x[1])
    append!(ytrail, x[2])

    xold = copy(x)
    c = 1
    xnew = BFGS(xold, eps_bfgs, nablaL, c)
    append!(xtrail, xnew[1])
    append!(ytrail, xnew[2])
    while sum((xnew - xold).^2) > eps_penalty
        c *= 1.01
        xold = copy(xnew)
        xnew = BFGS(xold, eps_bfgs, nablaL, c)
        append!(xtrail, xnew[1])
        append!(ytrail, xnew[2])
    end
    xtrail, ytrail
end

eps_penalty = 1e-9
eps_bfgs = 1e-16
x = [1., 1.]
xtrail, ytrail = penalty(x, eps_penalty, eps_bfgs)

x = y = range(-1.0, 1.0, length=1000)
p = plot(x, y, f, st=[:contourf])
for i in 1:length(xtrail)-1
    plot!(p[1], [xtrail[i], xtrail[i+1]], [ytrail[i], ytrail[i+1]], line=(:white, 1), legend=:none)
end
posx = @sprintf "%.2f" xtrail[end]
posy = @sprintf "%.2f" ytrail[end]
annotate!(xtrail[end], ytrail[end], text("($(posx), $(posy))", 10, :center, :white))
png("penalty")