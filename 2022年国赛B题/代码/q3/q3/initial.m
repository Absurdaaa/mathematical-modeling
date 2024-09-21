function ini=initial()
% 计算每个飞机的正确极坐标
    real_position = zeros(9, 2);
    for i = 1:9
        real_position(i, :) = [100, (i - 1) * 40];
    end
% 极坐标转化为直角坐标
for i = 1:9
    a = real_position(i, 1);
    b = real_position(i, 2);
    real_position(i, :) = [a * cos(b / 360 * 2 * pi), a * sin(b / 360 * 2 * pi)];
end

% 每个飞机初始极坐标
right_position ...
    =[100,0;
     98,40.10;
     112,80.21;
     105,119.75;
     98,159.86;
     112,199.96;
     105,240.07;
     98,280.17;
     112,320.28];
disp("极坐标为:");
disp(right_position);


% 极坐标转化为直角坐标
for i = 1:9
    a = right_position(i, 1);
    b = right_position(i, 2);
    right_position(i, :) = [a * cos(b / 360 * 2 * pi), a * sin(b / 360 * 2 * pi)];
end
disp("直角坐标为:");
disp(right_position);
    ini=[real_position,right_position];
end
