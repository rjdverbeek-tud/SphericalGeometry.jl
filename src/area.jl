export area

"""
    area(polygon::Polygon, radius::Float64=1.0)

Return the area of the spherical `polygon`. Without given radius a unit sphere is assumed.

Source: [Wikipedia](https://en.wikipedia.org/wiki/Spherical_trigonometry#Area_and_spherical_excess)

The method has been altered to allow for the usage of an internal point given with the Polygon.
This method only works with polygons that fit within half a sphere as it uses great circle distances between
subsequent points.
"""
function area(polygon::Polygon, radius::Float64=1.0)
    point₁ = polygon.points[1]
    area_polygon_unit_sphere = 0.0
    for point₂ in polygon.points[2:end]
        n_intersectionsᵢ = length(intersection_points(Arc(polygon.inside_point, 
        midpoint(point₁, point₂)), polygon))
        isodd(n_intersectionsᵢ) ? area_polygon_unit_sphere += 
        area(polygon.inside_point, point₁, point₂) : area_polygon_unit_sphere -= 
        area(polygon.inside_point, point₁, point₂)
        
        point₁ = point₂
    end
    return area_polygon_unit_sphere * radius^2
end

"""
    area(angular_distance₁₂::Float64, angular_distance₂₃::Float64, angular_distance₁₃::Float64, radius::Float64=1.0)

Return the area of the spherical triangle 123 based on the angular distances [deg] 12-23-13. Without given
radius a unit sphere is assumed.

Source: [MathWorld](https://mathworld.wolfram.com/SphericalTriangle.html)
"""
area(angular_distance₁₂::Float64, angular_distance₂₃::Float64, angular_distance₁₃::Float64, radius::Float64=1.0) =
    deg2rad(spherical_excess(angular_distance₁₂, angular_distance₁₃, angular_distance₂₃))*radius^2

"""
    area(point₁::Point, point₂::Point, point₃::Point, radius::Float64=1.0)

Return the area of the spherical triangle 123 based on the points `point₁` - `point₂` - `point₃`. Without given radius
a unit sphere is assumed.

Source: [MathWorld](https://mathworld.wolfram.com/SphericalTriangle.html)
"""
area(point₁::Point, point₂::Point, point₃::Point, radius::Float64=1.0) =
    area(angular_distance(point₁, point₂), angular_distance(point₂, point₃), angular_distance(point₃, point₁), radius)
