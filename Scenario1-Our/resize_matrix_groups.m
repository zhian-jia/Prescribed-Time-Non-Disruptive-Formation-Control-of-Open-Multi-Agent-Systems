function A_new = resize_matrix_groups(A, N1, N2, flag)
    % A 是原始长度为 12*N1 的列向量
    % N1 是原始 N 值，N2 是目标 N 值
    % 输出 A_new 是长度为 12*N2 的列向量

    % 每组长度
    group_size_old =  N1;%2 *
    group_size_new = N2;% 2 * 
    randset=1;
    % 初始化新的 A 向量
    A_new = [];

    % 遍历四组数据
    for i = 1:4
        % 提取原始第 i 组数据
        start_idx = (i - 1) * group_size_old + 1;
        end_idx = i * group_size_old;
        group_old = A(start_idx:end_idx);

        % 保证是列向量
        group_old = group_old(:);

        if N2 > N1 
            % 扩展：在末尾添加零或者其他随机值
            %这里应该区分状态估计值的初值应设定为0，
            if flag==1 &&  N2 ==6 && i==1
                group_new = [group_old; 0];%group_old(group_size_old)-5;group_old(group_size_old)+11
            elseif flag==1 && N2 ==7 && i==1
                group_new = [group_old; 15];    
            elseif flag==1 && N2 ==6 && i==2
                group_new = [group_old; 30];%group_old(group_size_old)-5;group_old(group_size_old)+11
            elseif flag==1 && N2 ==7 && i==2
                group_new = [group_old; 25];%group_old(group_size_old)-5;group_old(group_size_old)+11
            elseif flag==1 && randset==1 && i>2
                group_new = [group_old; ones((N2 - N1), 1)];%
            else
                group_new = [group_old; ones((N2 - N1), 1)];
            end
        else
            % 缩减：只保留前面部分
            group_new = group_old(1:N2);
        end

        % 拼接到新的 A 向量中
        A_new = [A_new; group_new];
    end
end
