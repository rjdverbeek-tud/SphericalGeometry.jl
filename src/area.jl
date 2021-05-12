export area

"""
    area(polygon::Polygon, radius::Float64=1.0)

Return the area of the spherical polygon. Without given radius a unit sphere is assumed.

Source: 
"""

"""
    area(point₁::Point, point₂::Point, point₃::Point, radius::Float64=1.0)

Return the area of the spherical triangle based on the points point₁ - point₂ - point₃. Without given radius
a unit sphere is assumed.

Source: mathworld.wolfram.com/SphericalTriangle.html
"""
function area(point₁::Point, point₂::Point, point₃::Point, radius::Float64=1.0)
    
end
