using Geometry
using Search
using Visualization
using BenchmarkTools
pc = rand(2,100000)

GL.VIEW([
    Visualization.points(pc; color = GL.COLORS[2], alpha = 0.3)
])


kdtree = Search.KDTree(pc)
seeds = [rand(1:100000),rand(1:100000)]
visitedverts = Int64[12487
                    89424
                    1259
                    39756
                    80325
                    88541
                    4451
                    93607
                    41747
                    53656]
threshold = 0.1
k = 500
N1 = Search.neighborhood(kdtree,pc,seeds,visitedverts,threshold,k)

GL.VIEW([
    Visualization.points(pc; color = GL.COLORS[2], alpha = 0.3)
    Visualization.points(pc[:,N1]; color = GL.COLORS[3], alpha = 1.0)
    Visualization.points(pc[:,seeds]; color = GL.COLORS[12], alpha = 1.)
    Visualization.points(pc[:,visitedverts]; color = GL.COLORS[1], alpha = 1.)
])

balltree = Search.BallTree(pc)
N = Search.n_inrange(balltree,pc,seeds,visitedverts,0.05)

GL.VIEW([
    Visualization.points(pc; color = GL.COLORS[2], alpha = 0.3)
    Visualization.points(pc[:,N]; color = GL.COLORS[3], alpha = 1.0)
    Visualization.points(pc[:,seeds]; color = GL.COLORS[12], alpha = 1.)
    # Visualization.points(pc[:,visitedverts]; color = GL.COLORS[1], alpha = 1.)
])
