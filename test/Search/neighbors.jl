@testset "NearestNeighbors" begin

    @testset "neighborhood" begin
        points = [  0.0 1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0;
                    0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0;
                    0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 ]

        kdtree = NearestNeighbors.KDTree(points)
        seeds = [1,2]
        visitedverts = [1,2,3]
        threshold = 5.0
        k = 5
        NN = Search.neighborhood(kdtree, points, seeds, visitedverts, threshold, k)
        @test NN == [4,5,6,7]
    end

    @testset "consistent_seeds" begin
        points = [  0.0 1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0;
                    1.0 0.2 0.0 0.0 6.0 2.0 7.0 0.0 8.0 1.0;
                    0.0 5.0 2.0 0.0 0.0 0.0 0.0 7.0 0.0 4.0 ]

        given_seeds = [  0.2 1.0 2.0 3.0 ;
                         1.1 0.2 0.1 0.1 ;
                         0.0 5.1 2.1 0.0  ]

        seeds = Search.consistent_seeds(Search.PointCloud(points)).([c[:] for c in eachcol(given_seeds)])

        @test seeds == [1,2,3,4]
    end
end
