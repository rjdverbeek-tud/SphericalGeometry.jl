export angular_distance, distance

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

Return the `angular_distance` [deg] of the great circle line on a unit sphere.
"""
angular_distance(line::Line) = angular_distance(line.point₁, line.point₂)

"""
    angular_distance(linestring::LineString)

Return the `angular_distance` [deg] along the linestringon a unit sphere.
"""
function angular_distance(linestring::LineString)
    point₁ = linestring.points[1]
    dist_deg = 0.0
    for point₂ in linestring.points[2:end]
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
    angular_distance(point₁::Point, point₂::Point, bearing₂::Float64)

Return the `angular_distance` [deg] from point₁ [deg] to the closest point on a
great circle line starting in `point₂` [deg] with `bearing₂` [deg].

Source: www.movable-type.co.uk/scripts/latlong.html
"""
function angular_distance(point₁::Point, point₂::Point, bearing₂::Float64)
    angular_distance₂₁ = angular_distance(point₂, point₁)
    bearing₂₁ = bearing(point₂, point₁)
    return angular_distance(angular_distance₂₁, bearing₂₁, bearing₂)
end

"""
    angular_distance(angular_distance₂₁::Float64, bearing₂₁::Float64,
    bearing₂::Float64)

Return the `angular_distance` [deg] from point₁ [deg] to the closest point on a
great circle line starting in `point₂` [deg] with `bearing₂` [deg]. For the
calculation we need the `angular_distance₂₁` and `bearing₂₁` between `point₂`
and `point₁` [deg], and the `bearing₂` from `point₂` along the great circle line.

Source: www.movable-type.co.uk/scripts/latlong.html
"""
function angular_distance(angular_distance₂₁::Float64, bearing₂₁::Float64,
bearing₂::Float64)
    return asind(sind(angular_distance₂₁) * sind(bearing₂₁ - bearing₂))
end

"""
    angular_distance(point₁::Point, point₂::Point, bearing₂::Float64)

Return the `angular_distance` [deg] from point₁ [deg] to the closest point on a
great circle line section starting in `point₂` [deg] towards `point₃` [deg].
"""
function angular_distance(point₁::Point, point₂::Point, point₃::Point)
    bearing₂₃ = bearing(point₂, point₃)
    angular_distance_full_line = angular_distance(point₁, point₂, bearing₂₃)
    #TODO Calculate along track distance
end
