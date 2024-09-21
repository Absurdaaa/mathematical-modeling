%初始化矩阵
function position=initial()
%三角形边长
a=50;
%xy坐标误差范围在正负delta以内
delta=5;
% 向量表示
A=[-sqrt(3)*a/2,a/2];%表示斜向左上方的单位向量
B=[-sqrt(3)/2*a,-a/2];%表示斜向左下方的单位向量
C=[0,-a];%表示向下的向量

position=zeros(15,4);
%以fy01为原点做直角坐标系
num=1;
for i=0:4
    for j=0:i
        position(num,1:2)=i*A + j*C;
        num=num+1;
    end
end
position(:,3:4)=position(:,1:2);
for i=2:15
    position(i,3)=position(i,3)+delta*2*rand()-delta;
    position(i,4)=position(i,4)+delta*2*rand()-delta;
end
end