%
% history points for Wall-Mounted Cube
%

clear;
casename='wmc';
%-----------------------------------------------------%
y = linspace(0,2,21)';
x = linspace(-5,20,1e3)';
%-----------------------------------------------------%
[x,y] = ndgrid(x,y);

x=reshape(x,[21*1e3,1]);
y=reshape(y,[21*1e3,1]);

z = 0*x;

%-----------------------------------------------------%
% create file casename.his
format long
A = [x,y,z];
n = length(x);
casename=[casename,'.his'];
fID = fopen(casename,'w');
fprintf(fID, [num2str(n) ' ! ',num2str(n),' monitoring points\n']);
dlmwrite(casename,A,'delimiter',' ','-append');
type(casename)
%-----------------------------------------------------%
%scatter3(x,y,z);
%xlabel('x');
%ylabel('y');
%zlabel('z');
%daspect([1 1 1]);
