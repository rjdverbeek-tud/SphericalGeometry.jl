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

    angular_distance_x = 34.49
    angular_distance_y = 28.11
    angular_distance_z = 29.0
    
    @test spherical_angle(angular_distance_z, angular_distance_y, angular_distance_x) ≈ 76.6 atol = 0.1
    @test spherical_angle(angular_distance_x, angular_distance_z, angular_distance_y) ≈ 54.1 atol = 0.1
    @test spherical_angle(angular_distance_y, angular_distance_x, angular_distance_z) ≈ 56.4 atol = 0.1

    angular_distance_x2 = 35.0
    angular_distance_y2 = 35.0
    angular_distance_z2 = 0.1

    @test spherical_angle(angular_distance_z2, angular_distance_y2, angular_distance_x2) ≈ 89.9 atol = 0.1
    @test spherical_angle(angular_distance_x2, angular_distance_z2, angular_distance_y2) ≈ 89.9 atol = 0.1
    @test spherical_angle(angular_distance_y2, angular_distance_x2, angular_distance_z2) ≈ 0.174 atol = 0.001

end
