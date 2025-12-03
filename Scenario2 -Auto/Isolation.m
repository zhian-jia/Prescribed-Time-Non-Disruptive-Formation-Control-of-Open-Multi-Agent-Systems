function L = Isolation(x,px,py,L,N)
    for i = 1:N
        for j=1:N
        if (L(i,j) == -1)   
            is_e(i,j) =x(i) - x(j)-px(i)+px(j)+x(i+N)-x(j+N)-py(i)+py(j)+x(i+2*N)-x(j+2*N)+x(i+3*N)-x(j+3*N);%除去偏移的位置和速度的偏差。
            is_ep(i,j) =x(i) - x(j)-px(i)+px(j)+x(i+N)-x(j+N)-py(i)+py(j);%位置偏移
            is_ev(i,j) =x(i+2*N)-x(j+2*N)+x(i+3*N)-x(j+3*N);%速度偏移
        end
        end
    end
L = attack_isolation_matrix(is_e(:,:), L, 5, N, 1);
% L = attack_isolation_matrix_MSR(is_ep(:,:),is_ev(:,:), L, 5, N, 1);

end