@testset "utility.jl" begin
    @test SphericalGeometry.normalize(-270.0, -180.0, 180.0) ≈ 90.0 atol = 0.1
    @test SphericalGeometry.normalize(181.0, -180.0, 180.0) ≈ -179.0 atol = 0.1

    # Source: https://gist.github.com/missinglink/d0a085188a8eab2ca66db385bb7c023a
    # Latitude positive
    @test SphericalGeometry.normalize(Point(55.555, 22.222)).ϕ ≈ 55.555 atol = 0.00001
    @test SphericalGeometry.normalize(Point(55.555, 22.222)).λ ≈ 22.222 atol = 0.00001

    @test SphericalGeometry.normalize(Point(1.0, 0.0)).ϕ ≈ 1.0 atol = 0.00001
    @test SphericalGeometry.normalize(Point(1.0, 0.0)).λ ≈ 0.0 atol = 0.00001

    @test SphericalGeometry.normalize(Point(91.0, 0.0)).ϕ ≈ 89.0 atol = 0.00001
    @test SphericalGeometry.normalize(Point(91.0, 0.0)).λ ≈ 180.0 atol = 0.00001

    @test SphericalGeometry.normalize(Point(181.0, 0.0)).ϕ ≈ -1.0 atol = 0.00001
    @test SphericalGeometry.normalize(Point(181.0, 0.0)).λ ≈ 180.0 atol = 0.00001

    @test SphericalGeometry.normalize(Point(271.0, 0.0)).ϕ ≈ -89.0 atol = 0.00001
    @test SphericalGeometry.normalize(Point(271.0, 0.0)).λ ≈ 0.0 atol = 0.00001

    @test SphericalGeometry.normalize(Point(361.0, 0.0)).ϕ ≈ 1.0 atol = 0.00001
    @test SphericalGeometry.normalize(Point(361.0, 0.0)).λ ≈ 0.0 atol = 0.00001

    @test SphericalGeometry.normalize(Point(631.0, 0.0)).ϕ ≈ -89.0 atol = 0.00001
    @test SphericalGeometry.normalize(Point(631.0, 0.0)).λ ≈ 0.0 atol = 0.00001

    @test SphericalGeometry.normalize(Point(721.0, 0.0)).ϕ ≈ 1.0 atol = 0.00001
    @test SphericalGeometry.normalize(Point(721.0, 0.0)).λ ≈ 0.0 atol = 0.00001

    # Latitude negative
    @test SphericalGeometry.normalize(Point(-1.0, 0.0)).ϕ ≈ -1.0 atol = 0.00001
    @test SphericalGeometry.normalize(Point(-1.0, 0.0)).λ ≈ 0.0 atol = 0.00001

    @test SphericalGeometry.normalize(Point(-91.0, 0.0)).ϕ ≈ -89.0 atol = 0.00001
    @test SphericalGeometry.normalize(Point(-91.0, 0.0)).λ ≈ 180.0 atol = 0.00001

    @test SphericalGeometry.normalize(Point(-181.0, 0.0)).ϕ ≈ 1.0 atol = 0.00001
    @test SphericalGeometry.normalize(Point(-181.0, 0.0)).λ ≈ 180.0 atol = 0.00001

    @test SphericalGeometry.normalize(Point(-271.0, 0.0)).ϕ ≈ 89.0 atol = 0.00001
    @test SphericalGeometry.normalize(Point(-271.0, 0.0)).λ ≈ 0.0 atol = 0.00001

    @test SphericalGeometry.normalize(Point(-361.0, 0.0)).ϕ ≈ -1.0 atol = 0.00001
    @test SphericalGeometry.normalize(Point(-361.0, 0.0)).λ ≈ 0.0 atol = 0.00001

    @test SphericalGeometry.normalize(Point(-631.0, 0.0)).ϕ ≈ 89.0 atol = 0.00001
    @test SphericalGeometry.normalize(Point(-631.0, 0.0)).λ ≈ 0.0 atol = 0.00001

    @test SphericalGeometry.normalize(Point(-721.0, 0.0)).ϕ ≈ -1.0 atol = 0.00001
    @test SphericalGeometry.normalize(Point(-721.0, 0.0)).λ ≈ 0.0 atol = 0.00001

    # Longitude positive
    @test SphericalGeometry.normalize(Point(0.0, 1.0)).ϕ ≈ 0.0 atol = 0.00001
    @test SphericalGeometry.normalize(Point(0.0, 1.0)).λ ≈ 1.0 atol = 0.00001

    @test SphericalGeometry.normalize(Point(0.0, 181.0)).ϕ ≈ 0.0 atol = 0.00001
    @test SphericalGeometry.normalize(Point(0.0, 181.0)).λ ≈ -179.0 atol = 0.00001

    @test SphericalGeometry.normalize(Point(0.0, 271.0)).ϕ ≈ 0.0 atol = 0.00001
    @test SphericalGeometry.normalize(Point(0.0, 271.0)).λ ≈ -89.0 atol = 0.00001

    @test SphericalGeometry.normalize(Point(0.0, 361.0)).ϕ ≈ 0.0 atol = 0.00001
    @test SphericalGeometry.normalize(Point(0.0, 361.0)).λ ≈ 1.0 atol = 0.00001

    @test SphericalGeometry.normalize(Point(0.0, 631.0)).ϕ ≈ 0.0 atol = 0.00001
    @test SphericalGeometry.normalize(Point(0.0, 631.0)).λ ≈ -89.0 atol = 0.00001

    @test SphericalGeometry.normalize(Point(0.0, 721.0)).ϕ ≈ 0.0 atol = 0.00001
    @test SphericalGeometry.normalize(Point(0.0, 721.0)).λ ≈ 1.0 atol = 0.00001

    # Longitude negative
    @test SphericalGeometry.normalize(Point(0.0, -1.0)).ϕ ≈ 0.0 atol = 0.00001
    @test SphericalGeometry.normalize(Point(0.0, -1.0)).λ ≈ -1.0 atol = 0.00001

    @test SphericalGeometry.normalize(Point(0.0, -181.0)).ϕ ≈ 0.0 atol = 0.00001
    @test SphericalGeometry.normalize(Point(0.0, -181.0)).λ ≈ 179.0 atol = 0.00001

    @test SphericalGeometry.normalize(Point(0.0, -271.0)).ϕ ≈ 0.0 atol = 0.00001
    @test SphericalGeometry.normalize(Point(0.0, -271.0)).λ ≈ 89.0 atol = 0.00001

    @test SphericalGeometry.normalize(Point(0.0, -361.0)).ϕ ≈ 0.0 atol = 0.00001
    @test SphericalGeometry.normalize(Point(0.0, -361.0)).λ ≈ -1.0 atol = 0.00001

    @test SphericalGeometry.normalize(Point(0.0, -631.0)).ϕ ≈ 0.0 atol = 0.00001
    @test SphericalGeometry.normalize(Point(0.0, -631.0)).λ ≈ 89.0 atol = 0.00001

    @test SphericalGeometry.normalize(Point(0.0, -721.0)).ϕ ≈ 0.0 atol = 0.00001
    @test SphericalGeometry.normalize(Point(0.0, -721.0)).λ ≈ -1.0 atol = 0.00001
end
