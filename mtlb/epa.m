%
% Nek
% 	U = 1 (at cube height)
%   L = 1 (cube height)
% \nu = 40e3

% EPA (Snyder, 1984)
%	U ~ 3.0-3.2
%   L = 0.2
% \nu = 1.48-1.57 e-5 (15*C, 25*C)

%-------------------------------------------------------
clear;

%-------------------------------------------------------
% geometry
xmn=-4; xmx=8;
zmn=-0; zmx=0;
xw=linspace(xmn,xmx,1e3);
zw=linspace(zmn,zmx,1e0);
[xw,yw,zw]=ndgrid(xw,0,zw);
[~,~,~,xw,yw,zw] = cube(90,xw,yw,zw);

%-------------------------------------------------------
% Snyder WMC 90
%
% Dir Streamwise/Normal/Spanwise - X,U/Z,W/Y,V
%-------------------------------------------------------

xfactor=1/200;
ufactor=1/1; % tbd

nx=21;ny=15;
% along vert. centerplane
% columns: x,z,u,u',w,w',TKE,TKE/UBARSQ,sqrt(H)
% units: length (mm), vel (m/s)
M=readmatrix('EPA_WindTunnel/EP3C1CT.xls');
M=reshape(M,[nx,ny,9]);
xEPA90=M(:,:,1)*xfactor;
zEPA90=M(:,:,2)*xfactor;
uEPA90=M(:,:,3)*ufactor;
upEPA90=M(:,:,4)*ufactor;
wEPA90=M(:,:,5)*ufactor;
wpEPA90=M(:,:,6)*ufactor;
tkEPA90=M(:,:,7)*ufactor;
tk1EPA90=M(:,:,8)*ufactor;
sqrtHEPA90=M(:,:,9)*ufactor;

%qty=tkEPA90 - 0.5*(upEPA90.^2 + wpEPA90.^2);
%qty=tk1EPA90 ./ tkEPA90;
%qty=sqrtHEPA90;
%clf;surf(xEPA90,zEPA90,qty);view(2);colorbar;xlabel('x');

I0=1:nx*ny;I0=reshape(I0,[nx,ny,1]);
profXY(uEPA90,1,1,0.1,'u','$$v_x$$',90,xw,yw,xEPA90,zEPA90,I0);

%-------------------------------------------------------
% Nek WMC 90
%
% Dir Streamwise/Normal/Spanwise - X,U/Y,V/Z,W
%-------------------------------------------------------
