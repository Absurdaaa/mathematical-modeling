h=0;
for k=1:200
position=initial();
right_position=position(:,1:2); %正确位置
real_position=position(:,3:4); %目前位置
%real_position=real_position-real_position(5,:);
%right_position=right_position-right_position(5,:);
z_1=[-1,0];
z_2=[0.5,-0.5*sqrt(3)];
z_3=[0.5,0.5*sqrt(3)];
real_position_1=zeros(15,2);
for i=2:15
    real_position_1(i,:)=[norm(real_position(i,:)),atand(real_position(i,2)/real_position(i,1))];
end
while abs(cal_degree(1,2,3,right_position,real_position)-60/180*pi)>0.0000001 || abs(cal_degree(3,2,1,right_position,real_position)-60/180*pi)>0.0000001 || abs(cal_degree(1,3,2,right_position,real_position)-60/180*pi)>0.0000001
    delta_distance_3=delta_distance(1,2,3,right_position,real_position);
    real_position(3,:)=real_position(3,:)+delta_distance_3*z_3;
    delta_distance_1=delta_distance(3,2,1,right_position,real_position);
    real_position(1,:)=real_position(1,:)+delta_distance_1*z_1;
    delta_distance_2=delta_distance(1,3,2,right_position,real_position);
    real_position(2,:)=real_position(2,:)+delta_distance_2*z_2;
end
real_position=real_position-real_position(1,:);
%变更坐标系
%转换成极坐标
for i=2:15
    real_position(i,:)=[norm(real_position(i,:)),atand(real_position(i,2)/real_position(i,1))];
end
temp=real_position(2,2)+30;
for i=2:15
    real_position(i,:)=real_position(i,:)-temp;
end
real_position(1,:)=[0,0];
real_position_2=real_position;
for i=2:15
    real_position(i,:)=[real_position(i,1)*cos(real_position(i,2)/180*pi),real_position(i,1)*sin(real_position(i,2)/180*pi)];
end
x=bianchang(2,1,3,real_position);
delta_distance_2=[50*sqrt(3)/2-x*sqrt(3)/2,x/2-50/2];
real_position(2,:)=real_position(2,:)+delta_distance_2;
delta_distance_3=[50*sqrt(3)/2-x*sqrt(3)/2,50/2-x/2];
real_position(3,:)=real_position(3,:)+delta_distance_3;
real_position_3=zeros(15,2);
for i=2:15
    real_position_3(i,:)=[norm(real_position(i,:)),atand(real_position(i,2)/real_position(i,1))];
end
%更换正确坐标系朝向
for i=2:15
    right_position(i,:)=[norm(right_position(i,:)),atand(right_position(i,2)/right_position(i,1))];
end
temp=right_position(2,2)+30;
right_position(1,:)=[0,0];
for i=2:15
    right_position(i,:)=[right_position(i,1)*cos(right_position(i,2)/180*pi),right_position(i,1)*sin(right_position(i,2)/180*pi)];
end
%已知01，02，03正确坐标之后调整其他坐标
for i=[5,8,9,12,13,14]
    pos=cul_position(1,2,3,i,right_position,real_position);
    real_position(i,:)=real_position(i,:)-(pos(1:2)-right_position(i,:));
end
for i=[4,6,7,10,11,15]
    pos=cul_position(1,5,13,i,right_position,real_position);
    real_position(i,:)=real_position(i,:)-(pos(1:2)-right_position(i,:));
end
real_position_4=zeros(15,2);
for i=2:15
    real_position_4(i,:)=[norm(real_position(i,:)),atand(real_position(i,2)/real_position(i,1))];
end
for i=2:15
    right_position(i,:)=[norm(right_position(i,:)),atand(right_position(i,2)/right_position(i,1))];
end
dev_s=real_position_4-right_position;
dev=sum(sum(dev_s.^2));
if dev<15
    h=h+1;
end
end
h=h/200;
disp(["准确率：",h])
