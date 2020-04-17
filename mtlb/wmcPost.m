%=============================================================
% reading data
%=============================================================
c0=['wmc','.his'];

% parse wmc.his to get this data
nx=20;
nz=20;
nl=10;
nv=10;
n = nx*nz + 4*nl*nv + nl*nl;

% parsing logfile
%logfile=textread('logfile','%s','delimiter','\n');
%area=find(~cellfun(@isempty,strfind(logfile,'area:')));
%area=logfile(area(end));
%area=cell2mat(area);
%area=str2num(area(6:end));


dsty=1;
visc=1/3900;

w0='wsh.dat';

C =dlmread(c0,' ',[1 0 n 2]); % X,Y,Z
U1=dlmread(w0,'' ,[1 1 n 3]); % Tm,uf,yp

at=dlmread(w0,'' ,[1 0 1 0]);
x =C (:,1);
y =C (:,2);
z =C (:,3);
Tm=U1(:,1);
uf=U1(:,2);
yp=U1(:,3);

%------------------------------
I0 =           (1:nx*nz); I0 = reshape(I0,[nx,nz]); % bed (xz plane)
I1 = I0(end) + (1:nl*nv); I1 = reshape(I1,[nl,nv]);
I2 = I1(end) + (1:nl*nv); I2 = reshape(I2,[nl,nv]);
I3 = I2(end) + (1:nl*nv); I3 = reshape(I3,[nl,nv]);
I4 = I3(end) + (1:nl*nv); I4 = reshape(I4,[nl,nv]);
I5 = I4(end) + (1:nl*nl); I5 = reshape(I5,[nl,nl]); % cube top (xz plane)
%------------------------------

%=============================================================
wmc_wall(Tm,'$$|\tau|$$',x,y,z,I0,I1,I2,I3,I4,I5);
wmc_wall(uf,'$$u_f$$'   ,x,y,z,I0,I1,I2,I3,I4,I5);
wmc_wall(yp,'$$y^+$$'   ,x,y,z,I0,I1,I2,I3,I4,I5);
%=============================================================
