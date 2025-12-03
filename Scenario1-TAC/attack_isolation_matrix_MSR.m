function L = attack_isolation_matrix_MSR(epsilon_p,epsilon_v, L_seq, tau, N, T)
% 分布式攻击隔离算法 - 输出为 (N x T) 的矩阵
% 输入:
%   epsilon_seq : 1×T cell，每个为 N×1 cell，epsilon_seq{k}{i} = ε_i(t_k)
%   L_seq       : 1×T cell，每个为 N×N 拉普拉斯矩阵
%   t_seq       : 1×T 时间向量
%   tau         : 检测启动时间
% 输出:
%   Si_record   : N×T 矩阵，记录所有 agent 的隔离判断标志（0/1）
Si_record = zeros(N, T);xu=0;
% epsilon_norm = zeros(N, T);
    L = L_seq;
    Ii = zeros(N,1);   % 本地是否异常
    Ci = zeros(N,1);   % 收到的异常数量（包括自己）  
    % 构造邻居集合
    Ni_set = false(N, N);
    for i = 1:N
        Ni_set(i,:) = (L(i,:) == -1);
%         epsilon_norm(i,k)=sum(epsilon_seq(i,:,k));
    end
    for i=1:N
        xu=0;xa=0;xd=0;
        xx=epsilon_p(i,:);
        xv=epsilon_v(i,:);
        for j = 1:N
            if (xv(j)>0.1 || xv(j)<-0.1)&& Ni_set(i,j) && xu==0
                L(i,j) =0;L(i,i)=L(i,i)-1;xu=xu+1;%只删除一个新加入的节点
            end
        end
        if xu==0
        theta0=sort(xx(:));
        for j=1:1:N
           if (xx(j)==theta0(1))&& Ni_set(i,j) && xa==0 %xd==0防止程序上可能删除很多次
             L(i,j) =0;L(i,i)=L(i,i)-1;xa=xa+1;
           elseif (xx(j)==theta0(N))&& Ni_set(i,j) && xd==0
             L(i,j) =0;L(i,i)=L(i,i)-1;xd=xd+1;
           end
        end
        end
    end
end
