Geometry.CopyMeshingMethod = 1;

/* MESH PARAMS */
E1 = 4;
E2 = 2;
E3 = 3;

N1 = E1+1;
N2 = E2+1;
N3 = E3+1;

R = 1.5;
L = R+1;
b = 0.4*R;
th  = 105.0/2.0;
phi = 135.0-th;
deg = Pi/180.0;

r = b*Sin(phi*deg)/Sin(th*deg);
h = R*Sqrt(0.5);
r = r*Sqrt(0.5);

/* TRIANGLE VERTICES */
x1 = 0; y1 = 0;
x2 = R; y2 = 0;
x3 = 0; y3 = R;

/* TRIANGLE MIDPOINTS */
x4 = b; y4 = 0;
x5 = h; y5 = h;
x6 = 0; y6 = b;

/* TRIANGLE CENTER */
x7 = r; y7 = r;

/* SQUARE CORNER */
x8 = L; y8 = 0;
x9 = L; y9 = L;
x10= 0; y10= L;


/* MESHING */
Point( 1) = {x1, y1, 0};
Point( 2) = {x2, y2, 0};
Point( 3) = {x3, y3, 0};
Point( 4) = {x4, y4, 0};
Point( 5) = {x5, y5, 0};
Point( 6) = {x6, y6, 0};
Point( 7) = {x7, y7, 0};
Point( 8) = {x8, y8, 0};
Point( 9) = {x9, y9, 0};
Point(10) = {x10,y10,0};

Line(1 ) = {1 ,4 }; 
Line(2 ) = {4 ,2 }; 
Circle(3 ) = {2, 1 ,5 }; 
Circle(4 ) = {5, 1 ,3 }; 
Line(5 ) = {3 ,6 }; 
Line(6 ) = {6 ,1 }; 
Line(7 ) = {4 ,7 }; 
Line(8 ) = {5 ,7 }; 
Line(9 ) = {6 ,7 }; 

Line(10)= { 5, 9};
Line(11)= { 9, 8};
Line(12)= { 8, 2};
Line(13)= { 3,10};
Line(14)= {10, 9};

Line Loop(101) = {1,7,-9,6};    Plane Surface(1) = {101};
Line Loop(102) = {2,3,8,-7};    Plane Surface(2) = {102};
Line Loop(103) = {4,5,9,-8};    Plane Surface(3) = {103};
Line Loop(104) = { 10,11,12,3}; Plane Surface(4) = {104};
Line Loop(105) = {-10,4,13,14}; Plane Surface(5) = {105};

Transfinite Curve {2,5,8} = N1;
Transfinite Curve {1,3,4,6,7,9} = N2;
Transfinite Curve {10,12,13} = N3;
Transfinite Surface "*";
Recombine Surface "*";

q1[] = {1,2,3,4,5};

q2[] = Symmetry {0, 1, 0, 0} { 
   Duplicata{
      Surface{ q1[0],q1[1],q1[2],q1[3],q1[4] };
   } 
};

q3[] = Symmetry {1, 0, 0, 0} {
   Duplicata{ 
      Surface{ q1[0],q1[1],q1[2],q1[3],q1[4],
               q2[0],q2[1],q2[2],q2[3],q2[4]};
   } 
};

Physical Surface(101) = {
   q1[3], q1[4],
   q2[3], q2[4], 
   q3[3], q3[4],
   q3[8], q3[9]
};

Physical Surface(102) = {
   q1[0], q1[1], q1[2],
   q2[0], q2[1], q2[2], 
   q3[0], q3[1], q3[2],
   q3[5], q3[6], q3[7]
};

px[] = Symmetry{1, 0, 0, -L  }{Duplicata{Physical Surface{101};}};
qx[] = Symmetry{1, 0, 0, -L  }{Duplicata{Physical Surface{102};}};

py[] = Symmetry{0, 1, 0, -L  }{Duplicata{Physical Surface{101};}};
qy[] = Symmetry{0, 1, 0, -L  }{Duplicata{Physical Surface{102};}};

pz[] = Symmetry{1, 1, 0, -2*L}{Duplicata{Physical Surface{101};}};
qz[] = Symmetry{1, 1, 0, -2*L}{Duplicata{Physical Surface{102};}};

Physical Surface("base",1) = {
   q1[3],q1[4], q2[3],q2[4], q3[3],q3[4], q3[8],q3[9], 
   px[0],px[1], px[2],px[3], px[4],px[5], px[6],px[7],
   py[0],py[1], py[2],py[3], py[4],py[5], py[6],py[7],
   pz[0],pz[1], pz[2],pz[3], pz[4],pz[5], pz[6],pz[7]
};

Physical Surface("stud",2) = {
   qx[0],qx[1],qx[2], qx[3],qx[4],qx[5], qx[6],qx[7],qx[8], qx[9],qx[10],qx[11],
   qy[0],qy[1],qy[2], qy[3],qy[4],qy[5], qy[6],qy[7],qy[8], qy[9],qy[10],qy[11],
   qz[0],qz[1],qz[2], qz[3],qz[4],qz[5], qz[6],qz[7],qz[8], qz[9],qz[10],qz[11],
   q1[0],q1[1],q1[2], q2[0],q2[1],q2[2], q3[0],q3[1],q3[2], q3[5],q3[ 6],q3[ 7]
};

Physical Curve("left",1) = {};
