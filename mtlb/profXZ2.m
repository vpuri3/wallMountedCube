%
% if fig==0
% q1,x1,y1 -> smooth line
% q2,x2,y2 -> smooth line
%
% if fig==1
% q1,x1,y1 -> smooth line
% q2,x2,y2 -> points
%
function profXZ2(q1,x1,z1,q2,x2,z2,scale,qty,qtyname,al,xw,zw,y,flg)

xq1 = x1 + scale*q1;
xq2 = x2 + scale*q2;

%------------------------------
           casename='WMC'  ;
if(al==45) casename='WMC45'; end;
if(al==90) casename='WMC90'; end;
%------------------------------

%figure;
figure;fig=gcf;ax=gca; hold on;grid on;
%title([casename,' ',qtyname,' Profile, y=',num2str(y)],'fontsize',14);
ax.XScale='linear';
ax.YScale='linear';
xlabel(['$$x/h + $$',qtyname]);
ylabel('$$z/h$$');

xlim([-4.5,7.0]);
ylim([-2.0,2.0]);

daspect([1,1,1]);
set(fig,'position',[585,1e3,1e3,500])

% cube
p=plot(xw,zw,'k-.','linewidth',1.5);
p.HandleVisibility='off';

% quantity 1
%p=plot(xq1,y1,'ko','linewidth',1.0);
for i=1:1:size(xq1,1)
	           p=plot(xq1(i,:),z1(i,:),'b-','linewidth',1.0);
	if(flg==0) p=plot(xq2(i,:),z2(i,:),'r-','linewidth',1.0); end;
	p.HandleVisibility='off';
end
p.HandleVisibility='on';
p.DisplayName=['WMC',num2str(al)];

if(flg==1) p=plot(xq2,z2,'ro','linewidth',1.0); end;
p.HandleVisibility='on';
p.DisplayName=['Snyder, 1994'];

lgd=legend('location','northeast');lgd.FontSize=14;
%------------------------------
figname=[casename,'-XZ-',qty];
%exportgraphics(fig,[figname,'.png'],'resolution',300);
saveas(fig,figname,'jpeg');
%------------------------------
end
