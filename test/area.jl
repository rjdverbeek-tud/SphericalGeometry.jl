@testset "area.jl" begin

    angular_distance_x = 34.49
    angular_distance_y = 28.11
    angular_distance_z = 29.0

    @test area(angular_distance_z, angular_distance_y, angular_distance_x) ≈ 0.1239 atol = 0.01

    p1 = Point(0.0, 0.0)
    p2 = Point(0.0, 90.0)
    p3 = Point(89.99, 0.0)

    @test area(p1, p2, p3) ≈ 1.5708 atol = 0.001
    @test area(p1, Point(0.0, 179.99), p3) ≈ 3.1416 atol = 0.001

    pi = Point(32.0, 47.0)
    pi2 = Point(-45.0, 100.0)
    poly = Polygon(pi, [p1, p2, p3])
    poly2 = Polygon(pi2, [p1, p2, p3])

    @test area(poly) ≈ 1.5708 atol = 0.001
    # @test area(poly2) ≈ 10.9956 atol = 0.001
    # @test area(Polygon(pi, [p1, Point(0.0, 270.0), p3])) ≈ 4.7124 atol = 0.001
    @test area(Polygon(pi, [p1, Point(0.0, 179.99), p3])) ≈ 3.1416 atol = 0.001
    @test area(Polygon(pi, [p1, p2, p3, Point(0.0, 270.001), Point(-89.99, 0.0)])) ≈ 4.7124 atol = 0.001
    @test area(Polygon(pi, [p2, p3, Point(0.0, 270.001), Point(-89.99, 0.0)])) ≈ 2*π atol = 0.001
    
end