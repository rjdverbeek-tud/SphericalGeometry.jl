export convexhull

# Intersection ∩
# union ∪
# Substraction -  (Maybe not, so not to create polygons with holes)

"""

    convexhull(polygon::Polygon)

    output: Polygon

Source: stackoverflow.com/questions/9678624/convex-hull-of-longitude-latitude-points-on-the-surface-of-a-sphere

- Convert all points to cartesian vectors
- Consider each great circle passing through each set of points (A-B and B-A)
- Create great circle by using cross product on the two points defining great circle
- Check if all points are within the hemisphere defined by great circle
- A point is on the hemisphere if the dot product of the great circle and the
point is greater (or equal) to 0.
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
    for n in 1:length(hull_points)-1
        id = findfirst(x -> x[1] == convex_set[end], hull_points)
        push!(convex_set, hull_points[id][2])
    end

    return Polygon(polygon.inside_point, polygon.points[convex_set])
end