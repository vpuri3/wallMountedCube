%
% history points for Wall-Mounted Cube
%

function wmcHptsEPA(al)

%-----------------------------------------------------%
x = [];
y = [];
z = [];

if(al==90)
	% centerline vertical profiles
	x0=[-800;-600;-400;-300;-200;-150;-120;-100;-40;0;...
	      40;100;120;150;200;300;400;600;800;1200;1600]/200;
	y0=linspace(0,2.5,1e3);
	z0=[0];
	nx1=length(x0);
	ny1=length(y0);
	nz1=length(z0);
	[x0,y0,z0] = ndgrid(x0,y0,z0);
	x = [x;reshape(x0,[nx1*ny1*nz1,1])];
	y = [y;reshape(y0,[nx1*ny1*nz1,1])];
	z = [z;reshape(z0,[nx1*ny1*nz1,1])];
	
	% ground
	x0=[-800;-600;-400;-300;-200;-120;-60;0;...
	      60;120;200;300;400;600;800;1200;1600]/200;
	y0=[0.1];
	z0=linspace(-2.5,2.5,1e3);
	nx2=length(x0);
	ny2=length(y0);
	nz2=length(z0);
	[x0,y0,z0] = ndgrid(x0,y0,z0);
	x = [x;reshape(x0,[nx2*ny2*nz2,1])];
	y = [y;reshape(y0,[nx2*ny2*nz2,1])];
	z = [z;reshape(z0,[nx2*ny2*nz2,1])];

	% centerline streamwise transects
	y0=[1.2;1.4;1.6;1.8;2.0];
	x0=linspace(-4,10,1e3);
	z0=[0];
	nx3=length(x0);
	ny3=length(y0);
	nz3=length(z0);
	[x0,y0,z0] = ndgrid(x0,y0,z0);
	x = [x;reshape(x0,[nx3*ny3*nz3,1])];
	y = [y;reshape(y0,[nx3*ny3*nz3,1])];
	z = [z;reshape(z0,[nx3*ny3*nz3,1])];

elseif(al==45)
	% centerline
	x0=[-800;-600;-400;-300;-250;-200;-161;-80;0;...
	      80;161;200;250;300;400;600;800;1200;1600]/200;
	y0=linspace(0,2.5,1e3);
	z0=[0];
	nx1=length(x0);
	ny1=length(y0);
	nz1=length(z0);
	[x0,y0,z0] = ndgrid(x0,y0,z0);
	x = [x;reshape(x0,[nx1*ny1*nz1,1])];
	y = [y;reshape(y0,[nx1*ny1*nz1,1])];
	z = [z;reshape(z0,[nx1*ny1*nz1,1])];
	
	% ground
	x0=[-800;-600;-400;-300;-250;-200;-161;-120;-80;-40;0;...
	      40;80;120;161;200;250;300;400;600;800;1200;1600]/200;
	y0=[0.1];
	z0=linspace(-3.5,3.5,1e3);
	nx2=length(x0);
	ny2=length(y0);
	nz2=length(z0);
	[x0,y0,z0] = ndgrid(x0,y0,z0);
	x = [x;reshape(x0,[nx2*ny2*nz2,1])];
	y = [y;reshape(y0,[nx2*ny2*nz2,1])];
	z = [z;reshape(z0,[nx2*ny2*nz2,1])];

	% centerline streamwise transects
	y0=[1.25;1.50;1.75;2.00];
	x0=linspace(-4,10,1e3);
	z0=[0];
	nx3=length(x0);
	ny3=length(y0);
	nz3=length(z0);
	[x0,y0,z0] = ndgrid(x0,y0,z0);
	x = [x;reshape(x0,[nx3*ny3*nz3,1])];
	y = [y;reshape(y0,[nx3*ny3*nz3,1])];
	z = [z;reshape(z0,[nx3*ny3*nz3,1])];

end

%-----------------------------------------------------%
% scatter plot
%-----------------------------------------------------%
clf
scatter3(x,y,z);
xlabel('x');
ylabel('y');
zlabel('z');
daspect([1 1 1]);

%-----------------------------------------------------%
% create file casename.his
%-----------------------------------------------------%
format long
A = [x,y,z];
n = nx1*ny1*nz1 + nx2*ny2*nz2 + nx3*ny3*nz3;
casename=['wmc','.his'];
fID = fopen(casename,'w');
fprintf(fID, [num2str(n)...
             ,' !=',num2str(nx1),'x',num2str(ny1),'x',num2str(nz1)...
             ,'+'  ,num2str(nx2),'x',num2str(ny2),'x',num2str(nz2)...
             ,'+'  ,num2str(nx3),'x',num2str(ny3),'x',num2str(nz3)...
             ,' monitoring points for WMC@',num2str(al),'\n']);
dlmwrite(casename,A,'delimiter',' ','-append');
type(casename)
%-----------------------------------------------------%
