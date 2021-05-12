"""
A Julia Package for handling Spherical Geometry.

It includes the calculation of:
* The distance to a point, line, arc, multi-arc, or polygon border
* The intersection points between lines, arcs, multi-arcs, and polygon borders.
* The self intersection points of multi-arcs and polygon borders

And testing if:
* a point, arc or multi-arc is inside a polygon
* a point is on a line, arc, multi-arc or polygon border
"""
module SphericalGeometry

import Base:(-)
import Base:(*)
import Base.Math.rad2deg, Base.Math.deg2rad

include("utility.jl")
include("types.jl")
include("angles.jl")
include("distances.jl")
include("points.jl")
include("operations.jl")
end

#TODO include area.jl
#TODO Add Area of spherical triangle
#TODO Add Area of spherical polygon
