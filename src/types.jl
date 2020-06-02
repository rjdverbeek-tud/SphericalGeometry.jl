export Point, LineSection, Line, LineSections, Polygon

"Point type with latitude `ϕ` [deg] and longitude `λ` [deg]"
struct Point{T<:Float64}
    ϕ::T
    λ::T
end

(-)(x::Point, y::Point) = Point(x.ϕ - y.ϕ, x.λ - y.λ)
(rad2deg)(x::Point) = Point(rad2deg(x.ϕ), rad2deg(x.λ))
(deg2rad)(x::Point) = Point(deg2rad(x.ϕ), deg2rad(x.λ))

"LineSection type with start position pos₁ [deg] and end position pos₂
[deg]"
struct LineSection{T<:Float64}
    point₁::Point{T}
    point₂::Point{T}
end

"Line type with `point` [deg] and `bearing` [deg]"
struct Line{T<:Float64}
    point::Point{T}
    bearing::Float64
end

"LineSections type with points [deg]. A minimum of two points are necessary for
a string of line sections"
struct LineSections{T<:Float64}
    points::Vector{Point{T}}
    function LineSections(points::Vector{Point{T}}) where T<:Float64
        if length(points) > 1
            new{T}(points)
        else
            throw(BoundsError("Invalid LineSections: # Points < 2"))
        end
    end
end

"Polygon type with points [deg]. A minimum of three different points are
necessary for a polygon."
struct Polygon{T<:Float64}
    points::Vector{Point{T}}
    function Polygon(points::Vector{Point{T}}) where T<:Float64
        if points[1] != points[end]
            points = vcat(points, points[1])
        end
        if length(points) > 3
            new{T}(points)
        else
            throw(BoundsError("Invalid Polygon: # individual Points < 3"))
        end
    end
end

#TODO Multiple LineSections
#TODO Multiple Polygons
