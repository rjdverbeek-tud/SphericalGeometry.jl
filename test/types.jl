@testset "types.jl" begin
    p1 = Point(80.0, 190.0)

    @test p1.ϕ ≈ 80.0 atol = 0.1
    @test p1.λ ≈ 190.0 atol = 0.1

    p2 = Point(40.0, -10.0)
    l = Line(p1, p2)

    @test l.point₁.ϕ ≈ 80.0 atol = 0.1

    p3 = Point(60.0, 30.0)
    ls = LineString([p1, p2, p3])

    @test ls.points[1].ϕ ≈ 80.0 atol = 0.1

    pg = Polygon([p1, p2, p3])

    @test pg.points[1].ϕ ≈ 80.0 atol = 0.1
    @test length(pg.points) == 4
end
