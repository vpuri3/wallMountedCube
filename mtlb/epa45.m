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
al=45;
%=======================================================

nx1=19; % centerline
ny1=1e3;
nz1=1;
nx2=23; % horizontal
ny2=1;
nz2=1e3;

n=nx1*ny1*nz1 + nx2*ny2*nz2;

%----------
% Nek
%----------
C   =dlmread('./wmc45snyder/wmc.his',' ',[1 0 n 2]); % X,Y,Z
time=dlmread('./wmc45snyder/ave.dat','' ,[1 0 1 0]);
U   =dlmread('./wmc45snyder/ave.dat','' ,[1 1 n 4]); % vx,vy,vz,pr
tk  =dlmread('./wmc45snyder/var.dat','' ,[1 1 n 3]); % < u' * u' >

xN=C(:,1);
yN=C(:,2);
zN=C(:,3);
[xN,yN,zN] = insidecube(al,xN,yN,zN);

uN=U(:,1);
vN=U(:,2);
wN=U(:,3);
pN=U(:,4);

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
ufactor=1/3; % tbd

M=readmatrix('~/Nek5000/run/wmc/mtlb/EPA_WindTunnel/EP3C13C.xls');
xE1=M(:,1)*xfactor;
zE1=M(:,2)*xfactor; % y -> z
yE1=M(:,3)*xfactor; % z -> y
uE1=M(:,4)*ufactor;
upE1=M(:,5)*ufactor;
wE1=M(:,6)*ufactor;  % v -> w
wpE1=M(:,7)*ufactor; % v -> w
wE1=M(:,8)*ufactor;  % w -> v
wpE1=M(:,9)*ufactor; % w -> v

[xE1,yE1,zE1] = insidecube(al,xE1,yE1,zE1);
%----------
% figs
%----------
profXY2(uN(I1),xN(I1),yN(I1),uE1,xE1,yE1,0.2,'u','$$v_x$$',al,xw,yw);
%profXY2(kN(I1),xN(I1),yN(I1),[],[],[],1.0,'k','$$k$$',al,xw,yw);
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
ufactor=1/3; % tbd

M=readmatrix('~/Nek5000/run/wmc/mtlb/EPA_WindTunnel/EP3C13GF.xls');
xE2=M(:,1)*xfactor;
zE2=M(:,2)*xfactor; % y -> z
uE2=M(:,3)*ufactor;
upE2=M(:,4)*ufactor;
vE2=M(:,7)*ufactor;  % w -> v
vpE2=M(:,8)*ufactor; % w -> v

yE2=xE2*0+0.1;
[xE2,yE2,zE2] = insidecube(al,xE2,yE2,zE2);
%----------
% figs
%----------
profXZ2(uN(I2),xN(I2),zN(I2),uE2,xE2,zE2,0.2,'u','$$v_x$$',al,xw,yw,0.1);

