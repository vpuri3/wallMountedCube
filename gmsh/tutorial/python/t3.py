# ------------------------------------------------------------------------------
#
#  Gmsh Python tutorial 3
#
#  Extruded meshes, options
#
# ------------------------------------------------------------------------------

import gmsh
import math

gmsh.initialize()
gmsh.option.setNumber("General.Terminal", 1)

gmsh.model.add("t3")

# Copied from t1.py...
lc = 1e-2
gmsh.model.geo.addPoint(0, 0, 0, lc, 1)
gmsh.model.geo.addPoint(.1, 0, 0, lc, 2)
gmsh.model.geo.addPoint(.1, .3, 0, lc, 3)
gmsh.model.geo.addPoint(0, .3, 0, lc, 4)
gmsh.model.geo.addLine(1, 2, 1)
gmsh.model.geo.addLine(3, 2, 2)
gmsh.model.geo.addLine(3, 4, 3)
gmsh.model.geo.addLine(4, 1, 4)
gmsh.model.geo.addCurveLoop([4, 1, -2, 3], 1)
gmsh.model.geo.addPlaneSurface([1], 1)
gmsh.model.addPhysicalGroup(1, [1, 2, 4], 5)
ps = gmsh.model.addPhysicalGroup(2, [1])
gmsh.model.setPhysicalName(2, ps, "My surface")

# As in `t2.py', we plan to perform an extrusion along the z axis.  But here,
# instead of only extruding the geometry, we also want to extrude the 2D
# mesh. This is done with the same `extrude()' function, but by specifying
# element 'Layers' (2 layers in this case, the first one with 8 subdivisions and
# the second one with 2 subdivisions, both with a height of h/2). The number of
# elements for each layer and the (end) height of each layer are specified in
# two vectors:

h = 0.1
angle = 90.
ov = gmsh.model.geo.extrude([(2, 1)], 0, 0, h, [8, 2], [0.5, 1])

# The extrusion can also be performed with a rotation instead of a translation,
# and the resulting mesh can be recombined into prisms (we use only one layer
# here, with 7 subdivisions). All rotations are specified by an an axis point
# (-0.1, 0, 0.1), an axis direction (0, 1, 0), and a rotation angle (-Pi/2):
ov = gmsh.model.geo.revolve([(2, 28)], -0.1, 0, 0.1, 0, 1, 0, -math.pi / 2,
                            [7])

# Using the built-in geometry kernel, only rotations with angles < Pi are
# supported. To do a full turn, you will thus need to apply at least 3
# rotations. The OpenCASCADE geometry kernel does not have this limitation.

# A translation (-2*h, 0, 0) and a rotation ((0,0.15,0.25), (1,0,0), Pi/2) can
# also be combined to form a "twist".  The last (optional) argument for the
# extrude() and twist() functions specifies whether the extruded mesh should be
# recombined or not.
ov = gmsh.model.geo.twist([(2, 50)], 0, 0.15, 0.25, -2 * h, 0, 0, 1, 0, 0,
                          angle * math.pi / 180., [10], [], True)

gmsh.model.geo.synchronize()

# All the extrusion functions return a vector of extruded entities: the "top" of
# the extruded surface (in `ov[0]'), the newly created volume (in `ov[1]') and
# the tags of the lateral surfaces (in `ov[2]', `ov[3]', ...).

# We can then define a new physical volume (with tag 101) to group all the
# elementary volumes:
gmsh.model.addPhysicalGroup(3, [1, 2, ov[1][1]], 101)

gmsh.model.mesh.generate(3)
gmsh.write("t3.msh")

# Let us now change some options... Since all interactive options are accessible
# through the API, we can for example make point tags visible or redefine some
# colors:

gmsh.option.setNumber("Geometry.PointNumbers", 1)
gmsh.option.setColor("Geometry.Points", 255, 165, 0)
gmsh.option.setColor("General.Text", 255, 255, 255)
gmsh.option.setColor("Mesh.Points", 255, 0, 0)

# Note that color options are special: setting a color option of "X.Y"
# actually sets the option "X.Color.Y".

r, g, b, a = gmsh.option.getColor("Geometry.Points")
gmsh.option.setColor("Geometry.Surfaces", r, g, b, a)

# Launch the GUI to see the effects of the color changes:

# gmsh.fltk.run();

# When the GUI is launched, you can use the `Help->Current Options and
# Workspace' menu to see the current values of all options. To save the options
# in a file, use `File->Export->Gmsh Options', or through the api:

# gmsh.write("t3.opt");

gmsh.finalize()
