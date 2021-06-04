const tolerance_deg = 0.00001

"""
    normalize(value::Float64[, lower::Float64 = 0.0, upper::Float64 = 360.0])

Normalize a `value` to stay within the `lower` and `upper` limit.

Example:
normalize(370.0, lower=0.0, upper=360.0)
10.0
"""
function normalize(value::Float64, lower::Float64 = 0.0, upper::Float64 = 360.0)
    result = value
    if result > upper || value == lower
        value = lower + abs(value + upper) % (abs(lower) + abs(upper))
    end
    if result < lower || value == upper
        value = upper - abs(value - lower) % (abs(lower) + abs(upper))
    end
    value == upper ? result = lower : result = value
    return result
end

"""
    normalize(point::Point)

Normalize the point to keep the longitude between -180 and 180 degrees and the
latitude between -90 and 90.

Source: gist.github.com/missinglink/ > wrap.js
"""
function normalize(point::Point)
    ϕ, λ = _normalize(point.ϕ, point.λ)
    return Point(ϕ, λ)
end

function _normalize(pointϕ::Float64, pointλ::Float64)
    ϕ = pointϕ
    λ = pointλ
    quadrant = floor(Int64, abs(ϕ)/90) % 4
    pole = ϕ > 0 ? 90.0 : -90.0
    offset = ϕ % 90.0

    if quadrant == 0
        ϕ = offset
    elseif quadrant == 1
        ϕ = pole - offset
        λ += 180.0
    elseif quadrant == 2
        ϕ = -offset
        λ += 180.0
    elseif quadrant == 3
        ϕ = - pole + offset
    end

    if λ > 180.0 || λ < -180.0
        λ -= floor((λ + 180.0) / 360) * 360
    end

    return ϕ, λ
end