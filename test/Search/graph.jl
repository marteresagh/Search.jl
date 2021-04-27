@testset "Graph" begin

	@testset "model2graph_edge2edge" begin
		V = [0. 4. 4. 0. 2. 3. 3. 2;
			0. 0. 4. 4. 2. 2. 3. 3.]
		EV = [[1,2],[2,3],[3,4],[4,1],[5,6],[6,7],[7,8],[8,5]]
		graph = Search.model2graph_edge2edge(V,EV)
		@test graph.fadjlist == [[2,4],[1,3],[2,4],[1,3],[6,8],[5,7],[6,8],[5,7]]
	end

	@testset "model2graph" begin
		V = [0. 4. 4. 0. 2. 3. 3. 2;
			0. 0. 4. 4. 2. 2. 3. 3.]
		EV = [[1,2],[2,3],[3,4],[4,1],[5,6],[6,7],[7,8],[8,5]]
		graph = Search.model2graph(V,EV)
		@test graph.fadjlist == [[2,4],[1,3],[2,4],[1,3],[6,8],[5,7],[6,8],[5,7]]
	end

	@testset "get_cycles" begin
		V = [0 6 8 8 8 0 5.;
		    0 0 0 1 4 4 3]
		EV = [[1,2],[2,3],[3,4],[4,5],[5,6],[6,1],[2,4],[4,7],[7,2]]
		cycles = Search.get_cycles(V,EV)
		bic = Search.biconnected_comps(V,EV)
		@test sort(sort.(cycles)) == [[1,4,5,6,7],[2,3,7],[7,8,9]]
		@test sort(sort.(bic)) == [[1,2,3,4,5,6,7,8,9]]
	end

	@testset "biconnected_components" begin
		V = [0 5 10 10 0 7 6 4 8 9 9 8;
			  0 0 0 6 6 2 3 2 4 4 5 5.]
		EV = [[1,2],[2,3],[3,4],[4,5],[5,1],[2,6],[6,7],[7,8],[8,2],[9,10],[10,11],[11,12],[12,9]]
		bic = Search.biconnected_comps(V,EV)
		cycles = Search.get_cycles(V,EV)
		@test sort(sort.(bic)) == [[1,2,3,4,5],[6,7,8,9],[10,11,12,13]]
		@test sort(sort.(cycles)) == [[1,2,3,4,5],[6,7,8,9],[10,11,12,13]]
	end
end

# @testset "makes_direct(g,s)" begin
# 	V = [0. 4. 4. 0. 2. 3. 3. 2;
# 		0. 0. 4. 4. 2. 2. 3. 3.]
# 	EV = [[1,2],[2,6],[6,5],[5,8],[8,7],[7,3],[4,3],[1,4]]
# 	g = Common.model2graph(V,EV)
# 	graph = Common.makes_direct(g,1)
# 	@test graph.fadjlist == [[2],[6],[4],[1],[8],[5],[3],[7]]
# end
