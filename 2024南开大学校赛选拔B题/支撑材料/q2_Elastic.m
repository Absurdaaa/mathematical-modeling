% 读取CSV文件为表格
dataTable = readtable('65.xlsx');

% 将表格转换为矩阵
X = table2array(dataTable(:, 2:end));
% 获取表格的列标题
columnTitles = dataTable.Properties.VariableNames;

% 将列标题转换为单元数组
columnTitlesCell = cellstr(columnTitles);
% 读取CSV文件为表格
dataTable_2 = readtable('y_data.csv');

% 将表格转换为矩阵
y = table2array(dataTable_2(:, 2:end));


% 使用lasso函数进行Elastic回归
[B, FitInfo] = lasso(X, y,'Alpha', 0.5, 'CV', 5);

% 找到最佳lambda对应的系数
idxLambda1SE = FitInfo.Index1SE;
coef = B(:, idxLambda1SE);

% 输出最佳lambda对应的系数
disp('最佳lambda对应的系数：');
disp(coef);
% 找出非零系数的下标
nonZeroIdx = find(coef ~= 0);
nonZeroColumnTitles = columnTitlesCell(nonZeroIdx + 1);
%输出非零值的下标
disp('非零值的下标：');
disp(nonZeroIdx);
% 绘制Lasso路径
lassoPlot(B, FitInfo, 'PlotType', 'Lambda', 'XScale', 'log');
xlabel('Lambda');
ylabel('Coefficients');
title('Elastic路径图');