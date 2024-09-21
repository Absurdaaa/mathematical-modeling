function delta_pos=delta_distance(num1,num2,k,right_position,real_position)
    % 边长
    a=50;
    % 计算夹角
    af=cal_degree(num1,num2,k,right_position,real_position);
    %计算相对移动距离
    delta_pos=(25/tan(af/2)-25*sqrt(3))*0.0001;
end
