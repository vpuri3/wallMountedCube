%
al=45;
% geometry
nx=1e3; % for plotting cube
ny=1e3; % for profile

xw=linspace(-1,10,nx);
yw=linspace(-0, 0,1 );
zw=linspace(-0, 0,1 );
[xw,yw,zw]=ndgrid(xw,yw,zw);
[~,~,~,xw,yw,zw] = cube(al,xw,yw,zw);

%=============================================================
% transects

x=[-1;10];
y=[1.2,1.4,1.6,1.8,2.0]; y=[y;y];

%=============================================================
% plotting

figure;
fig=gcf;ax=gca; hold on;grid on;
% title
%title(['Inflow Velocity Profile'],'fontsize',14);
% ax
ax.XScale='linear';
ax.YScale='linear';
xlabel(['$$x/h$$']);
ylabel('$$y/h$$');

daspect([1,1,1]);
set(fig,'position',[585,1e3,1200,300])
xlim([-1,10]);
ylim([ 0,2.2]);

% legend
%lgd=legend('location','southeast');lgd.FontSize=14;

% bottom wall
p=plot(xw,yw,'k-.','linewidth',1.5);
p.HandleVisibility='off';

ll='rgbck';
for i=1:1:size(y,2)
	p=plot(x,y(:,i),ll(i),'linewidth',2.0);
	p.HandleVisibility='off';
end
%legend('show');

%------------------------------
figname=['trans',num2str(al)];
exportgraphics(fig,[figname,'.png'],'resolution',300);
%saveas(fig,figname,'jpeg');
%------------------------------

