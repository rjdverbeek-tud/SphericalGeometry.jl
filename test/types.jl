@testset "types.jl" begin
    p1 = Point(80.0, 190.0)
    p2 = Point(40.0, -10.0)

    @test p1.ϕ ≈ 80.0 atol = 0.1
    @test p1.λ ≈ 190.0 atol = 0.1
    @test (p1-p2).ϕ ≈ 40.0 atol = 0.1
    @test (p1-p2).λ ≈ 200.0 atol = 0.1

    @test rad2deg(deg2rad(p1)).ϕ ≈ 80.0 atol = 0.1
    @test rad2deg(deg2rad(p1)).λ ≈ 190.0 atol = 0.1

    ls = LineSection(p1, p2)
    @test ls.point₁.ϕ ≈ 80.0 atol = 0.1
    @test ls.point₂.λ ≈ -10.0 atol = 0.1

    l = Line(p1, 90.0)
    @test l.point.ϕ ≈ 80.0 atol = 0.1
    @test l.bearing ≈ 90.0 atol = 0.1

    p3 = Point(60.0, 30.0)
    lss1 = LineSections([p1, p2, p3])

    @test lss1.points[1].ϕ ≈ 80.0 atol = 0.1
    @test lss1.points[3].λ ≈ 30.0 atol = 0.1

    @test_throws BoundsError lss2 = LineSections([p1])

    pg = Polygon([p1, p2, p3])

    @test pg.points[1].ϕ ≈ 80.0 atol = 0.1
    @test length(pg.points) == 4
    @test pg.points[4].λ ≈ 190.0 atol = 0.1

    @test_throws BoundsError pg2 = Polygon([p1, p2])
end
