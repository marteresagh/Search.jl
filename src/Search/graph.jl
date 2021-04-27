"""
	model2graph_edge2edge(V::Lar.Points,EV::Lar.Cells)::LightGraphs.SimpleGraphs.SimpleGraph{Int64}
"""
function model2graph_edge2edge(V::Points,EV::Cells)::LightGraphs.SimpleGraphs.SimpleGraph{Int64}
    M1 = Geometry.characteristicMatrix(EV)
	EE = (M1*M1').%2
	R, C, VAL = Geometry.findnz(EE)
	graph = SimpleGraph(length(EV))
	for i in 1:Geometry.nnz(EE)
		add_edge!(graph,R[i],C[i])
	end
	return graph
end

"""
	model2graph(V::Lar.Points,EV::Lar.Cells)::LightGraphs.SimpleGraphs.SimpleGraph{Int64}
"""
function model2graph(V::Points,EV::Cells)::LightGraphs.SimpleGraphs.SimpleGraph{Int64}
	graph = SimpleGraph(size(V,2))
	for ev in EV
		add_edge!(graph,ev[1],ev[2])
	end
	return graph
end


# """
# 	model2graph(V::Lar.Points,EV::Lar.Cells)::LightGraphs.SimpleGraphs.SimpleGraph{Int64}
# """
# function makes_direct(g,s)
# 	dg = LightGraphs.DiGraph(nv(g))
# 	parents = zeros(Int, nv(g))
# 	parents[s] = s
# 	seen = zeros(Bool, nv(g))
# 	S = Vector{Int}([s])
# 	seen[s] = true
# 	while !isempty(S)
# 		v = S[end]
# 		u = 0
# 		for n in outneighbors(g, v)
# 			if !seen[n]
# 				u = n
# 				break
# 			end
# 		end
# 		if u == 0
# 			pop!(S)
# 		else
# 			seen[u] = true
# 			push!(S, u)
# 			parents[u] = v
# 			add_edge!(dg,v,u)
#
# 		end
# 		for n in outneighbors(g, v)
# 			if n!=u && parents[v]!=n
# 				if seen[n]
# 					add_edge!(dg,v,n)
# 					break
# 				end
#
# 			end
# 		end
#
# 	end
# 	return dg
# end

"""
	biconnected_comps(g)
"""
function biconnected_comps(V::Points,EV::Cells)
	g = model2graph(V,EV)
	sort_EV = sort.(EV)
	gs = LightGraphs.biconnected_components(g)
	comps = Array{Int64,1}[]
	for bic in gs
		comp = Int64[]
		for edge in bic
			union!(comp,findall(x->x==[edge.src,edge.dst],sort_EV)[1])
		end
		push!(comps,comp)
	end
	return comps
end


"""
	get_cycles(V,EV)
"""
### migliore versione
function get_cycles(V::Points,EV::Cells)
    g = model2graph(V,EV)
    cycles = LightGraphs.cycle_basis(g)
    comps = Vector{Int64}[]
    for cycle in cycles
        comp = Int64[]
        for i in 1:length(EV)
            if EV[i][1] in cycle && EV[i][2] in cycle
                push!(comp,i)
            end
        end
        push!(comps,comp)
    end
    return comps
end

# function digraph_from_topology(V,EV)
#     n = size(V,2)
#     dg = DiGraph(n)
#     for a in EV
#         add_edge!(dg, a[2], a[1])
#     end
#     dg
# end
#
# "
# Finds (undirected) cycle.
# "
# function find_cycle(V,EV)
#     nnodes = size(V,2)
#     digraph = digraph_from_topology(V,EV)
#     graph = Graph(digraph)
#
#     # assume that graph is connected, so starting from single root is OK
#
#     # initialize DFS
#     root = 1
#     stack = [(root, root)] # collect unvisited nodes with parent
#     parent = fill(0, nnodes) # 0 means not visited
#
#     # run search
#     while length(stack) > 0 # not empty
#         from, current = pop!(stack)
#         parent[current] = from
#         for to in neighbors(graph, current)
#             if to == from
#                 continue # no antiparallel move
#             elseif parent[to] == 0 # not visited
#                 push!(stack, (current, to))
#             else # found cycle, run it in reverse
#                 path = [[to, current]]
#                 backtrack = current
#                 while backtrack ≠ to
#                     push!(path, [backtrack, parent[backtrack]])
#                     backtrack = parent[backtrack]
#                 end
#                 return path
#             end
#         end
#     end
#
#     # found no cycle
#     return []
# end
