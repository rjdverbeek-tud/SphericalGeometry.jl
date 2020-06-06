export azimuth, final_azimuth

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
