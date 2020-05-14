%=============================================================
function wmcPost(al,Re)

dsty=1;
visc=1/Re;

%=============================================================
% reading data


C=dlmread('wmc.his',' ',[1 0 n 2]); % X,Y,Z
U=dlmread('ave.dat','' ,[1 1 n 4]); % vx,vy,vz,pr
W=dlmread('wsh.dat','' ,[1 1 n 2]); % Tm,uf

tk=dlmread('var.dat','',[N0 1 N1 3]); % < u' * u' >
cn=dlmread('cn1.dat','',[N0 1 N1 3]); % convective term
pr=dlmread('pr1.dat','',[N0 1 N1 3]); % production
pt=dlmread('pt1.dat','',[N0 1 N1 3]); % pressure transport
pd=dlmread('pd1.dat','',[N0 1 N1 3]); % pressure diffusion
ps=dlmread('ps1.dat','',[N0 1 N1 3]); % pressure strain
td=dlmread('td1.dat','',[N0 1 N1 3]); % turbulent diffusion
ep=dlmread('ep1.dat','',[N0 1 N1 3]); % dissipation
vd=dlmread('vd1.dat','',[N0 1 N1 3]); % viscous diffusion

im = - cn + pr + pt + td + ep + vd;

%=============================================================
% parse logfile
%logfile=textread('logfile','%s','delimiter','\n');
%area=find(~cellfun(@isempty,strfind(logfile,'area:')));
%area=logfile(area(end));
%area=cell2mat(area);
%area=str2num(area(6:end));
%['area=' ,num2str(area) ];
%=============================================================

time = dlmread(W,'' ,[1 0 1 0]);

x=C(:,1);
y=C(:,2);
z=C(:,3);
u=U(:,1);
v=U(:,2);
w=U(:,3);
p=U(:,4);

Tm=W(:,1);
uf=W(:,2);

cnK = 0.5 * sum(cn')';
prK = 0.5 * sum(pr')';
ptK = 0.5 * sum(pt')';
pdK = 0.5 * sum(pd')';
psK = 0.5 * sum(ps')';
tdK = 0.5 * sum(td')';
epK = 0.5 * sum(ep')';
vdK = 0.5 * sum(vd')';
tkK = 0.5 * sum(tk')';
imK = 0.5 * sum(im')';

%=============================================================
% numbering

nx=20; % parse wmc.his
ny=20;
nz=20;
nl=10;
nv=10;
n = nx*ny*nz + 4*nl*nv + nl*nl;

I0 =           (1:nx*ny*nz); I0 = reshape(I0,[nx,nz]); % volume
I1 = I0(end) + (1:nl*nv);    I1 = reshape(I1,[nl,nv]); % lateral surf
I2 = I1(end) + (1:nl*nv);    I2 = reshape(I2,[nl,nv]);
I3 = I2(end) + (1:nl*nv);    I3 = reshape(I3,[nl,nv]);
I4 = I3(end) + (1:nl*nv);    I4 = reshape(I4,[nl,nv]);
I5 = I4(end) + (1:nl*nl);    I5 = reshape(I5,[nl,nl]); % cube top

%=============================================================
% cube surfaces

wmc_wall(Tm,'$$|\tau|$$',x,y,z,I0,I1,I2,I3,I4,I5);
wmc_wall(uf,'$$u_f$$'   ,x,y,z,I0,I1,I2,I3,I4,I5);

%=============================================================
% discard surface data - reshape to volume

x  =reshape(x  (I0),[nx,ny,nz]);
y  =reshape(y  (I0),[nx,ny,nz]);
z  =reshape(z  (I0),[nx,ny,nz]);
u  =reshape(u  (I0),[nx,ny,nz]);
v  =reshape(v  (I0),[nx,ny,nz]);
w  =reshape(w  (I0),[nx,ny,nz]);
p  =reshape(p  (I0),[nx,ny,nz]);

cn =reshape(cn (I0),[nx,ny,nz,3]);
pr =reshape(pr (I0),[nx,ny,nz,3]);
pt =reshape(pt (I0),[nx,ny,nz,3]);
pd =reshape(pd (I0),[nx,ny,nz,3]);
ps =reshape(ps (I0),[nx,ny,nz,3]);
td =reshape(td (I0),[nx,ny,nz,3]);
ep =reshape(ep (I0),[nx,ny,nz,3]);
vd =reshape(vd (I0),[nx,ny,nz,3]);
tk =reshape(tk (I0),[nx,ny,nz,3]);
im =reshape(im (I0),[nx,ny,nz,3]);

cnK=reshape(cnK(I0),[nx,ny,nz]);
prK=reshape(prK(I0),[nx,ny,nz]);
ptK=reshape(ptK(I0),[nx,ny,nz]);
pdK=reshape(pdK(I0),[nx,ny,nz]);
psK=reshape(psK(I0),[nx,ny,nz]);
tdK=reshape(tdK(I0),[nx,ny,nz]);
epK=reshape(epK(I0),[nx,ny,nz]);
vdK=reshape(vdK(I0),[nx,ny,nz]);
tkK=reshape(tkK(I0),[nx,ny,nz]);
imK=reshape(imK(I0),[nx,ny,nz]);

%=============================================================
% geometry



%=============================================================
% profile plots along centerline




