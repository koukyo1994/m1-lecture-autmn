using Plots
using Printf


f(x, y) = 3x^2 + 2y^2
dL(x, c) = [6x[1] - c / (x[1] + x[2] - 1), 4x[2] - c / (x[1] + x[2] - 1)]

function BFGS(x, c, epsilon)
    Hinv = [1 0; 0 1]
    xold = copy(x)
    xnew = xold - 0.01 .* Hinv * dL(xold, c)
    while sum((xnew - xold).^2) > epsilon
        s = xnew - xold
        t = dL(xnew, c) - dL(xold, c)
        xold = copy(xnew)
        Hinv = (
            Hinv + (s' * t + t' * Hinv * t) * s * s' ./ (s' * t)^2 -
            (Hinv * t * s' + s * t' * Hinv) ./ (s' * t)
        )
        xnew = xold - 0.01 .* Hinv * dL(xold, c)
    end
    xnew
end

function barrier(x, eps_barrier, eps_bfgs)
    xtrail = []
    ytrail = []
    append!(xtrail, x[1])
    append!(ytrail, x[2])

    xold = copy(x)
    xnew = BFGS(xold, 100.0, eps_bfgs)
    append!(xtrail, xnew[1])
    append!(ytrail, xnew[2])
    c = 1.0
    while sum((xnew - xold).^2) > eps_barrier
        c += 1.0
        xold = copy(xnew)
        xnew = BFGS(xold, 100. / c, eps_bfgs)
        append!(xtrail, xnew[1])
        append!(ytrail, xnew[2])
    end
    xtrail, ytrail
end

eps_barrier = 1e-10
eps_bfgs = 1e-16
x = [1., 1.]
xtrail, ytrail = barrier(x, eps_barrier, eps_bfgs)

x = y = range(-4.0, 4.0, length=1000)
p = plot(x, y, f, st=[:contourf])
for i in 1:length(xtrail)-1
    plot!(p[1], [xtrail[i], xtrail[i+1]], [ytrail[i], ytrail[i+1]], line=(:white, 1), legend=:none)
end
posx = @sprintf "%.2f" xtrail[end]
posy = @sprintf "%.2f" ytrail[end]
annotate!(xtrail[end], ytrail[end], text("($(posx), $(posy))", 10, :center, :white))
png("barrier")