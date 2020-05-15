%
%
%
function [x,y,z,xw,yw,zw] = cube(al,x,y,z)

% testing
%x=linspace(-2,2,100);
%y=linspace( 0,2,100);
%[x,y,z]=ndgrid(x,y,x);al=45;

[nx,ny,nz]=size(x);
xw=x(:,1,:);xw=reshape(xw,[nx,nz]);
zw=z(:,1,:);zw=reshape(zw,[nx,nz]);

a=al*pi/180;
M=[cos(a),-sin(a);sin(a),cos(a)];

xx=reshape(xw,[nx*nz,1]);
zz=reshape(zw,[nx*nz,1]);
xz=[xx,zz]*M';
xx=xz(:,1);xx=reshape(xx,[nx,nz]);
zz=xz(:,2);zz=reshape(zz,[nx,nz]);

Ix = abs(xx) < 0.50;
Iz = abs(zz) < 0.50;

yw = min(Ix,Iz);
clf;mesh(xw,zw,yw);

H=max(max(max(y)));
yy=reshape(yw,[nx,1,nz]);
y=(1-yy/H).*y+yy;

%yy=y(:,100,:);yy=reshape(yy,[nx,nz]);
%mesh(xw,zw,yy);

