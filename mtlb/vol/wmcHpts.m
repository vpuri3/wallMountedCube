%
% history points for Wall-Mounted Cube
%

clear;

%-----------------------------------------------------%
al = '90';
al = '45';

casename = 'wmc';

%-----------------------------------------------------%
x = [];
y = [];
z = [];

% volume
xmn = -5; xmx = 5; nx = 51; % n* odd
ymn =  0; ymx = 2; ny = 21;
zmn = -2; zmx = 2; nz = 41;

x0 = linspace(xmn,xmx,nx);
y0 = linspace(ymn,ymx,ny);
z0 = linspace(zmn,zmx,nz);
[x0,y0,z0] = ndgrid(x0,y0,z0);

x = [x;reshape(x0,[nx*ny*nz,1])];
y = [y;reshape(x0,[nx*ny*nz,1])];
z = [z;reshape(z0,[nx*ny*nz,1])];

% cube sides
nl = 50; % lateral  (xz)
nv = 50; % vertical (y )

ys = linspace(0   ,1  ,nv);
zs = linspace(-0.5,0.5,nl);
[zs,ys] = ndgrid(zs,ys);

xs = 0.5+0*reshape(ys,[nl*nv,1]);
ys =       reshape(ys,[nl*nv,1]);
zs =       reshape(zs,[nl*nv,1]);

xx = [xs];
yy = [ys];
zz = [zs];

for i=1:3
	r=i*pi/2;
	M=[cos(r),-sin(r);sin(r),cos(r)];
	xz=[xs,zs]*M';
	xx=[xx;xz(:,1)];
	yy=[yy;ys];
	zz=[zz;xz(:,2)];
end

% cube top
x5 = linspace(-0.5,0.5,nl);
z5 = linspace(-0.5,0.5,nl);
[x5,z5] = meshgrid(x5,z5);

xx = [xx;    reshape(x5,[nl*nl,1])];
yy = [yy;1+0*reshape(x5,[nl*nl,1])];
zz = [zz;    reshape(z5,[nl*nl,1])];

if(al=='45')
	a=pi/4;
	M=[cos(a),-sin(a);sin(a),cos(a)];
	xz=[xx,zz]*M';
	xx=xz(:,1);
	yy=yy;
	zz=xz(:,2);
end

x = [x;xx];
y = [y;yy];
z = [z;zz];

%-----------------------------------------------------%
% create file casename.his
format long
A = [x,y,z];
n = nx*ny*nz + 4*nl*nv + nl*nl;
casename=[casename,'.his'];
fID = fopen(casename,'w');
fprintf(fID, [num2str(n)...
             ,' !=',num2str(nx),'x',num2str(ny),'x',num2str(nz)...
             ,'+4x',num2str(nl),'x',num2str(nv)...
             ,'+'  ,num2str(nl),'x',num2str(nl)...
                      ,' monitoring points\n']);
dlmwrite(casename,A,'delimiter',' ','-append');
type(casename)
%-----------------------------------------------------%
%scatter3(x,y,z);
%xlabel('x');
%ylabel('y');
%zlabel('z');
%daspect([1 1 1]);
