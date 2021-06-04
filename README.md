# SphericalGeometry

[![Build Status](https://travis-ci.com/rjdverbeek-tud/SphericalGeometry.jl.svg?branch=master)](https://travis-ci.com/rjdverbeek-tud/SphericalGeometry.jl)
[![Coverage](https://codecov.io/gh/rjdverbeek-tud/SphericalGeometry.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/rjdverbeek-tud/SphericalGeometry.jl)
[![Coverage](https://coveralls.io/repos/github/rjdverbeek-tud/SphericalGeometry.jl/badge.svg?branch=master)](https://coveralls.io/github/rjdverbeek-tud/SphericalGeometry.jl?branch=master)

A Julia Package for handling Spherical Geometry. Spherical geometry is the 
geometry of the two-dimensional surface of a sphere. This package only
handles geometries generated using great circle sections (arcs).

Angles are specified in [deg].

Types:
* Point: specified by latitude ϕ [deg] and longitude λ [deg]
* Arc: specified as the shortest great circle between two points.
* Line: is a great circle line specified by a point and azimuth [deg]
* Arcs: is a string of continuous line sections defined by a set of points.
* Polygon: is a spherical polygon defined by a set of points.

It includes the calculation of:
* The angular distance to a point, line, arc, multi-arc, or polygon border
* The along line angular distance between a point and a line.
* The intersection points between lines, arcs, multi-arcs, and polygon borders.
* The self intersection points of multi-arcs and polygon borders
* The bounding box of a given polygon or set of arcs.
* The convexhull of a given polygon.
* The normalized point
* The (final) azimuth [deg] between two points
* The spherical angle [deg] and spherical excess [deg] between three points
* The midpoint between two points, of an arc, of an arcs
* The intermediate point at a given fraction between two points, of an arc, of an arcs
* The destination point given a start point, a direction and distance.
* The intersection points of arcs, and polygons
* The self intersection points of arcs or a polygon
* The highest/lowest latitude (point) of a great circle
* The area of a polygon/spherical triangle given a radius

And testing if:
* a point, arc, arcs or polygon is inside a polygon
* a point is on a line, arc, arcs or polygon border (within tolerance)
* a polygon/arcs is self-isselfintersecting
* a polygon is simple, complex, convex or concave
