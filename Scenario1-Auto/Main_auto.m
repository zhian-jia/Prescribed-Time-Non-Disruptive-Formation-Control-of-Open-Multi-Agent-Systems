clc; clear; close all;
SWITCH_flag=0;%SWITCH_flag=1-for proposed control approach;SWITCH_flag=0-for control approach proposed in \cite{ding2023auto}
%% 参数设置
alpha1 = 30;
alpha2 = 20;
rho = 10;
Tu = 3;
t0 = 0;
tf = 15;i=1;
for s=5:5:tf
ttf(i)=s;i=i+1;
end
N = 5;

L=[ 2  -1  0 0 -1;
   -1  2  -1 0  0;
    0 -1  2  -1  0;
    0  0 -1  2  -1;
    -1  0  0  -1  2];


px = [1; 2; 1; -1;-1];
py = [3^0.5; 0; -3^0.5; -3^0.5;3^0.5];

% 初始状态
x0 = [-10; -5; 5; 10;0];
y0 = [5; -5; -10; -10;-10];
vx0 = zeros(N,1);
vy0 = zeros(N,1);
X0 = [x0; y0; vx0; vy0];

b = [1; 0; 0; 0; 0];  % 

%
options = odeset('reltol',1e-5,'abstol',1e-5);
[t1, X1] = ode45(@(t, X) dynamics_leader(t, X, L, px, py, b, alpha1, alpha2, rho, Tu, t0), 0:0.01:ttf(1), X0,options);


L=[ 3  -1 -1  0  -1  0;
   -1  3  -1 -1  0  0;
    -1 -1  3  -1  0  0;
    0  -1  -1  4  -1 -1;
    -1  0  0  -1  3  -1;
    0  0  0  -1  -1  2];%


b=[0; 1; 0; 0; 0; 0; 0];
t0 = 5;
for k=1:1:ttf(1)/0.01
  xnew1(k,:)=resize_matrix_groups(X1(k,:), 5, 6, 0);
end
xnew1(ttf(1)/0.01+1,:)=resize_matrix_groups(X1(ttf(1)/0.01+1,:), 5, 6, 1);
N=6;
px = [1; 2; 1; -1;-1;-2];
py = [3^0.5; 0; -3^0.5; -3^0.5;3^0.5;0];
if SWITCH_flag==1
  L1=Isolation(xnew1(ttf(1)/0.01+1,:), px, py,L,N);
else
  L1=L;
end
[t2, X2] = ode45(@(t, X) dynamics_leader(t, X, L1, px, py, b, alpha1, alpha2, rho, Tu, t0),[ttf(1):0.01:ttf(2)],xnew1(ttf(1)/0.01+1,:),options);


% %阶段3
L=[ 2  -1  0  0   -1  0  0;
   -1  2   -1  0   0  0  0;
    0 -1   2  -1   0  0  0;
    0  0  -1   3  -1  -1  0;
    -1  0  0  -1   4  -1 -1;
    0  0  0   -1   -1  3 -1;
     0  0   0  0  -1  -1 2];
b=[1; 0; 0; 0; 0; 0; 0];t0 = 10;
for k=1:1:ttf(1)/0.01
  xnew2(k,:)=resize_matrix_groups(X2(k,:), 6, 7, 0);
end
xnew2(ttf(1)/0.01+1,:)=resize_matrix_groups(X2(ttf(1)/0.01+1,:), 6, 7, 1);
N=7;
px = [1; 2; 1; -1;-1;-2;-2];
py = [3^0.5; 0; -3^0.5; -3^0.5;3^0.5;0;3^0.5];
if SWITCH_flag==1
  L3=Isolation(xnew2(ttf(1)/0.01+1,:), px, py,L,N);
else
  L3=L;
end
[t3, X3] = ode45(@(t, X) dynamics_leader(t, X, L3, px, py, b, alpha1, alpha2, rho, Tu, t0),[ttf(2):0.01:ttf(3)],xnew2(ttf(1)/0.01+1,:),options);

%% 
t=zeros(tf/0.01+1,1);
x=zeros(tf/0.01+1,N*12);

t(1:ttf(1)/0.01+1,:)=t1(:,:);
t(ttf(1)/0.01+1:ttf(2)/0.01+1,:)=t2(:,:);
t(ttf(2)/0.01+1:ttf(3)/0.01+1,:)=t3(:,:);
% t(ttf(3)/0.01+1:ttf(4)/0.01+1,:)=t4(:,:);
for k=1:ttf(1)/0.01+1
    X(k,:)=resize_matrix_groups(xnew1(k,:), 6, 7, 0);
end
for k=1:ttf(1)/0.01+1
    X(ttf(1)/0.01+k,:)=resize_matrix_groups(X2(k,:), 6, 7, 0);
end
X(ttf(2)/0.01+1:ttf(3)/0.01+1,:)=X3(:,:);%xnew3(:,:)
% X(ttf(3)/0.01+1:ttf(4)/0.01+1,:)=X4(:,:);
%% 绘图：三维轨迹
figure;
plot(X(:,1), X(:,N+1),'LineStyle', '--', 'LineWidth', 1.5);hold on;
plot(X(:,2), X(:,N+2),'LineStyle', '--', 'LineWidth', 1.5);hold on;
plot(X(:,3), X(:,N+3),'LineStyle', '--', 'LineWidth', 1.5);hold on;
plot(X(:,4), X(:,N+4),'LineStyle', '--', 'LineWidth', 1.5);hold on;
plot(X(:,5), X(:,N+5),'LineStyle', '--', 'LineWidth', 1.5);hold on;
% plot(X(ttf(1)/0.01+1:ttf(2)/0.01,6), X(ttf(1)/0.01+1:ttf(2)/0.01,N+6),'LineStyle', '--', 'LineWidth', 1.5);hold on;
plot(X(ttf(1)/0.01+1:tf/0.01+1,6), X(ttf(1)/0.01+1:tf/0.01+1,N+6),'LineStyle', '--', 'LineWidth', 1.5);hold on;
plot(X(ttf(2)/0.01+1:tf/0.01+1,7), X(ttf(2)/0.01+1:tf/0.01+1,N+7),'LineStyle', '--', 'LineWidth', 1.5);hold on;
%画编队标记。
symbols = ['o', 's', 'd', 'p', '*', '+'];color = 'r'; % 定义符号类型
time_index=300;
 for i = 1:5
            plot(X(time_index, i), X(time_index, i+N), [color, symbols(5)], 'MarkerSize', 5, 'HandleVisibility', 'off');hold on;
            if i == 6                             
                robot_position1 = [X(time_index, i)  X(time_index, i+N)];
                robot_position2 = [X(time_index, 4)  X(time_index, 4+N)];
                plot([robot_position1(1), robot_position2(1)], [robot_position1(2), robot_position2(2)],'Color', 'b', 'LineStyle', '-', 'LineWidth', 1.5, 'HandleVisibility', 'off');
                hold on;
            elseif i == 1
                robot_position1 = [X(time_index, i)  X(time_index, i+N)];
                robot_position2 = [X(time_index, 5)  X(time_index, 5+N)];
                plot([robot_position1(1), robot_position2(1)], [robot_position1(2), robot_position2(2)],'Color', 'b', 'LineStyle', '-', 'LineWidth', 1.5, 'HandleVisibility', 'off');
                hold on;
            elseif i == 7
                robot_position1 = [X(time_index, i)  X(time_index, i+N)];
                robot_position2 = [X(time_index, 5)  X(time_index, 5+N)];
                plot([robot_position1(1), robot_position2(1)], [robot_position1(2), robot_position2(2)],'Color', 'b', 'LineStyle', '-', 'LineWidth', 1.5, 'HandleVisibility', 'off');
                hold on;
                robot_position1 = [X(time_index, i)  X(time_index, i+N)];
                robot_position2 = [X(time_index, 6)  X(time_index, 6+N)];
                plot([robot_position1(1), robot_position2(1)], [robot_position1(2), robot_position2(2)],'Color', 'b', 'LineStyle', '-', 'LineWidth', 1.5, 'HandleVisibility', 'off');
                hold on;
            else
                robot_position1 = [X(time_index, i)  X(time_index, i+N)];
                robot_position2 = [X(time_index, i-1)  X(time_index, i+N-1)];
                plot([robot_position1(1), robot_position2(1)], [robot_position1(2), robot_position2(2)],'Color', 'b', 'LineStyle', '-', 'LineWidth', 1.5, 'HandleVisibility', 'off');
                hold on;
            end
 end 
plot(X(501, 6), X(501, 6+N), [color, symbols(4)], 'MarkerSize', 8, 'HandleVisibility', 'off');hold on;

for time_index = 515:250:900
    N=7;
 for i = 1:6
            if i == 6                             
                robot_position1 = [X(time_index, i)  X(time_index, i+N)];
                robot_position2 = [X(time_index, 4)  X(time_index, 4+N)];
                plot([robot_position1(1), robot_position2(1)], [robot_position1(2), robot_position2(2)],'Color', 'b', 'LineStyle', '-', 'LineWidth', 1.5, 'HandleVisibility', 'off');
                hold on;
                robot_position1 = [X(time_index, i)  X(time_index, i+N)];
                robot_position2 = [X(time_index, 5)  X(time_index, 5+N)];
                plot([robot_position1(1), robot_position2(1)], [robot_position1(2), robot_position2(2)],'Color', 'b', 'LineStyle', '-', 'LineWidth', 1.5, 'HandleVisibility', 'off');
                hold on;
                plot(X(time_index, i), X(time_index, i+N), [color, symbols(4)], 'MarkerSize', 8, 'HandleVisibility', 'off');hold on;
            elseif i == 1
                robot_position1 = [X(time_index, i)  X(time_index, i+N)];
                robot_position2 = [X(time_index, 5)  X(time_index, 5+N)];
                plot([robot_position1(1), robot_position2(1)], [robot_position1(2), robot_position2(2)],'Color', 'b', 'LineStyle', '-', 'LineWidth', 1.5, 'HandleVisibility', 'off');
                hold on;
                plot(X(time_index, i), X(time_index, i+N), [color, symbols(5)], 'MarkerSize', 5, 'HandleVisibility', 'off');hold on;
            else
                robot_position1 = [X(time_index, i)  X(time_index, i+N)];
                robot_position2 = [X(time_index, i-1)  X(time_index, i+N-1)];
                plot([robot_position1(1), robot_position2(1)], [robot_position1(2), robot_position2(2)],'Color', 'b', 'LineStyle', '-', 'LineWidth', 1.5, 'HandleVisibility', 'off');
                hold on;
                plot(X(time_index, i), X(time_index, i+N), [color, symbols(5)], 'MarkerSize', 5, 'HandleVisibility', 'off');hold on;

            end
        end 
end

plot(X(1001, 7), X(1001, 7+N), [color, symbols(4)], 'MarkerSize', 8, 'HandleVisibility', 'off');hold on;


for time_index = 1015:250:1500
 for i = 1:N
            if i == 6                             
                robot_position1 = [X(time_index, i)  X(time_index, i+N)];
                robot_position2 = [X(time_index, 4)  X(time_index, 4+N)];
                plot([robot_position1(1), robot_position2(1)], [robot_position1(2), robot_position2(2)],'Color', 'b', 'LineStyle', '-', 'LineWidth', 1.5, 'HandleVisibility', 'off');
                hold on; robot_position1 = [X(time_index, i)  X(time_index, i+N)];
                robot_position2 = [X(time_index, 5)  X(time_index, 5+N)];
                plot([robot_position1(1), robot_position2(1)], [robot_position1(2), robot_position2(2)],'Color', 'b', 'LineStyle', '-', 'LineWidth', 1.5, 'HandleVisibility', 'off');
                plot(X(time_index, i), X(time_index, i+N), [color, symbols(5)], 'MarkerSize', 5, 'HandleVisibility', 'off');hold on;
            elseif i == 1
                robot_position1 = [X(time_index, i)  X(time_index, i+N)];
                robot_position2 = [X(time_index, 5)  X(time_index, 5+N)];
                plot([robot_position1(1), robot_position2(1)], [robot_position1(2), robot_position2(2)],'Color', 'b', 'LineStyle', '-', 'LineWidth', 1.5, 'HandleVisibility', 'off');
                hold on;
                plot(X(time_index, i), X(time_index, i+N), [color, symbols(5)], 'MarkerSize', 5, 'HandleVisibility', 'off');hold on;
            elseif i == 7
                robot_position1 = [X(time_index, i)  X(time_index, i+N)];
                robot_position2 = [X(time_index, 5)  X(time_index, 5+N)];
                plot([robot_position1(1), robot_position2(1)], [robot_position1(2), robot_position2(2)],'Color', 'b', 'LineStyle', '-', 'LineWidth', 1.5, 'HandleVisibility', 'off');
                hold on;
                robot_position1 = [X(time_index, i)  X(time_index, i+N)];
                robot_position2 = [X(time_index, 6)  X(time_index, 6+N)];
                plot([robot_position1(1), robot_position2(1)], [robot_position1(2), robot_position2(2)],'Color', 'b', 'LineStyle', '-', 'LineWidth', 1.5, 'HandleVisibility', 'off');
                hold on;
                plot(X(time_index, i), X(time_index, i+N), [color, symbols(4)], 'MarkerSize', 8, 'HandleVisibility', 'off');hold on;
            else
                robot_position1 = [X(time_index, i)  X(time_index, i+N)];
                robot_position2 = [X(time_index, i-1)  X(time_index, i+N-1)];
                plot([robot_position1(1), robot_position2(1)], [robot_position1(2), robot_position2(2)],'Color', 'b', 'LineStyle', '-', 'LineWidth', 1.5, 'HandleVisibility', 'off');
                hold on;
                plot(X(time_index, i), X(time_index, i+N), [color, symbols(5)], 'MarkerSize', 5, 'HandleVisibility', 'off');hold on;                
            end
        end 
end
xlim([-10 32]);
ylim([-10 32]);
xlabel('x'); ylabel('y');
% title('含领航节点的编队轨迹');
set(gca,'FontSize',12, 'box','on');   
% grid on;
%加小图只放大一个区域。
axes('position',[.6 .2 .25 .3]);
box on;
plot(X(:,1), X(:,N+1),'LineStyle', '--', 'LineWidth', 1.5);hold on;
plot(X(:,2), X(:,N+2),'LineStyle', '--', 'LineWidth', 1.5);hold on;
plot(X(:,3), X(:,N+3),'LineStyle', '--', 'LineWidth', 1.5);hold on;
plot(X(:,4), X(:,N+4),'LineStyle', '--', 'LineWidth', 1.5);hold on;
plot(X(:,5), X(:,N+5),'LineStyle', '--', 'LineWidth', 1.5);hold on;
for time_index=345:170:700
 for i = 1:5
            plot(X(time_index, i), X(time_index, i+N), [color, symbols(5)], 'MarkerSize', 5, 'HandleVisibility', 'off');hold on;
            if i == 6                             
                robot_position1 = [X(time_index, i)  X(time_index, i+N)];
                robot_position2 = [X(time_index, 4)  X(time_index, 4+N)];
                plot([robot_position1(1), robot_position2(1)], [robot_position1(2), robot_position2(2)],'Color', 'b', 'LineStyle', '-', 'LineWidth', 1.5, 'HandleVisibility', 'off');
                hold on;
            elseif i == 1
                robot_position1 = [X(time_index, i)  X(time_index, i+N)];
                robot_position2 = [X(time_index, 5)  X(time_index, 5+N)];
                plot([robot_position1(1), robot_position2(1)], [robot_position1(2), robot_position2(2)],'Color', 'b', 'LineStyle', '-', 'LineWidth', 1.5, 'HandleVisibility', 'off');
                hold on;
            elseif i == 7
                robot_position1 = [X(time_index, i)  X(time_index, i+N)];
                robot_position2 = [X(time_index, 5)  X(time_index, 5+N)];
                plot([robot_position1(1), robot_position2(1)], [robot_position1(2), robot_position2(2)],'Color', 'b', 'LineStyle', '-', 'LineWidth', 1.5, 'HandleVisibility', 'off');
                hold on;
                robot_position1 = [X(time_index, i)  X(time_index, i+N)];
                robot_position2 = [X(time_index, 6)  X(time_index, 6+N)];
                plot([robot_position1(1), robot_position2(1)], [robot_position1(2), robot_position2(2)],'Color', 'b', 'LineStyle', '-', 'LineWidth', 1.5, 'HandleVisibility', 'off');
                hold on;
            else
                robot_position1 = [X(time_index, i)  X(time_index, i+N)];
                robot_position2 = [X(time_index, i-1)  X(time_index, i+N-1)];
                plot([robot_position1(1), robot_position2(1)], [robot_position1(2), robot_position2(2)],'Color', 'b', 'LineStyle', '-', 'LineWidth', 1.5, 'HandleVisibility', 'off');
                hold on;
            end
 end 
end
xlim([3 18]);
ylim([3 18]);
set(gca,'FontSize',12, 'box','on');   
%% 编队误差计算
errors = zeros(length(t), N);
for k = 1:length(t)
    xi = X(k,1:N)';
    yi = X(k,N+1:2*N)';
    vxi = X(k,2*N+1:3*N)';
    vyi = X(k,3*N+1:4*N)';
    % 领导节点轨迹
    xl = 2*t(k);
    yl = 2*t(k);

    % 每个 agent 的目标位置 = 领导位置 + 偏移
    x_des = xl + px;
    y_des = yl + py;

    ex = xi - x_des;
    ey = yi - y_des;
    
    evx = vxi - 2;
    evy = vyi - 2;    

    for j = 1:N
            errorsx(k,j) = ex(j);
            errorsy(k,j) = ey(j);
            errorsvx(k,j) = evx(j);
            errorsvy(k,j) = evy(j);
            errors(k,j)=ex(j)+ey(j);
            errorsv(k,j)=evx(j)+evy(j);
    end
end

figure;
subplot(2,2,1);
plot(t, errorsx(:,1:5), 'LineWidth', 1.5);hold on;
plot(t(ttf(1)/0.01+1:ttf(3)/0.01), errorsx(ttf(1)/0.01+1:ttf(3)/0.01,6), 'LineWidth', 1.5);hold on;
% plot(t3, errors(ttf(2)/0.01+1:ttf(3)/0.01+1,6), 'LineWidth', 1.5);hold on;
plot(t3, errorsx(ttf(2)/0.01+1:ttf(3)/0.01+1,7), 'LineWidth', 1.5);hold on;
legend('Agent 1','Agent 2','Agent 3','Agent 4','Agent 5','Agent 6','Agent 7');
set(gca,'FontSize',12, 'box','on');  
xlabel('Times(s)','FontSize',15); ylabel('$e^x_{pi}$','interpreter','latex','FontSize',16); 
xlim([0 15]);
ylim([-10 30]);
grid on;

subplot(2,2,2);
plot(t, errorsy(:,1:5), 'LineWidth', 1.5);hold on;
plot(t(ttf(1)/0.01+1:ttf(3)/0.01), errorsy(ttf(1)/0.01+1:ttf(3)/0.01,6), 'LineWidth', 1.5);hold on;
% plot(t3, errors(ttf(2)/0.01+1:ttf(3)/0.01+1,6), 'LineWidth', 1.5);hold on;
plot(t3, errorsy(ttf(2)/0.01+1:ttf(3)/0.01+1,7), 'LineWidth', 1.5);hold on;
set(gca,'FontSize',12, 'box','on');  
xlabel('Times(s)','FontSize',15); ylabel('$e^y_{pi}$','interpreter','latex','FontSize',16); 
xlim([0 15]);
ylim([-10 30]);
grid on;


%x轴的速度误差
subplot(2,2,3);
plot(t, errorsvx(:,1:5), 'LineWidth', 1.5);hold on;
plot(t(ttf(1)/0.01+1:ttf(3)/0.01), errorsvx(ttf(1)/0.01+1:ttf(3)/0.01,6), 'LineWidth', 1.5);hold on;
% plot(t3, errors(ttf(2)/0.01+1:ttf(3)/0.01+1,6), 'LineWidth', 1.5);hold on;
plot(t3, errorsvx(ttf(2)/0.01+1:ttf(3)/0.01+1,7), 'LineWidth', 1.5);hold on;
set(gca,'FontSize',12, 'box','on');  
xlabel('Times(s)','FontSize',15); ylabel('$e^x_{vi}$','interpreter','latex','FontSize',16); 
xlim([0 15]);
ylim([-20 50]);
grid on;


%x轴的速度误差
subplot(2,2,4);
plot(t, errorsvy(:,1:5), 'LineWidth', 1.5);hold on;
plot(t(ttf(1)/0.01+1:ttf(3)/0.01), errorsvy(ttf(1)/0.01+1:ttf(3)/0.01,6), 'LineWidth', 1.5);hold on;
% plot(t3, errors(ttf(2)/0.01+1:ttf(3)/0.01+1,6), 'LineWidth', 1.5);hold on;
plot(t3, errorsvy(ttf(2)/0.01+1:ttf(3)/0.01+1,7), 'LineWidth', 1.5);hold on;
set(gca,'FontSize',12, 'box','on');  
xlabel('Times(s)','FontSize',15); ylabel('$e^y_{vi}$','interpreter','latex','FontSize',16); 
xlim([0 15]);
ylim([-20 50]);
grid on;

%小图1
axes('position',[.15 .7 .1 .15]);
box on;
plot(t(100:400), errorsx(100:400,1:5), 'LineWidth', 1.5);hold on;
xlim([1 4]);ylim([-0.01 0.01]);
% xlim([1 4]);ylim([-0.01 0.01]);
set(gca,'FontSize',12, 'box','on');  
line([3,3], [-2,20], 'linewidth',1, 'Color','r', 'linestyle','--')
text(3, 0.01, '$\mathcal T_1$', 'interpreter','latex', 'HorizontalAlignment','left','FontSize',12);
axes('position',[.3 .7 .1 .15]);
box on;
plot(t(501:900), errorsx(501:900,1:6), 'LineWidth', 1.5);hold on;
xlim([5 9]);ylim([-0.02 0.01]);
% xlim([5 9]);ylim([-0.02 0.01]);
set(gca,'FontSize',12, 'box','on');  
line([8,8], [-2,20], 'linewidth',1, 'Color','r', 'linestyle','--')
text(8, 0.01, '$\mathcal T_2$', 'interpreter','latex', 'HorizontalAlignment','left','FontSize',12);
%小图2
axes('position',[.6 .7 .1 .15]);
box on;
plot(t(100:400), errorsy(100:400,1:5), 'LineWidth', 1.5);hold on;
xlim([1 4]);ylim([-0.01 0.01]);
% xlim([1 4]);ylim([-0.01 0.01]);
set(gca,'FontSize',12, 'box','on');  
line([3,3], [-2,20], 'linewidth',1, 'Color','r', 'linestyle','--')
text(3, 0.01, '$\mathcal T_1$', 'interpreter','latex', 'HorizontalAlignment','left','FontSize',12);
axes('position',[.8 .7 .1 .15]);
box on;
plot(t(501:900), errorsy(501:900,1:6), 'LineWidth', 1.5);hold on;
xlim([5 9]);ylim([-0.01 0.02]);
% xlim([5 9]);ylim([-0.01 0.02]);
set(gca,'FontSize',12, 'box','on');  
line([8,8], [-2,20], 'linewidth',1, 'Color','r', 'linestyle','--')
text(8, 0.02, '$\mathcal T_2$', 'interpreter','latex', 'HorizontalAlignment','left','FontSize',12);
%小图3
axes('position',[.15 .2 .1 .15]);
box on;
plot(t(100:400), errorsvx(100:400,1:5), 'LineWidth', 1.5);hold on;
xlim([1 4]);ylim([-0.01 0.01]);
% xlim([1 4]);ylim([-0.01 0.01]);
set(gca,'FontSize',12, 'box','on');  
line([3,3], [-2,20], 'linewidth',1, 'Color','r', 'linestyle','--')
text(3, 0.01, '$\mathcal T_1$', 'interpreter','latex', 'HorizontalAlignment','left','FontSize',12);
axes('position',[.3 .2 .1 .15]);
box on;
plot(t(501:900), errorsvx(501:900,1:6), 'LineWidth', 1.5);hold on;
xlim([5 9]);ylim([-0.01 0.02]);
% xlim([5 9]);ylim([-0.01 0.02]);
set(gca,'FontSize',12, 'box','on');  
line([8,8], [-2,20], 'linewidth',1, 'Color','r', 'linestyle','--')
text(8, 0.02, '$\mathcal T_2$', 'interpreter','latex', 'HorizontalAlignment','left','FontSize',12);
%小图4
axes('position',[.6 .2 .1 .15]);
box on;
plot(t(100:400), errorsvy(100:400,1:5), 'LineWidth', 1.5);hold on;
xlim([1 4]);ylim([-0.01 0.01]);
% xlim([1 4]);ylim([-0.01 0.01]);
set(gca,'FontSize',12, 'box','on');  
line([3,3], [-2,20], 'linewidth',1, 'Color','r', 'linestyle','--')
text(3, 0.01, '$\mathcal T_1$', 'interpreter','latex', 'HorizontalAlignment','left','FontSize',12);
axes('position',[.8 .2 .1 .15]);
box on;
plot(t(501:900), errorsvy(501:900,1:6), 'LineWidth', 1.5);hold on;
xlim([5 9]);ylim([-0.02 0.01]);
% xlim([5 9]);ylim([-0.02 0.01]);
set(gca,'FontSize',12, 'box','on');  
line([8,8], [-2,20], 'linewidth',1, 'Color','r', 'linestyle','--')
text(8, 0.01, '$\mathcal T_2$', 'interpreter','latex', 'HorizontalAlignment','left','FontSize',12);

%% 系统动态函数
function dX = dynamics_leader(t, X, L, px, py, b, alpha1, alpha2, rho, Tu, t0)
    N = size(L,1);
    x = X(1:N);
    y = X(N+1:2*N);
    vx = X(2*N+1:3*N);
    vy = X(3*N+1:4*N);
    beta=1;%

    % 偏移后误差
    ex = x - px;%
    ey = y - py;%
    disturbance =0.2*cos(t);%zeros(N,1)
    % 领航节点轨迹、速度、加速度
    xl = [2*t; 2*t];
    vl = [2; 2];
    al = [0; 0];

    % eta与phi计算
    epsilon = 1e-8;
    if t < t0 + Tu
        eta = (Tu / (t0 + Tu - t + epsilon))^rho;
%         eta_dot = rho * (Tu / (t0 + Tu - t + epsilon))^rho / (t0 + Tu - t + epsilon);
        eta_dot = rho/ Tu * eta^(1+1/rho);
        phi = eta_dot / eta;
    else
        eta = (Tu)^rho;
        phi = rho / Tu;
    end

    % 控制律
    ux = zeros(N,1); uy = zeros(N,1);
    for i = 1:N
        sum_x = 0; sum_vx = 0;
        sum_y = 0; sum_vy = 0;
        for j = 1:N
            if i~=j
            sum_x = sum_x - L(i,j)*(ex(i) - ex(j));
            sum_vx = sum_vx - L(i,j)*(vx(i) - vx(j));
            sum_y = sum_y - L(i,j)*(ey(i) - ey(j));
            sum_vy = sum_vy - L(i,j)*(vy(i) - vy(j));
            end
        end
%         z1=x(i) - xl(1)-px(i)+
        ux(i) = al(1) ...
              - alpha1 * phi^2 * (sum_x + b(i)*(x(i) - xl(1)-px(i))) ...
              - alpha2 * phi * (sum_vx + b(i)*(vx(i) - vl(1)))-beta*sign(alpha1*phi* (sum_x + b(i)*(x(i) - xl(1)-px(i)))+alpha2*(sum_vx + b(i)*(vx(i) - vl(1))));%sign(x(i) - xl(1)-px(i))
        uy(i) = al(2) ...
              - alpha1 * phi^2 * (sum_y + b(i)*(y(i) - xl(2)-py(i))) ...
              - alpha2 * phi * (sum_vy + b(i)*(vy(i) - vl(2)))-beta*sign(alpha1*phi* (sum_y + b(i)*(y(i) - xl(2)-py(i)))+alpha2*(sum_vy + b(i)*(vy(i) - vl(2))));%sign(y(i) - xl(2)-py(i))
        % Mm=50;
        % if ux(i)>0 && ux(i)>=Mm
        %    ux(i)=Mm;
        % elseif ux(i)<0 && ux(i)<=-Mm
        %     ux(i)=-Mm;
        % end
        % if uy(i)>0 && uy(i)>=Mm
        %    uy(i)=Mm;
        % elseif uy(i)<0 && uy(i)<=-Mm
        %     uy(i)=-Mm;
        % end
    end

    % 状态导数
    dx = vx ;
    dy = vy ;
    dvx = ux+ disturbance;%-1*vx-2*x
    dvy = uy+ disturbance;%-1*vy-2*y
    dX = [dx; dy; dvx; dvy];
end

