export Point, Arc, Line, Arcs, Polygon, issimple, iscomplex, boundingbox,
isconcave, isconvex

"Point type with latitude `ϕ` [deg] and longitude `λ` [deg]"
struct Point{T<:Float64}
    ϕ::T
    λ::T
end

(-)(x::Point, y::Point) = Point(x.ϕ - y.ϕ, x.λ - y.λ)
(rad2deg)(x::Point) = Point(rad2deg(x.ϕ), rad2deg(x.λ))
(deg2rad)(x::Point) = Point(deg2rad(x.ϕ), deg2rad(x.λ))

"Arc type with start position pos₁ [deg] and end position pos₂
[deg]"
struct Arc{T<:Float64}
    point₁::Point{T}
    point₂::Point{T}
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

" issimple(polygon::Polygon)

True if the polygon is 'simple' meaning that it does not self-intersect.
"
function issimple(polygon::Polygon)
    return !isselfintersecting(polygon)
end

"""
    iscomplex(polygon::Polygon)

True if the polygon is 'complex' meaning that it self-intersects.
"""
function iscomplex(polygon::Polygon)
    return !issimple(polygon)
end

"""
    boundingbox(arcs::Arcs)

    Output: [[ϕ_south,ϕ_north],[λ_west,λ_east]]

Generate bounding box values from the given arcs. Any edge of the arcs stays
within the lat/lon-limits of the bounding box.

Source: Chamberlain & Duquette - Some Algorithms for Polygons on a Sphere
"""
function boundingbox(arcs::Arcs)
    λw = minimum([point.λ for point in arcs.points])
    λe = maximum([point.λ for point in arcs.points])
    pt1 = arcs.points[1]
    ϕmax = -90.0
    ϕmin = 90.0
    for pt2 in arcs.points[2:end] 
        ϕmax = max(ϕmax, highest_latitude_point(pt1, pt2).ϕ)
        ϕmin = min(ϕmin, lowest_latitude_point(pt1, pt2).ϕ)
        pt1=pt2
    end
    return [[ϕmin,ϕmax],[λw,λe]]
end

"""
    boundingbox(polygon::Polygon)

    Output: [[ϕ_south,ϕ_north],[λ_west,λ_east]]

Generate bounding box values from the given polygon. This bounding box can be 
used for quick point-in-polygon tests. Any edge of the polygon stays within 
the lat/lon-limits of the bounding box.

Source: Chamberlain & Duquette - Some Algorithms for Polygons on a Sphere
"""
function boundingbox(polygon::Polygon)
    λw = minimum([point.λ for point in polygon.points])
    λe = maximum([point.λ for point in polygon.points])
    pt1 = polygon.points[1]
    ϕmax = -90.0
    ϕmin = 90.0
    for pt2 in polygon.points[2:end] 
        ϕmax = max(ϕmax, highest_latitude_point(pt1, pt2).ϕ)
        ϕmin = min(ϕmin, lowest_latitude_point(pt1, pt2).ϕ)
        pt1=pt2
    end
    return [[ϕmin,ϕmax],[λw,λe]]
end

"""
    isconcave(polygon::Polygon)

Tests is a polygon is concave.

The test is setup by checking exhaustively all possible arcs between all
points of the polygon to intersect with the polygon. If true the polygon
is concave.

#TODO More efficient method for determining if polygon is concave.
"""
function isconcave(polygon::Polygon)
    for (id,pt1) in enumerate(polygon.points[1:end-2])
        for pt2 in polygon.points[id+1:end]
            if length(intersection_points(Arc(pt1,pt2), polygon)) > 2
                return true
            end
        end
    end
    return false
end

"""
    isconvex(polygon::Polygon)

Tests is a polygon is convex.

Opposite of concave polygon.
"""
isconvex(polygon::Polygon) = !isconcave(polygon)

#TODO isclockwise
#TODO iscounterclockwise