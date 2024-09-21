function x=bianchang(num1,num2,num3,real_position)
% 这里的num1最好是左下角的飞机
    delta_y=1;
    real_position(num1,2)=real_position(num1,2)-delta_y;

    % 计算夹角
    A = real_position(num1, :);
    B = real_position(num2, :);
    C = real_position(num3, :);
    BA = sqrt(sum((A - B).^2));
    CA = sqrt(sum((A - C).^2));
    BC = sqrt(sum((B - C).^2));
    cos1=(CA^2+BA^2-BC^2)/(2*BA*CA);
    af=acos(cos1);
    af2=pi/3-af;
    x=delta_y  * sin(af) / sin(af2);
end