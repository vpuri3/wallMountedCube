
/* MESH PARAMS */

Nc = 25;         // # points on cube side
No = 20;         // # points on line from cube to outer box
Nb = 0.5*(Nc+1); // # points on side of small quads

hc = 0.5;
ho = 1.0;
//ho = hc;

lc=1e-2;

/******************** POINTS ********************/

Point(0) = {0  ,0  ,0,lc};

Point(1) = {0.2,0  ,0,lc};
Point(2) = {0.1,0.1,0,lc};
Point(3) = {0.0,0.2,0,lc};
Point(4) = {1.0,0  ,0,lc};
Point(5) = {1.0,1.0,0,lc};
Point(6) = {0.0,1.0,0,lc};

Point(11) = {0.2,0  ,hc,lc};
Point(12) = {0.1,0.1,hc,lc};
Point(13) = {0.0,0.2,hc,lc};
Point(14) = {1.0,0  ,ho,lc};
Point(15) = {1.0,1.0,ho,lc};
Point(16) = {0.0,1.0,ho,lc};

/******************** LINES ********************/

// bottom
Line(1) = {1,2}; Transfinite Curve {1} = Nb;
Line(2) = {2,3}; Transfinite Curve {2} = Nb;
Line(3) = {1,4}; Transfinite Curve {3} = No;
Line(4) = {2,5}; Transfinite Curve {4} = No;
Line(5) = {3,6}; Transfinite Curve {5} = No;
Line(6) = {4,5}; Transfinite Curve {6} = Nb;
Line(7) = {5,6}; Transfinite Curve {7} = Nb;

// top
Line(11) = {11,12}; Transfinite Curve {11} = Nb;
Line(12) = {12,13}; Transfinite Curve {12} = Nb;
Line(13) = {11,14}; Transfinite Curve {13} = No;
Line(14) = {12,15}; Transfinite Curve {14} = No;
Line(15) = {13,16}; Transfinite Curve {15} = No;
Line(16) = {14,15}; Transfinite Curve {16} = Nb;
Line(17) = {15,16}; Transfinite Curve {17} = Nb;

// vert
Line(21) = {1,11}; Transfinite Curve {21} = Nb;
Line(22) = {2,12}; Transfinite Curve {22} = Nb;
Line(23) = {3,13}; Transfinite Curve {23} = No;
Line(24) = {4,14}; Transfinite Curve {24} = No;
Line(25) = {5,15}; Transfinite Curve {25} = No;
Line(26) = {6,16}; Transfinite Curve {26} = Nb;

/******************** SURFACES ********************/


//Line Loop(1) = {11,14,-16,-13}; Surface(1) = {1};
//Transfinite Surface {1}; Recombine Surface {1};

// bottom
Line Loop(1) = { 1, 4,- 6,- 3}; Plane Surface(1) = {1};
Line Loop(2) = { 2, 5,- 7,- 4}; Plane Surface(2) = {2};

Transfinite Surface {1}; Recombine Surface {1};
Transfinite Surface {2}; Recombine Surface {2};

// top
Line Loop(3) = {11,14,-16,-13}; Surface(3) = {3};
Line Loop(4) = {12,15,-17,-14}; Surface(4) = {4};

Transfinite Surface {3}; Recombine Surface {3};
Transfinite Surface {4}; Recombine Surface {4};

//Line Loop(1) = {-1,2,4,5 ,-3}; Plane Surface(1) = {1};
//Line Loop(2) = {-6,7,9,10,-8}; Plane Surface(2) = {2};
//Line Loop(3) = {1,12,-6 ,-11}; Plane Surface(3) = {3};
//Line Loop(4) = {2,13,-7 ,-11}; Plane Surface(4) = {4};
//Line Loop(5) = {3,15,-8 ,-12}; Plane Surface(5) = {5};
//Line Loop(6) = {4,14,-9 ,-13}; Plane Surface(6) = {6};
//Line Loop(7) = {5,15,-10,-14}; Plane Surface(7) = {7};
//
//Transfinite Surface {1} = {1,2,3,5 }; Recombine Surface {1};
//Transfinite Surface {2} = {6,7,8,10}; Recombine Surface {2};
//Transfinite Surface {3}; Recombine Surface {3};
//Transfinite Surface {4}; Recombine Surface {4};
//Transfinite Surface {5}; Recombine Surface {5};
//Transfinite Surface {6}; Recombine Surface {6};
//Transfinite Surface {7}; Recombine Surface {7};

//Mesh.Smoothing = 10;

/******************** VOLUMES ********************/

//Surface Loop(1) = {1,2,3,4,5,6,7}; Volume(1) = {1};

//Transfinite Volume {1}={1,2,3,5,6,7,8,10}; Recombine Volume {1};

