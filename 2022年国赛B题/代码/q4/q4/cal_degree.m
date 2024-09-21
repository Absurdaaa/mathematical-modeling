function af = cal_degree(num1,num2,k,right_position,real_position)
%DEGREE 此处显示有关此函数的摘要
%   此处显示详细说明
    A = real_position(k, :);
    B = real_position(num1, :);
    C = real_position(num2, :);
    BA = sqrt(sum((A - B).^2));
    CA = sqrt(sum((A - C).^2));
    BC = sqrt(sum((B - C).^2));
    cos1=(CA^2+BA^2-BC^2)/(2*CA*BA);
    af=acos(cos1);
end

