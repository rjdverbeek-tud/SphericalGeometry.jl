export angular_distance, distance, along_line_angular_distance, angular_length

"""
    Radius Earth [m]

Source: en.wikipedia.org/wiki/Earth_radius
"""
const Rₑ_m = 6371008.7714

"""
    angular_distance(point₁::Point, point₂::Point)

Return the `angular_distance` [deg] of the great circle line between the
positions `point₁` [deg] and `point₂` [deg] on a unit sphere.

Source: www.movable-type.co.uk/scripts/latlong.html
"""
function angular_distance(point₁::Point, point₂::Point)
    Δpos = point₂ - point₁
    a = sind(Δpos.ϕ/2.0)^2 + cosd(point₁.ϕ)*cosd(point₂.ϕ)*sind(Δpos.λ/2.0)^2
    c = 2.0 * atand(√a, √(1.0 - a))
    return c
end

"""
    angular_length(line::Line)

Return the `angular_length` [deg] of the great circle line section on a
unit sphere.
"""
angular_length(arc::Arc) =
angular_distance(arc.point₁, arc.point₂)

"""
    angular_length(arcs::Arcs)

Return the `angular_length` [deg] along the arcs on a unit sphere.
"""
function angular_length(arcs::Arcs)
    point₁ = arcs.points[1]
    dist_deg = 0.0
    for point₂ in arcs.points[2:end]
        dist_deg += angular_distance(point₁, point₂)
        point₁ = point₂
    end
    return dist_deg
end

"""
    distance(angular_distance::Float64, radius::Float64=Rₑ_m)

Convert the `angular_distance` [deg] into a distance on a sphere of given radius
 [m]. The default radius is the radius of the Earth.
"""
function distance(angular_distance::Float64, radius::Float64=Rₑ_m)
    return deg2rad(angular_distance) * radius
end

"""
    angular_distance(point₃::Point, point₁::Point, azimuth₁₂::Float64)

Return the `angular_distance` [deg] from point₃ [deg] to the closest point on a
great circle line starting in `point₁` [deg] with `azimuth₁₂` [deg] from
`point₁` to `point₂`. It is assumed that the great circle line does not stop in
`point₂`, but continuous around the unit sphere. A positive value indicates
being right of the line, and negative being left of the line.

Source: www.movable-type.co.uk/scripts/latlong.html
"""
function angular_distance(point₃::Point, point₁::Point, azimuth₁₂::Float64)
    angular_distance₁₃ = angular_distance(point₁, point₃)
    azimuth₁₃ = azimuth(point₁, point₃)
    return angular_distance(angular_distance₁₃, azimuth₁₃, azimuth₁₂)
end

"""
    angular_distance(point₃::Point, line₁::Line)

Return the `angular_distance` [deg] from point₃ [deg] to the closest point on a
great circle line starting in `point₁` [deg] with `azimuth₁₂` [deg]. A positive
value indicates being right of the line, and negative being left of the line.

Source: www.movable-type.co.uk/scripts/latlong.html
"""
angular_distance(point₃::Point, line₁::Line) = angular_distance(point₃,
line₁.point, line₁.azimuth)

"""
    angular_distance(angular_distance₁₃::Float64, azimuth₁₃::Float64,
    azimuth₁₂::Float64)

Return the `angular_distance` [deg] from point₃ [deg] to the closest point on a
great circle line starting in `point₁` [deg] with `azimuth₁₂` [deg]. For the
calculation we need the `angular_distance₁₃` and `azimuth₁₃` between `point₁`
and `point₃` [deg], and the `azimuth₁₂` from `point₁` to `point₂` along the
great circle line. It is assumed that the great circle line does not stop in
`point₂`, but continuous around the unit sphere.

Source: www.movable-type.co.uk/scripts/latlong.html
"""
function angular_distance(angular_distance₁₃::Float64, azimuth₁₃::Float64,
azimuth₁₂::Float64)
    return asind(sind(angular_distance₁₃) * sind(azimuth₁₃ - azimuth₁₂))
end

#QUESTION To we have to make it left or right dependent?
"""
    angular_distance(point₃::Point, point₁::Point, point₂::Point)

Return the `angular_distance` [deg] from point₃ [deg] to the closest point on a
great circle line section starting in `point₁` [deg] and ending in `point₂` [deg].
The great circle line section does not continue around the unit sphere.

The `angular_distance` does not change sign when being left or right of the arc.
"""
function angular_distance(point₃::Point, point₁::Point, point₂::Point, tolerance::Float64=tolerance_deg)
    angular_distance₁₂ = angular_distance(point₁, point₂)
    angular_distance₁₃ = angular_distance(point₁, point₃)
    angular_distance₂₃ = angular_distance(point₂, point₃)
    azimuth₁₂ = azimuth(point₁, point₂)
    angular_distance_line3 = angular_distance(point₃, point₁, azimuth₁₂)
    along_line_angular_dist = along_line_angular_distance(angular_distance₁₃,
    angular_distance_line3)
    along_line_pnt_3a = along_line_point(point₃, Line(point₁, azimuth₁₂))
    if abs(angular_distance(along_line_pnt_3a, point₁) +
        angular_distance(along_line_pnt_3a, point₂) -
        angular_distance₁₂) < tolerance
        return abs(angular_distance_line3)
    else
        return min(angular_distance₁₃, angular_distance₂₃)
    end
end

"""
    angular_distance(point₃::Point, points::Vector{Points{T}}) where T<:Float64

Return the `angular_distance` [deg] from point₃ [deg] to the closest point on a
an set of points representing an set of arcs.

The `angular_distance` does not change sign when being left or right of the arc.
"""
function angular_distance(point₃::Point, points::Vector{Point{T}}) where
    T<:Float64
    point₁ = points[1]
    point₂ = points[2]
    min_dist = angular_distance(point₃, point₁, point₂)
    point₁ = point₂
    for point₂ in points[2:end]
        min_dist = min(min_dist, angular_distance(point₃, point₁, point₂))
        point₁ = point₂
    end
    return min_dist
end

"""
    angular_distance(point₃::Point, arcs::Arcs)

Return the `angular_distance` [deg] from point₃ [deg] to the closest point on a
an `arcs`.

The `angular_distance` does not change sign when being left or right of the arc.
"""
angular_distance(point₃::Point, arcs::Arcs) = angular_distance(point₃,
arcs.points)
# function angular_distance(point₃::Point, arcs::Arcs)
#     point₁ = arcs.points[1]
#     point₂ = arcs.points[2]
#     min_dist = angular_distance(point₃, point₁, point₂)
#     point₁ = point₂
#     for point₂ in arcs.points[2:end]
#         min_dist = min(min_dist, angular_distance(point₃, point₁, point₂))
#         point₁ = point₂
#     end
#     return min_dist
# end

"""
    angular_distance(point₃::Point, polygon::Polygon)

Return the `angular_distance` [deg] from point₃ [deg] to the closest point on
the border of a `polygon`.

The `angular_distance` does not change sign when being left or right of the arc.
"""
angular_distance(point₃::Point, polygon::Polygon) = angular_distance(point₃,
polygon.points)

"""
    angular_distance(point₃::Point, arc₁₂::Arc)

Return the `angular_distance` [deg] from point₃ [deg] to the closest point on a
great circle line section starting in `point₁` [deg] and ending in `point₂` [deg].
The great circle line section does not continue around the unit sphere.
"""
angular_distance(point₃::Point, arc₁₂::Arc) =
angular_distance(point₃, arc₁₂.point₁, arc₁₂.point₂)

"""
    along_line_angular_distance(angular_distance₁₃::Float64,
    angular_distance_line3::Float64)

The `along_line_angular_distance` from the start `point₁` [deg] to the closest
point on the great circle line to `point₃`. As input we need the
`angular_distance₁₃` [deg] between `point₁` and `point₃` [deg] and the closest
distance `angular_distance_line3` [deg] between the great circle line and
`point3` [deg]. The distance is non-directional.

Source: www.movable-type.co.uk/scripts/latlong.html
"""
function along_line_angular_distance(angular_distance₁₃::Float64,
angular_distance_line3::Float64)
    return acosd(cosd(angular_distance₁₃) / cosd(angular_distance_line3))
end

"""
    along_line_angular_distance(point₃::Point, line₁::Line)

The `along_line_angular_distance` from the start `point₁` [deg] to the closest
point on the great circle line `line₁` to `point₃`. The distance is
non-directional.

Source: www.movable-type.co.uk/scripts/latlong.html
"""
function along_line_angular_distance(point₃::Point, line₁::Line)
    angular_distance₁₃ = angular_distance(line₁.point, point₃)
    angular_distance_line3 = angular_distance(point₃::Point, line₁::Line)
    return along_line_angular_distance(angular_distance₁₃,
    angular_distance_line3)
end

#TODO Distance to polygon
