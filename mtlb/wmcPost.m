%

%=============================================================
function wmcPost(al,Re)
%=============================================================
format compact; format shorte;

dsty=1;
visc=1/Re;

%=============================================================
% numbering

nx=51; % parse wmc.his
ny=100;
nz=11;
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

time = dlmread('wsh.dat','',[1 0 1 0]);

C=dlmread('wmc.his',' ',[1 0 n 2]); % X,Y,Z
U=dlmread('ave.dat','' ,[1 1 n 4]); % vx,vy,vz,pr
W=dlmread('wsh.dat','' ,[1 1 n 5]); % Tm,uf,Tx,Tu.Tz

cv=dlmread('cov.dat','',[1 1 n 3]); % uv, vw, wu
tk=dlmread('var.dat','',[1 1 n 3]); % < u' * u' >

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
% cube surfaces

%wmc_wall(Tm,'$$|\tau|$$',x,y,z,II,I1,I2,I3,I4,I5);
%wmc_wall(uf,'$$u_f$$'   ,x,y,z,II,I1,I2,I3,I4,I5);

%=============================================================
% geometry
xmn=min(min(min(x))); xmx=max(max(max(x)));
zmn=min(min(min(z))); zmx=max(max(max(z)));
xw=linspace(xmn,xmx,999);
zw=linspace(zmn,zmx,999);
[xw,yw,zw]=ndgrid(xw,0,zw);
[~,~,~,xw,yw,zw] = cube(al,xw,yw,zw);

%=============================================================
% profile

iz = 0.5 * (nz+1); izw= 0.5 * (999+1); % centerline
iy = 0.5 * (ny+1);

vmg = sqrt(u.^2+v.^2+w.^2);

profXY(u  ,iz,izw,0.5,'u'  ,'$$v_x$$',xw,yw,x,y,I0)
profXY(tkK,iz,izw,1.0,'tkK','$$k$$'  ,xw,yw,x,y,I0)
