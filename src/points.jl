export midpoint, intermediate_point, destination_point, intersection_point,
intersection_points, isinside, isonborder, ison, isselfintersecting,
highest_latitude, highest_latitude_point, lowest_latitude, lowest_latitude_point,
point_cartesian, point_spherical

"""
    midpoint(point₁::Point, point₂::Point)

    output: point::Point

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
    midpoint(arc::Arc)

    output: point::Point

Return the half-way point `midpoint` [deg] on the great circle `arc`
[deg] on a unit sphere.
"""
midpoint(arc::Arc) = midpoint(arc.point₁, arc.point₂)

"""
    midpoint(arcs::Arcs)
    
    output: point::Point

Return the half-way point `midpoint` [deg] on the great circle `arcs`
[deg] on a unit sphere.
"""
midpoint(arcs::Arcs) = intermediate_point(arcs, 0.5)


"""
    intermediate_point(point₁::Point, point₂::Point, fraction::Float64)

    output: point::Point

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
    intermediate_point(arc::Arc, fraction::Float64)
    
    output: point::Point

Return the `intermediate_point` [deg] at any `fraction` along the great circle
`arc` [deg]. The fraction along the great circle `arc` is such
that `fraction` = 0.0 is at the start of the `arc` and `fraction` 1.0 is
at the end of the `arc`.
"""
intermediate_point(arc::Arc, fraction::Float64) =
intermediate_point(arc.point₁, arc.point₂, fraction)

"""
    intermediate_point(arcs::Arcs, fraction::Float64)
    
    output: point::Point

Return the `intermediate_point` [deg] at any `fraction` along the great circle
`arcs` [deg]. The fraction along the great circle `arcs` is such
that `fraction` = 0.0 is at the start of the `arcs` and `fraction` 1.0 is
at the end of the `arcs`.
"""
function intermediate_point(arcs::Arcs, fraction::Float64)
    angular_length_ip = angular_length(arcs) * fraction
    p₁ = arcs.points[1]
    dist = 0.0
    if angular_length_ip == dist
        return arcs.points[1]
    end
    for p₂ in arcs.points[2:end]
        dist_p₁p₂ = angular_distance(p₁, p₂)
        if dist + dist_p₁p₂ ≥ angular_length_ip
            fraction_section = (angular_length_ip - dist) / dist_p₁p₂
            return intermediate_point(p₁, p₂, fraction_section)
        end
        dist += dist_p₁p₂
        p₁ = p₂
    end
    return arcs.points[end]
end


"""
    destination_point(start_point::Point, angular_distance::Float64,
    azimuth::Float64)

    output: point::Point

Given a `start_point` [deg], initial `azimuth` (clockwise from North) [deg],
`angular_distance` [deg] calculate the position of the `destina­tion_point`
[deg] traversing along a great circle line.

Source: www.movable-type.co.uk/scripts/latlong.html
"""
function destination_point(start_point::Point, angular_distance::Float64,
azimuth::Float64)
    ϕ₂ = asind(sind(start_point.ϕ) * cosd(angular_distance) +
    cosd(start_point.ϕ) * sind(angular_distance) * cosd(azimuth))
    λ₂ = start_point.λ + atand(sind(azimuth) * sind(angular_distance) *
    cosd(start_point.ϕ), cosd(angular_distance) - sind(start_point.ϕ) * sind(ϕ₂))
    return Point(ϕ₂, λ₂)
end

"""
    destination_point(line::Line, angular_distance::Float64)
    
    output: point::Point

Given a line with a start_point and azimuth, calculate the `destina­tion_point`
[deg] at the `angular_distance`.
"""
destination_point(line::Line, angular_distance::Float64) =
destination_point(line.point, angular_distance, line.azimuth)


"""
    intersection_point(point₁::Point, point₂::Point, azimuth₁₃::Float64,
    azimuth₂₃::Float64)
    
    output: point::Point

Return the intersection point `point₃` [deg] of two great circle lines given
by two start points [deg] `point₁` and `point₂` [deg] and two azimuths [deg]
from `point₁` to `point₃` [deg], and from `point₂` to `point₃` [deg].

Under certain circumstances the results can be an ∞ or *ambiguous solution*.

Source: edwilliams.org/avform.htm
"""
function intersection_point(point₁::Point, point₂::Point, azimuth₁₃::Float64,
azimuth₂₃::Float64)
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
    α₁ = (azimuth₁₃ - θ₁₂ + 180.0)%(360.0) - 180.0
    α₂ = (θ₂₁ - azimuth₂₃ + 180.0)%(360.0) - 180.0

    if sind(α₁) ≈ 0.0 && sind(α₂) ≈ 0.0
        return Point(Inf, Inf)  # infinity of intersections
    elseif sind(α₁) * sind(α₂) < 0.0
        # return Point_rad(Inf, Inf)  # intersection ambiguous
        return Point(NaN, NaN)
    else
        α₃ = acosd(-cosd(α₁) * cosd(α₂) + sind(α₁) * sind(α₂) * cosd(δ₁₂))
        δ₁₃ = atand(sind(δ₁₂) * sind(α₁) * sind(α₂), cosd(α₂) + cosd(α₁) * cosd(α₃))
        ϕ₃ = asind(sind(point₁.ϕ) * cosd(δ₁₃) + cosd(point₁.ϕ) * sind(δ₁₃) * cosd(azimuth₁₃))
        Δλ₁₃ = atand(sind(azimuth₁₃) * sind(δ₁₃) * cosd(point₁.ϕ), cosd(δ₁₃)
        - sind(point₁.ϕ) * sind(ϕ₃))
        λ₃ = point₁.λ + Δλ₁₃
        return Point(ϕ₃, λ₃)
    end
end

"""
    intersection_point(line₁::Line, line₂::Line)

    output: point::Point

Return the intersection point `point₃` [deg] of two great circle lines 'line₁'
and `line₂`.

Under certain circumstances the results can be an ∞ or *ambiguous solution*.
"""
intersection_point(line₁::Line, line₂::Line) = intersection_point(line₁.point,
line₂.point, line₁.azimuth, line₂.azimuth)

"""
    intersection_point(point₁::Point, point₂::Point, point₃::Point, point₄::Point)

    output: point::Point

Return the intersection `point` [deg] of two great circle line section given
by two sets of two points: `point₁` and `point₂` [deg] and `point₃` and
`point₄` [deg].

Under certain circumstances the results can be an ∞ or *ambiguous solution*.
https://blog.mbedded.ninja/mathematics/geometry/spherical-geometry/finding-the-intersection-of-two-arcs-that-lie-on-a-sphere/
"""
function intersection_point(point₁::Point, point₂::Point, point₃::Point, point₄::Point)
    if point₁ == point₃ || point₁ == point₄
        return point₁
    elseif point₂ == point₃ || point₂ == point₄
        return point₂
    end

    sph_point₁₁ = point_cartesian(point₁)
    sph_point₁₂ = point_cartesian(point₂)
    sph_point₂₁ = point_cartesian(point₃)
    sph_point₂₂ = point_cartesian(point₄)
    N₁ = cross(sph_point₁₁,sph_point₁₂)
    N₂ = cross(sph_point₂₁, sph_point₂₂)
    L = cross(N₁, N₂)
    I₁ = L/norm(L)
    I₂ = -I₁

    angular_dist(sph_point₁::Vector{Float64}, sph_point₂::Vector{Float64}) = 
    angular_distance(point_spherical(sph_point₁), point_spherical(sph_point₂))

    for i in 1:2
        i == 1 ? Iₙ = I₁ : Iₙ = I₂
        θ₁₁ᵢₙ = angular_dist(sph_point₁₁, Iₙ)
        θ₁₂ᵢₙ = angular_dist(sph_point₁₂, Iₙ)
        θ₁₁₁₂ = angular_dist(sph_point₁₁, sph_point₁₂)
        θ₂₁ᵢₙ = angular_dist(sph_point₂₁, Iₙ)
        θ₂₂ᵢₙ = angular_dist(sph_point₂₂, Iₙ)
        θ₂₁₂₂ = angular_dist(sph_point₂₁, sph_point₂₂)
        if abs(θ₁₁ᵢₙ + θ₁₂ᵢₙ - θ₁₁₁₂) < tolerance_deg && abs(θ₂₁ᵢₙ + θ₂₂ᵢₙ - θ₂₁₂₂) < tolerance_deg
            return point_spherical(Iₙ)
        end
    end
    return Point(NaN, NaN)
end

"""
    intersection_point(arc₁::Arc, arc₂::Arc)
    
    output: point::Point

Return the intersection `point` [deg] of two great circle line sections.

Under certain circumstances the results can be an ∞ or *ambiguous solution*.
"""
intersection_point(arc₁::Arc, arc₂::Arc) =
intersection_point(arc₁.point₁, arc₁.point₂, arc₂.point₁, arc₂.point₂)


"""
    intersection_points(arcs₁::Arcs, arcs₂::Arcs)
    
    output: points::Vector of Point

Return the intersection points [deg] of two line sections.
"""
function intersection_points(arcs₁::Arcs, arcs₂::Arcs)
    lss₁_p₁ = arcs₁.points[1]
    inter_points = Vector{Point{Float64}}()
    for lss₁_p₂ in arcs₁.points[2:end]
        lss₂_p₁ = arcs₂.points[1]
        distances_section = Vector{Float64}()
        inter_points_section = Vector{Point{Float64}}()
        for lss₂_p₂ in arcs₂.points[2:end]
            intersection_pnt = intersection_point(lss₁_p₁, lss₁_p₂, lss₂_p₁, lss₂_p₂)
            if isinf(intersection_pnt.ϕ) || isnan(intersection_pnt.ϕ)
                #
            elseif intersection_pnt in inter_points_section || intersection_pnt in inter_points
                #
            else
                ipin = false
                for ip in inter_points_section
                    if isapprox(intersection_pnt.ϕ, ip.ϕ; atol=tolerance_deg) && 
                        isapprox(intersection_pnt.λ, ip.λ; atol=tolerance_deg)
                        ipin = true
                        break
                    end
                end
                for ip in inter_points
                    if isapprox(intersection_pnt.ϕ, ip.ϕ; atol=tolerance_deg) && 
                        isapprox(intersection_pnt.λ, ip.λ; atol=tolerance_deg)
                        ipin = true
                        break
                    end
                end
                if ipin
                    #
                else
                    append!(distances_section,
                    angular_distance(lss₁_p₁, intersection_pnt))
                    append!(inter_points_section, [intersection_pnt])
                end
            end
            lss₂_p₁ = lss₂_p₂
        end
        lss₁_p₁ = lss₁_p₂
        p = sortperm(distances_section)
        append!(inter_points, inter_points_section[p])
    end
    return unique(inter_points)
end

intersection_points(arc::Arc, arcs::Arcs) =
intersection_points(Arcs([arc.point₁, arc.point₂]), arcs)

"""
    intersection_points(arcs::Arcs, polygon::Polygon)

    output: points::Vector of Point

Return the intersection points [deg] of a `arcs` with a `polygon`.
"""
intersection_points(arcs::Arcs, polygon::Polygon) =
intersection_points(arcs, Arcs(polygon.points))

intersection_points(arc::Arc, polygon::Polygon) =
intersection_points(Arcs([arc.point₁, arc.point₂]), polygon)

"""
    intersection_points(polygon₁::Polygon, polygon₂::Polygon)

    output: points::Vector of Point

Return the intersection points [deg] of two polygons.
"""
intersection_points(polygon₁::Polygon, polygon₂::Polygon) =
intersection_points(Arcs(polygon₁.points), Arcs(polygon₂.points))

"""
    self_intersection_points(points::Vector{Point{Float64}})

    output: points::Vector of Point

Return the self intersection points [deg] of a set of points.
"""
function self_intersection_points(points::Vector{Point{Float64}})
    if length(points) < 4
        return Vector{Point{Float64}}()
    end
    lss₁_p₁ = points[1]
    inter_points = Vector{Point{Float64}}()
    for (index, lss₁_p₂) in enumerate(points[2:end-1])
        lss₂_p₁ = points[index+2]
        distances_section = Vector{Float64}()
        inter_points_section = Vector{Point{Float64}}()
        for lss₂_p₂ in points[index+3:end]
            intersection_pnt = intersection_point(lss₁_p₁, lss₁_p₂, lss₂_p₁, lss₂_p₂)
            if isinf(intersection_pnt.ϕ) || isnan(intersection_pnt.ϕ)
                #
            else
                append!(distances_section,
                angular_distance(lss₁_p₁, intersection_pnt))
                append!(inter_points_section, [intersection_pnt])
            end
            lss₂_p₁ = lss₂_p₂
        end
        lss₁_p₁ = lss₁_p₂
        p = sortperm(distances_section)
        append!(inter_points, inter_points_section[p])
    end
    return inter_points
end

self_intersection_points(polygon::Polygon) = self_intersection_points(polygon.points)

"""
    isinside(point::Point, polygon::Polygon)

Determine if the `point` is inside the `polygon`. The border is outside the `polygon`.

Source: M. Bevis and J.L. Chatelain, "Locating a point on a spherical surface
relative to a spherical polygon" 1989
"""
function isinside(point::Point, polygon::Polygon)
    return iseven(length(intersection_points(Arc(point, polygon.inside_point), polygon)))
end

"""
    isinside(arc::Arc, polygon::Polygon)

Determine if the `arc` is fully inside the `polygon`. The border is outside the `polygon`.
"""
function isinside(arc::Arc, polygon::Polygon)
    return isinside(arc.point₁, polygon) && length(intersection_points(arc, polygon)) == 0
end

"""
    isinside(arcs::Arcs, polygon::Polygon)

Determine if the `arcs` is fully inside the `polygon`. The border is outside the `polygon`.
"""
function isinside(arcs::Arcs, polygon::Polygon)
    return isinside(arcs.points[1], polygon) && length(intersection_points(arcs, polygon)) == 0
end

"""
    isinside(polygon₁::Polygon, polygon₂::Polygon)

Determine if the `polygon₁` is fully inside the `polygon₂`. The border is outside the `polygon₁`.
"""
function isinside(polygon₁::Polygon, polygon₂::Polygon)
    return isinside(polygon₁.points[1], polygon₂) && length(intersection_points(polygon₁, polygon₂)) == 0
end

"""
    ison(point::Point, line::Line [,tolerance::Float64=tolerance_deg])

Determine if the `point` is on the `line`.
"""
function ison(point::Point, line::Line, tolerance::Float64=tolerance_deg)
    return abs(angular_distance(point, line)) < tolerance
end

"""
    ison(point::Point, arc::Arc [,tolerance::Float64=tolerance_deg])

Determine if the `point` is on the `arc`.
"""
function ison(point::Point, arc::Arc, tolerance::Float64=tolerance_deg)
    return abs(angular_distance(point, arc)) < tolerance
end

"""
    ison(point::Point, arc::Arcs [,tolerance::Float64=tolerance_deg])

Determine if the `point` is on the `arcs`.
"""
function ison(point::Point, arcs::Arcs, tolerance::Float64=tolerance_deg)
    return abs(angular_distance(point, arcs)) < tolerance
end

"""
    ison(point::Point, polygon::Polygon [,tolerance::Float64=tolerance_deg])

Determine if the `point` is on the border of the `polygon`.
"""
function ison(point::Point, polygon::Polygon, tolerance::Float64=tolerance_deg)
    return abs(angular_distance(point, polygon)) < tolerance
end

"""
    along_line_point(point₃::Point, line₁::Line)

    output: point::Point

The `along_line_point` from the start `point₁` [deg] to the closest
point on the great circle line `line₁` to `point₃`.
"""
function along_line_point(point₃::Point, line₁::Line)
    along_dist = along_line_angular_distance(point₃, line₁)
    p3a = destination_point(line₁, along_dist)
    p3b = destination_point(line₁, -along_dist)
    dist_p3a = angular_distance(point₃, p3a)
    dist_p3b = angular_distance(point₃, p3b)
    return dist_p3a < dist_p3b ? p3a : p3b
end

"""
    isselfintersecting(polygon::Polygon)
"""
function isselfintersecting(polygon::Polygon)
    polypoints = deepcopy(polygon.points)
    fraction = 0.999999
    updatelast = intermediate_point(polypoints[end-1], polypoints[end], fraction)
    polypoints[end] = updatelast
    isselfintersecting(polypoints)
end

"""
    isselfintersecting(arcs::Arcs)
"""
isselfintersecting(arcs::Arcs) = isselfintersecting(arcs.points)

"""
    isselfintersecting(points::Vector{Point{Float64}})
"""
function isselfintersecting(points::Vector{Point{Float64}})
    inter_pnts = self_intersection_points(points)
    return length(inter_pnts) != 0
end

"""
    highest_latitude(point::Point, azimuth::Float64)

    output: latitude [deg]

The highest latitude a great circle reaches when starting in a point along the
given azimuth [deg].

Source: https://www.edwilliams.org/avform147.htm#Clairaut
"""
function highest_latitude(point₁::Point, azimuth₁₂::Float64)
    return acosd(abs(sind(azimuth₁₂)*cosd(point₁.ϕ)))
end


"""
    lowest_latitude(point::Point, azimuth::Float64)

    output: latitude [deg]

The lowest latitude a great circle reaches when starting in a point along the
given azimuth [deg].
"""
function lowest_latitude(point₁::Point, azimuth₁₂::Float64)
    return -highest_latitude(point₁, azimuth₁₂)
end


"""
    highest_latitude_point(point::Point, azimuth::Float64)

    output: point::Point

The highest latitude point a great circle reaches when starting in point along the
given azimuth [deg].

Source: https://www.edwilliams.org/avform147.htm#XTE
"""
function highest_latitude_point(point₁::Point, azimuth₁₂::Float64)
    pole = Point(90.0, 0.0)
    Δazimuth = azimuth(point₁,pole) - azimuth₁₂
    dist₁ₚ = angular_distance(point₁, pole)
    p = atand(sind(dist₁ₚ)*cosd(Δazimuth), cosd(dist₁ₚ))
    return destination_point(point₁, p, azimuth₁₂)
end


"""
    lowest_latitude_point(point::Point, azimuth::Float64)

    output: point::Point

The lowest latitude point a great circle reaches when starting in point along the
given azimuth [deg].

Source: https://www.edwilliams.org/avform147.htm#XTE
"""
function lowest_latitude_point(point₁::Point, azimuth₁₂::Float64)
    hlp = highest_latitude_point(point₁, azimuth₁₂)
    return Point(-hlp.ϕ, normalize(hlp.λ+180.0, -180.0, 180.0))
end


#TBD Test scenarios for highest_latitude_point
"""
    highest_latitude_point(point₁::Point, point₂::Point)

    output: point::Point

The highest latitude point a great circle reaches when starting in point₁ 
towards point₂. The point must be between point₁ and point₂.

Source: https://www.edwilliams.org/avform147.htm#XTE
"""
function highest_latitude_point(point₁::Point, point₂::Point)
    azimuth₁₂ = azimuth(point₁, point₂)
    hlp = highest_latitude_point(point₁, azimuth₁₂)
    if point₁.λ == point₂.λ
        if point₁.ϕ > point₂.ϕ
            return point₁
        else
            return point₂
        end
    else
        if point₁.λ ≤ hlp.λ ≤ point₂.λ || point₂.λ ≤ hlp.λ ≤ point₁.λ
            return hlp
        else
            if point₁.ϕ > point₂.ϕ
                return point₁
            else
                return point₂
            end
        end
    end
end

"""
    lowest_latitude_point(point₁::Point, point₂::Point)

    output: point::Point

The lowest latitude point a great circle reaches when starting in point₁ 
towards point₂. The point must be between point₁ and point₂.

Source: https://www.edwilliams.org/avform147.htm#XTE
"""
function lowest_latitude_point(point₁::Point, point₂::Point)
    azimuth₁₂ = azimuth(point₁, point₂)
    llp = lowest_latitude_point(point₁, azimuth₁₂)
    if point₁.λ == point₂.λ
        if point₁.ϕ > point₂.ϕ
            return point₂
        else
            return point₁
        end
    else
        if point₁.λ ≤ llp.λ ≤ point₂.λ || point₂.λ ≤ llp.λ ≤ point₁.λ
            return llp
        else
            if point₁.ϕ > point₂.ϕ
                return point₂
            else
                return point₁
            end
        end
    end
end
   
point_cartesian(point::Point) = [cosd(point.λ)*cosd(point.ϕ); sind(point.λ)*cosd(point.ϕ); sind(point.ϕ)]
point_spherical(point::Vector) = Point(asind(point[3]), atand(point[2], point[1]))