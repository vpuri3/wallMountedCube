%
%=======================================================
% NEK
% 	U = 1 (at cube height)
%   L = 1 (cube height)
% \nu = 40e3

% Directions: Streamwise/Normal/Spanwise - X,U/Y,V/Z,W

% EPA (Snyder, 1994)
%	U ~ 3.0-3.2
%   L = 0.2
% \nu = 1.48-1.57 e-5 (15*C, 25*C)

% Directions: Streamwise/Normal/Spanwise - X,U/Z,W/Y,V

%-------------------
% Snyder Inflow
%-------------------

%y0=1/200; % roughness length
%uf=0.05;  % friction velocity
%
%uepa = (y/1.0).^0.16;

%=======================================================
function compare(al)
%al=90;

uscl=0.5;
kscl=2.0;

%=======================================================
% NEK
%=======================================================

nx1=4; % centerline
ny1=1e3;
nz1=1;
nx2=1e3; % transect
ny2=1;
nz2=1;

n=nx1*ny1*nz1 + nx2*ny2*nz2;

dir=['./wmc',num2str(al),'snyder/'];
C =dlmread([dir,'wmc.his'],' ',[1 0 n 2]); % X,Y,Z
U =dlmread([dir,'ave.dat'],'' ,[1 1 n 4]); % vx,vy,vz,pr
tk=dlmread([dir,'var.dat'],'' ,[1 1 n 3]); % < u' * u' >

xN=C(:,1);
yN=C(:,2);
zN=C(:,3);
%[xN,yN,zN] = insidecube(al,xN,yN,zN);

uN=U(:,1);
vN=U(:,2);
wN=U(:,3);
pN=U(:,4);

uuN=tk(:,1);
vvN=tk(:,2);
wwN=tk(:,3);
k1N=0.75*(uuN+vvN); % good proxy for TKE
kN = 0.5 * sum(tk')';

I1=         1:nx1*ny1*nz1 ; I1=reshape(I1,[nx1,ny1,nz1]);
I2=I1(end)+(1:nx2*ny2*nz2); I2=reshape(I2,[nx2,ny2,nz2]);
I1ref=I1(1,334);
I2ref=I2(1);

%=======================================================
% EPA
%=======================================================

%----------
% geometry 
%----------
xmn=-4; xmx=10;
zmn=-0; zmx=0;
xw=linspace(xmn,xmx,1e3);
zw=linspace(zmn,zmx,1e0);
[xw,yw,zw]=ndgrid(xw,0,zw);
[~,~,~,xw,yw,~] = cube(al,xw,yw,zw);

%----------
% Snyder
% columns: x,z,u,u',w,w',TKE,TKE/UBARSQ,sqrt(H)
% units: length (mm), vel (m/s)
%----------
xfactor=1/200;
ufactor=1/3; % tbd

if(al==45)
	fil=['~/Nek5000/run/wmc/mtlb/profiles/EPA_WindTunnel/EP3C13C.xls'];
	M=readmatrix(fil);
	xE1=M(:,1)*xfactor;
	zE1=M(:,2)*xfactor; % y -> z
	yE1=M(:,3)*xfactor; % z -> y
	uE1=M(:,4)*ufactor;
	uuE1=M(:,5)*ufactor;
	wE1=M(:,6)*ufactor;  % v -> w
	wwE1=M(:,7)*ufactor; % v -> w
	vE1=M(:,8)*ufactor;  % w -> v
	vvE1=M(:,9)*ufactor; % w -> v
	kE1=0.75*(uuE1.*uuE1+vvE1.*vvE1);
	
elseif(al==90)
	fil=['~/Nek5000/run/wmc/mtlb/profiles/EPA_WindTunnel/EP3C1CT.xls'];
	M=readmatrix('~/Nek5000/run/wmc/mtlb/profiles/EPA_WindTunnel/EP3C1CT.xls');
	xE1=M(:,1)*xfactor;
	yE1=M(:,2)*xfactor; % z -> y
	zE1=xE1*0;
	uE1=M(:,3)*ufactor;
	uuE1=M(:,4)*ufactor;
	vE1=M(:,5)*ufactor; % w -> v
	vvE1=M(:,6)*ufactor; % w -> v
	kE1 = 0.75*(uuE1.*uuE1+vvE1.*vvE1);
end
%[xE1,yE1,zE1] = insidecube(al,xE1,yE1,zE1);

% Reshaping EPA
if(al==45)
	% insert 5x zeros after idx=80, then after idx=90, then after idx=100
	z=zeros(5,1);
	xE1=[xE1(1:80);z;xE1(81:85);z;xE1(86:90);z;xE1(91:end)];
	yE1=[yE1(1:80);z;yE1(81:85);z;yE1(86:90);z;yE1(91:end)];
	uE1=[uE1(1:80);z;uE1(81:85);z;uE1(86:90);z;uE1(91:end)];

	xE1 = reshape(xE1,[10,19]);xE1=xE1';
	yE1 = reshape(yE1,[10,19]);yE1=yE1';
	uE1 = reshape(uE1,[10,19]);uE1=uE1';
elseif(al==90)
	xE1 = reshape(xE1,[21,15]); % [nx,ny]
	yE1 = reshape(yE1,[21,15]);
	uE1 = reshape(uE1,[21,15]);
end

%=======================================================
% Nalu
%=======================================================
if(al==45)
	f1='./nalu/U-profiles_inflow_45dg';
	f2='./nalu/CLx_inflow_45dg_New';
elseif(al==90)
	f1='./nalu/U-profiles_inflow_00dg';
	f2='./nalu/CLx_inflow_00dg_New';
end
M=readmatrix(f1);
xN1=[-4,2.5,5.5,7.5];
yN1=M(:,1);
uN1=M(:,2:5); uN1=uN1/uN1(4,1);
M=readmatrix(f2);
xN2=M(:,1);
uN2=M(:,2); uN2=uN2/uN2(1);
%=======================================================
% QUIC
%=======================================================
load('./QUICprofs/U_3H_45dg.mat');
load('./QUICprofs/U_3H_90dg.mat');
load('./QUICprofs/U_6H_45dg.mat');
load('./QUICprofs/U_6H_90dg.mat');
load('./QUICprofs/U_8H_45dg.mat');
load('./QUICprofs/U_8H_90dg.mat');
load('./QUICprofs/U_CL_1_5H_45dg.mat');
load('./QUICprofs/U_CL_1_6H_90dg.mat');
load('./QUICprofs/U_inflow_45dg.mat');
load('./QUICprofs/U_inflow_90dg.mat');
load('./QUICprofs/x_QUIC.mat');
load('./QUICprofs/z_QUIC.mat');

xQ=x_QUIC;
yQ=z_QUIC;
if(al==45)
	uQ1=[U_inflow_45dg;U_3H_45dg;U_6H_45dg;U_8H_45dg];
	uQ2=U_CL_1_5H_45dg;
elseif(al==90)
	uQ1=[U_inflow_90dg;U_3H_90dg;U_6H_90dg;U_8H_90dg];
	uQ2=U_CL_1_6H_90dg;
end
xxQ=[-4,3,6,8];

uQ1=uQ1 / (0.5*(uQ1(1,21)+uQ1(1,21)));
uQ2=uQ2 / (0.5*(uQ2(110) +uQ2(111) ));

%=======================================================
% vertical profiles
%=======================================================
% normalization
if(al==45)     uE1=uE1 / uE1(1,end-5);
elseif(al==90) uE1=uE1 / uE1(1,end-6);
end
uN =uN  / uN(I1ref);

% profile
nS=size(xE1,1);
SS=[1,nS-3,nS-1,nS];

cc='rgbk';
for i=1:nx1
	figure;fig=gcf;ax=gca; hold on;grid on;
	ax.XScale='linear';  ax.YScale='linear';
	xlabel(['$$v_x$$']); ylabel('$$y$$');
	xlim([0,1.2]);       ylim([0,2.0]);

	p=plot(uN(I1(i,:)),yN(I1(i,:)),['-',cc(1)],'linewidth',2);
	p.DisplayName=['Nek x=',num2str(xN(I1(i,1)))];
	
	p=plot(uE1(SS(i),:),yE1(SS(i),:),['-o',cc(2)],'linewidth',2);
	p.DisplayName=['EPA x=',num2str(xN(I1(i,1)))];

	p=plot(uQ1(i,:),yQ,['-',cc(3)],'linewidth',2);
	p.DisplayName=['QUIC x=',num2str(xxQ(i))];

	p=plot(uN1(:,i),yN1,['-',cc(4)],'linewidth',2);
	p.DisplayName=['Nalu x=',num2str(xN1(i))];

	title(['WMC',num2str(al),' x-velocity at x=',num2str(xxQ(i))]);
	legend('show','location','northwest');
	figname=['WMC',num2str(al),'xvel_x',num2str(i)];
	saveas(fig,figname,'png');
end

% deficit
nS=size(xE1,1);
SS=[1,nS-3,nS-1,nS];

for i=2:nx1
	figure;fig=gcf;ax=gca; hold on;grid on;
	ax.XScale='linear';  ax.YScale='linear';
	xlabel(['$$v_x$$']); ylabel('$$y$$');
	%xlim([0,1.2]);
	ylim([0,2.0]);
	cc='rgbk';

	II =I1(i,:); II0=II(1);
	p=plot(uN(I1(i,:))-uN(I1(1,:)),yN(I1(i,:)),['-',cc(1)],'linewidth',2);
	p.DisplayName=['Nek x=',num2str(xN(I1(i,1)))];
	
	p=plot(uE1(SS(i),:)-uE1(SS(1),:),yE1(SS(i),:),['-o',cc(2)],'linewidth',2);
	p.DisplayName=['EPA x=',num2str(xN(II0))];

	p=plot(uQ1(i,:)-uQ1(1,:),yQ,['-',cc(3)],'linewidth',2);
	p.DisplayName=['QUIC x=',num2str(xxQ(i))];

	p=plot(uN1(:,i)-uN1(:,1),yN1,['-',cc(4)],'linewidth',2);
	p.DisplayName=['Nalu x=',num2str(xN1(i))];

	title(['WMC',num2str(al),' x-velocity deficit at x=',num2str(xxQ(i))]);
	legend('show','location','northwest');
	figname=['WMC',num2str(al),'xvel_deficit_x',num2str(i)];
	saveas(fig,figname,'png');
end
%=======================================================
% streamwise transect
%=======================================================
% normalization
uE1=uE1 / uE1(1,end-2);
uN =uN  / uN (I2ref);

% profile
figure;fig=gcf;ax=gca; hold on;grid on;
ax.XScale='linear';
ax.YScale='linear';
xlabel(['$$x$$']);
ylabel('$$v_x$$');

p=plot(xN(I2),uN(I2),['-',cc(1)],'linewidth',2.0);
p.DisplayName=['Nek, y=',num2str(yN(I2ref))];

p=plot(xE1(:,end-2),uE1(:,end-2),['o',cc(2)],'linewidth',2);
p.DisplayName=['EPA, y=',num2str(yE1(1,end-2))];

p=plot(xQ,uQ2,['-',cc(3)],'linewidth',2);
p.DisplayName=['QUIC'];

p=plot(xN2,uN2,['-',cc(4)],'linewidth',2);
p.DisplayName=['Nalu'];

p=plot(xw,yw*0.02+1,'k-.','linewidth',2);
p.DisplayName=['wall'];
title(['WMC',num2str(al),'streamwise transect x-velocity']);
legend('show');
%
figname=['WMC',num2str(al),'xvel_','streamwise'];
saveas(fig,figname,'png');


% deficit
figure;fig=gcf;ax=gca; hold on;grid on;
ax.XScale='linear';
ax.YScale='linear';
xlabel(['$$x$$']);
ylabel('$$v_x$$');

p=plot(xN(I2),uN(I2)-1,['-',cc(1)],'linewidth',2.0);
p.DisplayName=['Nek, y=',num2str(yN(I2ref))];

p=plot(xE1(:,end-2),uE1(:,end-2)-1,['o',cc(2)],'linewidth',2);
p.DisplayName=['EPA, y=',num2str(yE1(1,end-2))];

p=plot(xQ,uQ2-1,['-',cc(3)],'linewidth',2);
p.DisplayName=['QUIC'];

p=plot(xN2,uN2-1,['-',cc(4)],'linewidth',2);
p.DisplayName=['Nalu'];

p=plot(xw,yw*0.02,'k-.','linewidth',2);
p.DisplayName=['wall'];
title(['WMC',num2str(al),'streamwise transect x-velocity deficit']);
legend('show');
%
figname=['WMC',num2str(al),'xvel_deficit_','streamwise'];
saveas(fig,figname,'png');
%=======================================================
