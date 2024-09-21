%先初始化生成
%real_position 目标位置
%right_position 目前位置
tmp=initial();
real_position=tmp(1:9,1:2);
right_position=tmp(1:9,3:4);


num=[2,5,7];
%先优化距离，让大家都在一个圆上,优化10次
for i=1:20
    for j=1:3
        k=num(mod(j,3)+1);
            pos1=cul_position(num(mod(j+2,3)+1),num(mod(j+1,3)+1),k,right_position,real_position);
            pos2=cul_position(1,num(mod(j+1,3)+1),k,right_position,real_position);
            pos3=cul_position(1,num(mod(j+2,3)+1),k,right_position,real_position);
            pos=pos1+pos2+pos3;
            pos=pos/3;
            pos=pos(1:2); %pos是算到的假坐标 
            delta_pos=(100/norm(pos))*pos-pos;
            right_position(k,:)=delta_pos+right_position(k,:);
    end
end

%优化10次
for s=1:20
    for j=1:3
            k=num(mod(j,3)+1);
            pos1=cul_position(num(mod(j+2,3)+1),num(mod(j+1,3)+1),k,right_position,real_position);
            pos2=cul_position(1,num(mod(j+1,3)+1),k,right_position,real_position);
            pos3=cul_position(1,num(mod(j+2,3)+1),k,right_position,real_position);
            pos=pos1+pos2+pos3;
            pos=pos/3;
            pos=pos(1:2); %pos是算到的假坐标 
            delta_pos=pos-real_position(k,:);
            right_position(k,:)=right_position(k,:)-delta_pos;
    end
end
values=[3,4,6,8,9];
right_num1=1;
right_num2=2;
for wrong_num3=values
        pos=cul_position_2(right_num1,right_num2,wrong_num3,right_position,real_position);
        delta_pos=pos-real_position(wrong_num3,:);
        right_position(wrong_num3,:)=right_position(wrong_num3,:)-delta_pos;
end
%转换成极坐标
for i=1:9
    right_position(i,:)=[norm(right_position(i,:)),atand(right_position(i,2)/right_position(i,1))];
end
 