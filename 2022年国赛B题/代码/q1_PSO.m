dev_sum=zeros(1,1000); 
for j=1:1000
% 计算每个飞机的正确极坐标
right_position = zeros(9, 2);
for i = 1:9
    right_position(i, :) = [100, (i - 1) * 40];
end
disp("正确位置为:")
disp(right_position)
% 假设飞机偏移
indices = randperm(9, 3); % 生成随机排列的索引，并取3个
right_num1 = indices(1);
right_num2 = indices(2);
wrong_num3 = indices(3);
% 设定偏移坐标
r = rand(1)*30-15;
a = right_position(wrong_num3, 1);
b = right_position(wrong_num3, 2);
right_position(wrong_num3, 2) = b + r;
r = rand()*2-1; 
right_position(wrong_num3, 1) = a + r;
right_position_1=right_position;
% 极坐标转化为直角坐标
for i = 1:9
    a = right_position(i, 1);
    b = right_position(i, 2);
    right_position(i, :) = [a * cos(b / 360 * 2 * pi), a * sin(b / 360 * 2 * pi)];
end
%disp(right_position)

fy00_position = [0, 0];

% 计算夹角
A = fy00_position;
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
[x, fval] = particleswarm(fitnessFunction, 2, [], [], opts);
dev=(x(1)-right_position(wrong_num3,1))^2+(x(2)-right_position(wrong_num3,2))^2;
dev_sum(j)=dev;
% 显示解
disp(['x 的解：', num2str(x(1))])
disp(['y 的解：', num2str(x(2))])
end
percent=sum(dev_sum<1)/1000;
disp(["准确率:",percent]);
