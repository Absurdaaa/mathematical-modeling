% cul_position.m
function position = cul_position(numA,num1,num2,wrong_num,right_position,real_position)
    % 计算夹角
        A = real_position(numA, :);
        B = real_position(num1, :);
        C = real_position(num2, :);
        P = real_position(wrong_num, :);
        PA = sqrt(sum((A - P).^2));
        PB = sqrt(sum((B - P).^2));
        PC = sqrt(sum((C - P).^2));
        BA = sqrt(sum((A - B).^2));
        CA = sqrt(sum((A - C).^2));
        BC = sqrt(sum((B - C).^2));
        cos1 = (PA^2 + PB^2 - BA^2) / (2 * PA * PB);
        cos2 = (PC^2 + PB^2 - BC^2) / (2 * PC * PB);
        cos3 = (PA^2 + PC^2 - CA^2) / (2 * PA * PC);
        
        % 生成初始解矩阵
        num_particles = 50; % 粒子数
        initial_guess = (rand(50, 2) - 0.5) * 2+right_position(wrong_num,:);
        
        % 设置粒子群优化的参数
        opts = optimoptions('particleswarm', ...
            'Display', 'iter', ...       % 显示迭代过程
            'MaxIterations', 500, ...    % 最大迭代次数
            'SwarmSize', num_particles, ... % 粒子数
            'InitialSwarmMatrix', initial_guess ... % 初始解
        );
        %带入正确坐标
        A = right_position(numA, :);
        B = right_position(num1, :);
        C = right_position(num2, :);
        BA = sqrt(sum((A - B).^2));
        CA = sqrt(sum((A - C).^2));
        BC = sqrt(sum((B - C).^2));
        % 定义适应度函数
        fitnessFunction = @(vars) sum([
            (vars(1) - A(1))^2 + (vars(2) - A(2))^2 + (vars(1) - B(1))^2 + (vars(2) - B(2))^2 - BA^2 - 2*cos1*sqrt((vars(1) - A(1))^2 + (vars(2) - A(2))^2)*sqrt((vars(1) - B(1))^2 + (vars(2) - B(2))^2);
            (vars(1) - C(1))^2 + (vars(2) - C(2))^2 + (vars(1) - B(1))^2 + (vars(2) - B(2))^2 - BC^2 - 2*cos2*sqrt((vars(1) - C(1))^2 + (vars(2) - C(2))^2)*sqrt((vars(1) - B(1))^2 + (vars(2) - B(2))^2);
            (vars(1) - A(1))^2 + (vars(2) - A(2))^2 + (vars(1) - C(1))^2 + (vars(2) - C(2))^2 - CA^2 - 2*cos3*sqrt((vars(1) - A(1))^2 + (vars(2) - A(2))^2)*sqrt((vars(1) - C(1))^2 + (vars(2) - C(2))^2)
        ].^2);
        
        lb=[right_position(wrong_num,1)-2,right_position(wrong_num,2)-2];
        ub=[right_position(wrong_num,1)+2,right_position(wrong_num,2)+2];
        % 使用粒子群优化求解
        [x, fval] = particleswarm(fitnessFunction, 2, [],[], opts);
        position = [x, fval];
end



