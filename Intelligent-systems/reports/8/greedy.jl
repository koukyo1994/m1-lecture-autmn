mutable struct edge
    from::Int64
    to::Int64
    cost::Int64
end

function greedy(m)
    openlist = [edge(1, 1, 0)]
    closedlist = []
    totalcost = 0
    while length(openlist) > 0
        s = pop!(openlist)
        push!(closedlist, s)
        totalcost += s.cost
        if size(m)[1] == s.to
            break
        end
        candidate = [i for i in 1:length(m[s.to, :]) if m[s.to, i] != 0]
        next = reverse(sort(candidate, by=x -> m[s.to, x]))
        closed_from = [n.from for n in closedlist]
        for n in next
            if n in closed_from
                continue
            end
            push!(openlist, edge(s.to, n, m[s.to, n]))
        end
    end
    closedlist, totalcost
end

m = [0 1 0 2 0 0 0 0 0 0;
     1 0 2 0 0 0 0 0 0 0;
     0 2 0 0 0 0 1 0 0 0;
     2 0 0 0 1 0 0 0 0 0;
     0 0 0 1 0 2 0 0 0 0;
     0 0 0 0 2 0 1 0 0 0;
     0 0 1 0 0 1 0 1 0 0;
     0 0 0 0 0 0 1 0 1 2;
     0 0 0 0 0 0 0 1 0 0;
     0 0 0 0 0 0 0 2 0 0]

greedy(m)