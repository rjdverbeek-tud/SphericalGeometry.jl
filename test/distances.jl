@testset "distances.jl" begin
    p1 = rad2deg(Point(0.5, 1.0))
    p2 = rad2deg(Point(1.0, 0.5))
    p3 = rad2deg(Point(0.6, 1.0))

    rs = Line(p1,p2)

    @test distance(angular_distance(p1, p2)) ≈ 3888e3 atol = 1e3
    @test distance(angular_distance(rs)) ≈ 3888e3 atol = 1e3
    @test distance(angular_distance(p1, p1)) == 0.0

    p1b = Point(30.0, 100.0)
    p2b = Point(50.0, 210.0)
    rsb = Line(p1b, p2b)

    @test distance(angular_distance(p1b, p2b)) ≈ 8773000.0 atol = 1000.0
    @test angular_distance(p1b, p2b) ≈ 78.8974 atol = 0.1
end
