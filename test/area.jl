@testset "area.jl" begin

    angular_distance_x = 34.49
    angular_distance_y = 28.11
    angular_distance_z = 29.0

    @test area(angular_distance_z, angular_distance_y, angular_distance_x) ≈ 0.1239 atol = 0.01

    p1a = Point(0.0, 0.0)
    p2a = Point(0.0, 90.0)
    p3a = Point(89.99, 0.0)

    @test area(p1a, p2a, p3a) ≈ 1.5708 atol = 0.001
    @test area(p1a, Point(0.0, 179.99), p3a) ≈ 3.1416 atol = 0.001

    pi = Point(32.0, 47.0)
    poly = Polygon(pi, [p1a, p2a, p3a])

    @test area(poly) ≈ 1.5708 atol = 0.001
    @test area(Polygon(pi, [p1a, Point(0.0, 179.99), p3a])) ≈ 3.1416 atol = 0.001
    @test area(Polygon(pi, [p1a, p2a, p3a, Point(0.0, 270.001), Point(-89.99, 0.0)])) ≈ 4.7124 atol = 0.001
    @test area(Polygon(pi, [p2a, p3a, Point(0.0, 270.001), Point(-89.99, 0.0)])) ≈ 2*π atol = 0.001
    
    #complex polygon
    p1 = Point(64.0, 27.0)
    p2 = Point(47.0, 0.0)
    p3 = Point(42.0, 25.0)
    p4 = intermediate_point(p2,p3,0.33)
    p5 = Point(52.0, 16.0)
    p6 = intermediate_point(p2,p3,0.67)
    p7 = Point(55.0, -7.0)
    p8 = intermediate_point(p2,p1,0.33)
    p9 = Point(62.0, 4.0)
    p10 = intermediate_point(p2,p1,0.67)
    p11 = Point(56.0, 21.0)

    ## triangle areas
    at1 = area(p1,p2,p3)
    at2 = area(p4,p5,p6)
    at3 = area(p2,p7,p8)
    at4 = area(p8,p9,p10)

    ## area polygon
    expected_area_polygon = at1-at2+at3+at4

    polygon_complex_right = Polygon(p11, [p1,p3,p6,p5,p4,p2,p7,p8,p9,p10])
    polygon_complex_left = Polygon(p11, [p10,p9,p8,p7,p2,p4,p5,p6,p3,p1])

    @test area(polygon_complex_right) ≈ expected_area_polygon atol = 0.001
    @test area(polygon_complex_left) ≈ expected_area_polygon atol = 0.001
end