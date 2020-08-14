// -----------------------------------------------------------------------------
//
//  Gmsh C++ tutorial 19
//
//  Thrusections, fillets, pipes, mesh size from curvature
//
// -----------------------------------------------------------------------------

// The OpenCASCADE geometry kernel supports several useful features for solid
// modelling.

#include <cmath>
#include <cstdlib>
#include <gmsh.h>

int main(int argc, char **argv)
{
  gmsh::initialize(argc, argv);
  gmsh::option::setNumber("General.Terminal", 1);

  gmsh::model::add("t19");

  // Volumes can be constructed from (closed) curve loops thanks to the
  // `addThruSections()' function
  gmsh::model::occ::addCircle(0, 0, 0, 0.5, 1);
  gmsh::model::occ::addCurveLoop({1}, 1);
  gmsh::model::occ::addCircle(0.1, 0.05, 1, 0.1, 2);
  gmsh::model::occ::addCurveLoop({2}, 2);
  gmsh::model::occ::addCircle(-0.1, -0.1, 2, 0.3, 3);
  gmsh::model::occ::addCurveLoop({3}, 3);
  std::vector<std::pair<int, int> > out;
  gmsh::model::occ::addThruSections({1, 2, 3}, out, 1);
  gmsh::model::occ::synchronize();

  // We can also force the creation of ruled surfaces:
  gmsh::model::occ::addCircle(2 + 0, 0, 0, 0.5, 11);
  gmsh::model::occ::addCurveLoop({11}, 11);
  gmsh::model::occ::addCircle(2 + 0.1, 0.05, 1, 0.1, 12);
  gmsh::model::occ::addCurveLoop({12}, 12);
  gmsh::model::occ::addCircle(2 - 0.1, -0.1, 2, 0.3, 13);
  gmsh::model::occ::addCurveLoop({13}, 13);
  gmsh::model::occ::addThruSections({11, 12, 13}, out, 11, true, true);
  gmsh::model::occ::synchronize();

  // We copy the first volume, and fillet all its edges:
  gmsh::model::occ::copy({{3, 1}}, out);
  gmsh::model::occ::translate(out, 4, 0, 0);
  gmsh::model::occ::synchronize();
  std::vector<std::pair<int, int> > f;
  gmsh::model::getBoundary(out, f);
  std::vector<std::pair<int, int> > e;
  gmsh::model::getBoundary(f, e, false);
  std::vector<int> c;
  for(std::size_t i = 0; i < e.size(); i++) c.push_back(abs(e[i].second));
  gmsh::model::occ::fillet({out[0].second}, c, {0.1}, out);
  gmsh::model::occ::synchronize();

  // OpenCASCADE also allows general extrusions along a smooth path. Let's first
  // define a spline curve:
  double nturns = 1;
  int npts = 20;
  double r = 1;
  double h = 1 * nturns;
  std::vector<int> p;
  for(int i = 0; i < npts; i++) {
    double theta = i * 2 * M_PI * nturns / npts;
    gmsh::model::occ::addPoint(r * cos(theta), r * sin(theta), i * h / npts, 1,
                               1000 + i);
    p.push_back(1000 + i);
  }
  gmsh::model::occ::addSpline(p, 1000);

  // A wire is like a curve loop, but open:
  gmsh::model::occ::addWire({1000}, 1000);

  // We define the shape we would like to extrude along the spline (a disk):
  gmsh::model::occ::addDisk(1, 0, 0, 0.2, 0.2, 1000);
  gmsh::model::occ::rotate({{2, 1000}}, 0, 0, 0, 1, 0, 0, M_PI / 2);

  // We extrude the disk along the spline to create a pipe:
  gmsh::model::occ::addPipe({{2, 1000}}, 1000, out);

  // We delete the source surface, and increase the number of sub-edges for a
  // nicer display of the geometry:
  gmsh::model::occ::remove({{2, 1000}});
  gmsh::option::setNumber("Geometry.NumSubEdges", 1000);

  gmsh::model::occ::synchronize();

  // We can activate the calculation of mesh element sizes based on curvature:
  gmsh::option::setNumber("Mesh.CharacteristicLengthFromCurvature", 1);

  // And we set the minimum number of elements per 2*Pi radians:
  gmsh::option::setNumber("Mesh.MinimumElementsPerTwoPi", 20);

  // We can constraint the min and max element sizes to stay within reasonnable
  // values (see `t10.cpp' for more details):
  gmsh::option::setNumber("Mesh.CharacteristicLengthMin", 0.001);
  gmsh::option::setNumber("Mesh.CharacteristicLengthMax", 0.3);

  gmsh::model::mesh::generate(3);
  gmsh::write("t19.msh");

  // gmsh::fltk::run();
  return 0;
}
