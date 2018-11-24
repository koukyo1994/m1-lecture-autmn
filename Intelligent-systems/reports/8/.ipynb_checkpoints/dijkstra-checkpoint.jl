import Base: sort


mutable struct node
    id::Int64
    min_cost::Int64
    from::Int64
end

function sort(a::Array{node, 1})
    costs = [n.min_cost for n in a]
    idx = sortperm(costs)
    a = a[idx]
end

function dijkstra(m)
    initnode = node(1, 0, 1)
    pendinglist = [initnode]
    allnodes = []
    closedlist = []
    while true
        pending_id = [n.id for n in pendinglist]
        if size(m)[1] in pending_id
            break
        end

        pendinglist = sort(pendinglist)
        s = popfirst!(pendinglist)
        all_id = [n.id for n in allnodes]
        if !(s.id in all_id)
            push!(allnodes, s)
        end
        idx = s.id
        root = m[idx, :]
        candidate_idx = [i for i in 1:length(root) if root[i] != 0]
        pending_id = [n.id for n in pendinglist]
        for i in candidate_idx
            cost = s.min_cost + root[i]
            if i in pending_id
                pending_idx = indexin(i, pending_id)[1]
                if cost < (pendinglist[pending_idx].min_cost)
                    pendinglist[pending_idx].min_cost = cost
                    pendinglist[pending_idx].from = idx
                end
                continue
            end
            push!(pendinglist, node(i, cost, idx))
        end
    end
    
    pending_id = [n.id for n in pendinglist]
    all_id = [n.id for n in allnodes]
    poslast = indexin(size(m)[1], pending_id)[1]
    current = pendinglist[poslast]
    push!(closedlist, current)
    while true
        if current.from == 1
            push!(closedlist, initnode)
            break
        end
        
        pos = indexin(current.from, all_id)[1]
        push!(closedlist, allnodes[pos])
        current = allnodes[pos]
    end
    sort(closedlist)
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

dijkstra(m)