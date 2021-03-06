@testset "points.jl" begin
    p1 = Point(80.0, 190.0)
    p2 = Point(40.0, -10.0)

    mp = midpoint(p1, p2)
    @test mp.ϕ ≈ 69.58472222222 atol = 0.001
    @test mp.λ ≈ -15.62638888888 atol = 0.001
    @test midpoint(Arc(p1, p2)).ϕ ≈ 69.58472222222 atol = 0.001

    ip = intermediate_point(p1, p2, 0.5)
    @test ip.ϕ ≈ 69.58472222222 atol = 0.001
    @test ip.λ ≈ -15.62638888888 atol = 0.001

    p3 = Point(0.0, -10.0)
    p4 = Point(0.0, 0.0)
    p5 = Point(0.0, 10.0)
    lss = Arcs([p3, p4, p5])
    ip_lss = intermediate_point(lss, 0.6)
    @test ip_lss.ϕ ≈ 0.0 atol = 0.01
    @test ip_lss.λ ≈ 2.0 atol = 0.01
    @test intermediate_point(lss, 0.0).λ ≈ -10.0 atol = 0.01
    @test intermediate_point(lss, 1.0).λ ≈ 10.0 atol = 0.01
    @test midpoint(lss).λ ≈ 0.0 atol = 0.01

    ad = 89.9321605919
    @test SphericalGeometry.normalize(destination_point(p1, ad, 45.0).λ, -180.0, 180.0) ≈ -35.44694444444 atol = 0.001
    @test destination_point(Line(p1, 45.0), ad).ϕ ≈ 7.12027777777 atol = 0.001

    intp = intersection_point(p4, p2, 45.0, 20.0)
    @test intp.ϕ ≈ 27.43166666666 atol = 0.001
    @test intp.λ ≈ 148.73138888888 atol = 0.001
    intp2 = intersection_point(Line(p4, 45.0), Line(p2, 20.0))
    @test intp2.ϕ ≈ 27.43166666666 atol = 0.001
    @test intp2.λ ≈ 148.73138888888 atol = 0.001

    p1ni = Point(50.0, 10.0)
    p2ni = Point(50.0, 30.0)
    p3ni = Point(40.0, 20.0)
    p4ni = Point(60.0, 20.0)

    @test intersection_point(p1ni, p2ni, p3ni, p4ni).ϕ ≈ 50.43250 atol = 0.01
    @test intersection_point(p1ni, p2ni, p3ni, p4ni).λ ≈ 20.0 atol = 0.0001
    @test intersection_point(p1ni, p2ni, p3ni, p2ni).λ ≈ 30.0 atol = 0.0001
    @test intersection_point(Arc(p1ni, p2ni), Arc(p3ni, p2ni)).λ ≈ 30.0 atol = 0.0001

    pa11 = Point(20.0, 10.0)
    pa12 = Point(90.0, 60.0)
    pa21 = Point(10.0, 50.0)
    pa22 = Point(80.0, 5.0)

    @test intersection_point(pa11, pa12, pa21, pa22).λ ≈ 10.0 atol = 0.1
    @test intersection_point(pa11, pa12, pa21, pa22).ϕ ≈ 79.06854 atol = 0.01

    p4ni2 = Point(49.0, 20.0)
    @test isnan(intersection_point(p1ni, p2ni, p3ni, p4ni2).λ)

    # p1a = Point(10.0374, 0.0)
    # p2a = Point(-90.0, 0.0)
    # p3a = Point(0.0, 0.0)
    # @test isinf(intersection_point(p3a, p2a, p1a, p3a).ϕ)

    p1ip1 = Point(5.0, -10.0)
    p2ip1 = Point(5.0, -5.0)
    p3ip1 = Point(5.0, 5.0)
    p4ip1 = Point(5.0, 6.0)
    p5ip1 = Point(5.0, 11.0)
    p6ip1 = Point(-1.0, 5.0)
    p1ip2 = Point(0.0, 0.0)
    p2ip2 = Point(0.0, 10.0)
    p3ip2 = Point(10.0, 10.0)
    p4ip2 = Point(10.0, 0.0)
    p5ip2 = Point(1.0, 0.0)

    @test length(intersection_points(Arcs([p1ip1, p2ip1, p3ip1, p4ip1, p5ip1,
    p6ip1]), Arcs([p1ip2, p2ip2, p3ip2, p4ip2, p5ip2]))) == 4
    @test length(intersection_points(Arcs([p1ip1, p2ip1, p3ip1, p4ip1, p5ip1,
    p6ip1]), Polygon(p1ip2, [p1ip2, p2ip2, p3ip2, p4ip2, p5ip2]))) == 4
    @test length(intersection_points(Polygon(p1ip2, [p1ip1, p2ip1, p3ip1, p4ip1, p5ip1,
    p6ip1]), Polygon(p1ip2, [p1ip2, p2ip2, p3ip2, p4ip2, p5ip2]))) == 6

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

    @test length(intersection_points(Arc(Point(63.0, 27.0), Point(65.0, 27.0)), polygon_concave)) == 1
    @test length(intersection_points(Arc(Point(63.0, 28.0), Point(65.0, 28.0)), polygon_concave)) == 0
    @test length(intersection_points(Arc(Point(62.0, 4.0), Point(55.0, -7.0)), polygon_concave)) == 2
    @test length(intersection_points(Arc(Point(56.0, 21.0), Point(55.0, 21.0)), polygon_concave)) == 0
    @test length(intersection_points(Arc(Point(64.0, 26.0), Point(47.0, -1.0)), polygon_concave)) == 4
    @test length(intersection_points(Arc(Point(56.0, 21.0), Point(52.0, 16.0)), polygon_concave)) == 1
    @test length(intersection_points(Arc(Point(52.0, 16.0), Point(56.0, 21.0)), polygon_concave)) == 1
    @test length(intersection_points(Arc(Point(56.0, 21.0), Point(56.0, 30.0)), polygon_concave)) == 1

    pt1 = Point(20.0, -5.0)
    pt2 = Point(21.0, 5.0)
    pt3 = Point(22.0, 15.0)
    pa = Point(40.0, 5.0)
    pb = Point(30.0, 5.0)
    pc = Point(10.0, 5.0)
    pd = Point(0.0, 5.0)
    arcs123 = Arcs([pt1, pt2, pt3])

    z = intersection_points(arcs123, Arcs([pt2,pc,pd]))

    @test length(intersection_points(arcs123, Arcs([pt1,pc,pd]))) == 1
    @test length(intersection_points(arcs123, Arcs([pt2,pc,pd]))) == 1
    @test length(intersection_points(arcs123, Arcs([pt3,pc,pd]))) == 1
    @test length(intersection_points(arcs123, Arcs([pb,pt1,pc]))) == 1
    @test length(intersection_points(arcs123, Arcs([pb,pt2,pc]))) == 1
    @test length(intersection_points(arcs123, Arcs([pb,pt3,pc]))) == 1
    @test length(intersection_points(arcs123, Arcs([pa,pb,pt1]))) == 1
    @test length(intersection_points(arcs123, Arcs([pa,pb,pt2]))) == 1
    @test length(intersection_points(arcs123, Arcs([pa,pb,pt3]))) == 1
    
    @test length(intersection_points(arcs123, Arcs([pb,Point(10.0, 4.0),pd]))) == 1
    @test length(intersection_points(arcs123, Arcs([pa,pb,pc]))) == 1

    @test !ison(p1ip1, Arc(p2ip1, p3ip1))
    @test ison(Point(0.0, 5.0), Arc(p1ip2, p2ip2))
    @test ison(Point(0.0, 5.0), Arcs([p1ip2, p2ip2, p3ip2]))
    @test ison(Point(0.0, 5.0), Polygon(p5ip2, [p1ip2, p2ip2, p3ip2]))

    p1i = Point(0.0, 0.0)
    p2i = Point(0.0, 10.0)
    p3i = Point(10.0, 10.0)
    p4i = Point(5.0, 5.0)
    p5i = Point(10.0, 0.0)
    px_inside = Point(7.0, 8.0)

    p6i_out = Point(15.0, 0.0)
    p7i_out = Point(6.0, 5.0)
    p8i_out = Point(6.0, -2.0)
    p9i_in = Point(6.0, 2.0)
    p10i_in = Point(1.0, 6.0)
    p11i_in = Point(1.0, 1.0)

    poly_inside = Polygon(px_inside, [p1i, p2i, p3i, p4i, p5i])
    @test !isinside(p6i_out, poly_inside)
    @test !isinside(p7i_out, poly_inside)
    @test !isinside(p8i_out, poly_inside)
    @test isinside(p9i_in, poly_inside)
    @test isinside(p10i_in, poly_inside)

    @test isinside(Arc(p9i_in, p10i_in), poly_inside)
    @test !isinside(Arc(p8i_out, p10i_in), poly_inside)
    @test !isinside(Arc(p10i_in, p8i_out), poly_inside)
    @test !isinside(Arc(p6i_out, p8i_out), poly_inside)

    @test isinside(Arcs([p9i_in, p10i_in]), poly_inside)
    @test !isinside(Arcs([p8i_out, p10i_in]), poly_inside)
    @test !isinside(Arcs([p10i_in, p8i_out]), poly_inside)
    @test !isinside(Arcs([p6i_out, p8i_out]), poly_inside)

    poly2 = Polygon(Point(2.0, 2.0), [p9i_in, p11i_in, p10i_in])
    @test isinside(poly2, poly_inside)

    poly3 = Polygon(px_inside, [p1i, p2i, p5i, p3i])
    arcs3 = Arcs([p1i, p3i, p2i, p5i])
    @test !isselfintersecting(poly2)
    @test isselfintersecting(poly3)
    @test isselfintersecting(arcs3)
    @test !isselfintersecting(Arcs([p1i, p2i, p3i, p4i, p5i]))

    # https://www.onboardintelligence.com/GC for generating test (sphere)
    pz1 = Point(50.0, 70.0)
    pz2 = Point(50.0, -70.0)
    azi = azimuth(pz1, pz2)
    @test highest_latitude(pz1, azi) ≈ 73.9871 atol = 0.0001
    @test lowest_latitude(pz1, azi) ≈ -73.9871 atol = 0.0001
    @test highest_latitude_point(pz1, pz2).ϕ ≈ 73.9871 atol = 0.0001
    @test lowest_latitude_point(pz1, pz2).ϕ ≈ 50.0 atol = 0.001
    @test highest_latitude_point(pz1, Point(60.0, 70.0)).ϕ ≈ 60.0 atol = 0.001
    @test highest_latitude_point(Point(60.0, 70.0), pz1).ϕ ≈ 60.0 atol = 0.001
    @test lowest_latitude_point(pz1, Point(60.0, 70.0)).ϕ ≈ 50.0 atol = 0.001
    @test lowest_latitude_point(Point(60.0, 70.0), pz1).ϕ ≈ 50.0 atol = 0.001
    @test highest_latitude_point(pz1, Point(60.0, 80.0)).ϕ ≈ 60.0 atol = 0.0001

    azi2 = azimuth(Point(30.0, 89.0), Point(50.0, -60.0))
    @test highest_latitude_point(Point(30.0, 89.0), azi2).ϕ ≈ 73.2626 atol=0.0001
    @test highest_latitude_point(Point(30.0, 89.0), azi2).λ ≈ 8.9986 atol=0.0001
    @test lowest_latitude_point(Point(30.0, 89.0), azi2).λ ≈ -171.0014 atol=0.0001

    @test highest_latitude_point(pz1, azi).ϕ ≈ 73.9871 atol = 0.0001
    @test lowest_latitude_point(pz1, azi).ϕ ≈ -73.9871 atol = 0.0001
    @test highest_latitude_point(pz1, azi).λ ≈ 0.0 atol = 0.0001

    @test highest_latitude_point(Point(30.0, 90.0), 0.0).ϕ ≈ 90.0 atol = 0.1

end
