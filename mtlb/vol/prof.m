function prof(xsw,ysw,xrw,yrw,xS,yS,qS,xR,yR,qR,scale,qty,qtyname)

xqS = xS + scale*qS;
xqR = xR + scale*qR;

%------------------------------
figure;
fig=gcf;ax=gca; hold on;grid on;
% title
title(['Wavy Wall ',qtyname,' Profile' ],'fontsize',14);
% ax
xlim([-0.01 1.01]);
ylim([-0.01 0.50]);
ax.XScale='linear';
ax.YScale='linear';
xlabel('$$x/\lambda$$');
ylabel('$$y/H$$');

%daspect([1,1,1]);
set(fig,'position',[585,1e3,1000,500])

% legend
lgd=legend('location','southeast');lgd.FontSize=14;

% bottom wall
p=plot(xsw,ysw,'k-.','linewidth',1.5);
p.HandleVisibility='off';

p=plot(xrw,yrw,'k--','linewidth',1.5);
p.HandleVisibility='off';

% RWW
for i=1:10
	p=plot(xqR(:,i),yR(:,i),'k-','linewidth',2.0);
	p.HandleVisibility='off';
end
p.HandleVisibility='on';
p.DisplayName='RWW';

% SWW
for i=1:10
	p=plot(xqS(:,i),yS(:,i),'r-','linewidth',2.0);
	p.HandleVisibility='off';
end
p.HandleVisibility='on';
p.DisplayName='SWW';

%------------------------------
figname=['ww','-',qty];
saveas(fig,figname,'jpeg');
%------------------------------
end
