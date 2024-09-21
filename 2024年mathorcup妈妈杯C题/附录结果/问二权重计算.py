# _*_coding : utf-8_*_
# @Time : 2024/4/14 7:27
# @Auther :jiangzhuo
# @File : 问二权重计算
# @Project : 第二问.py
import pandas as pd
import networkx as nx

future_edges_df = pd.read_csv('D:/zhuomian/2024年MathorCup数学应用挑战赛赛题/C题/附件/附件4.csv',encoding='gbk')
G_directed = nx.from_pandas_edgelist(
    future_edges_df,
    source='始发分拣中心',
    target='到达分拣中心',
    create_using=nx.DiGraph()
)
G = G_directed.to_undirected()

centrality_results = {}

# 获取所有的连通分量
connected_components = nx.connected_components(G)

# 遍历所有的连通分量
for component in connected_components:
    subgraph = G.subgraph(component).copy()

    # 为当前连通分量计算中心性
    degree_centrality = nx.degree_centrality(subgraph)
    betweenness_centrality = nx.betweenness_centrality(subgraph)
    eigenvector_centrality = nx.eigenvector_centrality(subgraph)

    # 创建一个DataFrame来存储当前连通分量的中心性结果
    component_df = pd.DataFrame({
        '节点名称': list(degree_centrality.keys()),
        '度中心性': list(degree_centrality.values()),
        '中间中心性': [betweenness_centrality[node] for node in degree_centrality.keys()],
        '特征向量中心性': [eigenvector_centrality[node] for node in degree_centrality.keys()]
    })

    # 将当前连通分量的DataFrame存储到字典中，以连通分量中某个节点的标识作为键
    centrality_results[str(list(component)[0])] = component_df

# 输出每个连通分量的中心性结果
for component_key, component_df in centrality_results.items():
    print(f"连通分量 {component_key} 的中心性结果:")
    component_df.to_excel(f'D:/zhuomian/mathercup/第二问/连通分量 {component_key} 的中心性.xlsx', index=False)
    print(component_df)
    print()