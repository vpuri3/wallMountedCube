#
# Cases
WMC45 - Case EP3C13 - Wall-Mounted Cube rotated 45* with respect to wind vector
WMC90 - Case EP3C1  - Wall-Mounted Cube with sides perpendicular to wind vector

# Coordinate System
Origin - Center of ground surface of cube
x - Streamwise dir
y - Spanwise dir
z - Ground normal dir

All lengths are normalized by cube height, H

# Inflow
uInflow = (z/1.0).^0.16
=> The flow characteristic velocity is uInflow(z=1) = 1

# Files
WMC45dat1.csv - WMC45 vertical profiles at X=3H,6H,8H
WMC45dat2.csv - WMC45 centerline transect at height z=1.5H; u(x=-4H)=1.0625894
#
WMC90dat1.csv - WMC90 vertical profiles at X=3H,6H,8H
WMC90dat2.csv - WMC90 centerline transect at height z=1.6H; u(x=-4H)=1.0733567

Check ./wallMountedCube.pdf for case setup
