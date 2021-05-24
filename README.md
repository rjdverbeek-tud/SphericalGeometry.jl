# SphericalGeometry

[![Build Status](https://travis-ci.com/rjdverbeek-tud/SphericalGeometry.jl.svg?branch=master)](https://travis-ci.com/rjdverbeek-tud/SphericalGeometry.jl)
[![Coverage](https://codecov.io/gh/rjdverbeek-tud/SphericalGeometry.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/rjdverbeek-tud/SphericalGeometry.jl)
[![Coverage](https://coveralls.io/repos/github/rjdverbeek-tud/SphericalGeometry.jl/badge.svg?branch=master)](https://coveralls.io/github/rjdverbeek-tud/SphericalGeometry.jl?branch=master)

A Julia Package for handling Spherical Geometry.

It includes the calculation of:
* The distance to a point, line, arc, arcs, or polygon border
* The area of spherical triangle and polygon
* The intersection points between lines, arcs, and polygon borders.
* The midpoint of two points, arc or arcs
* The intermediate point of two points, arc or arcs
* The destination point given a point, distance and azimuth
* The self intersection points of arcs and polygon borders
* The azimuth between two points

And testing if:
* a point, arc or arcs is inside a polygon
* a point is on a line, arc, arcs or polygon border
