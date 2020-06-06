using SphericalGeometry
using Test

@testset "SphericalGeometry.jl" begin
    tests = ["utility", "types", "distances", "azimuth", "points"]
    # tests = ["distances"]
    for t in tests
        include("$(t).jl")
    end
end
