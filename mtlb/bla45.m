%
%=======================================================
% NEK
% 	U = 1 (at cube height)
%   L = 1 (cube height)
% \nu = 40e3

%=======================================================
clear;
al=45;

uscl=0.2;
kscl=1.0;

%=======================================================

nx1=19; % centerline
ny1=1e3;
nz1=1;
nx2=23; % horizontal
ny2=1;
nz2=1e3;

n=nx1*ny1*nz1 + nx2*ny2*nz2;

I1=         1:nx1*ny1*nz1 ; I1=reshape(I1,[nx1,ny1,nz1]);
I2=I1(end)+(1:nx2*ny2*nz2); I2=reshape(I2,[nx2,ny2,nz2]);

%----------
% Nek Blasius \d_99 = 0.25
%----------
C   =dlmread('./wmc45bla0.25/wmc.his',' ',[1 0 n 2]); % X,Y,Z
time=dlmread('./wmc45bla0.25/ave.dat','' ,[1 0 1 0]);
U   =dlmread('./wmc45bla0.25/ave.dat','' ,[1 1 n 4]); % vx,vy,vz,pr
tk  =dlmread('./wmc45bla0.25/var.dat','' ,[1 1 n 3]); % < u' * u' >

xN1=C(:,1);
yN1=C(:,2);
zN1=C(:,3);
[xN1,yN1,zN1] = insidecube(al,xN1,yN1,zN1);

uN1=U(:,1);
vN1=U(:,2);
wN1=U(:,3);
pN1=U(:,4);

uuN1=tk(:,1);
vvN1=tk(:,2);
wwN1=tk(:,3);
kN1 = 0.5 * sum(tk')';

%----------
% Nek Blasius \d_99 = 2.00
%----------
C   =dlmread('./wmc45bla2.00/wmc.his',' ',[1 0 n 2]); % X,Y,Z
time=dlmread('./wmc45bla2.00/ave.dat','' ,[1 0 1 0]);
U   =dlmread('./wmc45bla2.00/ave.dat','' ,[1 1 n 4]); % vx,vy,vz,pr
tk  =dlmread('./wmc45bla2.00/var.dat','' ,[1 1 n 3]); % < u' * u' >

xN2=C(:,1);
yN2=C(:,2);
zN2=C(:,3);
[xN2,yN2,zN2] = insidecube(al,xN2,yN2,zN2);

uN2=U(:,1);
vN2=U(:,2);
wN2=U(:,3);
pN2=U(:,4);

uuN2=tk(:,1);
vvN2=tk(:,2);
wwN2=tk(:,3);
kN2 = 0.5 * sum(tk')';

%=======================================================
% vertical centerline plane
%=======================================================

xmn=-5; xmx=9;
zmn=-0; zmx=0;
xw=linspace(xmn,xmx,1e3);
zw=linspace(zmn,zmx,1e0);
[xw,yw,zw]=ndgrid(xw,0,zw);
[~,~,~,xw,yw,~] = cube(al,xw,yw,zw);

profXY2(uN1(I1),xN1(I1),yN1(I1),uN2(I1),xN2(I1),yN2(I1),uscl,'BLA-u','$$v_x$$',al,xw,yw,0);
profXY2(kN1(I1),xN1(I1),yN1(I1),kN2(I1),xN2(I1),yN2(I1),kscl,'BLA-k','$$k$$'  ,al,xw,yw,0);
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

profXZ2(uN1(I2),xN1(I2),zN1(I2),uN2(I2),xN2(I2),zN2(I2),uscl,'BLA-u','$$v_x$$',al,xw,zw,0.1,0);
profXZ2(kN1(I2),xN1(I2),zN1(I2),kN2(I2),xN2(I2),zN2(I2),kscl,'BLA-k','$$k$$'  ,al,xw,zw,0.1,0);
