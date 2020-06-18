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
% blassius
%-------------------
d99=0.25;

y_in  = 0.095;
y_out = 0.32;
y_buf = 0.02;

ux_in  = (-5.2443*y.^2 + 6.7224*y );
ux_mid = ( 35.401*y.^4 + 16.752*y.^3 - 32.97*y.^2 + 11.484*y - 0.2193 );
ux_out = 1.0+0*y;

w0i = (y-(y_in -y_buf)) ./ ((y_in +y_buf)-(y_in -y_buf)); w1i = 1.0 - w0i;
w0o = (y-(y_out-y_buf)) ./ ((y_out+y_buf)-(y_out-y_buf)); w1o = 1.0 - w0o;

I_in  = (y<(y_in -y_buf));
I_ibf = (y<(y_in +y_buf))                 - I_in;
I_mid = (y<(y_out-y_buf))         - I_ibf - I_in;
I_obf = (y<(y_out+y_buf)) - I_mid - I_ibf - I_in;
I_out = (y>(y_out+y_buf));

u =     I_in  .* ux_in ; u = u + I_ibf .* (w1i.*ux_in  + w0i.*ux_mid);
u = u + I_mid .* ux_mid;
u = u + I_obf .* (w1o.*ux_mid + w0o.*ux_out);
u = u + I_out .* ux_out;

ubla = u;

%-------------------
% epa
%-------------------

y0=1/200; % roughness length
uf=0.05;  % friction velocity

uepa = (y/1.0).^0.16;

%-------------------
% aeris
%-------------------

y0aer=y0 * 0.14/0.20;
uaer = log(y/y0aer);
uaer = uaer /log(1.0/y0aer); % normalized st uaer(y=1)=1

%=============================================================
% plotting
xbla = x + ubla;
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

p=plot(xbla,y,'k-','linewidth',1.5);
p.DisplayName='Blasius with $$\delta_{99}=0.25h$$';

p=plot(xaer,y,'r-','linewidth',1.5);
p.DisplayName='Aeris';

p=plot(xepa,y,'b-','linewidth',1.5);
p.DisplayName='Snyder, 1984';

legend('show');

%------------------------------
figname=['uin'];
saveas(fig,figname,'jpeg');
%------------------------------

