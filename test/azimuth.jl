@testset "azimuth.jl" begin
    p1 = rad2deg(Point(0.5, 1.0))
    p2 = rad2deg(Point(1.0, 0.5))
    p3 = rad2deg(Point(0.6, 1.0))  # above p1

    rs = Arc(p1,p2)
    @test azimuth(p1, p2) ≈ rad2deg(5.81412807071) atol = 0.001
    @test azimuth(rs) ≈ rad2deg(5.81412807071) atol = 0.001
    @test azimuth(p3, p1) ≈ 180.0 atol = 0.001

    @test final_azimuth(p1, p2) ≈ rad2deg(5.45864813531) atol = 0.001
    @test final_azimuth(rs) ≈ rad2deg(5.45864813531) atol = 0.001
end
