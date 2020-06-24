%
Re=40e3;
dsty=1;
visc=1/Re;

%=============================================================
% geometry
nx=1e3; % for plotting cube
ny=1e3; % for profile

al=90;

xw=linspace(-2.0,2,nx);
yw=linspace(-0  ,0,1 );
zw=linspace(-0  ,0,1 );
[xw,yw,zw]=ndgrid(xw,yw,zw);
[~,~,~,xw,yw,zw] = cube(al,xw,yw,zw);

%=============================================================
% profile

y=linspace(0,2,ny);
x=-2+0*y;
z=   0*y;

I0=1:ny; I0=reshape(I0,[1,ny,1]);

%-------------------
% blasius
%-------------------
ubl1 = blasius_inflow(y,1);
ubl2 = blasius_inflow(y,2);


%-------------------
% Snyder
%-------------------

y0=1/200; % roughness length
uf=0.05;  % friction velocity

uepa = (y/1.0).^0.16;

%-------------------
% Aeris
%-------------------
 
y0aer=y0 * 0.14/0.20;
uaer = log(y/y0aer);
uaer = uaer /log(1.0/y0aer); % normalized st uaer(y=1)=1

%=============================================================
% plotting
xbl1 = x + ubl1;
xbl2 = x + ubl2;
xaer = x + uaer;
xepa = x + uepa;

figure;
fig=gcf;ax=gca; hold on;grid on;
% title
title(['Inflow Velocity Profile'],'fontsize',14);
% ax
ax.XScale='linear';
ax.YScale='linear';
xlabel(['$$x + v_x$$']);
ylabel('$$y$$');

daspect([1,1,1]);
xlim([-2.00,1.00]);%ylim([0.00,2.00]);
%set(fig,'position',[585,1e3,2000,250])

% legend
%lgd=legend('location','southeast');lgd.FontSize=14;

% bottom wall
p=plot(xw,yw,'k-.','linewidth',1.5);
p.HandleVisibility='off';

p=plot(xbl1,y,'r-','linewidth',1.5);
p.DisplayName='Blasius, $$\delta_{99}=0.25h$$';

p=plot(xbl2,y,'k-','linewidth',1.5);
p.DisplayName='Blasius, $$\delta_{99}=2.00h$$';

p=plot(xepa,y,'b-','linewidth',1.5);
p.DisplayName='Snyder, 1984';

legend('show');

%------------------------------
figname=['uin'];
saveas(fig,figname,'jpeg');
%------------------------------

