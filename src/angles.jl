export azimuth, final_azimuth, spherical_angle

"""
    azimuth(point₁::Point, point₂::Point)

Return the initial `azimuth` [deg], measured clockwise from the north direction,
of the great circle line between the positions `point₁` and `point₂` [deg] on a
unit sphere.

Source: www.movable-type.co.uk/scripts/latlong.html
"""
function azimuth(point₁::Point, point₂::Point)
    Δpos = point₂ - point₁
    return mod(atand(sind(Δpos.λ)*cosd(point₂.ϕ), cosd(point₁.ϕ)*sind(point₂.ϕ) -
    sind(point₁.ϕ)*cosd(point₂.ϕ)*cosd(Δpos.λ)), 360.0)
end

"""
    azimuth(line::Line)

Return the initial `azimuth` [deg], measured clockwise from the north direction,
of the line on a unit sphere.
"""
azimuth(arc::Arc) =
azimuth(arc.point₁, arc.point₂)

"""
    final_azimuth(point₁::Point, point₂::Point)

Return the final `azimuth` [deg], measured clockwise from the north direction,
of the great circle line between the positions `point₁` and `point₂` [deg] on a
unit sphere.

Source: www.movable-type.co.uk/scripts/latlong.html
"""
function final_azimuth(point₁::Point, point₂::Point)
    return mod(azimuth(point₂, point₁) + 180.0, 360.0)
end

"""
    final_azimuth(line::Line)

Return the `final_azimuth` [deg] of the line on a unit sphere.
"""
final_azimuth(arc::Arc) =
final_azimuth(arc.point₁, arc.point₂)

"""
    spherical_angle(angular_distance₁₂::Float64, angular_distance₂₃::Float64, angular_distance₁₃::Float64)

Return the 'spherical_angle' [deg] of angle₁₂₃ given the angular distances [deg] between point₁ and point₂,
point₂ and point₃, and point₁ and point₃.

Source: en.wikipedia.org/wiki/Spherical_trigonometry
"""
function spherical_angle(angular_distance₁₂::Float64, angular_distance₂₃::Float64, angular_distance₁₃::Float64,
    tolerance::Float64=tolerance_deg)
    a = deg2rad(angular_distance₁₃)
    b = deg2rad(angular_distance₂₃)
    c = deg2rad(angular_distance₁₂)
    if b < deg2rad(tolerance) || c < deg2rad(tolerance)
        return acos(1 - deg2rad(a)^2/2)
    end
    cosA = (cos(a) - cos(b)*cos(c)) / (sin(b)*sin(c))
    return rad2deg(acos(cosA))
end

"""
    spherical_angle(point₁::Point, point₂::Point, point₃::Point)

Return the 'spherical_angle' [deg] of angle₁₂₃ given the triangle point₁ - point₂ - point₃

Source: en.wikipedia.org/wiki/Spherical_trigonometry
"""
spherical_angle(point₁::Point, point₂::Point, point₃::Point, tolerance::Float64=tolerance_deg) =
spherical_angle(angular_distance(point₁, point₂), angular_distance(point₂, point₃), angular_distance(point₁, point₃))