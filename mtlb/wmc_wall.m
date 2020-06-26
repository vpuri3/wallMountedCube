function wmc_wall(f,qty,x,y,z,I0,I1,I2,I3,I4,I5)

figure;
title(qty,'fontsize',14); xlabel('x'); ylabel('z');
fig=gcf;ax=gca;
set(fig,'position',[750,0,750,1000])
hold on;grid on;
%------------------------------
subplot(4,2,[1,2]);
surf(x(I0),z(I0),f(I0)); shading interp; colorbar; view(2);daspect([1,1,1]);
title(['ground - surface 0'],'fontsize',14); xlabel('x'); ylabel('z');
hcb=colorbar; title(hcb,qty,'interpreter','latex','fontsize',14);
%------------------------------
subplot(4,2,3);
surf(f(I1)); shading interp; colorbar; view(2);
title(['cube vert - surface 1'],'fontsize',14); xlabel('y'); ylabel('xz');
hcb=colorbar; title(hcb,qty,'interpreter','latex','fontsize',14);
%------------------------------
subplot(4,2,4);
surf(f(I2)); shading interp; colorbar; view(2);
title(['cube vert - surface 2'],'fontsize',14); xlabel('y'); ylabel('xz');
hcb=colorbar; title(hcb,qty,'interpreter','latex','fontsize',14);
%------------------------------
subplot(4,2,5);
surf(f(I3)); shading interp; colorbar; view(2);
title(['cube vert - surface 3'],'fontsize',14); xlabel('y'); ylabel('xz');
hcb=colorbar; title(hcb,qty,'interpreter','latex','fontsize',14);
%------------------------------
subplot(4,2,6);
surf(f(I4)); shading interp; colorbar; view(2);
title(['cube vert - surface 4'],'fontsize',14); xlabel('y'); ylabel('xz');
hcb=colorbar; title(hcb,qty,'interpreter','latex','fontsize',14);
%------------------------------
subplot(4,2,7);
surf(x(I5),z(I5),f(I5)); shading interp; colorbar; view(2);
title(['cube top - surface 5'],'fontsize',14); xlabel('x'); ylabel('z');
hcb=colorbar; title(hcb,qty,'interpreter','latex','fontsize',14);
%------------------------------
%figname=[''];
%saveas(fig,figname,'jpeg');

end
