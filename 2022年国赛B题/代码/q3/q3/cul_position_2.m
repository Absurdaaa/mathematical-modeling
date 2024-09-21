function position = cul_position_2(right_num1,right_num2,wrong_num3,right_position,real_position)
%CUL_POSITION_2 此处显示有关此函数的摘要
%   此处显示详细说明
%计算正确角度集合
% 初始化一个4*4*4的cell数组  
true_degree = cell(3,3,3);  
% 
% % 填充这个cell数组，使得每个元素都是一个3x1的零向量  
for i = 1:3  
    for j = 1:3
        for k=1:3
            true_degree{i, j, k} = zeros(1, 3);  % 创建一个1x3的零向量并放入cell数组中的相应位置
        end
    end  
end  
num=[0,1,2];
for i=1:3
    for j=1:3
        for k=1:3
            if i==j ||j==k||i==k
                continue;
            end
            if num(i)==0
                A=[0,0];
            else
                A=real_position(num(i), :);
            end
            if num(j)==0
                B=[0,0];
            else
                B=real_position(num(j), :);
            end
            if num(k)==0
                C=[0,0];
            else
                C=real_position(num(k), :);
            end
            P = real_position(wrong_num3, :);
            PA = sqrt(sum((A - P).^2));
            PB = sqrt(sum((B - P).^2));
            PC = sqrt(sum((C - P).^2));
            BA = sqrt(sum((A - B).^2));
            CA = sqrt(sum((A - C).^2));
            BC = sqrt(sum((B - C).^2));
            cos1 = (PA^2 + PB^2 - BA^2) / (2 * PA * PB);
            cos2 = (PC^2 + PB^2 - BC^2) / (2 * PC * PB);
            cos3 = (PA^2 + PC^2 - CA^2) / (2 * PA * PC);
            true_degree{i,j,k}=[acos(cos1)*180/pi,acos(cos2)*180/pi,acos(cos3)*180/pi];
        end
    end
end
% 计算夹角
A = [0,0];            
B = right_position(right_num1, :);
C = right_position(right_num2, :);
P = right_position(wrong_num3, :);
PA = sqrt(sum((A - P).^2));
PB = sqrt(sum((B - P).^2));
PC = sqrt(sum((C - P).^2));
BA = sqrt(sum((A - B).^2));
CA = sqrt(sum((A - C).^2));
BC = sqrt(sum((B - C).^2));
cos1 = (PA^2 + PB^2 - BA^2) / (2 * PA * PB);
cos2 = (PC^2 + PB^2 - BC^2) / (2 * PC * PB);
cos3 = (PA^2 + PC^2 - CA^2) / (2 * PA * PC);
 %挑选最合适的飞机
        for i=1:3
            for j=1:3
                for k=1:3
                    true_degree{i,j,k}=true_degree{i,j,k}-[acos(cos1)*180/pi,acos(cos2)*180/pi,acos(cos3)*180/pi];
                end
            end
        end
        minSum = Inf;
        minIndex_1 = 0; 
        minIndex_2 = 0;
        minIndex_3=0;
        for i = 1:3
            for j = 1:3
                for k=1:3
                    if i==j||i==k||j==k
                        continue
                    end
                    currentSum = true_degree{i,j,k}(1)^2 + true_degree{i, j,k}(2)^2 + true_degree{i, j,k}(3)^2;  
                    if currentSum < minSum  
                        minSum = currentSum;  
                        minIndex_1 = num(i);  
                        minIndex_2=num(j);
                        minIndex_3=num(k);
                    end
                end
            end
        end
        if minIndex_1==0
            A=[0,0];
        else
            A=real_position(minIndex_1,:);
        end
        if minIndex_2==0
            B=[0,0];
        else
            B=real_position(minIndex_2,:);
        end
        if minIndex_3==0
            C=[0,0];
        else
            C=real_position(minIndex_3,:);
        end
% 生成初始解矩阵
num_particles = 50; % 粒子数
a=100-12+24*rand(num_particles, 1);
b=(wrong_num3-1)*40-0.5 + rand(num_particles, 1);
initial_guess = [a .* (cos(b/360*2*pi)),a .* (sin(b/360*2*pi))];

% 设置粒子群优化的参数
opts = optimoptions('particleswarm', ...
    'Display', 'iter', ...       % 显示迭代过程
    'MaxIterations', 500, ...    % 最大迭代次数
    'SwarmSize', num_particles, ... % 粒子数
    'InitialSwarmMatrix', initial_guess ... % 初始解
);
% 定义适应度函数
fitnessFunction = @(vars) sum([
    (vars(1) - A(1))^2 + (vars(2) - A(2))^2 + (vars(1) - B(1))^2 + (vars(2) - B(2))^2 - BA^2 - 2*cos1*sqrt((vars(1) - A(1))^2 + (vars(2) - A(2))^2)*sqrt((vars(1) - B(1))^2 + (vars(2) - B(2))^2);
    (vars(1) - C(1))^2 + (vars(2) - C(2))^2 + (vars(1) - B(1))^2 + (vars(2) - B(2))^2 - BC^2 - 2*cos2*sqrt((vars(1) - C(1))^2 + (vars(2) - C(2))^2)*sqrt((vars(1) - B(1))^2 + (vars(2) - B(2))^2);
    (vars(1) - A(1))^2 + (vars(2) - A(2))^2 + (vars(1) - C(1))^2 + (vars(2) - C(2))^2 - CA^2 - 2*cos3*sqrt((vars(1) - A(1))^2 + (vars(2) - A(2))^2)*sqrt((vars(1) - C(1))^2 + (vars(2) - C(2))^2)
].^2);

% 使用粒子群优化求解
[x, ~] = particleswarm(fitnessFunction, 2, [], [], opts);
position=x;
end

