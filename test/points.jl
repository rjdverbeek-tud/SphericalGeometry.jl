@testset "points.jl" begin
    p1 = Point(80.0, 190.0)
    p2 = Point(40.0, -10.0)

    mp = midpoint(p1, p2)
    @test mp.ϕ ≈ 69.58472222222 atol = 0.001
    @test mp.λ ≈ -15.62638888888 atol = 0.001
    @test midpoint(LineSection(p1, p2)).ϕ ≈ 69.58472222222 atol = 0.001

    ip = intermediate_point(p1, p2, 0.5)
    @test ip.ϕ ≈ 69.58472222222 atol = 0.001
    @test ip.λ ≈ -15.62638888888 atol = 0.001

    p3 = Point(0.0, -10.0)
    p4 = Point(0.0, 0.0)
    p5 = Point(0.0, 10.0)
    lss = LineSections([p3, p4, p5])
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
end
