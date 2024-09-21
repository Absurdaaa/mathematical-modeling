# _*_coding : utf-8_*_
# @Time : 2024/4/13 16:28
# @Auther :jiangzhuo
# @File : 第二问
# @Project : 分析2.py
import numpy as np
import pandas as pd
import networkx as nx
edges_df = pd.read_csv('D:/zhuomian/2024年MathorCup数学应用挑战赛赛题/C题/附件/附件3.csv',encoding='gbk')

G = nx.from_pandas_edgelist(
    edges_df,
    source='始发分拣中心',
    target='到达分拣中心',
    edge_attr='货量',
    create_using=nx.DiGraph()
)
future_edges_df = pd.read_csv('D:/zhuomian/2024年MathorCup数学应用挑战赛赛题/C题/附件/附件4.csv',encoding='gbk')


# 更新网络图
for _, row in future_edges_df.iterrows():
    src, dst = row['始发分拣中心'], row['到达分拣中心']
    # 检查边是否存在，存在则更新，不存在则添加
    if G.has_edge(src, dst):
        # 使用与该目的地或来源相关的所有边的平均货量
        specific_avg = edges_df[
            (edges_df['始发分拣中心'] == src) | (edges_df['到达分拣中心'] == dst)
        ]['货量'].mean()
        G[src][dst]['货量'] = specific_avg
    else:
        # 对于不存在的边，也计算与目的地或来源相关的边的平均货量
        specific_avg = edges_df[
            (edges_df['始发分拣中心'] == src) | (edges_df['到达分拣中心'] == dst)
        ]['货量'].mean()
        G.add_edge(src, dst, 货量=specific_avg if not pd.isna(specific_avg) else 0)

# 打印图中所有边的信息
for edge in G.edges(data=True):
    print(edge)

daily_prediction = pd.read_csv('D:/zhuomian/2024年MathorCup数学应用挑战赛赛题/C题/结果/结果表1.csv',encoding='gbk')

print(daily_prediction)

# 转换日期格式，确保一致性
daily_prediction['日期'] = pd.to_datetime(daily_prediction['日期'])

# 创建空DataFrame用于存储更新后的货量
updated_loads = daily_prediction.copy()

# 将DataFrame转换为每天一个字典，便于操作
daily_load_dict = daily_prediction.groupby('日期').apply(lambda x: dict(zip(x['分拣中心'], x['货量']))).to_dict()

#加权重
weight= pd.read_excel('D:/zhuomian/mathercup/第二问/连通分量重要性.xlsx')
weight=weight.set_index('节点名称')


# 遍历每天，调整货量
for date, loads in daily_load_dict.items():
    # 遍历图中每条边，调整货量
    for (src, dst, data) in G.edges(data=True):
        # 确保源和目的节点都在当天的预测数据中
        if src in loads and dst in loads:
            # 计算要转移的货量
            transfer_amount = data['货量']

            # 从源分拣中心减去货量
            loads[src] = max(0, loads[src] - transfer_amount*weight.at[src,'权重'])  # 避免负数

            # 向目的地分拣中心添加货量
            loads[dst] += transfer_amount*weight.at[src,'权重']

    # 更新DataFrame
    for center, new_load in loads.items():
        new_load = int(new_load)
        updated_loads.loc[(updated_loads['日期'] == date) & (updated_loads['分拣中心'] == center), '货量'] = new_load

updated_loads.to_excel('D:/zhuomian/结果2-1(new).xlsx',index=False)

#预测小时的结果
'''avg_distribution = pd.read_csv('avg_distribution.csv')  #是一个小时比例表



def distribute_daily_to_hourly(daily_forecast, hourly_distribution):
    forecast_detailed = daily_forecast.merge(hourly_distribution, on=['分拣中心'])
    forecast_detailed['预测货量'] = forecast_detailed['货量'] * forecast_detailed['小时比例']
    return forecast_detailed[['分拣中心', '日期', '小时', '预测货量']]
####
result_hourly = distribute_daily_to_hourly(updated_loads, avg_distribution)
result_hourly.to_csv('D:/zhuomian/结果2-2.csv',index=False)'''''