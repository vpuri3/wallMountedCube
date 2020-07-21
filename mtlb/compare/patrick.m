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

%-------------------
% Snyder Inflow
%-------------------

%y0=1/200; % roughness length
%uf=0.05;  % friction velocity
%
%uepa = (y/1.0).^0.16;

%=======================================================
function patrick(al)

uscl=0.5;
kscl=2.0;

%=======================================================
% NEK
%=======================================================

nx1=4; % centerline
ny1=1e3;
nz1=1;
nx2=1e3; % transect
ny2=1;
nz2=1;

n=nx1*ny1*nz1 + nx2*ny2*nz2;

dir=['./wmc',num2str(al),'snyder/'];
C =dlmread([dir,'wmc.his'],' ',[1 0 n 2]); % X,Y,Z
U =dlmread([dir,'ave.dat'],'' ,[1 1 n 4]); % vx,vy,vz,pr
tk=dlmread([dir,'var.dat'],'' ,[1 1 n 3]); % < u' * u' >

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
I1ref=I1(1,334);
I2ref=I2(1);

%=======================================================
% vertical centerline plane
%=======================================================

%xmn=-4; xmx=10;
%zmn=-0; zmx=0;
%xw=linspace(xmn,xmx,1e3);
%zw=linspace(zmn,zmx,1e0);
%[xw,yw,zw]=ndgrid(xw,0,zw);
%[~,~,~,xw,yw,~] = cube(al,xw,yw,zw);
%
%xfactor=1/200;
%ufactor=1/3; % tbd
%
%if(al==45)
%	fil=['~/Nek5000/run/wmc/mtlb/profiles/EPA_WindTunnel/EP3C13C.xls'];
%	M=readmatrix(fil);
%	xE1=M(:,1)*xfactor;
%	zE1=M(:,2)*xfactor; % y -> z
%	yE1=M(:,3)*xfactor; % z -> y
%	uE1=M(:,4)*ufactor;
%	uuE1=M(:,5)*ufactor;
%	wE1=M(:,6)*ufactor;  % v -> w
%	wwE1=M(:,7)*ufactor; % v -> w
%	vE1=M(:,8)*ufactor;  % w -> v
%	vvE1=M(:,9)*ufactor; % w -> v
%	kE1=0.75*(uuE1.*uuE1+vvE1.*vvE1);
%	
%elseif(al==90)
%	fil=['~/Nek5000/run/wmc/mtlb/profiles/EPA_WindTunnel/EP3C1CT.xls'];
%	M=readmatrix('~/Nek5000/run/wmc/mtlb/profiles/EPA_WindTunnel/EP3C1CT.xls');
%	xE1=M(:,1)*xfactor;
%	yE1=M(:,2)*xfactor; % z -> y
%	zE1=xE1*0;
%	uE1=M(:,3)*ufactor;
%	uuE1=M(:,4)*ufactor;
%	vE1=M(:,5)*ufactor; % w -> v
%	vvE1=M(:,6)*ufactor; % w -> v
%	kE1 = 0.75*(uuE1.*uuE1+vvE1.*vvE1);
%end
%[xE1,yE1,zE1] = insidecube(al,xE1,yE1,zE1);
%profXY2( uN(I1),xN(I1),yN(I1),uE1,xE1,yE1,uscl,'SNY-u','$$v_x$$',al,xw,yw,1);
%profXY2(k1N(I1),xN(I1),yN(I1),kE1,xE1,yE1,kscl,'SNY-k','$$k$$'  ,al,xw,yw,1);
%
%=======================================================
% create CSV file for Patrick
%=======================================================
%
% normalize
%
u1ref=uN(I1ref);
u2ref=uN(I2ref);

 uN= uN/u1ref;
 vN= vN/u1ref;
 wN= wN/u1ref;

uuN=uuN/(u1ref^2);
vvN=vvN/(u1ref^2);
wwN=wwN/(u1ref^2);

%uN(I2)=uN(I2)/u2ref;
%vN(I2)=vN(I2)/u2ref;
%wN(I2)=wN(I2)/u2ref;
%
%uuN(I2)=uuN(I2)/(u2ref^2);
%vvN(I2)=vvN(I2)/(u2ref^2);
%wwN(I2)=wwN(I2)/(u2ref^2);

cHeader={'x','y','z','u','v','w','uu','vv','ww'};
casename=['WMC',num2str(al)];
format long
I1=reshape(I1',[4e3,1]);
A = [ xN(I1), zN(I1), yN(I1)...
    , uN(I1), wN(I1), vN(I1)...
    ,uuN(I1),wwN(I1),vvN(I1)];
T = array2table(A);
T.Properties.VariableNames(1:9)={'x','y','z','u','v','w','uu','vv','ww'}
writetable(T,[casename,'dat1','.csv']);
A = [ xN(I2), zN(I2), yN(I2)...
    , uN(I2), wN(I2), vN(I2)...
    ,uuN(I2),wwN(I2),vvN(I2)];
T = array2table(A);
T.Properties.VariableNames(1:9)={'x','y','z','u','v','w','uu','vv','ww'}
writetable(T,[casename,'dat2','.csv']);
