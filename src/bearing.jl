export bearing, final_bearing

"""
    bearing(point₁::Point, point₂::Point)

Return the initial `bearing` [deg], measured clockwise from the north direction,
of the great circle line between the positions `point₁` and `point₂` [deg] on a
unit sphere.

Source: www.movable-type.co.uk/scripts/latlong.html
"""
function bearing(point₁::Point, point₂::Point)
    Δpos = point₂ - point₁
    return mod(atand(sind(Δpos.λ)*cosd(point₂.ϕ), cosd(point₁.ϕ)*sind(point₂.ϕ) -
    sind(point₁.ϕ)*cosd(point₂.ϕ)*cosd(Δpos.λ)), 360.0)
end

"""
    bearing(line::Line)

Return the initial `bearing` [deg], measured clockwise from the north direction,
of the line on a unit sphere.
"""
bearing(line::Line) = bearing(line.point₁, line.point₂)

"""
    final_bearing(point₁::Point, point₂::Point)

Return the final `bearing` [deg], measured clockwise from the north direction,
of the great circle line between the positions `point₁` and `point₂` [deg] on a
unit sphere.

Source: www.movable-type.co.uk/scripts/latlong.html
"""
function final_bearing(point₁::Point, point₂::Point)
    return mod(bearing(point₂, point₁) + 180.0, 360.0)
end

"""
    final_bearing(line::Line)

Return the `final_bearing` [deg] of the line on a unit sphere.
"""
final_bearing(line::Line) = final_bearing(line.point₁, line.point₂)
