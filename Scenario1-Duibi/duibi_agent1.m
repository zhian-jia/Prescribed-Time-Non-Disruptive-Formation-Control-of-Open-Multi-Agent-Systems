auto1=load("auto-errorx.mat");
our1=load("our-errorx.mat");
tac1=load("tac-errorx.mat");
figure
plot(0.01:0.01:15.01, auto1.errorsx(:,3), 'LineWidth', 1.5,'color','b');hold on;
plot(0.01:0.01:15.01, tac1.errorsx(:,3), 'LineWidth', 1.5,'color','r');hold on;
plot(0.01:0.01:15.01, our1.errorsx(:,3), 'LineWidth', 1.5,'color','k');hold on;

legend('Control approach in [14]','Control approach in [5]','Proposed control approach');
set(gca,'FontSize',12, 'box','on');  
xlabel('Times(s)','FontSize',15); ylabel('$e^x_{pi}$','interpreter','latex','FontSize',16); 
xlim([0 15]);
ylim([-10 5]);
grid on;

axes('position',[.2 .25 .35 .25]);
box on;
plot(0.01:0.01:15.01, auto1.errorsx(:,3), 'LineWidth', 1.5,'color','b');hold on;
plot(0.01:0.01:15.01, tac1.errorsx(:,3), 'LineWidth', 1.5,'color','r');hold on;
plot(0.01:0.01:15.01, our1.errorsx(:,3), 'LineWidth', 1.5,'color','k');hold on;
xlim([3 13]);ylim([-0.2 0.2]);
set(gca,'FontSize',12, 'box','on');  
