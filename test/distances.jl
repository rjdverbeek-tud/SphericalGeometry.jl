@testset "distances.jl" begin
    p1 = Point(30.0, 100.0)
    p2 = Point(50.0, 210.0)
    p3 = Point(40.0, 180.0)

    ls = Arc(p1,p2)
    lss = Arcs([p1, p2, p3])

    @test (angular_distance(p1, p2)) ≈ 8773e3/6371008.7714 atol = 1e3
    @test (angular_length(ls)) ≈ 8773e3/6371008.7714 atol = 1e3
    @test (angular_distance(p1, p1)) == 0.0
    @test (angular_length(lss)) ≈ (8773e3+2585e3)/6371008.7714 atol = 1e3

    # Example http://edwilliams.org/avform.htm Cross track error
    pLAX = Point(33.95,-118.4)
    pJFK = Point(40.63333, -73.78333)
    pD = Point(34.5, -116.5)

    dist_LAX2D = angular_distance(pLAX, pD)
    @test dist_LAX2D ≈ rad2deg(0.02905) atol = 0.1
    bearing_LAX2D = azimuth(pLAX, pD)
    @test bearing_LAX2D ≈ 70.17 atol = 0.01
    bearing_LAX2JFK = azimuth(pLAX, pJFK)

    @test angular_distance(dist_LAX2D, bearing_LAX2D, bearing_LAX2JFK) ≈
    rad2deg(0.00216747) atol = 0.0001
    @test angular_distance(pD, pLAX, bearing_LAX2JFK) ≈
    rad2deg(0.00216747) atol = 0.0001
    @test angular_distance(pD, Line(pLAX, bearing_LAX2JFK)) ≈
    rad2deg(0.00216747) atol = 0.0001

    @test along_line_angular_distance(rad2deg(0.02905), rad2deg(0.00216747)) ≈
    rad2deg(0.0289691) atol = 0.00001
    @test along_line_angular_distance(pD, Line(pLAX, bearing_LAX2JFK)) ≈
    rad2deg(0.0289691) atol = 0.00001

    px1 = Point(-10.0, -20.0)
    px2 = Point(10.0, -20.0)
    px3a = Point(0.0, -10.0)
    @test angular_distance(px3a, px1, px2) ≈ 10.0 atol = 0.1
    px3b = Point(15.0, -20.0)
    @test angular_distance(px3b, px1, px2) ≈ 5.0 atol = 0.1
    px3c = Point(-17.0, -20.0)
    @test angular_distance(px3c, px1, px2) ≈ 7.0 atol = 0.1
    @test angular_distance(px3c, Arc(px1, px2)) ≈ 7.0 atol = 0.1

    px4 = Point(0.0, 0.0)
    px5 = Point(10.0, 0.0)
    arc = Arc(px4, px5)
    @test (angular_distance(Point(-5.0, 0.0), arc)) ≈ 556.0*1000/6371008.7714 atol = 100.0
    @test (angular_distance(Point(-5.0, 5.0), arc)) ≈ 785.8*1000/6371008.7714 atol = 100.0
    @test (angular_distance(Point(0.0, 5.0), arc)) ≈ 556.0*1000/6371008.7714 atol = 100.0
    @test (angular_distance(Point(5.0, 5.0), arc)) ≈ 553.9*1000/6371008.7714 atol = 100.0
    @test (angular_distance(Point(10.0, 5.0), arc)) ≈ 547.5*1000/6371008.7714 atol = 100.0
    @test (angular_distance(Point(15.0, 0.0), arc)) ≈ 556.0*1000/6371008.7714 atol = 100.0
    @test (angular_distance(Point(15.0, -5.0), arc)) ≈ 776.9*1000/6371008.7714 atol = 100.0
    @test (angular_distance(Point(10.0, -5.0), arc)) ≈ 547.5*1000/6371008.7714 atol = 100.0
    @test (angular_distance(Point(5.0, -5.0), arc)) ≈ 553.9*1000/6371008.7714 atol = 100.0
    @test (angular_distance(Point(0.0, -5.0), arc)) ≈ 556.0*1000/6371008.7714 atol = 100.0
    @test (angular_distance(Point(5.0, 0.0), arc)) ≈ 0.0*1000/6371008.7714 atol = 100.0

    @test (angular_distance(Point(-5.0, 0.0), px4)) ≈ 556.0*1000/6371008.7714 atol = 100.0
    @test (angular_distance(Point(-5.0, 5.0), px4)) ≈ 785.8*1000/6371008.7714 atol = 100.0
    @test (angular_distance(Point(0.0, 5.0), px4)) ≈ 556.0*1000/6371008.7714 atol = 100.0
    @test (angular_distance(Point(5.0, 5.0), arc)) ≈ 553.9*1000/6371008.7714 atol = 100.0
    @test (angular_distance(Point(10.0, 5.0), px5)) ≈ 547.5*1000/6371008.7714 atol = 100.0
    @test (angular_distance(Point(15.0, 0.0), px5)) ≈ 556.0*1000/6371008.7714 atol = 100.0
    @test (angular_distance(Point(15.0, -5.0), px5)) ≈ 776.9*1000/6371008.7714 atol = 100.0
    @test (angular_distance(Point(10.0, -5.0), px5)) ≈ 547.5*1000/6371008.7714 atol = 100.0
    @test (angular_distance(Point(5.0, -5.0), arc)) ≈ 553.9*1000/6371008.7714 atol = 100.0
    @test (angular_distance(Point(0.0, -5.0), px4)) ≈ 556.0*1000/6371008.7714 atol = 100.0
    @test (angular_distance(Point(5.0, 0.0), arc)) ≈ 0.0*1000/6371008.7714 atol = 100.0

    @test (angular_length(Polygon(p1, [p1, p2, p3, p1]))) ≈ (8773e3+
    2585e3)/6371008.7714+(angular_distance(p1, p3)) atol = 1e3

end
