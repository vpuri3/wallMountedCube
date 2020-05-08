%=============================================================
% reading data
%=============================================================
c='wmc.his';
u='vel.dat';

% parse wmc.his to get this data
nx=1e3;
ny=21;
nz=1;
n = nx*ny*nz;

% parsing logfile
%logfile=textread('logfile','%s','delimiter','\n');
%area=find(~cellfun(@isempty,strfind(logfile,'area:')));
%area=logfile(area(end));
%area=cell2mat(area);
%area=str2num(area(6:end));


dsty=1;
visc=1/3900;

w='wsh.dat';

C=dlmread(c,' ',[1 0 n 2]); % X,Y,Z
U=dlmread(u,'' ,[1 1 n 4]); % vx,vy,vz,pr

at=dlmread(u,'' ,[1 0 1 0]);

x =C(:,1);
y =C(:,2);
z =C(:,3);

vx=U(:,1);
vy=U(:,2);
vz=U(:,3);
pr=U(:,4);

x = reshape(x,[nx,ny]);
y = reshape(y,[nx,ny]);

vx= reshape(vx,[nx,ny]);
vy= reshape(vy,[nx,ny]);
vz= reshape(vz,[nx,ny]);
pr= reshape(pr,[nx,ny]);

%=============================================================
%figure; fig=gcf;ax=gca;
%plot(x(:,4),vx(:,4));
%=============================================================
figure; fig=gcf;ax=gca;
surf(x,y,vx); colorbar; view(2); shading interp
title(['$$v_x$$'],'fontsize',14); xlabel('x'); ylabel('y');
hcb=colorbar; title(hcb,'$$v_x$$','interpreter','latex','fontsize',14);
figname=['u'];
saveas(fig,figname,'jpeg');

