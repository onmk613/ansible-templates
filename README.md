# Absible Templates

- 默认在线安装,执行[download.sh](download.sh)会提前下载部署包
- 默认联网安装: **online_install: true**

## Intsall docker
- 可通过变量实现版本和部分配置控制
- 避免过于臃肿,大部分配置仍需要自行配置

## Install node_exporter
- 可通过变量实现版本和部分配置控制
- 避免过于臃肿,大部分配置仍需要自行配置
- 可通过**node_exporter_smart: true**实现磁盘健康健康, 不过需要主机提前安装一些软件实现支持

## Install nexus
- use_prxy_mode控制协议: http和https
- docker_servername: docker的代理地址
- ghcr_servername: ghcr代理地址
- mirrors_servername: mirror代理细致
- nexus_servername: nexus本身地址
- 更多代理可以添加到[roles/nexus/templates/](roles/nexus/templates/)目录下，命名为*.conf.j2

## Install clickhouse
- 需要联网pull镜像
- 配置查看和编辑[roles/clickhouse](roles/clickhouse)
- 多节点需要配置clickhouse-keeper, keeper_server_id为keeper节点必须手动配置的变量, 且每个节点的值必须唯一
- 避免配置臃肿请自行配置其他参数
