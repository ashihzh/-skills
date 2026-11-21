<!-- skill-version: 2.2.0 -->
# <主题> 规划合并（rNN–rMM）

> 本文是「断链压缩」产物：把 rNN–rMM 共 N 轮已终态、链已断、同主题的历史轮压成的索引。
> 原文（三件套）在 `archive/<轮>/`，本文只保留决策精华，细节回链。生成日期：YYYY-MM-DD。

## 一、轮次总览

| 轮 | 原状态 | 一句话目标 | 三件套原文 |
|---|---|---|---|
| rNN | done | … | `archive/rNN-.../plan.md` |
| rNN+1 | superseded | … | `archive/rNN+1-.../plan.md` |
| rMM | done | … | `archive/rMM-.../plan.md` |

## 二、共有设计决策

（本组各轮共同遵守的决策；逐条写清「为什么这么定」，尤其「为什么否决了另一个方案」）

1. **决策 A**：……。否决方案 X 的原因：……。
2. **决策 B**：……。

## 三、关键路径 / 端口 / 服务名 / commit hash

- 路径：……
- 端口：……
- 服务名：……
- commit hash：……

## 四、踩过的坑与规避（可直接复用）

| 坑 | 现象 | 规避 |
|---|---|---|
| …… | …… | …… |

## 五、原文回链（细节还查得到）

- rNN：`archive/rNN-.../plan.md` / `brief.md` / `ledger.md`
- rNN+1：`archive/rNN+1-.../plan.md` / `brief.md` / `ledger.md`
- rMM：`archive/rMM-.../plan.md` / `brief.md` / `ledger.md`

## 六、压缩元信息

- 断链压缩四条件核对：终态 ✅ / 链已断 ✅ / 同主题≥3 ✅ / 不在最近5轮 ✅
- 压缩授权：manual（已获用户批准）/ auto
- 归档 evidence manifest：`archive/_evidence-manifest.tsv`
