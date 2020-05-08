/* MESH PARAMS */

/* at lx1=8, first point at 0.05 for z \in [0,1] */

Nc  = 21;            // # points on cube side
No  = 40;            // # points on line from cube to outer box
Ny  = 20;            // # points (y-dir)
Ne  = 10;            // # points in entrance (x-dir)
Nw  = 40;            // # points in wake     (x-dir)
bfc = 1.05;          //   expansion from cube surface
Py  = 1.15;          //   expansion from ground (y-dir)
Pc  = 0.05;          //   edge refinement on cube eg. "Nc Using Bump Pc;"
Nsmooth = 0;         // # mesh smoothing iterations

// fixed due to geom
Nb = 0.5*(Nc+1);  // # points on side of small quads

/********** DOMAIN **********/

h        =  1.0; // cube height
span     = 10.0;
len      = span;
wake     = 20.0 + 0.5*span;
height   = 5.0;
entrance = -(5.0 + 0.5*span);

lc = 1e-1;

/********** CREATE DOMAIN **********/

// Triangle Splitting
r = 0.60;
x = r/Sqrt(2);
y = r/Sqrt(2);
y2 = r/Sqrt(2)*(1+Sin(Pi/8));
x3 = 0.50;
y3 = 0.50;

ll = len/2;

xx0 = ll*(1-x);
zz0 = ll*(1-y);
xx1 = ll*(1-y2);
zz1 = ll;
xx2 = ll;
zz2 = ll*(1-y2);
xx3 = ll*(1-x3);
zz3 = ll*(1-y3);

/******************** POINTS ********************/

// inner bottom
hh = h/Sqrt(2);
hm = h/Sqrt(2)/2;

Point(0) = {  0,0,  0,lc};
Point(1) = { hh,0,  0,lc};
Point(2) = { hm,0, hm,lc};
Point(3) = {  0,0, hh,lc};
Point(4) = {-hm,0, hm,lc};
Point(5) = {-hh,0,  0,lc};
Point(6) = {-hm,0,-hm,lc};
Point(7) = {  0,0,-hh,lc};
Point(8) = { hm,0,-hm,lc};
       
// inner middle
Point(11) = { hh,h,  0,lc};
Point(12) = { hm,h, hm,lc};
Point(13) = {  0,h, hh,lc};
Point(14) = {-hm,h, hm,lc};
Point(15) = {-hh,h,  0,lc};
Point(16) = {-hm,h,-hm,lc};
Point(17) = {  0,h,-hh,lc};
Point(18) = { hm,h,-hm,lc};
       
// outer bottom
ss=0.5*span;

Point(21) = { ss,0,  0,lc};
Point(22) = { ss,0, ss,lc};
Point(23) = {  0,0, ss,lc};
Point(24) = {-ss,0, ss,lc};
Point(25) = {-ss,0,  0,lc};
Point(26) = {-ss,0,-ss,lc};
Point(27) = {  0,0,-ss,lc};
Point(28) = { ss,0,-ss,lc};

// outer middle
h2 = 0.5 * height;
Point(31) = { ss,h2,  0,lc};
Point(32) = { ss,h2, ss,lc};
Point(33) = {  0,h2, ss,lc};
Point(34) = {-ss,h2, ss,lc};
Point(35) = {-ss,h2,  0,lc};
Point(36) = {-ss,h2,-ss,lc};
Point(37) = {  0,h2,-ss,lc};
Point(38) = { ss,h2,-ss,lc};

// outer top
Point(41) = { ss,height,  0,lc};
Point(42) = { ss,height, ss,lc};
Point(43) = {  0,height, ss,lc};
Point(44) = {-ss,height, ss,lc};
Point(45) = {-ss,height,  0,lc};
Point(46) = {-ss,height,-ss,lc};
Point(47) = {  0,height,-ss,lc};
Point(48) = { ss,height,-ss,lc};

// inner middle
//Point(51) = { hh,h2,  0,lc};
//Point(52) = { hm,h2, hm,lc};
//Point(53) = {  0,h2, hh,lc};
//Point(54) = {-hm,h2, hm,lc};
//Point(55) = {-hh,h2,  0,lc};
//Point(56) = {-hm,h2,-hm,lc};
//Point(57) = {  0,h2,-hh,lc};
//Point(58) = { hm,h2,-hm,lc};

// inner top
h3 = 0.5  * ss;
h4 = 0.25 * ss;
Point(61) = { h3,height,  0,lc};
Point(62) = { h4,height, h4,lc};
Point(63) = {  0,height, h3,lc};
Point(64) = {-h4,height, h4,lc};
Point(65) = {-h3,height,  0,lc};
Point(66) = {-h4,height,-h4,lc};
Point(67) = {  0,height,-h3,lc};
Point(68) = { h4,height,-h4,lc};

/******************** LINES ********************/

// inner bottom
Line(1) = {1,2}; Transfinite Curve {1} = Nb;
Line(2) = {2,3}; Transfinite Curve {2} = Nb;
Line(3) = {3,4}; Transfinite Curve {3} = Nb;
Line(4) = {4,5}; Transfinite Curve {4} = Nb;
Line(5) = {5,6}; Transfinite Curve {5} = Nb;
Line(6) = {6,7}; Transfinite Curve {6} = Nb;
Line(7) = {7,8}; Transfinite Curve {7} = Nb;
Line(8) = {8,1}; Transfinite Curve {8} = Nb;

// inner middle
Line(11) = {11,12}; Transfinite Curve {11} = Nb;
Line(12) = {12,13}; Transfinite Curve {12} = Nb;
Line(13) = {13,14}; Transfinite Curve {13} = Nb;
Line(14) = {14,15}; Transfinite Curve {14} = Nb;
Line(15) = {15,16}; Transfinite Curve {15} = Nb;
Line(16) = {16,17}; Transfinite Curve {16} = Nb;
Line(17) = {17,18}; Transfinite Curve {17} = Nb;
Line(18) = {18,11}; Transfinite Curve {18} = Nb;

// inner bottom-middle (vert)
Line(21) = {1,11}; Transfinite Curve {21} = Ny;
Line(22) = {2,12}; Transfinite Curve {22} = Ny;
Line(23) = {3,13}; Transfinite Curve {23} = Ny;
Line(24) = {4,14}; Transfinite Curve {24} = Ny;
Line(25) = {5,15}; Transfinite Curve {25} = Ny;
Line(26) = {6,16}; Transfinite Curve {26} = Ny;
Line(27) = {7,17}; Transfinite Curve {27} = Ny;
Line(28) = {8,18}; Transfinite Curve {28} = Ny;

// outer bottom
Line(31) = {21,22}; Transfinite Curve {31} = Nb;
Line(32) = {22,23}; Transfinite Curve {32} = Nb;
Line(33) = {23,24}; Transfinite Curve {33} = Nb;
Line(34) = {24,25}; Transfinite Curve {34} = Nb;
Line(35) = {25,26}; Transfinite Curve {35} = Nb;
Line(36) = {26,27}; Transfinite Curve {36} = Nb;
Line(37) = {27,28}; Transfinite Curve {37} = Nb;
Line(38) = {28,21}; Transfinite Curve {38} = Nb;

// outer middle
Line(41) = {31,32}; Transfinite Curve {41} = Nb;
Line(42) = {32,33}; Transfinite Curve {42} = Nb;
Line(43) = {33,34}; Transfinite Curve {43} = Nb;
Line(44) = {34,35}; Transfinite Curve {44} = Nb;
Line(45) = {35,36}; Transfinite Curve {45} = Nb;
Line(46) = {36,37}; Transfinite Curve {46} = Nb;
Line(47) = {37,38}; Transfinite Curve {47} = Nb;
Line(48) = {38,31}; Transfinite Curve {48} = Nb;

// outer bottom-middle (vert)
Line(51) = {21,31}; Transfinite Curve {51} = Ny;
Line(52) = {22,32}; Transfinite Curve {52} = Ny;
Line(53) = {23,33}; Transfinite Curve {53} = Ny;
Line(54) = {24,34}; Transfinite Curve {54} = Ny;
Line(55) = {25,35}; Transfinite Curve {55} = Ny;
Line(56) = {26,36}; Transfinite Curve {56} = Ny;
Line(57) = {27,37}; Transfinite Curve {57} = Ny;
Line(58) = {28,38}; Transfinite Curve {58} = Ny;

// connect (inner-outer) bottom
Line(61) = {1,21}; Transfinite Curve {61} = No;
Line(62) = {2,22}; Transfinite Curve {62} = No;
Line(63) = {3,23}; Transfinite Curve {63} = No;
Line(64) = {4,24}; Transfinite Curve {64} = No;
Line(65) = {5,25}; Transfinite Curve {65} = No;
Line(66) = {6,26}; Transfinite Curve {66} = No;
Line(67) = {7,27}; Transfinite Curve {67} = No;
Line(68) = {8,28}; Transfinite Curve {68} = No;

// connect (inner-outer) middle
Line(71) = {11,31}; Transfinite Curve {71} = No;
Line(72) = {12,32}; Transfinite Curve {72} = No;
Line(73) = {13,33}; Transfinite Curve {73} = No;
Line(74) = {14,34}; Transfinite Curve {74} = No;
Line(75) = {15,35}; Transfinite Curve {75} = No;
Line(76) = {16,36}; Transfinite Curve {76} = No;
Line(77) = {17,37}; Transfinite Curve {77} = No;
Line(78) = {18,38}; Transfinite Curve {78} = No;

// outer middle-top (vert)
Line(81) = {31,41}; Transfinite Curve {81} = 5;
Line(82) = {32,42}; Transfinite Curve {82} = 5;
Line(83) = {33,43}; Transfinite Curve {83} = 5;
Line(84) = {34,44}; Transfinite Curve {84} = 5;
Line(85) = {35,45}; Transfinite Curve {85} = 5;
Line(86) = {36,46}; Transfinite Curve {86} = 5;
Line(87) = {37,47}; Transfinite Curve {87} = 5;
Line(88) = {38,48}; Transfinite Curve {88} = 5;

// outer top
Line(91) = {41,42}; Transfinite Curve {91} = Nb;
Line(92) = {42,43}; Transfinite Curve {92} = Nb;
Line(93) = {43,44}; Transfinite Curve {93} = Nb;
Line(94) = {44,45}; Transfinite Curve {94} = Nb;
Line(95) = {45,46}; Transfinite Curve {95} = Nb;
Line(96) = {46,47}; Transfinite Curve {96} = Nb;
Line(97) = {47,48}; Transfinite Curve {97} = Nb;
Line(98) = {48,41}; Transfinite Curve {98} = Nb;

// connect (inner-outer) top
Line(101) = {61,41}; Transfinite Curve {101} = No;
Line(102) = {62,42}; Transfinite Curve {102} = No;
Line(103) = {63,43}; Transfinite Curve {103} = No;
Line(104) = {64,44}; Transfinite Curve {104} = No;
Line(105) = {65,45}; Transfinite Curve {105} = No;
Line(106) = {66,46}; Transfinite Curve {106} = No;
Line(107) = {67,47}; Transfinite Curve {107} = No;
Line(108) = {68,48}; Transfinite Curve {108} = No;

// inner top
Line(111) = {61,62}; Transfinite Curve {111} = Nb;
Line(112) = {62,63}; Transfinite Curve {112} = Nb;
Line(113) = {63,64}; Transfinite Curve {113} = Nb;
Line(114) = {64,65}; Transfinite Curve {114} = Nb;
Line(115) = {65,66}; Transfinite Curve {115} = Nb;
Line(116) = {66,67}; Transfinite Curve {116} = Nb;
Line(117) = {67,68}; Transfinite Curve {117} = Nb;
Line(118) = {68,61}; Transfinite Curve {118} = Nb;

// inner middle-top (vert)
Line(121) = {11,61}; Transfinite Curve {121} = 5;
Line(122) = {12,62}; Transfinite Curve {122} = 5;
Line(123) = {13,63}; Transfinite Curve {123} = 5;
Line(124) = {14,64}; Transfinite Curve {124} = 5;
Line(125) = {15,65}; Transfinite Curve {125} = 5;
Line(126) = {16,66}; Transfinite Curve {126} = 5;
Line(127) = {17,67}; Transfinite Curve {127} = 5;
Line(128) = {18,68}; Transfinite Curve {128} = 5;

/******************** SURFACES ********************/

// inner bottom-middle (vert)
For i In {0:7}
	ii = i;
	If(i==7)
		ii = -1;
	EndIf
	Line Loop(1+i)={1+i,22+ii,-(11+i),-(21+i)};
	Plane  Surface(1+i)={1+i};
	Transfinite Surface {1+i};
	Recombine   Surface {1+i};
EndFor

// bottom
For i In {0:7}
	ii = i;
	If(i==7)
		ii = -1;
	EndIf
	Line Loop(11+i)={1+i,62+ii,-(31+i),-(61+i)};
	Plane Surface(11+i)={11+i};
	Transfinite Surface {11+i};
	Recombine   Surface {11+i};
EndFor

// connect bottom-middle (vert)
For i In {0:7}
	Line Loop(21+i)={61+i,51+i,-(71+i),-(21+i)};
	Plane Surface(21+i)={21+i};
	Transfinite Surface {21+i};
	Recombine   Surface {21+i};
EndFor

// middle
For i In {0:7}
	ii = i;
	If(i==7)
		ii = -1;
	EndIf
	Line Loop(31+i)={11+i,72+ii,-(41+i),-(71+i)};
	Surface(31+i)={31+i};
	Transfinite Surface {31+i};
	Recombine   Surface {31+i};
EndFor

// bottom-middle (vert)
For i In {0:7}
	ii = i;
	If(i==7)
		ii = -1;
	EndIf
	Line Loop(41+i)={31+i,52+ii,-(41+i),-(51+i)};
	Plane Surface(41+i)={41+i};
	Transfinite Surface {41+i};
	Recombine   Surface {41+i};
EndFor



// center bottom
Line Loop(9)={11:18}; Plane Surface(9)={9};
Transfinite Surface {9}={11,13,15,17}; Recombine Surface {9};

Mesh.Smoothing = Nsmooth;

/******************** VOLUMES ********************/

// lower
For i In {0:7}
	ii = i;
	If(i==7)
		ii = -1;
	EndIf
	Surface Loop(1+i)={1+i,11+i,22+ii,41+i,21+i,31+i};
	Volume       (1+i)={1+i};
	Transfinite Volume {1+i};
	Recombine   Volume {1+i};
EndFor

// box top

/******************** BOUNDARY CONDITIONS ********************/


