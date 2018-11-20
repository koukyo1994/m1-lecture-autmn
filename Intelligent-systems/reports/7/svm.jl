using Plots


mutable struct SVMResult
    n::Int64
    epsilon::Float64
    h::Float64
    C::Float64
    theta::VecOrMat{Float64}
    x::VecOrMat{Float64}
    y::VecOrMat{Float64}
    k::Matrix{Float64}
    converged::Bool
end

function SVM(
    x::Matrix{T}, 
    y::VecOrMat{T}, 
    C::Float64, 
    h::Float64;
    epsilon::Float64=0.01, 
    maxiter::Int64=10000, 
    tol::Float64=1e-6) where T<:AbstractFloat

    n = Int(length(x) / 2)
    @assert n == length(y)
    xx = x[:, 1]
    xy = x[:, 2]
    xx2 = xx .^ 2
    xy2 = xy .^ 2
    k = exp.(
        -(
            (repeat(xx2, 1, n) + repeat(xx2', n, 1) - 2 .* (xx * xx')) + 
            (repeat(xy2, 1, n) + repeat(xy2', n, 1) - 2 .* (xy * xy'))
        ) ./ (2 * h^2)
    )
    theta = rand(n, 1)
    converged = false
    cnt = 1
    while !converged && cnt < maxiter
        delThetaj = ifelse.(
            ones(n, 1) - (k * theta) .* y .> 0,
            - y .* k,
            0
        )
        sum_delTheta = sum(delThetaj, dims=1)'
        new_theta = theta - epsilon .* (C .* sum_delTheta + 2 .* (k * theta))
        if sqrt(sum((theta - new_theta).^2)) > tol
            theta = new_theta
            cnt += 1
        else
            theta = new_theta
            converged = true
        end
    end
    SVMResult(n, epsilon, h, C, theta, x, y, k, converged)
end
    
n = 200
a = collect(range(0, stop=4 * pi, length=Int(n/2)))
u = append!(a .* cos.(a), (a .+ pi) .* cos.(a)) + rand(n, 1)
v = append!(a .* sin.(a), (a .+ pi) .* sin.(a)) + rand(n, 1)
x = [u v]
y = append!(reshape(ones(1, Int(n/2)), (100,)), reshape(-ones(1, Int(n/2)), (100,)))
    
svm = SVM(x, y, 0.1, 0.3)
m = 100
X = collect(range(-15, stop=15, length=m))
X2 = X .^ 2
U=exp.(-(repeat(u.^2,1,m)+repeat(X2',n,1)-2 .* (u*X'))/ (2 * svm.h^2))
V=exp.(-(repeat(v.^2,1,m)+repeat(X2',n,1)-2 .* (v*X'))/ (2 * svm.h^2))
p = contour(X, X, sign.(V' * (U .* repeat(svm.theta, 1, m))), 
    fill=true,
    fillcolor=:viridis,
    fillalpha=0.1,
    xlabel="X",
    ylabel="Y",
    xlims=(-15, 15),
    ylims=(-15, 15)
)
scatter!(p, u[1:100], v[1:100], y[1:100], color=:yellow, label="Class1", ticks=false)
scatter!(p, u[101:200], v[101:200], y[101:200], color=:red, label="Class2", ticks=false)
png("svm")