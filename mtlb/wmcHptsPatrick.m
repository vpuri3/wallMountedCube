%
% history points for Wall-Mounted Cube
%

function wmcHptsEPA(al)

%-----------------------------------------------------%
casename = 'wmc';

%-----------------------------------------------------%
x = [];
y = [];
z = [];

% centerline
x0=[-4;3;6;8];
y0=linspace(0.0,3.0,1e3);
z0=[0];
nx1=length(x0);
ny1=length(y0);
nz1=1;
[x0,y0,z0] = ndgrid(x0,y0,z0);
x = [x;reshape(x0,[nx1*ny1*nz1,1])];
y = [y;reshape(y0,[nx1*ny1*nz1,1])];
z = [z;reshape(z0,[nx1*ny1*nz1,1])];

% transect
x0=linspace(-4,20,1e3);
if    (al==45) y0=[1.5];
elseif(al==90) y0=[1.6];
end
z0=[0.0];
nx2=length(x0);
ny2=1;
nz2=length(z0);
[x0,y0,z0] = ndgrid(x0,y0,z0);
x = [x;reshape(x0,[nx2*ny2*nz2,1])];
y = [y;reshape(y0,[nx2*ny2*nz2,1])];
z = [z;reshape(z0,[nx2*ny2*nz2,1])];

%-----------------------------------------------------%
clf
scatter3(x,y,z);
xlabel('x');
ylabel('y');
zlabel('z');
daspect([1 1 1]);
%-----------------------------------------------------%
% create file casename.his
format long
A = [x,y,z];
n = nx1*ny1*nz1 + nx2*ny2*nz2;
casename=[casename,'.his'];
fID = fopen(casename,'w');
fprintf(fID, [num2str(n)...
             ,' !=',num2str(nx1),'x',num2str(ny1),'x',num2str(nz1)...
             ,'+'  ,num2str(nx2),'x',num2str(ny2),'x',num2str(nz2)...
             ,' monitoring points for WMC@',num2str(al),'\n']);
dlmwrite(casename,A,'delimiter',' ','-append');
type(casename)
%-----------------------------------------------------%
