@testset "types.jl" begin
    p1 = Point(80.0, 190.0)
    p2 = Point(40.0, -10.0)

    @test p1.ϕ ≈ 80.0 atol = 0.1
    @test p1.λ ≈ 190.0 atol = 0.1
    @test (p1-p2).ϕ ≈ 40.0 atol = 0.1
    @test (p1-p2).λ ≈ 200.0 atol = 0.1

    @test rad2deg(deg2rad(p1)).ϕ ≈ 80.0 atol = 0.1
    @test rad2deg(deg2rad(p1)).λ ≈ 190.0 atol = 0.1

    ls = Arc(p1, p2)
    @test ls.point₁.ϕ ≈ 80.0 atol = 0.1
    @test ls.point₂.λ ≈ -10.0 atol = 0.1

    l = Line(p1, 90.0)
    @test l.point.ϕ ≈ 80.0 atol = 0.1
    @test l.azimuth ≈ 90.0 atol = 0.1

    p3 = Point(60.0, 30.0)
    lss1 = Arcs([p1, p2, p3])

    @test lss1.points[1].ϕ ≈ 80.0 atol = 0.1
    @test lss1.points[3].λ ≈ 30.0 atol = 0.1

    @test_throws BoundsError lss2 = Arcs([p1])

    pg = Polygon(Point(60.0, 31.0), [p1, p2, p3])

    @test pg.points[1].ϕ ≈ 80.0 atol = 0.1
    @test length(pg.points) == 4
    @test pg.points[4].λ ≈ 190.0 atol = 0.1

    @test_throws BoundsError pg2 = Polygon(Point(60.0, 31.0), [p1, p2])

    pa1 = Point(50.0, 5.0)
    pa2 = Point(60.0, 5.0)
    pa3 = Point(60.0, 15.0)
    pa4 = Point(50.0, 15.0)

    pg_simple = Polygon(Point(55.0, 6.0), [pa1, pa2, pa3, pa4])
    pg_complex = Polygon(Point(55.0, 6.0), [pa1, pa2, pa4, pa3])

    @test issimple(pg_simple)
    @test iscomplex(pg_complex)

    #concave polygon
    pc1 = Point(64.0, 27.0)
    pc2 = Point(47.0, 0.0)
    pc3 = Point(42.0, 25.0)
    pc4 = intermediate_point(pc2,pc3,0.33)
    pc5 = Point(52.0, 16.0)
    pc6 = intermediate_point(pc2,pc3,0.67)
    pc7 = Point(55.0, -7.0)
    pc8 = intermediate_point(pc2,pc1,0.33)
    pc9 = Point(62.0, 4.0)
    pc10 = intermediate_point(pc2,pc1,0.67)
    pc11 = Point(56.0, 21.0)

    polygon_concave = Polygon(pc11,
    [pc1,pc3,pc6,pc5,pc4,pc2,pc7,pc8,pc9,pc10])

    @test boundingbox(pg_simple)[1][2] ≈ 60.0945 atol = 0.0001
    arcs_simple = Arcs(pg_simple.points)
    @test boundingbox(arcs_simple)[1][2] ≈ 60.0945 atol = 0.0001

    @test isconcave(pg_simple) == false
    @test isconcave(polygon_concave)
    @test isconvex(pg_simple)
    @test isconvex(polygon_concave) == false
end
