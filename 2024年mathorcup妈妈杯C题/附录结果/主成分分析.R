#主成分分析，多变量降维处理
#强相关的指标组合成新的互不相观的新指标
data=read.table()
pca=princomp(data,cor=TRUE,subset=c(1:10))
##cor:TRUE表示使用相关矩阵求主成分，否则使用协方差矩阵
#scores：表示是否计算每个主成分上的分数
#subset：选取数据部分子集（通常取一般多或）缺省为全取
summary(pca,loadings=TRUE)  #loadings 表示是否进行相关矩阵的特征向量的输出
#自上而下依次是标准差、指标贡献率、累计贡献率  #只要累计贡献率达到80%或85%以上就行了
#loadings是特征向量的输出 即X1=W指标一+W指标二。。。。

screeplot(pca,type='lines') #画出贡献率的折线图

#调用
pca$loadings[,1:3] #前三个主成分的特征向量
pca$scores[,1:3]#三个主成分的综合得分

#注意，princomp执行主成分分析时
#默认情况下会对数据进行标准化。这意味着在计算主成分时，会将每个变量的平均值设为0，标准差设为1。