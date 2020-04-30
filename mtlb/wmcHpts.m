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

% bed - surface 0
xmn = -5; xmx = 5; nx = 20;
zmn = -5; zmx = 5; nz = 20;

x0 = linspace(xmn,xmx,nx);
z0 = linspace(zmn,zmx,nz);
[x0,z0] = meshgrid(x0,z0);

x = [x;  reshape(x0,[nx*nz,1])];
y = [y;0*reshape(x0,[nx*nz,1])];
z = [z;  reshape(z0,[nx*nz,1])];

% cube sides
nl = 10; % lateral  (x,z)
nv = 10; % vertical (y)

ys = linspace(0   ,1  ,nv);
zs = linspace(-0.5,0.5,nl);
[ys,zs] = meshgrid(ys,zs);

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

% horizontal surface y = 0.3
xmn = -2; xmx = 2; n2 = 200;
zmn = -2; zmx = 2; n2 = 200;

x0 = linspace(xmn,xmx,n2);
z0 = linspace(zmn,zmx,n2);
[x0,z0] = meshgrid(x0,z0);

x = [x;      reshape(x0,[n2*n2,1])];
y = [y;0.3+0*reshape(x0,[n2*n2,1])];
z = [z;      reshape(z0,[n2*n2,1])];

%-----------------------------------------------------%
% create file casename.his
format long
A = [x,y,z];
n = nx*nz + 4*nl*nv + nl*nl + n2*n2;
casename=[casename,'.his'];
fID = fopen(casename,'w');
fprintf(fID, [num2str(n) ' !=',num2str(nx),'x',num2str(nz)...
                           'x',num2str(nl),'x',num2str(nv)...
                                 ,' monitoring points\n']);
dlmwrite(casename,A,'delimiter',' ','-append');
type(casename)
%-----------------------------------------------------%
scatter3(x,y,z);
xlabel('x');
ylabel('y');
zlabel('z');
daspect([1 1 1]);
