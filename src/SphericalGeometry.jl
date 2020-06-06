module SphericalGeometry

import Base:(-)
import Base:(*)
import Base.Math.rad2deg, Base.Math.deg2rad
# Write your package code here.

include("utility.jl")
include("types.jl")
include("azimuth.jl")
include("distances.jl")
include("points.jl")
end
#TODO Area
#TODO voronoi triangulation
