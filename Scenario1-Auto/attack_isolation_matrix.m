function L = attack_isolation_matrix(epsilon_norm, L_seq, tau, N, T)
% 分布式攻击隔离算法 - 输出为 (N x T) 的矩阵
% 输入:
%   epsilon_seq : 1×T cell，每个为 N×1 cell，epsilon_seq{k}{i} = ε_i(t_k)
%   L_seq       : 1×T cell，每个为 N×N 拉普拉斯矩阵
%   t_seq       : 1×T 时间向量
%   tau         : 检测启动时间
% 输出:
%   Si_record   : N×T 矩阵，记录所有 agent 的隔离判断标志（0/1）
Si_record = zeros(N, T);
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

%     if t >= tau
        % 第一步：计算 Ii 和本地 Ci
        for i = 1:N
            if sum(abs(epsilon_norm(i,:)))/N > 0.01 %
                Ii(i) = 1;
                Ci(i) = 1;
            else
                Ii(i) = 0;
                Ci(i) = 0;
            end
        end

        % 第二步：统计邻居中异常数量
        for i = 1:N
            for j = 1:N
                if (Ni_set(i,j) && Ii(j) == 1)  %  
                    Ci(i) = Ci(i) + 1;
                end
            end
        end

        % 第三步：是否满足隔离条件
        for i = 1:N
            if (Ci(i) == sum(Ni_set(i,:)) + 1) %
                Si_record(i) = 1;
            end
        end

        for i=1:N
            if Si_record(i)==1
                for j=1:N
                    if L(j,i)==-1
                        L(j,i)=0;
                        L(j,j)=L(j,j)-1;
                    end
                end
            end
        end
end

