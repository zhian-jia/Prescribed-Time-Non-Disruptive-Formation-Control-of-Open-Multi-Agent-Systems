auto1=load("auto-X1.mat");
auto2=load("auto-X2.mat");
auto3=load("auto-X3.mat");
our1=load("our-X1.mat");
our2=load("our-X2.mat");
our3=load("our-X3.mat");
tac1=load("tac-X1.mat");
tac2=load("tac-X2.mat");
tac3=load("tac-X3.mat");
t1=[0:0.01:5]';
t2=[5:0.01:10]';
t3=[10:0.01:15]';
figure
px = [1; 2; 1; -1;-1;2; 4; 2; -2;-2; 3; 6; 3; -3;-3;4; 8; 4; -4;-4];
py = [3^0.5; 0; -3^0.5; -3^0.5;3^0.5;2*3^0.5; 0; 2*-3^0.5; 2*-3^0.5;2*3^0.5;3*3^0.5; 0; 3*-3^0.5; 3*-3^0.5;3*3^0.5;4*3^0.5; 0; 4*-3^0.5; 4*-3^0.5;4*3^0.5];

plot(t1, auto1.X1(:,1)-px(1)-2*t1, 'LineWidth', 1.5,'color','b');hold on;
plot(t1, tac1.X1(:,1)-px(1)-2*t1, 'LineWidth', 1.5,'color','r');hold on;
plot(t1, our1.X1(:,1)-px(1)-2*t1, 'LineWidth', 1.5,'color','k');hold on;


px = [1; 2; 1;-1;2; 4; 2; -2;-2; 3; 6; 3; -3;-3;4; 8; 4; -4;-4;0;0];
py = [3^0.5; 0; -3^0.5;3^0.5;2*3^0.5; 0; 2*-3^0.5; 2*-3^0.5;2*3^0.5;3*3^0.5; 0; 3*-3^0.5; 3*-3^0.5;3*3^0.5;4*3^0.5; 0; 4*-3^0.5; 4*-3^0.5;4*3^0.5;0;0];
plot(t2, auto2.X2(:,1)-px(1)-2*t2, 'LineWidth', 1.5,'color','b');hold on;
plot(t2, tac2.X2(:,1)-px(1)-2*t2, 'LineWidth', 1.5,'color','r');hold on;
plot(t2, our2.X2(:,1)-px(1)-2*t2, 'LineWidth', 1.5,'color','k');hold on;


plot(t3, auto3.X3(:,1)-px(1)-2*t3, 'LineWidth', 1.5,'color','b');hold on;
plot(t3, tac3.X3(:,1)-px(1)-2*t3, 'LineWidth', 1.5,'color','r');hold on;
plot(t3, our3.X3(:,1)-px(1)-2*t3, 'LineWidth', 1.5,'color','k');hold on;

legend('Control approach in [14]','Control approach in [5]','Proposed control approach');
set(gca,'FontSize',12, 'box','on');  
xlabel('Times(s)','FontSize',15); ylabel('$e^x_{pi}$','interpreter','latex','FontSize',16); 
xlim([0 15]);
ylim([-10 5]);
grid on;

axes('position',[.2 .25 .35 .25]);
box on;
px = [1; 2; 1; -1;-1;2; 4; 2; -2;-2; 3; 6; 3; -3;-3;4; 8; 4; -4;-4];
py = [3^0.5; 0; -3^0.5; -3^0.5;3^0.5;2*3^0.5; 0; 2*-3^0.5; 2*-3^0.5;2*3^0.5;3*3^0.5; 0; 3*-3^0.5; 3*-3^0.5;3*3^0.5;4*3^0.5; 0; 4*-3^0.5; 4*-3^0.5;4*3^0.5];

plot(t1, auto1.X1(:,1)-px(1)-2*t1, 'LineWidth', 1.5,'color','b');hold on;
plot(t1, tac1.X1(:,1)-px(1)-2*t1, 'LineWidth', 1.5,'color','r');hold on;
plot(t1, our1.X1(:,1)-px(1)-2*t1, 'LineWidth', 1.5,'color','k');hold on;


px = [1; 2; 1;-1;2; 4; 2; -2;-2; 3; 6; 3; -3;-3;4; 8; 4; -4;-4;0;0];
py = [3^0.5; 0; -3^0.5;3^0.5;2*3^0.5; 0; 2*-3^0.5; 2*-3^0.5;2*3^0.5;3*3^0.5; 0; 3*-3^0.5; 3*-3^0.5;3*3^0.5;4*3^0.5; 0; 4*-3^0.5; 4*-3^0.5;4*3^0.5;0;0];
plot(t2, auto2.X2(:,1)-px(1)-2*t2, 'LineWidth', 1.5,'color','b');hold on;
plot(t2, tac2.X2(:,1)-px(1)-2*t2, 'LineWidth', 1.5,'color','r');hold on;
plot(t2, our2.X2(:,1)-px(1)-2*t2, 'LineWidth', 1.5,'color','k');hold on;


plot(t3, auto3.X3(:,1)-px(1)-2*t3, 'LineWidth', 1.5,'color','b');hold on;
plot(t3, tac3.X3(:,1)-px(1)-2*t3, 'LineWidth', 1.5,'color','r');hold on;
plot(t3, our3.X3(:,1)-px(1)-2*t3, 'LineWidth', 1.5,'color','k');hold on;
xlim([3 13]);ylim([-0.2 0.2]);
set(gca,'FontSize',12, 'box','on');  
