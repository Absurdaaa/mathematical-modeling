data=readtable('D:\zhuomian\mathercup\附件1-1.xlsx')
% 创建一个空的数据表
newTable1 = table();
newTable2 = table();
% 获取数据表的列名
columnNames = data.Properties.VariableNames;
for j=1:1:57
    columnName = columnNames{j}; % 如果你知道列的名称，也可以直接赋值给columnName

    % 获取第一列的数据
    columnData = data.(columnName);
    result = columnData; % 这里应该是您的模拟数据生成代码  
    [error,t_sim2]=lstm11(result);
    newTable1 = [newTable1, table(t_sim2, 'VariableNames', {columnName})];
    newTable2 = [newTable2, table(error, 'VariableNames', {columnName})];
 
end

%writetable(newTable1, '结果1-1.csv');
writetable(newTable2, '均方误差表.csv');

