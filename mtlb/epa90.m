%
%=======================================================
% NEK
% 	U = 1 (at cube height)
%   L = 1 (cube height)
% \nu = 40e3

% Directions: Streamwise/Normal/Spanwise - X,U/Y,V/Z,W

% EPA (Snyder, 1994)
%	U ~ 3.0-3.2
%   L = 0.2
% \nu = 1.48-1.57 e-5 (15*C, 25*C)

% Directions: Streamwise/Normal/Spanwise - X,U/Z,W/Y,V

%=======================================================
clear;
al=90;

uscl=0.5;
kscl=2.0;

%=======================================================

nx1=21; % centerline
ny1=1e3;
nz1=1;
nx2=17; % horizontal
ny2=1;
nz2=1e3;

n=nx1*ny1*nz1 + nx2*ny2*nz2;

%----------
% Nek
%----------
C   =dlmread('./wmc90snyder/wmc.his',' ',[1 0 n 2]); % X,Y,Z
time=dlmread('./wmc90snyder/ave.dat','' ,[1 0 1 0]);
U   =dlmread('./wmc90snyder/ave.dat','' ,[1 1 n 4]); % vx,vy,vz,pr
tk  =dlmread('./wmc90snyder/var.dat','' ,[1 1 n 3]); % < u' * u' >

xN=C(:,1);
yN=C(:,2);
zN=C(:,3);
[xN,yN,zN] = insidecube(al,xN,yN,zN);

uN=U(:,1);
vN=U(:,2);
wN=U(:,3);
pN=U(:,4);

uuN=tk(:,1);
vvN=tk(:,2);
wwN=tk(:,3);
k1N=0.75*(uuN+vvN); % good proxy for TKE
kN = 0.5 * sum(tk')';

I1=         1:nx1*ny1*nz1 ; I1=reshape(I1,[nx1,ny1,nz1]);
I2=I1(end)+(1:nx2*ny2*nz2); I2=reshape(I2,[nx2,ny2,nz2]);

%=======================================================
% vertical centerline plane
%=======================================================

%----------
% geometry 
%----------
xmn=-5; xmx=9;
zmn=-0; zmx=0;
xw=linspace(xmn,xmx,1e3);
zw=linspace(zmn,zmx,1e0);
[xw,yw,zw]=ndgrid(xw,0,zw);
[~,~,~,xw,yw,~] = cube(90,xw,yw,zw);

%----------
% Snyder
% columns: x,z,u,u',w,w',TKE,TKE/UBARSQ,sqrt(H)
% units: length (mm), vel (m/s)
%----------
xfactor=1/200;
ufactor=1/3;

M=readmatrix('~/Nek5000/run/wmc/mtlb/profiles/EPA_WindTunnel/EP3C1CT.xls');
xE1=M(:,1)*xfactor;
yE1=M(:,2)*xfactor; % z -> y
uE1=M(:,3)*ufactor;
uuE1=M(:,4)*ufactor;
vE1=M(:,5)*ufactor; % w -> v
vvE1=M(:,6)*ufactor; % w -> v
kE1 = 0.75*(uuE1.*uuE1+vvE1.*vvE1);

zE1=xE1*0;
[xE1,yE1,zE1] = insidecube(al,xE1,yE1,zE1);
%----------
% figs
%----------

profXY2( uN(I1),xN(I1),yN(I1),uE1,xE1,yE1,uscl,'SNY-u','$$v_x$$',al,xw,yw,1);
profXY2(k1N(I1),xN(I1),yN(I1),kE1,xE1,yE1,kscl,'SNY-k','$$k$$'  ,al,xw,yw,1);
%
%=======================================================
% horizontal ground plane
%=======================================================

%----------
% geometry
%----------
xx=linspace(-0.5,0.5,1e2)';
xw=[xx      ;0*xx+0.5;flip(xx);0*xx-0.5];
zw=[0*xx-0.5;xx      ;0*xx+0.5;flip(xx)];
a=al*pi/180;
M=[cos(a),-sin(a);sin(a),cos(a)];
xz=[xw,zw]*M';
xw=xz(:,1);
zw=xz(:,2);

%----------
% Snyder
% columns: x,z,u,u',w,w',TKE,TKE/UBARSQ,sqrt(H)
% units: length (mm), vel (m/s)
%----------
xfactor=1/200;
ufactor=1/3; % tbd

M=readmatrix('~/Nek5000/run/wmc/mtlb/profiles/EPA_WindTunnel/EP3C1GF.xls');
xE2=M(:,1)*xfactor;
zE2=M(:,2)*xfactor; % y -> z
uE2=M(:,3)*ufactor;
uuE2=M(:,4)*ufactor;
wE2=M(:,7)*ufactor;  % v -> w
wwE2=M(:,8)*ufactor; % v -> w
kE2=0.75*(uuE2.*uuE2+wwE2.*wwE2);

yE2=xE2*0+0.1;
[xE2,yE2,zE2] = insidecube(al,xE2,yE2,zE2);
%----------
% figs
%----------
profXZ2( uN(I2),xN(I2),zN(I2),uE2,xE2,zE2,uscl,'SNY-u','$$v_x$$',al,xw,zw,0.1,1);
profXZ2(k1N(I2),xN(I2),zN(I2),kE2,xE2,zE2,kscl,'SNY-k','$$k$$'  ,al,xw,zw,0.1,1);
