%
%=======================================================
% NEK:
% 	U = 1 (at cube height)
%   L = 1 (cube height)
% \nu = 40e3

% Directions: Streamwise/Normal/Spanwise - X,U/Y,V/Z,W

% EPA (Snyder, 1994):
%	U ~ 3.0-3.2
%   L = 0.2
% \nu = 1.48-1.57 e-5 (15*C, 25*C)

% Directions: Streamwise/Normal/Spanwise - X,U/Z,W/Y,V

%=======================================================
clear;
al=45;

uscl=0.5;
kscl=2.0;

nx1=19; % centerline
ny1=1e3;
nz1=1;
nx2=23; % horizontal
ny2=1;
nz2=1e3;
nx3=1e3;
ny3=4;
nz3=1;

n=nx1*ny1*nz1 + nx2*ny2*nz2 + nx3*ny3*nz3;

%=======================================================
% Nek
%=======================================================

C   =dlmread('./wmc45snyder/wmc.his',' ',[1 0 n 2]); % X,Y,Z
time=dlmread('./wmc45snyder/ave.dat','' ,[1 0 1 0]);
U   =dlmread('./wmc45snyder/ave.dat','' ,[1 1 n 4]); % vx,vy,vz,pr
tk  =dlmread('./wmc45snyder/var.dat','' ,[1 1 n 3]); % < u' * u' >

xN=C(:,1);
yN=C(:,2);
zN=C(:,3);
[xN,yN,zN] = insidecube(al,xN,yN,zN);

uN=U(:,1);
vN=U(:,2);
wN=U(:,3);
pN=U(:,4);

uuN=tk(:,1);
vvN=tk(:,2);
wwN=tk(:,3);

I1=         1:nx1*ny1*nz1 ; I1=reshape(I1,[nx1,ny1,nz1]);
I2=I1(end)+(1:nx2*ny2*nz2); I2=reshape(I2,[nx2,ny2,nz2]);
I3=I2(end)+(1:nx3*ny3*nz3); I3=reshape(I3,[nx3,ny3,nz3]);

% normalization
I1ref=I1(1,401); u1ref=uN(I1ref); % profiles (centerline and ground)
I3ref=I3(1,:);   u3ref=uN(I3ref)'; % transects

uN(I1)=uN(I1)/u1ref; uuN(I1)=uuN(I1)/(u1ref^2);
vN(I1)=vN(I1)/u1ref; vvN(I1)=vvN(I1)/(u1ref^2);
wN(I1)=wN(I1)/u1ref; wwN(I1)=wwN(I1)/(u1ref^2);

uN(I2)=uN(I2)/u1ref; uuN(I2)=uuN(I2)/(u1ref^2);
vN(I2)=vN(I2)/u1ref; vvN(I2)=vvN(I2)/(u1ref^2);
wN(I2)=wN(I2)/u1ref; wwN(I2)=wwN(I2)/(u1ref^2);

uN(I3)=uN(I3)./u1ref; uuN(I3)=uuN(I3)./(u1ref.^2);
vN(I3)=vN(I3)./u1ref; vvN(I3)=vvN(I3)./(u1ref.^2);
wN(I3)=wN(I3)./u1ref; wwN(I3)=wwN(I3)./(u1ref.^2);

% TKE
k1N=0.75*(uuN+vvN); % good proxy for TKE
kN = 0.5 * sum(tk')';
%=======================================================
% vertical centerline plane
%=======================================================

%----------
% geometry 
%----------
xmn=-5; xmx=9;
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

M=readmatrix('~/Nek5000/run/wmc/mtlb/profiles/EPA_WindTunnel/EP3C13C.xls');
xE1=M(:,1)*xfactor;
zE1=M(:,2)*xfactor; % y -> z
yE1=M(:,3)*xfactor; % z -> y
uE1=M(:,4);

ufactor=1/uE1(5);

uE1=uE1*ufactor;
uuE1=M(:,5)*ufactor;
wE1=M(:,6)*ufactor;  % v -> w
wwE1=M(:,7)*ufactor; % v -> w
vE1=M(:,8)*ufactor;  % w -> v
vvE1=M(:,9)*ufactor; % w -> v
kE1=0.75*(uuE1.*uuE1+vvE1.*vvE1);

[xE1,yE1,zE1] = insidecube(al,xE1,yE1,zE1);
%----------
% figs
%----------
profXY2( uN(I1),xN(I1),yN(I1),uE1,xE1,yE1,uscl,'SNY-u','$$v_x$$',al,xw,yw,1);
profXY2(k1N(I1),xN(I1),yN(I1),kE1,xE1,yE1,kscl,'SNY-k','$$k$$'  ,al,xw,yw,1);
%
%=======================================================
% horizontal ground plane
%=======================================================

%----------
% geometry
%----------
xx=linspace(-0.5,0.5,1e2)';
xw=[xx      ;0*xx+0.5;flip(xx);0*xx-0.5];
zw=[0*xx-0.5;xx      ;0*xx+0.5;flip(xx)];
a=al*pi/180;
M=[cos(a),-sin(a);sin(a),cos(a)];
xz=[xw,zw]*M';
xw=xz(:,1);
zw=xz(:,2);

%----------
% Snyder
% columns: x,z,u,u',w,w',TKE,TKE/UBARSQ,sqrt(H)
% units: length (mm), vel (m/s)
%----------
xfactor=1/200;

M=readmatrix('~/Nek5000/run/wmc/mtlb/profiles/EPA_WindTunnel/EP3C13GF.xls');
xE2=M(:,1)*xfactor;
zE2=M(:,2)*xfactor; % y -> z
uE2=M(:,3)*ufactor;
uuE2=M(:,4)*ufactor;
wE2=M(:,7)*ufactor;  % v -> w
wwE2=M(:,8)*ufactor; % v -> w
kE2=0.75*(uuE2.*uuE2+wwE2.*wwE2);

yE2=xE2*0+0.1;

[xE2,yE2,zE2] = insidecube(al,xE2,yE2,zE2);
%----------
% figs
%----------
profXZ2(uN(I2) ,xN(I2),zN(I2),uE2,xE2,zE2,uscl,'SNY-u','$$v_x$$',al,xw,zw,0.1,1);
profXZ2(k1N(I2),xN(I2),zN(I2),kE2,xE2,zE2,kscl,'SNY-k','$$k$$'  ,al,xw,zw,0.1,1);

%=======================================================
% streamline transects
%=======================================================
% reshaping EPA centerline data
z=zeros(5,1);
xE1=[xE1(1:80);z;xE1(81:85);z;xE1(86:90);z;xE1(91:end)];
yE1=[yE1(1:80);z;yE1(81:85);z;yE1(86:90);z;yE1(91:end)];
zE1=[zE1(1:80);z;zE1(81:85);z;zE1(86:90);z;zE1(91:end)];

uE1=[uE1(1:80);z;uE1(81:85);z;uE1(86:90);z;uE1(91:end)];
vE1=[vE1(1:80);z;vE1(81:85);z;vE1(86:90);z;vE1(91:end)];
wE1=[wE1(1:80);z;wE1(81:85);z;wE1(86:90);z;wE1(91:end)];

uuE1=[uuE1(1:80);z;uuE1(81:85);z;uuE1(86:90);z;uuE1(91:end)];
vvE1=[vvE1(1:80);z;vvE1(81:85);z;vvE1(86:90);z;vvE1(91:end)];
wwE1=[wwE1(1:80);z;wwE1(81:85);z;wwE1(86:90);z;wwE1(91:end)];

 xE3 = reshape( xE1,[10,19]);  xE3= xE3((7:10)',:); % [ny3,nx3]
 yE3 = reshape( yE1,[10,19]);  yE3= yE3((7:10)',:);
 zE3 = reshape( zE1,[10,19]);  zE3= zE3((7:10)',:);
 uE3 = reshape( uE1,[10,19]);  uE3= uE3((7:10)',:);
 vE3 = reshape( vE1,[10,19]);  vE3= vE3((7:10)',:);
 wE3 = reshape( wE1,[10,19]);  wE3= wE3((7:10)',:);
uuE3 = reshape(uuE1,[10,19]); uuE3=uuE3((7:10)',:);
vvE3 = reshape(vvE1,[10,19]); vvE3=vvE3((7:10)',:);
wwE3 = reshape(wwE1,[10,19]); wwE3=wwE3((7:10)',:);

% normalization
%u3ref = uE3(:,1);
%uE3=uE3./u3ref; uuE3=uuE3./u3ref;
%vE3=vE3./u3ref; vvE3=vvE3./u3ref;
%wE3=wE3./u3ref; wwE3=wwE3./u3ref;

kE3=0.75*(uuE3.*uuE3+vvE3.*vvE3);

ll='rgbck';
%----------
% geometry 
%----------
xmn=-4; xmx=8;
zmn=-0; zmx=0;
xw=linspace(xmn,xmx,1e3);
zw=linspace(zmn,zmx,1e0);
[xw,yw,zw]=ndgrid(xw,0,zw);
[~,~,~,xw,yw,~] = cube(al,xw,yw,zw);

%
% locations
%
figure;fig=gcf;ax=gca; hold on;grid on;
ax.XScale='linear';
ax.YScale='linear';
xlabel(['$$x/h$$']);
ylabel('$$y/h$$');

daspect([1,1,1]); set(fig,'position',[585,1e3,1200,300])
for i=1:ny3
	p=plot(xE3(i,:),yE3(i,:),['-',ll(i)],'linewidth',2.0);
	p.HandleVisibility='on';
	p.DisplayName=['$$y=$$',num2str(yE3(i,1))];
end
p=plot(xw,yw,'k-.','linewidth',2);
p.DisplayName=['wall'];
legend('show');
%------------------------------
figname=['WMC',num2str(al),'trans'];
%exportgraphics(fig,[figname,'.png'],'resolution',300);
saveas(fig,figname,'png');
%------------------------------
%
% velocity profile
%
figure;fig=gcf;ax=gca; hold on;grid on;
ax.XScale='linear';
ax.YScale='linear';
xlabel(['$$x/h$$']);
ylabel('$$v_x$$');

set(fig,'position',[585,1e3,1200,300])
for i=1:ny3
	p=plot(xN(I3(:,i)),uN(I3(:,i)),['-',ll(i)],'linewidth',2.0);
	p.HandleVisibility='on';
	p.DisplayName=['Nek $$y=$$',num2str(yE3(i,1))];

	p=plot(xE3(i,:),uE3(i,:),['o',ll(i)],'linewidth',2.0);
	p.HandleVisibility='on';
	p.DisplayName=['$$y=$$',num2str(yE3(i,1))];
end
legend('show');
%------------------------------
figname=['WMC',num2str(al),'trans_u'];
%exportgraphics(fig,[figname,'.png'],'resolution',300);
saveas(fig,figname,'png');
%------------------------------
%
% TKE profile
%
figure;fig=gcf;ax=gca; hold on;grid on;
ax.XScale='linear';
ax.YScale='log';
xlabel(['$$x/h$$']);
ylabel('$$k$$');

set(fig,'position',[585,1e3,1200,300])
for i=1:ny3
 	p=plot(xN(I3(:,i)),k1N(I3(:,i)),['-',ll(i)],'linewidth',2.0);
 	p.HandleVisibility='on';
 	p.DisplayName=['Nek $$y=$$',num2str(yE3(i,1))];

	p=plot(xE3(i,:),kE3(i,:),['o',ll(i)],'linewidth',2.0);
	p.HandleVisibility='on';
	p.DisplayName=['EPA $$y=$$',num2str(yE3(i,1))];
end
legend('show');
%------------------------------
figname=['WMC',num2str(al),'trans_k'];
%exportgraphics(fig,[figname,'.png'],'resolution',300);
saveas(fig,figname,'png');
%------------------------------
