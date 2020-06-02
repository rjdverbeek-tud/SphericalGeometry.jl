@testset "utility.jl" begin
    @test SphericalGeometry.normalize(-270.0, -180.0, 180.0) ≈ 90.0 atol = 0.1
    @test SphericalGeometry.normalize(181.0, -180.0, 180.0) ≈ -179.0 atol = 0.1
end
