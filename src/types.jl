export Point, Arc, Line, Arcs, Polygon

"Point type with latitude `ϕ` [deg] and longitude `λ` [deg]"
struct Point{T<:Float64}
    ϕ::T
    λ::T
end

(-)(x::Point, y::Point) = Point(x.ϕ - y.ϕ, x.λ - y.λ)
(rad2deg)(x::Point) = Point(rad2deg(x.ϕ), rad2deg(x.λ))
(deg2rad)(x::Point) = Point(deg2rad(x.ϕ), deg2rad(x.λ))

"Multiple Points"
struct MultiPoint{T<:Float64}
    mpoint::Vector{Point{T}}
end

"Arc type with start position pos₁ [deg] and end position pos₂
[deg]"
struct Arc{T<:Float64}
    point₁::Point{T}
    point₂::Point{T}
end

"Multiple Arc"
struct MultiArc{T<:Float64}
    marc::Vector{Arc{T}}
end

"Line type with `point` [deg] and `azimuth` [deg]"
struct Line{T<:Float64}
    point::Point{T}
    azimuth::Float64
end

"Arcs type with points [deg]. A minimum of two points are necessary for
a string of line sections"
struct Arcs{T<:Float64}
    points::Vector{Point{T}}
    function Arcs(points::Vector{Point{T}}) where T<:Float64
        if length(points) > 1
            new{T}(points)
        else
            throw(BoundsError("Invalid Arcs: # Points < 2"))
        end
    end
end

"Multiple Arcs"
struct MultiArcs{T<:Float64}
    marcs::Vector{Arcs{T}}
end

#TODO Ensure that the inside_point is not on any line crossing adjacent points of the polygon
"Polygon type with points [deg]. A minimum of three different points are
necessary for a polygon."
struct Polygon{T<:Float64}
    inside_point::Point{T}
    points::Vector{Point{T}}
    function Polygon(inside_point::Point, points::Vector{Point{T}}) where T<:Float64
        if points[1] != points[end]
            points = vcat(points, points[1])
        end
        if length(points) > 3
            new{T}(inside_point, points)
        else
            throw(BoundsError("Invalid Polygon: # individual Points < 3"))
        end
    end
end

"Multiple Polygons"
struct MultiPolygons{T<:Float64}
    mpolygon::Vector{Polygon{T}}
end
