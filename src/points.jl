export midpoint, intermediate_point, destination_point, intersection_point

"""
    midpoint(point₁::Point, point₂::Point)

Return the half-way point `midpoint` [deg] on the great circle line between
the positions `point₁` and `point₂` [deg] on a unit sphere.

Source: www.movable-type.co.uk/scripts/latlong.html
"""
function midpoint(point₁::Point, point₂::Point)
    Δpos = point₂ - point₁
    Bx = cosd(point₂.ϕ) * cosd(Δpos.λ)
    By = cosd(point₂.ϕ) * sind(Δpos.λ)
    ϕₘ = atand(sind(point₁.ϕ) + sind(point₂.ϕ), √((cosd(point₁.ϕ) + Bx)^2 + By^2))
    λₘ = point₁.λ + atand(By, cosd(point₁.ϕ) + Bx)
    return Point(ϕₘ, normalize(λₘ, -180.0, 180.0))
end

"""
    midpoint(linesection::LineSection)

Return the half-way point `midpoint` [deg] on the great circle `linesection`
[deg] on a unit sphere.
"""
midpoint(linesection::LineSection) = midpoint(linesection.point₁,
linesection.point₂)

"""
    midpoint(linesections::LineSections)

Return the half-way point `midpoint` [deg] on the great circle `linesections`
[deg] on a unit sphere.
"""
midpoint(linesections::LineSections) = intermediate_point(linesections, 0.5)

"""
    intermediate_point(point₁::Point, point₂::Point, fraction::Float64)

Return the `intermediate_point` [deg] at any `fraction` along the great circle
line section between the two points `point₁` and `point₂` [deg]. The fraction
along the great circle line section is such that `fraction` = 0.0 is at `point₁`
[deg] and `fraction` 1.0 is at `point₂` [deg].

Source: www.movable-type.co.uk/scripts/latlong.html
"""
function intermediate_point(point₁::Point, point₂::Point, fraction::Float64)
    δ = angular_distance(point₁, point₂)
    a = sind((1.0 - fraction) * δ) / sind(δ)
    b = sind(fraction * δ) / sind(δ)
    x = a * cosd(point₁.ϕ) * cosd(point₁.λ) + b * cosd(point₂.ϕ) * cosd(point₂.λ)
    y = a * cosd(point₁.ϕ) * sind(point₁.λ) + b * cosd(point₂.ϕ) * sind(point₂.λ)
    z = a * sind(point₁.ϕ) + b * sind(point₂.ϕ)
    ϕᵢ = atand(z, √(x*x + y*y))
    λᵢ = atand(y, x)
    return Point(ϕᵢ, λᵢ)
end

"""
    intermediate_point(linesection::LineSection, fraction::Float64)

Return the `intermediate_point` [deg] at any `fraction` along the great circle
`linesection` [deg]. The fraction along the great circle `linesection` is such
that `fraction` = 0.0 is at the start of the `linesection` and `fraction` 1.0 is
at the end of the `linesection`.
"""
intermediate_point(linesection::LineSection, fraction::Float64) =
intermediate_point(linesection.point₁, linesection.point₂, fraction)

"""
    intermediate_point(linesections::LineSections, fraction::Float64)

Return the `intermediate_point` [deg] at any `fraction` along the great circle
`linesections` [deg]. The fraction along the great circle `linesections` is such
that `fraction` = 0.0 is at the start of the `linesections` and `fraction` 1.0 is
at the end of the `linesections`.
"""
function intermediate_point(linesections::LineSections, fraction::Float64)
    angular_distance_ip = angular_distance(linesections) * fraction
    p₁ = linesections.points[1]
    dist = 0.0
    if angular_distance_ip == dist
        return linesections.points[1]
    end
    for p₂ in linesections.points[2:end]
        dist_p₁p₂ = angular_distance(p₁, p₂)
        if dist + dist_p₁p₂ ≥ angular_distance_ip
            fraction_section = (angular_distance_ip - dist) / dist_p₁p₂
            return intermediate_point(p₁, p₂, fraction_section)
        end
        dist += dist_p₁p₂
        p₁ = p₂
    end
    return linesections.points[end]
end

"""
    destination_point(start_point::Point, angular_distance::Float64,
    bearing::Float64)

Given a `start_point` [deg], initial `bearing` (clockwise from North) [deg],
`angular_distance` [deg] calculate the position of the `destina­tion_point`
[deg] traversing along a great circle line.

Source: www.movable-type.co.uk/scripts/latlong.html
"""
function destination_point(start_point::Point, angular_distance::Float64,
bearing::Float64)
    ϕ₂ = asind(sind(start_point.ϕ) * cosd(angular_distance) +
    cosd(start_point.ϕ) * sind(angular_distance) * cosd(bearing))
    λ₂ = start_point.λ + atand(sind(bearing) * sind(angular_distance) *
    cosd(start_point.ϕ), cosd(angular_distance) - sind(start_point.ϕ) * sind(ϕ₂))
    return Point(ϕ₂, λ₂)
end

"""
    destination_point(line::Line, angular_distance::Float64)

Given a line with a start_point and bearing, calculate the `destina­tion_point`
[deg] at the `angular_distance`.
"""
destination_point(line::Line, angular_distance::Float64) =
destination_point(line.point, angular_distance, line.bearing)

"""
    intersection_point(point₁::Point, point₂::Point, bearing₁₃::Float64,
    bearing₂₃::Float64)

Return the intersection point `point₃` [deg] of two great circle lines given
by two start points [deg] `point₁` and `point₂` [deg] and two bearings [deg]
from `point₁` to `point₃` [deg], and from `point₂` to `point₃` [deg].

Under certain circumstances the results can be an ∞ or *ambiguous solution*.

Source: edwilliams.org/avform.htm
"""
function intersection_point(point₁::Point, point₂::Point, bearing₁₃::Float64,
bearing₂₃::Float64)
    Δpos = point₂ - point₁
    δ₁₂ = 2asind(√(sind(Δpos.ϕ / 2)^2 + cosd(point₁.ϕ) * cosd(point₂.ϕ) * sind(Δpos.λ/2)^2))
    if sind(δ₁₂) * cosd(point₁.ϕ) == 0.0 || sind(δ₁₂) * cosd(point₂.ϕ) == 0.0
        return Point(NaN, NaN)
    end
    θₐ = acosd((sind(point₂.ϕ) - sind(point₁.ϕ) * cosd(δ₁₂)) / (sind(δ₁₂) * cosd(point₁.ϕ)))
    θᵦ = acosd((sind(point₁.ϕ) - sind(point₂.ϕ) * cosd(δ₁₂)) / (sind(δ₁₂) * cosd(point₂.ϕ)))
    local θ₁₂, θ₂₁
    if sind(Δpos.λ) > 0.0
        θ₁₂ = θₐ
        θ₂₁ = 360.0 - θᵦ
    else
        θ₁₂ = 360.0 - θₐ
        θ₂₁ = θᵦ
    end
    α₁ = (bearing₁₃ - θ₁₂ + 180.0)%(360.0) - 180.0
    α₂ = (θ₂₁ - bearing₂₃ + 180.0)%(360.0) - 180.0

    if sind(α₁) ≈ 0.0 && sind(α₂) ≈ 0.0
        return Point(Inf, Inf)  # infinity of intersections
    elseif sind(α₁) * sind(α₂) < 0.0
        # return Point_rad(Inf, Inf)  # intersection ambiguous
        return Point(NaN, NaN)
    else
        α₃ = acosd(-cosd(α₁) * cosd(α₂) + sind(α₁) * sind(α₂) * cosd(δ₁₂))
        δ₁₃ = atand(sind(δ₁₂) * sind(α₁) * sind(α₂), cosd(α₂) + cosd(α₁) * cosd(α₃))
        ϕ₃ = asind(sind(point₁.ϕ) * cosd(δ₁₃) + cosd(point₁.ϕ) * sind(δ₁₃) * cosd(bearing₁₃))
        Δλ₁₃ = atand(sind(bearing₁₃) * sind(δ₁₃) * cosd(point₁.ϕ), cosd(δ₁₃)
        - sind(point₁.ϕ) * sind(ϕ₃))
        λ₃ = point₁.λ + Δλ₁₃
        return Point(ϕ₃, λ₃)
    end
end

"""
    intersection_point(line₁::Line, line₂::Line)

Return the intersection point `point₃` [deg] of two great circle lines 'line₁'
and `line₂`.

Under certain circumstances the results can be an ∞ or *ambiguous solution*.
"""
intersection_point(line₁::Line, line₂::Line) = intersection_point(line₁.point,
line₂.point, line₁.bearing, line₂.bearing)

#TODO Create Test for intersection_point
"""
    intersection_point(point₁::Point, point₂::Point, point₃::Point, point₄::Point)

Return the intersection `point` [deg] of two great circle line section given
by two sets of two points: `point₁` and `point₂` [deg] and `point₃` and
`point₄` [deg].

Under certain circumstances the results can be an ∞ or *ambiguous solution*.
"""
function intersection_point(point₁::Point, point₂::Point, point₃::Point,
    point₄::Point)
    inter_pnt = intersection_point(point₁, point₃, bearing(point₁, point₂),
    bearing(point₃, point₄))
    if isinf(inter_pnt.ϕ)
        return inter_pnt
    elseif distance(point₁, point₂) + tolerance_m ≥ distance(point₁, inter_pnt) &&
        distance(point₃, point₄) + tolerance_m ≥ distance(point₃, inter_pnt)
        return inter_pnt
    else
        return Point(NaN, NaN)
    end
end
