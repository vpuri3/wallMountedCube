/* MESH PARAMS */
N1 = 17;
N2 = 17;
N3 = 17;

/* TRIANGLE VERTICES */
x1 =-1; y1 =-1;
x2 = 1; y2 = 0;
x3 = 0; y3 = 1;

x1 = 0; y1 = 0;
x2 = 1; y2 = 0;
x3 = 0; y3 = 1;

/* BARYCENTRIC WEIGHTS */
z1 = Sqrt( (x2-x3)^2 + (y2-y3)^2 );
z2 = Sqrt( (x1-x3)^2 + (y1-y3)^2 );
z3 = Sqrt( (x1-x2)^2 + (y1-y2)^2 );
z4 = z1+z2;
z5 = z2+z3;
z6 = z1+z3;
z7 = z1+z2+z3;

/* MIDPOINTS */
x4 = ( z1*x1 + z2*x2 )/z4;  y4 = ( z1*y1 + z2*y2 )/z4; 
x5 = ( z2*x2 + z3*x3 )/z5;  y5 = ( z2*y2 + z3*y3 )/z5; 
x6 = ( z1*x1 + z3*x3 )/z6;  y6 = ( z1*y1 + z3*y3 )/z6; 

/* INCENTER */
x7 = ( z1*x1 + z2*x2 + z3*x3 )/z7; 
y7 = ( z1*y1 + z2*y2 + z3*y3 )/z7; 



/* MESHING */
Point(1 ) = {x1, y1, 0};
Point(2 ) = {x2, y2, 0};
Point(3 ) = {x3, y3, 0};
Point(4 ) = {x4, y4, 0};
Point(5 ) = {x5, y5, 0};
Point(6 ) = {x6, y6, 0};
Point(7 ) = {x7, y7, 0};

Line(1 ) = {1 ,4 }; Transfinite Curve {1 } = N1;
Line(2 ) = {4 ,2 }; Transfinite Curve {2 } = N2;
Line(3 ) = {2 ,5 }; Transfinite Curve {3 } = N3;
Line(4 ) = {5 ,3 }; Transfinite Curve {4 } = N1;
Line(5 ) = {3 ,6 }; Transfinite Curve {5 } = N2;
Line(6 ) = {6 ,1 }; Transfinite Curve {6 } = N3;
Line(7 ) = {4 ,7 }; Transfinite Curve {7 } = N3;
Line(8 ) = {5 ,7 }; Transfinite Curve {8 } = N2;
Line(9 ) = {6 ,7 }; Transfinite Curve {9 } = N1;

Line Loop(10) = {1,7,-9,6}; Plane Surface(1) = {10};
Line Loop(11) = {2,3,8,-7}; Plane Surface(2) = {11};
Line Loop(12) = {4,5,9,-8}; Plane Surface(3) = {12};

Transfinite Surface {1}; Recombine Surface {1};
Transfinite Surface {2}; Recombine Surface {2};
Transfinite Surface {3}; Recombine Surface {3};


Physical Curve("Hor",1) = {1,2};
Physical Curve("Ver",2) = {5,6};
Physical Curve("Diag",3) = {3,4};
Physical Surface("Dom", 1) = {1,2,3};
