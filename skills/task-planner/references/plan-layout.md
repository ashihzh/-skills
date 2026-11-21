<!-- skill-version: 2.2.0 -->
# `.plan/` 布局契约（规划与执行的绑定点）

> 规划技能**写**这个布局；执行技能**读**这个布局。两边的唯一契约就是 `.plan/INDEX.md`。
> 只要这个契约成立，用户说「执行一下」就够了——不需要报路径，也不需要贴交接提示词。
>
> **本文件是「目标目录契约」的唯一权威定义**：规划时按它初始化轮目录，执行时按它落盘临时产物与证据，`plan-ops.sh check` 按它判红违规。
> 目标：让 `.plan/` 长期保持「只有三件套 + `ROUND.md` + `INDEX.md` + 每轮一份几 KB 的 `evidence.md`」，垃圾一律进 `_attic/`。

## 目标目录契约（定稿，不得另起炉灶）

```
<workspace>/.plan/
  INDEX.md                 ← 唯一入口。必含：当前生效轮 / 压缩授权开关 / 近轮表 / 已压缩组表
  _attic/                  ← 垃圾区，永不自动删
    <轮>/tmp/              ← 探针/调试/一次性产物（跑的时候直接写这里）
    <轮>/evidence/         ← 原始证据（日志/截图/json）
    skill-backup/<ts>/     ← 技能母版升级前的整目录备份
    _root-tmp/             ← 历史根目录散落 `_*` 文件的集中处
  _tools/
    plan-ops.sh            ← 唯一合法的清理/归档/审计/校验工具（默认 dry-run）
  archive/
    <轮>/                  ← 已完结轮的三件套（evidence 已挪 attic）
    topics/                ← 压缩产物（多轮合并成一份 topic md）
    _evidence-manifest.tsv ← 删 evidence 前的路径+字节+md5 清单
  <轮>/
    ROUND.md plan.md brief.md ledger.md evidence.md
    tasks/<任务>/          ← 仅多任务轮/团队轮
    TEAM.md                ← 仅团队轮
```

四块专用区，各自唯一去处，**不得混用**：

| 区 | 放什么 | 谁写 | 生命周期 |
|---|---|---|---|
| `_attic/<轮>/tmp/` | 探针、调试脚本、一次性产物 | 规划/执行当场写 | 永不自动删，用户手动清 |
| `_attic/<轮>/evidence/` | 原始证据：日志、截图、json、命令原始输出 | 执行 | 永不自动删 |
| `_tools/plan-ops.sh` | 清理/归档/压缩审计/违规检查 | 技能随附 `assets/plan-ops.sh`；工作区缺时从它复制过去 | 长期保留 |
| `archive/` | 已终态轮的三件套 + 压缩合并产物 | 压缩流程 | 长期保留 |

## 写入位置先定后写（硬规则，非建议）

任何探针/调试/一次性脚本，**落盘前**先确认目标路径在 `_attic/<轮>/tmp/`。
写进轮目录（`<轮>/*.mjs`、`*.py`、`*.sh`）或 `.plan` 根目录 = 违规，`plan-ops.sh check` 判红。

## 证据两段式（硬规则，非建议）

- **原始证据**（完整命令输出、截图、json、日志）→ `_attic/<轮>/evidence/`。
- **轮目录只维护 `evidence.md`**：一行一条，含「结论 / 路径 / 命令或哈希 / 时间」。
- 轮目录内出现 `evidence/` 目录、或出现 `*.png`、`*.json`、`*.mjs`、`*.sh` = 违规（`check` 判红）。

## 收工必跑校验（硬规则，非建议）

规划交付前、执行收工前，都必须跑 `bash .plan/_tools/plan-ops.sh check`；有任何红灯不得把状态写成 `done`。

## `INDEX.md` 必须包含什么（执行技能据此定位）

1. 一句 **`当前生效轮：<轮目录名>`**（执行技能靠它找目录）。
2. 一行 **`压缩授权：manual / auto`**：`manual` 时每次压缩前必须问用户；`auto` 时按预授权直接执行。改一次永久生效。
3. 一行 **`体积水位：<时间> 实测 <大小>`**：供执行技能判断是否需要提议压缩。
4. 一张**两级轮次表**：近 5 轮（完整列）+ 历史（轮 / 目录 / 状态 / 一句话）。
5. 一张**已压缩组表**（本轮为空，留给 compact 填）。
6. 状态词以 `references/state-machine.md` 为**唯一权威**（轮级全集 10 词，不在此重复列举）；本处只保留约束：**同一时刻最多一个 `active`**；新轮转 active 时，上一轮必须显式改成 `done` 或 `superseded`。

## 压缩授权与保护窗（规划期就要写清）

- 压缩授权开关在 `INDEX.md` 顶部，`manual` 为默认安全值。
- **最近 5 轮永不参与压缩、永不被 `archive` 移走**（`plan-ops.sh` 内 hardcode 为 5）。
- 历史轮的 `plan.md`/`brief.md`/`ledger.md`/`ROUND.md` 三件套原样进 `archive/<轮>/`，不合成一份大 `HISTORY.md`。
- 多轮压缩的合并产物统一放 `archive/topics/<主题>-rNN-rMM.md`（即 `archive/topics/` 目录），细节仍回链到 `archive/<轮>/plan.md`。

## `ROUND.md` 必须包含什么（执行技能据此判断能不能开工）

| 字段 | 用途 |
|---|---|
| 类型 | 单任务 / 多任务 / 团队 |
| 状态 | 与 INDEX 一致 |
| 继承自 / 本轮废弃 | 消灭「新旧计划互相矛盾」 |
| 目标 | 一句话 |
| 验收口径 | 可判定 |
| **下一步** | 执行技能开工后第一件事就是读这句；若写「未放行/待批准」，必须先问用户 |
| 证据索引 | 指向本轮 `evidence.md` |
| 临时产物目录 | 本轮 `_attic/<轮>/tmp/` |

## 三种轮形态

- **单任务轮**：工作包写在 `plan.md` 里，**不建 `tasks/`**。不为了对称硬造空目录。
- **多任务轮**：`tasks/<任务>/TASK.md`（目标/写范围/依赖/验收/负责人）+ 任务级 `brief.md`/`ledger.md`；轮级三件套作「总」。
- **团队轮**：同多任务，另加 `TEAM.md` 记录计划侧↔agent-teams 映射。

## 单一事实源规则（防「同一件事写四遍」）

决策→`plan.md`；事实→`brief.md`；过程与证据→`ledger.md`；证据索引→`evidence.md`；索引进 `INDEX.md`；`handoff.md` 是导出物、不得当事实源。

## 台账双区制（防「越写越长没人看」）

`ledger.md` 顶部「当前状态」覆盖式更新、永远一屏；下方历史只追加不改写。执行技能只读上半屏。

## 规划收尾自查（新增）

1. 新轮目录里只有 `ROUND.md`/`plan.md`/`brief.md`/`ledger.md`/`evidence.md`（+ 多任务 `tasks/`、团队 `TEAM.md`）。
2. `INDEX.md` 三行头部（生效轮 / 压缩授权 / 体积水位）+ 两级表 + 已压缩组表齐全。
3. `bash .plan/_tools/plan-ops.sh check` 零红。
4. 母版零任务内容：技能文件里不出现本任务的具体轮号、slug、commit。
