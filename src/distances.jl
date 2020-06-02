export angular_distance, distance, along_line_angular_distance

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
    angular_distance(line::Line)

Return the `angular_distance` [deg] of the great circle line section on a
unit sphere.
"""
angular_distance(linesection::LineSection) =
angular_distance(linesection.point₁, linesection.point₂)

"""
    angular_distance(linesections::LineSections)

Return the `angular_distance` [deg] along the linesections on a unit sphere.
"""
function angular_distance(linesections::LineSections)
    point₁ = linesections.points[1]
    dist_deg = 0.0
    for point₂ in linesections.points[2:end]
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
    angular_distance(point₃::Point, point₁::Point, bearing₁₂::Float64)

Return the `angular_distance` [deg] from point₃ [deg] to the closest point on a
great circle line starting in `point₁` [deg] with `bearing₁₂` [deg] from
`point₁` to `point₂`. It is assumed that the great circle line does not stop in
`point₂`, but continuous around the unit sphere.

Source: www.movable-type.co.uk/scripts/latlong.html
"""
function angular_distance(point₃::Point, point₁::Point, bearing₁₂::Float64)
    angular_distance₁₃ = angular_distance(point₁, point₃)
    bearing₁₃ = bearing(point₁, point₃)
    return angular_distance(angular_distance₁₃, bearing₁₃, bearing₁₂)
end

"""
    angular_distance(point₃::Point, line₁::Line)

Return the `angular_distance` [deg] from point₃ [deg] to the closest point on a
great circle line starting in `point₁` [deg] with `bearing₁₂` [deg].

Source: www.movable-type.co.uk/scripts/latlong.html
"""
angular_distance(point₃::Point, line₁::Line) = angular_distance(point₃,
line₁.point, line₁.bearing)

"""
    angular_distance(angular_distance₁₃::Float64, bearing₁₃::Float64,
    bearing₁₂::Float64)

Return the `angular_distance` [deg] from point₃ [deg] to the closest point on a
great circle line starting in `point₁` [deg] with `bearing₁₂` [deg]. For the
calculation we need the `angular_distance₁₃` and `bearing₁₃` between `point₁`
and `point₃` [deg], and the `bearing₁₂` from `point₁` to `point₂` along the
great circle line. It is assumed that the great circle line does not stop in
`point₂`, but continuous around the unit sphere.

Source: www.movable-type.co.uk/scripts/latlong.html
"""
function angular_distance(angular_distance₁₃::Float64, bearing₁₃::Float64,
bearing₁₂::Float64)
    return asind(sind(angular_distance₁₃) * sind(bearing₁₃ - bearing₁₂))
end

"""
    angular_distance(point₃::Point, point₁::Point, point₂::Point)

Return the `angular_distance` [deg] from point₃ [deg] to the closest point on a
great circle line section starting in `point₁` [deg] and ending in `point₂` [deg].
The great circle line section does not continue around the unit sphere.
"""
function angular_distance(point₃::Point, point₁::Point, point₂::Point)
    angular_distance₁₂ = angular_distance(point₁, point₂)
    angular_distance₁₃ = angular_distance(point₁, point₃)
    angular_distance₂₃ = angular_distance(point₂, point₃)
    bearing₁₂ = bearing(point₁, point₂)
    angular_distance_line3 = angular_distance(point₃, point₁, bearing₁₂)
    along_line_angular_dist = along_line_angular_distance(angular_distance₁₃, angular_distance_line3)
    if 0 ≤ along_line_angular_dist ≤ angular_distance₁₂
        return along_line_angular_dist
    else
        return min(angular_distance₁₃, angular_distance₂₃)
    end
end

"""
    angular_distance(point₃::Point, linesection₁₂::LineSection)

Return the `angular_distance` [deg] from point₃ [deg] to the closest point on a
great circle line section starting in `point₁` [deg] and ending in `point₂` [deg].
The great circle line section does not continue around the unit sphere.
"""
angular_distance(point₃::Point, linesection₁₂::LineSection) =
angular_distance(point₃, linesection₁₂.point₁, linesection₁₂.point₂)

"""
    along_line_angular_distance(angular_distance₁₃::Float64,
    angular_distance_line3::Float64)

The `along_line_angular_distance` from the start `point₁` [deg] to the closest
point on the great circle line to `point₃`. As input we need the
`angular_distance₁₃` [deg] between `point₁` and `point₃` [deg] and the closest
distance `angular_distance_line3` [deg] between the great circle line and
`point3` [deg].

Source: www.movable-type.co.uk/scripts/latlong.html
"""
function along_line_angular_distance(angular_distance₁₃::Float64,
angular_distance_line3::Float64)
    return acosd(cosd(angular_distance₁₃) / cosd(angular_distance_line3))
end

"""
    along_line_angular_distance(point₃::Point, line₁::Line)

The `along_line_angular_distance` from the start `point₁` [deg] to the closest
point on the great circle line `line₁` to `point₃`.

Source: www.movable-type.co.uk/scripts/latlong.html
"""
function along_line_angular_distance(point₃::Point, line₁::Line)
    angular_distance₁₃ = angular_distance(line₁.point, point₃)
    angular_distance_line3 = angular_distance(point₃::Point, line₁::Line)
    return along_line_angular_distance(angular_distance₁₃,
    angular_distance_line3)
end

#TODO Distance to polygon
#TODO Distance to LineSections
