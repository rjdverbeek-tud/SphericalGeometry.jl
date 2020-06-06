using Documenter, SphericalGeometry

makedocs(
    sitename = "SphericalGeometry.jl",
    modules = [SphericalGeometry],
    pages = Any[
        "Home" => "index.md",
    ],
)

deploydocs(
    repo = "github.com/rjdverbeek-tud/SphericalGeometry.jl.git",
)
