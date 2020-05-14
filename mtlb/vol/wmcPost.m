%=============================================================
% reading data
%=============================================================
c=['wmc','.his'];

% parse wmc.his to get this data
nx=20;
ny=20;
nz=20;
nl=10;
nv=10;
n2=200;
n = nx*ny*nz + 4*nl*nv + nl*nl + n2*n2;

% parsing logfile
%logfile=textread('logfile','%s','delimiter','\n');
%area=find(~cellfun(@isempty,strfind(logfile,'area:')));
%area=logfile(area(end));
%area=cell2mat(area);
%area=str2num(area(6:end));


dsty=1;
visc=1/3900;

u='vel.dat';
w='wsh.dat';

C=dlmread(c,' ',[1 0 n 2]); % X,Y,Z
U=dlmread(u,'' ,[1 1 n 4]); % vx,vy,vz,pr
W=dlmread(w,'' ,[1 1 n 3]); % Tm,uf,yp

at=dlmread(w,'' ,[1 0 1 0]);
x =C(:,1);
y =C(:,2);
z =C(:,3);

vx=U(:,1);
vy=U(:,2);
vz=U(:,3);
pr=U(:,4);

%Tm=W(:,1);
%uf=W(:,2);
%yp=W(:,3);

%=============================================================
% numbering
%=============================================================
% walls
I0 =           (1:nx*ny*nz); I0 = reshape(I0,[nx,nz]); % volume
I1 = I0(end) + (1:nl*nv);    I1 = reshape(I1,[nl,nv]); % lateral surf
I2 = I1(end) + (1:nl*nv);    I2 = reshape(I2,[nl,nv]);
I3 = I2(end) + (1:nl*nv);    I3 = reshape(I3,[nl,nv]);
I4 = I3(end) + (1:nl*nv);    I4 = reshape(I4,[nl,nv]);
I5 = I4(end) + (1:nl*nl);    I5 = reshape(I5,[nl,nl]); % cube top

wmc_wall(Tm,'$$|\tau|$$',x,y,z,I0,I1,I2,I3,I4,I5);
wmc_wall(uf,'$$u_f$$'   ,x,y,z,I0,I1,I2,I3,I4,I5);
wmc_wall(yp,'$$y^+$$'   ,x,y,z,I0,I1,I2,I3,I4,I5);

%=============================================================
% horizontal surface
%=============================================================
%I6 = I5(end) + (1:n2*n2); I6 = reshape(I6,[n2,n2]); % horizontal surface
%
%figure; fig=gcf;ax=gca;
%surf(x(I6),z(I6),vx(I6)); colorbar; view(2); shading interp
%title(['u'],'fontsize',14); xlabel('x'); ylabel('z');
%hcb=colorbar; title(hcb,'$$u$$','interpreter','latex','fontsize',14);
%figname=['u'];
%saveas(fig,figname,'jpeg');

