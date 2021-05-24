@testset "operations.jl" begin

    using LinearAlgebra

    #concave polygon
    pc1 = Point(64.0, 27.0)
    pc2 = Point(42.0, 25.0)
    pc6 = Point(47.0, 0.0)
    pc3 = intermediate_point(pc2,pc6,0.33)
    # pc3 = Point(46.0, 17.0)
    pc4 = Point(52.0, 16.0)
    pc5 = intermediate_point(pc2,pc6,0.67)
    # pc5 = Point(47.0, 9.0)
    
    
    pc7 = Point(55.0, -7.0)
    pc8 = intermediate_point(pc6,pc1,0.33)
    pc9 = Point(62.0, 4.0)
    pc10 = intermediate_point(pc6,pc1,0.67)
    pc11 = Point(56.0, 21.0)

    polygon_concave = Polygon(pc11,
    [pc1,pc2,pc3,pc4,pc5,pc6,pc7,pc8,pc9,pc10])

    polygon_convexhull = Polygon(pc11,
    [pc1,pc2,pc6,pc7,pc9])

    @test length(convexhull(polygon_concave).points) == 6
    @test area(polygon_convexhull) ≈ area(convexhull(polygon_concave))
    @test area(polygon_convexhull) ≈ area(convexhull(polygon_convexhull))

    pa1 = Point(50.0, 5.0)
    pa2 = Point(60.0, 5.0)
    pa3 = Point(60.0, 15.0)
    pa4 = Point(50.0, 15.0)

    pg_simple = Polygon(Point(55.0, 6.0), [pa1, pa2, pa3, pa4])
    @test area(pg_simple) ≈ area(convexhull(pg_simple))

end