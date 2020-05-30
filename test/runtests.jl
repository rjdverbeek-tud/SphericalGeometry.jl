using SphericalGeometry
using Test

@testset "SphericalGeometry.jl" begin
    tests = ["types", "distances", "bearing"]

    for t in tests
        include("$(t).jl")
    end
end
