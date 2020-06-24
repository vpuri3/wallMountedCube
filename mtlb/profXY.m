%
function profXY(q,iz,izw,scale,qty,qtyname,al,xw,yw,x,y,I0)

x=x(I0);
y=y(I0);
q=q(I0);

x=x(:,:,iz);
y=y(:,:,iz);
q=q(:,:,iz);

xw=xw(:,izw);
yw=yw(:,izw);

xq = x + scale*q;
xq = x + scale*q;

%------------------------------
           casename='WMC'  ;
if(al==45) casename='WMC45'; end;
if(al==90) casename='WMC90'; end;
%------------------------------
%figure;
fig=gcf;ax=gca; hold on;grid on;
% title
title([casename,' ',qtyname,' Profile' ],'fontsize',14);
% ax
ax.XScale='linear';
ax.YScale='linear';
xlabel(['$$x + $$',qtyname]);
ylabel('$$y$$');

daspect([1,1,1]);

%xlim([-11.00,26.00]); ylim([  0.00,05.00]);
%set(fig,'position',[585,1e3,2000,250])

% zoom
%xlim([-5,5]); ylim([0,2]);
set(fig,'position',[585,1e3,1000,250])

% legend
%lgd=legend('location','southeast');lgd.FontSize=14;

% bottom wall
p=plot(xw,yw,'k-.','linewidth',1.5);
p.HandleVisibility='off';

for i=1:1:size(x,1)
	p=plot(xq(i,:),y(i,:),'ro','linewidth',1.0);
	p.HandleVisibility='off';
end
p.HandleVisibility='on';
p.DisplayName='RWW';

%------------------------------
figname=[casename,'-',qty];
saveas(fig,figname,'jpeg');
%------------------------------
end
