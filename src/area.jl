export area

"""
    area(polygon::Polygon, radius::Float64=1.0)

Return the area of the spherical polygon. Without given radius a unit sphere is assumed.

Source: en.wikipedia.org/wiki/Spherical_trigonometry # Area and spherical excess

The method has been altered to allow for the usage of an internal point given with the Polygon.
"""
# function area(polygon::Polygon, radius::Float64=1.0)
#     n_points = length(polygon.points) - 1
#     point₁ = polygon.points[end-1]
#     area_polygon_unit_sphere_deg = -(n_points-2)*180.0
#     println(area_polygon_unit_sphere_deg)
#     for point₂ in polygon.points[1:end-1]
#         area_polygon_unit_sphere_deg += spherical_angle(polygon.inside_point, point₁, point₂)
#         println(spherical_angle(polygon.inside_point, point₁, point₂))
#         area_polygon_unit_sphere_deg += spherical_angle(point₁, point₂, polygon.inside_point)
#         println(spherical_angle(point₁, point₂, polygon.inside_point))
#         point₁ = point₂
#     end
#     return deg2rad(area_polygon_unit_sphere_deg) * radius^2
# end
function area(polygon::Polygon, radius::Float64=1.0)
    n_points = length(polygon.points) - 1
    fraction = 0.999999
    point₁ = polygon.points[1]
    n_intersections₁ = length(intersection_points(Arc(polygon.inside_point, intermediate_point(polygon.inside_point, point₁, fraction)), polygon))
    area_polygon_unit_sphere = 0.0
    for point₂ in polygon.points[2:end]
        # println(intersection_points(Arc(polygon.inside_point, point₂), polygon))
        n_intersections₂ = length(intersection_points(Arc(polygon.inside_point, 
        intermediate_point(polygon.inside_point, point₂, fraction)), polygon))
        # println(n_intersections₁, " ", n_intersections₂)
        iseven(n_intersections₁ + n_intersections₂) ? area_polygon_unit_sphere += area(polygon.inside_point, point₁, point₂) : area_polygon_unit_sphere -= area(polygon.inside_point, point₁, point₂)
        iseven(n_intersections₁ + n_intersections₂) ? println(area(polygon.inside_point, point₁, point₂)) : println(-area(polygon.inside_point, point₁, point₂))
        
        point₁ = point₂
        n_intersections₁ = n_intersections₂
    end
    return area_polygon_unit_sphere * radius^2
end
#intersection_points(Arc(point, polygon.inside_point), polygon)

# function area(polygon::Polygon, radius::Float64=1.0)
#     n_points = length(polygon.points) - 1
#     point₁ = polygon.points[end-2]
#     point₂ = polygon.points[end-1]
#     area_polygon_unit_sphere_deg = -(n_points-2)*180.0
#     println(area_polygon_unit_sphere_deg)
#     for point₃ in polygon.points[1:end-1]
#         area_polygon_unit_sphere_deg += spherical_angle(point₁, point₂, point₃)
#         point₁ = point₂
#         point₂ = point₃
#     end
#     return deg2rad(area_polygon_unit_sphere_deg) * radius^2
# end
# function area(polygon::Polygon, radius::Float64=1.0)
#     n_points = length(polygon.points) - 1
#     point₁ = reverse(polygon.points)[end-2]
#     point₂ = reverse(polygon.points)[end-1]
#     area_polygon_unit_sphere_deg = -(n_points-2)*180.0
#     println(area_polygon_unit_sphere_deg)
#     for point₃ in reverse(polygon.points)[1:end-1]
#         area_polygon_unit_sphere_deg += spherical_angle(point₁, point₂, point₃)
#         point₁ = point₂
#         point₂ = point₃
#     end
#     return deg2rad(area_polygon_unit_sphere_deg) * radius^2
# end

"""
    area(angular_distance₁₂::Float64, angular_distance₂₃::Float64, angular_distance₁₃::Float64,
    radius::Float64=1.0)

Return the area of the spherical triangle 123 based on the angular distances [deg] 12-23-13. Without given
radius a unit sphere is assumed.

Source: mathworld.wolfram.com/SphericalTriangle.html
"""
function area(angular_distance₁₂::Float64, angular_distance₂₃::Float64, angular_distance₁₃::Float64,
    radius::Float64=1.0)
    return deg2rad(spherical_excess(angular_distance₁₂, angular_distance₁₃, angular_distance₂₃))*radius^2
end

"""
    area(point₁::Point, point₂::Point, point₃::Point, radius::Float64=1.0)

Return the area of the spherical triangle 123 based on the points point₁ - point₂ - point₃. Without given radius
a unit sphere is assumed.

Source: mathworld.wolfram.com/SphericalTriangle.html
"""
area(point₁::Point, point₂::Point, point₃::Point, radius::Float64=1.0) = 
area(angular_distance(point₁, point₂), angular_distance(point₂, point₃), angular_distance(point₁, point₃),
radius)