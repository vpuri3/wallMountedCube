%
%=============================================================
function wmcPost(al)
%=============================================================
format compact; format shorte;

dsty=1;
%visc=1/Re;

%=============================================================
% numbering

nx=201; % parse wmc.his
ny=21;
nz=21;
nl=50;
nv=50;
n = nx*ny*nz + 4*nl*nv + nl*nl;

I0 =           (1:nx*ny*nz); I0 = reshape(I0,[nx,ny,nz]); % volume
I1 = I0(end) + (1:nl*nv);    I1 = reshape(I1,[nl,nv]);    % lateral surf
I2 = I1(end) + (1:nl*nv);    I2 = reshape(I2,[nl,nv]);
I3 = I2(end) + (1:nl*nv);    I3 = reshape(I3,[nl,nv]);
I4 = I3(end) + (1:nl*nv);    I4 = reshape(I4,[nl,nv]);
I5 = I4(end) + (1:nl*nl);    I5 = reshape(I5,[nl,nl]);    % cube top

II = I0(:,1,:);              II = reshape(II,[nx,nz]);    % ground

%=============================================================
% reading data
dir=['wmc',num2str(al),'snyder/'];

time=dlmread([dir,'wsh.dat'],'' ,[1 0 1 0]);
C   =dlmread([dir,'wmc.his'],' ',[1 0 n 2]); % X,Y,Z
U   =dlmread([dir,'ave.dat'],'' ,[1 1 n 4]); % vx,vy,vz,pr
W   =dlmread([dir,'wsh.dat'],'' ,[1 1 n 5]); % Tm,uf,Tx,Tu.Tz
cv  =dlmread([dir,'cov.dat'],'',[1 1 n 3]); % uv, vw, wu
tk  =dlmread([dir,'var.dat'],'',[1 1 n 3]); % < u' * u' >

%cn=dlmread('cn1.dat','',[1 1 n 3]); % convective term
%pr=dlmread('pr1.dat','',[1 1 n 3]); % production
%pt=dlmread('pt1.dat','',[1 1 n 3]); % pressure transport
%pd=dlmread('pd1.dat','',[1 1 n 3]); % pressure diffusion
%ps=dlmread('ps1.dat','',[1 1 n 3]); % pressure strain
%td=dlmread('td1.dat','',[1 1 n 3]); % turbulent diffusion
%ep=dlmread('ep1.dat','',[1 1 n 3]); % dissipation
%vd=dlmread('vd1.dat','',[1 1 n 3]); % viscous diffusion
%
%im = - cn + pr + pt + td + ep + vd;

%=============================================================
% parse logfile
%logfile=textread('logfile','%s','delimiter','\n');
%area=find(~cellfun(@isempty,strfind(logfile,'area:')));
%area=logfile(area(end));
%area=cell2mat(area);
%area=str2num(area(6:end));
%['area=' ,num2str(area) ];
%=============================================================

Re = 40e3;
visc = 1/Re;

x=C(:,1);
y=C(:,2);
z=C(:,3);

u=U(:,1);
v=U(:,2);
w=U(:,3);
p=U(:,4);

Tm=W(:,1);
uf=W(:,2);
Tx=W(:,3);
Ty=W(:,4);
Tz=W(:,5);

yp = 1 ./ (visc ./ uf);
yp(yp<1e-9)=NaN;yp=log(yp)/log(10);

tkK = 0.5 * sum(tk')';

%cnK = 0.5 * sum(cn')';
%prK = 0.5 * sum(pr')';
%ptK = 0.5 * sum(pt')';
%pdK = 0.5 * sum(pd')';
%psK = 0.5 * sum(ps')';
%tdK = 0.5 * sum(td')';
%epK = 0.5 * sum(ep')';
%vdK = 0.5 * sum(vd')';
%imK = 0.5 * sum(im')';

%=============================================================
% transects
xx=x(I0);
yy=y(I0);
zz=z(I0);
uu=u(I0);
kk=tkK(I0);

uin = (yy/1.0).^0.16;

udef = (uu-uin) ./ uin;

iz=(nz+1)/2;
iy=(13:2:21)';

figure; fig=gcf;ax=gca; hold on;grid on;
ax.XScale='linear';
ax.YScale='linear';
xlabel(['$$x/h$$']);
ylabel('$$v_x/v_x(y)$$');

%daspect([2,100,1]);
set(fig,'position',[585,1e3,1200,300])
xlim([-1,10]);
ll='rgbck';
for i=1:1:size(iy,1)
	p=plot(xx(:,iy(i),iz),udef(:,iy(i),iz),ll(i),'linewidth',2.0);
	p.DisplayName=['$$y=$$',num2str(yy(1,iy(i),iz)),'$$h$$'];
end
lgd=legend('location','southeast');lgd.FontSize=14;

%------------------------------
figname=['WMC',num2str(al),'-utrans'];
exportgraphics(fig,[figname,'.png'],'resolution',300);
%saveas(fig,figname,'jpeg');
%------------------------------

%=============================================================
% cube surfaces

%wmcWall(Tm,'$$|\tau|$$',x,y,z,II,I1,I2,I3,I4,I5);
%wmcWall(uf,'$$u_f$$'   ,x,y,z,II,I1,I2,I3,I4,I5);
%wmcWall(yp,'$$y^+$$'   ,x,y,z,II,I1,I2,I3,I4,I5);

%=============================================================
% geometry
%xmn=min(min(min(x))); xmx=max(max(max(x)));
%zmn=min(min(min(z))); zmx=max(max(max(z)));
%xw=linspace(xmn,xmx,1e3);
%zw=linspace(zmn,zmx,1e3);
%[xw,yw,zw]=ndgrid(xw,0,zw);
%[~,~,~,xw,yw,zw] = cube(al,xw,yw,zw);

%=============================================================
% profile

%iz = 0.5 * (nz+1); izw= 0.5 * (999+1); % centerline
%iy = 0.5 * (ny+1);
%
%vmg = sqrt(u.^2+v.^2+w.^2);

%profXY(u  ,iz,izw,0.2,'u'  ,'$$v_x$$',al,xw,yw,x,y,I0)
%profXY(tkK,iz,izw,1.0,'tkK','$$k$$'  ,al,xw,yw,x,y,I0)



%=============================================================
% streamlines plots
% overlay profiles from different x-locations
% find location of stagnation point, reattchment point
%=============================================================


