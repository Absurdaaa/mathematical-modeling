
  
function [error2,a] = lstm11(result)

num_samples=length(result);  
kim=10;% 延时步长
zim=1;   %跨越1个点

% 划分数据集  
for i= 1:num_samples-kim-zim+1
    res(i, :)=[reshape(result(i:i+kim-1),1,kim),result(i+kim+zim-1)];
end

temp=1:1:90;
P_train=res(temp(1:80),1:10)';
T_train=res(temp(1:80),11)';
M=size(P_train,2);

P_test=res(temp(81:end),1:10)';
T_test=res(temp(81:end),11)';
N=size(P_test,2);
 %Index in position 1 exceeds array bounds. Index must not exceed 90.
%%数据归一化
[P_train,ps_input]=mapminmax(P_train,0,1);
P_test=mapminmax('apply',P_test,ps_input);

[t_train,ps_output]=mapminmax(T_train,0,1);
t_test=mapminmax('apply',T_test,ps_output);
%%数据平铺
P_train=double(reshape(P_train,10,1,1,M));
P_test=double(reshape(P_test,10,1,1,N));


t_train=t_train';
t_test=t_test';




%%数据格式转换
for i = 1:M
    p_train{i,1}=P_train( :, :,1,i);
end
for i = 1:N
    p_test{i,1}=P_test( :, :,1,i);
end
  
  
% LSTM网络结构定义（保持不变）  
layers = [  
    sequenceInputLayer(10)
    
    lstmLayer(10, 'OutputMode', 'last') %lstm层
    reluLayer    %激活层

    fullyConnectedLayer(1)  %全连接层
    regressionLayer  
];  
  
% 训练选项（保持不变）  
options = trainingOptions('adam', ...    %adam梯度下降算法
    'MaxEpochs', 500, ...                %最大训练次数
    'InitialLearnRate', 8e-3, ...       %初始学习率
    'LearnRateSchedule', 'piecewise', ...   %学习率下降
    'LearnRateDropPeriod', 480, ...      %经125次训练后学习率为0.005*0.1
    'LearnRateDropFactor', 0.1, ...       %学习率下降因子     
    'Verbose', false );  
  
% 训练LSTM网络（保持不变）  
net = trainNetwork(p_train, t_train, layers, options);
  
% 仿真预测
t_sim1=predict(net,p_train);

t_sim2=predict(net,p_test);



error2=sqrt(sum((t_sim2'-t_test).^2)./N);
%反归一化
T_sim1=mapminmax('reverse',t_sim1,ps_output);
T_sim2=mapminmax('reverse',t_sim2,ps_output) ; 

%均方根误差
error1=sqrt(sum((T_sim1'-T_train).^2)./M);


   
a=[];



end
