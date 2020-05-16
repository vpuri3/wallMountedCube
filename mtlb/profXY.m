%
function profXY(q,iz,izw,scale,qty,qtyname,xw,yw,x,y)

x=x(:,:,iz);
y=y(:,:,iz);
q=q(:,:,iz);

xw=xw(:,izw);
yw=yw(:,izw);

xq = x + scale*q;
xq = x + scale*q;

%------------------------------
figure;
fig=gcf;ax=gca; hold on;grid on;
% title
title(['WMC ',qtyname,' Profile' ],'fontsize',14);
% ax
%xlim([-10.01,1.00]);
%ylim([  0.00,2.00]);
ax.XScale='linear';
ax.YScale='linear';
xlabel('$$x$$');
ylabel('$$y$$');

daspect([1,1,1]);
set(fig,'position',[585,1e3,1000,200])

% legend
%lgd=legend('location','southeast');lgd.FontSize=14;

% bottom wall
p=plot(xw,yw,'k-.','linewidth',1.5);
p.HandleVisibility='off';

for i=1:2:size(x,1)
	p=plot(xq(i,:),y(i,:),'g-','linewidth',1.0);
	p.HandleVisibility='off';
end
p.HandleVisibility='on';
p.DisplayName='RWW';

%------------------------------
%figname=['ww','-',qty];
%saveas(fig,figname,'jpeg');
%------------------------------
end
