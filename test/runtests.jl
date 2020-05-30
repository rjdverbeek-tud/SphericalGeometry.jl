using SphericalGeometry
using Test

@testset "SphericalGeometry.jl" begin
    tests = ["types"]

    for t in tests
        include("$(t).jl")
    end
end
