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
