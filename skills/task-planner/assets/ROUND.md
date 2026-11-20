# r<N> <轮标题>

| 项 | 值 |
|---|---|
| 轮次 | r<N> |
| 类型 | 单任务 / 多任务 / 团队 |
| 状态 | draft / **active** / done / superseded / archived |
| 开始 | YYYY-MM-DDTHH:MM+08:00 |
| 结束 | — |
| 继承自 | r<M>（本轮接的是哪一轮的结论） |
| 本轮废弃 | 上一轮哪些结论在本轮作废；没有就写「无」 |

## 目标

一句话说清这一轮要交付什么。

## 验收口径

1. …
2. …

## 下一步

（收工时更新；开工时读这句就知道该干什么）

## 轮内文件

- `plan.md` —— 决策与工作包
- `brief.md` —— 事实 / 红线 / 命令
- `ledger.md` —— 过程与证据
- `evidence.md` —— 证据索引（几 KB；原始证据在 `_attic/<轮>/evidence/`，不堆轮目录）

## 证据索引与临时产物

- 原始证据：落 `_attic/<轮>/evidence/`，轮目录只留 `evidence.md` 索引。
- 临时产物：探针/调试/一次性脚本一律落 `_attic/<轮>/tmp/`，不写轮目录或 `.plan` 根。
- 收工前必跑 `bash .plan/_tools/plan-ops.sh check`，有红不得写 done。
- `handoff.md` —— 可选，跨对话交接导出物
- `evidence/` —— 日志、截图
