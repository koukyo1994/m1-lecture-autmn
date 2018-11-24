import Base: sort, indexin


function options(p)
    idx = indexin(0, p)[1]
    indices = [CartesianIndex(i, j) for (i, j) in [
                (idx[1]-1, idx[2]), (idx[1]+1, idx[2]),
                (idx[1], idx[2]-1), (idx[1], idx[2]+1)
                ]]
    indices = [i for i in indices if 0 < i[1] <= size(p)[1] && 0 < i[2] <= size(p)[2]]
end


function flip(p, idx)
    zeropos = indexin(0, p)[1]
    p[zeropos], p[idx] = p[idx], p[zeropos]
    p
end


function number_of_misplace(p, o)
    sum(sign.(abs.(p - o)))
end


function manhattan(p, o)
    distance = 0
    for i in 1:maximum(p)
        idxp = indexin(i, p)[1]
        idxo = indexin(i, o)[1]
        cartesian_diff = idxp - idxo
        distance += abs(cartesian_diff[1]) + abs(cartesian_diff[2])
    end
    distance
end


mutable struct State
    state::Array{Int64, 2}
    before::Array{Int64, 2}
    min_cost::Int64
    heuristic::Int64
end


function sort(a::Array{State, 1})
    costs = [s.min_cost + s.heuristic for s in a]
    a[sortperm(costs)]
end


function indexin(elem::Array{Int64, 2}, arr::Array{Array{Int64, 2}, 1})
    [i for i in 1:length(arr) if arr[i] == elem][1]
end


function astar(p, o, f)
    pendinglist = [State(copy(p), copy(p), 0, f(p, o))]
    visitedlist = []
    closedlist = []
    while true
        pendinglist = sort(pendinglist)
        next = popfirst!(pendinglist)
        visited_state = [s.state for s in visitedlist]
        if !(next.state in visited_state)
            push!(visitedlist, next)
        end
        next_option = options(next.state)
        next_p = [flip(copy(next.state), i) for i in next_option]
        next_state = [State(np, copy(next.state), next.min_cost+1, f(np, o)) for np in next_p]
        if o in next_p
            push!(visitedlist, State(o, copy(next.state), next.min_cost+1, f(o, o)))
            break
        end
        
        pending_state = [s.state for s in pendinglist]
        for ns in next_state
            if !(ns.state in pending_state)
                push!(pendinglist, ns) 
            end
        end
    end
    visited_state = [s.state for s in visitedlist]
    current = o
    while true
        idxcurrent = indexin(current, visited_state)
        push!(closedlist, visitedlist[idxcurrent])
        if current == p
            break
        end
        before = visitedlist[idxcurrent].before
        idxbefore = indexin(before, visited_state)
        current = visitedlist[idxbefore].state
    end
    reverse(closedlist)
end


puzzle = [4 3 5;
          2 1 0]

optimal = [1 2 3;
           4 5 0]

astar(puzzle, optimal, number_of_misplace)