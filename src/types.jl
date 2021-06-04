export Point, Arc, Line, Arcs, Polygon, issimple, iscomplex, boundingbox,
isconcave, isconvex, convexhull

"""
    Point(ϕ::Float64, λ::Float64)

Point type with latitude `ϕ` [deg] and longitude `λ` [deg]
"""
struct Point{T<:Float64}
    ϕ::T
    λ::T
end

(-)(x::Point, y::Point) = Point(x.ϕ - y.ϕ, x.λ - y.λ)
(rad2deg)(x::Point) = Point(rad2deg(x.ϕ), rad2deg(x.λ))
(deg2rad)(x::Point) = Point(deg2rad(x.ϕ), deg2rad(x.λ))


"""
    Arc(point₁::Point, point₂::Point)

Arc type with start position `point₁` [deg] and end position `point₂`
[deg]. The Arc is defined along the shortest great circle distance between
the two points.
"""
struct Arc{T<:Float64}
    point₁::Point{T}
    point₂::Point{T}
end


"""
    Line(point::Point, azimuth::Float64)

Line type with `point` [deg] and `azimuth` [deg]. The line type of a great
circle line that completely circles the sphere.
"""
struct Line{T<:Float64}
    point::Point{T}
    azimuth::Float64
end


"""
    Arcs(points::Vector{Point})

Arcs type with a Vector of points [deg]. A minimum of two points are
necessary for the continuous string of line sections.
"""
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
"""
    Polygon(inside_point::Point, points::Vector{Point})

Polygon type with points [deg]. A minimum of three different points are
necessary for a polygon. Also an inside point must be given.
"""
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

"""
    Polygon(inside_point::Point, arcs::Arcs)

Generate Polygon type based on Arcs. Also an inside point must be given.
"""
Polygon(inside_point::Point, arcs::Arcs) = Polygon(inside_point,
arcs.points)


"""
    issimple(polygon::Polygon)

True if the polygon is 'simple' meaning that it does not self-intersect.
"""
function issimple(polygon::Polygon)
    return !isselfintersecting(polygon)
end

"""
    iscomplex(polygon::Polygon)

True if the polygon is 'complex' meaning that it self-intersects.
"""
iscomplex(polygon::Polygon) = !issimple(polygon)


"""
    isconcave(polygon::Polygon)

Tests if a polygon is concave.
    
This is true when the polygon is simple and not convex.
"""
isconcave(polygon::Polygon) = issimple(polygon) && !isconvex(polygon)

"""
    isconvex(polygon::Polygon)

Tests if a polygon is convex.

The test is setup by checking exhaustively all possible arcs between all
points of the polygon to intersect with the polygon. If false the polygon
is convex.
"""
function isconvex(polygon::Polygon)
    for (id,pt1) in enumerate(polygon.points[1:end-2])
        for pt2 in polygon.points[id+1:end]
            if length(intersection_points(Arc(pt1,pt2), polygon)) > 2
                return false
            end
        end
    end
    return true
end


"""
    boundingbox(arcs::Arcs)

    Output: [[ϕ_south,ϕ_north],[λ_west,λ_east]]

Generate bounding box values from the given arcs. All arcs stay
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
used for quick point-in-polygon tests. Any arc of the polygon stays within 
the lat/lon-limits of the bounding box.

Source: Chamberlain & Duquette - Some Algorithms for Polygons on a Sphere
"""
boundingbox(polygon::Polygon) = boundingbox(Arcs(polygon.points))


"""
    convexhull(polygon::Polygon)

    output: Polygon

Generate a convex hull for the polygon.

Source: stackoverflow.com/questions/9678624/convex-hull-of-longitude-latitude-points-on-the-surface-of-a-sphere
"""
function convexhull(polygon::Polygon)
    n_pts = length(polygon.points) - 1

    inside_point = point_cartesian(polygon.inside_point)
    points = point_cartesian.(polygon.points[1:end-1])
    # move points that are on a great circle arc section to inside_point
    for idA in 1:n_pts
        for idB in 1:n_pts
            if idA == idB
                #
            else
                for id in 1:n_pts
                    if id ≠ idA && id ≠ idB && ison(polygon.points[id], Arc(polygon.points[idA], 
                        polygon.points[idB]))
                        points[id] = inside_point
                    end
                end
            end
        end
    end

    # add great circle lines that have all points on or inside the convex hull
    hull_points = []
    for (idA, pointA) in enumerate(points)
        for (idB, pointB) in enumerate(points)
            if pointA == pointB
                #
            else
                great_circle = cross(pointA, pointB)
                tst = map(x -> dot(great_circle, x), points)
                tst[idA] = 0.0
                tst[idB] = 0.0
                if all(tst.≥0.0)
                    append!(hull_points, [[idA, idB]])
                end
            end
        end
    end

    # create convex hull by sequencing points
    convex_set = [hull_points[1][1], hull_points[1][2]]
    for _ in 1:length(hull_points)-1
        id = findfirst(x -> x[1] == convex_set[end], hull_points)
        push!(convex_set, hull_points[id][2])
    end

    return Polygon(polygon.inside_point, polygon.points[convex_set])
end