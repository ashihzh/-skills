# 轮次状态机（唯一权威定义）

> 本文件是 `.plan/` 轮次与任务状态词的**唯一权威**。所有模板、文档、脚本涉及状态词时引用本文件，不再各自列全量词表。
> 各层级只用与自身相关的**子集**时，必须显式标注「本层级子集，全集见 `references/state-machine.md`」。
> 本文件只描述抽象状态规则，不含任何具体轮次、slug、提交或凭据内容。

## 为什么需要唯一状态机

状态词散落在多个模板里各列一套（轮级列 8 词、台账级列 4 词、任务卡列 4 词），会导致：
- 同一状态在不同文件含义不同（如 `blocked` 在台账里是工作包级，在轮级却没定义）；
- 新增状态时漏改某处，出现「文档说 done、INDEX 还 active」的漂移；
- `plan-ops.sh check` 无法据单一词表做契约校验。

因此：**词表只此一份，其余引用。**

## 状态全集（10 个）

| 状态 | 层级 | 含义 |
|---|---|---|
| `draft` | 轮 | 规划草稿，尚未交付三件套 |
| `active` | 轮 | 正在执行，同一时刻最多一个轮 active |
| `awaiting_user` | 轮 | 人工闸门态，等用户批准/评价（规划完成待批准、或执行完待主观确认） |
| `in_progress` | 轮 / 工作包 / 任务 | 正在推进中 |
| `done` | 轮 / 工作包 / 任务 | 验收全过、已收口 |
| `failed` | 工作包 / 任务 | 未通过验收或被判定失败 |
| `blocked` | 轮 / 工作包 | 被卡住（卡在用户/上游/环境），需登记阻塞项 |
| `superseded` | 轮 | 结论被后续轮整体取代 |
| `superseded-by-rNN` | 轮 | 被某一具体后续轮取代（rNN 为占位符，指代轮号） |
| `archived` | 轮 | 已压缩归档，三件套在 `archive/<轮>/`，细节回链 |

> 说明：`superseded` 与 `superseded-by-rNN` 是终态的两种记法——不指名用前者，指名用后者。

## 合法迁移

```
draft ──规划交付──> awaiting_user
awaiting_user ──用户批准开工──> active
awaiting_user ──用户否决/要求返工──> draft
active ──开工──> in_progress
in_progress ──验收全过──> done
in_progress ──需用户确认──> awaiting_user
in_progress ──卡住──> blocked
blocked ──解除阻塞──> in_progress
done ──被后续轮取代──> superseded / superseded-by-rNN
done / superseded / superseded-by-rNN ──压缩归档──> archived
```

人工闸门铁律：
- `awaiting_user` **只有用户明确点头**才能迁移到 `active` / `done` / `draft`；机器绿灯不得代替用户确认。
- `in_progress → done` 之前必须通过质量自检闸门与 `plan-ops.sh check` 零红。

## 非法迁移示例（防漂移）

| 非法迁移 | 为什么非法 |
|---|---|
| `draft → done` | 跳过规划交付与用户确认 |
| `awaiting_user → done`（无用户点头） | 人工闸门被机器绕过 |
| `active → archived` | 未收口就归档，决策会丢 |
| `blocked → done` | 阻塞未解除就宣布完成 |
| `done → in_progress`（同一轮复活） | 终态不可回退；要返工请新开轮 |
| `archived → active` | 归档轮不可直接复活；从 `archive/` 恢复需走显式流程 |

## 各状态进入/退出条件

| 状态 | 进入条件 | 退出条件 |
|---|---|---|
| `draft` | 新轮初始化、或被用户打回返工 | 三件套交付 → `awaiting_user` |
| `awaiting_user` | 规划交付 / 执行完待主观确认 | 用户明确答复 → `active`/`done`/`draft` |
| `active` | 用户批准开工 | 开工 → `in_progress` |
| `in_progress` | 开始逐工作包执行 | 验收全过 → `done`；待确认 → `awaiting_user`；卡住 → `blocked` |
| `done` | 验收全过 + check 零红 + 闸门过 | 被取代 → `superseded*`；压缩 → `archived` |
| `failed` | 工作包/任务验收失败 | 修复重试 → `in_progress`（工作包级） |
| `blocked` | 遇到需外部仲裁的卡点 | 卡点解除 → `in_progress` |
| `superseded*` | 被后续轮取代 | 压缩 → `archived` |
| `archived` | 四条件满足 + 用户批准压缩 | 终态（恢复需显式流程） |

## 各层级子集（引用本文件时的标准写法）

- 轮级（`ROUND.md` / `INDEX.md`）：用全集 10 词。
- 工作包级（`ledger.md` 工作包台账）：子集 `pending | in_progress | done | blocked`（`pending` 是工作包「未开始」记法，等价轮级尚未开工；注意全集无 `pending`，它是台账层专用记法）。
- 任务卡级（`TASK.md`）：子集 `pending | in_progress | done | failed`。

> 层级子集只列本层用到的词，其余以本文件全集为准；新状态先加入本文件全集，再逐层决定哪些层需要暴露。
