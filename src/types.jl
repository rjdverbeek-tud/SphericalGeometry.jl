export Point, Line, LineString, Polygon

"Point type with latitude `ϕ` [deg] and longitude `λ` [deg]"
struct Point{T<:Float64}
    ϕ::T
    λ::T
end

(-)(x::Point, y::Point) = Point(x.ϕ - y.ϕ, x.λ - y.λ)
(rad2deg)(x::Point) = Point(rad2deg(x.ϕ), rad2deg(x.λ))
(deg2rad)(x::Point) = Point(deg2rad(x.ϕ), deg2rad(x.λ))

"Line type with start position pos₁ [deg] and end position pos₂
[deg]"
struct Line{T<:Float64}
    point₁::Point{T}
    point₂::Point{T}
end

"LineString type with points [deg]. A minimum of two points are necessary for a linestring"
struct LineString{T<:Float64}
    points::Vector{Point{T}}
    function LineString(points::Vector{Point{T}}) where T<:Float64
        if length(points) > 1
            new{T}(points)
        else
            error("invalid LineString: # points < 2")
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
            error("invalid Polygon: # points < 3")
        end
    end
end
