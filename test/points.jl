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

    @test intersection_point(p1ni, p2ni, p3ni, p4ni).ϕ ≈ 50.4313888888 atol = 0.0001
    @test intersection_point(p1ni, p2ni, p3ni, p4ni).λ ≈ 20.0 atol = 0.0001
    @test intersection_point(p1ni, p2ni, p3ni, p2ni).λ ≈ 30.0 atol = 0.0001
    @test intersection_point(Arc(p1ni, p2ni), Arc(p3ni, p2ni)).λ ≈ 30.0 atol = 0.0001

    p4ni2 = Point(49.0, 20.0)
    @test isnan(intersection_point(p1ni, p2ni, p3ni, p4ni2).λ)

    p1a = Point(10.0374, 0.0)
    p2a = Point(-90.0, 0.0)
    p3a = Point(0.0, 0.0)
    @test isinf(intersection_point(p3a, p2a, p1a, p3a).ϕ)

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

end
