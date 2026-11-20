# skills · 技能仓库

> 唯一事实源：`skills/` 目录。要安装哪个技能，直接复制对应子目录即可。
> 本仓库曾同时提供"根目录单文件版"，但它与 skills/ 本体长期不一致（旧版），自 v2.0.0 起已移除，避免新旧掺杂。

## 版本

| 版本 | 日期 | 说明 |
|---|---|---|
| v2.0.0 | 2026-11-21 | 多轮压缩内建两张主技能、撤销独立 task-compactor、移除过时根目录单文件版、重写本说明 |

版本号见两张主技能 frontmatter 的 `version` 字段；完整变更见 [CHANGELOG.md](CHANGELOG.md)。

## 一页总览

| skill | 一句话 | 什么时候用 | 版本 |
|---|---|---|---|
| [task-planner](skills/task-planner/SKILL.md) | 把不明确的需求变成决策完整的计划，产出 plan.md + brief.md + ledger.md 三件套；多轮压缩规则由它持有 | 用户说规划、做个计划、只出计划不执行、出个方案、怎么干、先想清楚、先规划后执行，或面对复杂任务想先对齐再动手 | v2.0.0 |
| [task-executor](skills/task-executor/SKILL.md) | 照三件套逐工作包执行，靠证据判定和止损稳定交付；用户要求或体积超阈值时自行执行多轮压缩 | 用户说执行、执行一下、开工、干活、继续、接着干、按计划做、按执行技能干活；或工作区有 .plan/ 而用户要求推进 | v2.0.0 |
| [session-handoff-prompt](skills/session-handoff-prompt/SKILL.md) | 把本会话进展整理成给新对话的交接提示词文件 | 用户说总结一下、交接、给新对话、换个对话继续、接着上次做、继续优化 | — |
| [tech-doc-docx](skills/tech-doc-docx/SKILL.md) | 把工程素材变成正式中文技术文档（.docx，三线表，四种文档范式） | 用户说技术文档、技术报告、操作手册、接口文档、模块说明、部署指南、.docx | — |

## 多轮规划压缩（v2.0.0 新增，内建能力）

压缩不是独立技能，而是 planner / executor 的内建能力：

- **谁持规则**：task-planner 的 `references/compact-rules.md` 定义断链压缩四条件（终态 / 链已断 / 同主题成组≥3 / 永不碰最近 5 轮）与合并产物模板 `assets/TOPIC.md`。
- **谁执行**：task-executor 在 `.plan/` 超过 200MB 或单轮超过 50MB 时提议压缩；用户说"压缩规划 / 归档 r50–r56 / 把这几轮合并一下"时直接自行执行。
- **授权开关**：`.plan/INDEX.md` 顶部的"压缩授权 manual/auto"——manual 时每次压缩前必须问用户，auto 一次开启长期生效。
- **边界**：归档到 `.plan/_attic/<轮>/`，原始证据进 `_attic/<轮>/evidence/`，轮内只留几 KB 的 `evidence.md` 索引；_attic 永不自动删。

## 目录结构

```
README.md                              <- 本文件（总入口 + 版本）
CHANGELOG.md                           <- 变更记录
skills/
  task-planner/                        <- 可安装本体（规划侧）
    SKILL.md                           <- v2.0.0（含 version 字段）
    assets/
      ROUND.md                         <- 轮次总览模板
      TASK.md                          <- 多任务卡模板
      TEAM.md                          <- 并行团队模板
      TOPIC.md                         <- 断链压缩合并产物模板（v2.0.0 新增）
      brief-template.md                <- 说明书/事实/红线模板
      plan-template.md                 <- 计划模板（含本轮清理义务）
    references/
      clarify-checklist.md             <- 复杂任务强制澄清清单
      compact-rules.md                 <- 断链压缩四条件（v2.0.0 新增，唯一判定依据）
      plan-layout.md                   <- .plan 目标目录契约
  task-executor/                       <- 可安装本体（执行侧）
    SKILL.md                           <- v2.0.0（含 version 字段，内建多轮压缩）
    assets/ledger-template.md          <- 台账模板
    references/method-and-selfcheck.md <- 执行方法论与自检
  session-handoff-prompt/SKILL.md      <- 可安装本体（单文件）
  tech-doc-docx/                       <- 可安装本体（可独立使用）
    SKILL.md
    agents/openai.yaml
    references/                        <- 内容风格/跨学科风格/文档范式/格式模板
```

## 安装用法

- 把 `skills/` 下对应子目录复制到你的 skill 目录（如 DSH 的 skills 目录或项目的 `.agents/skills`），即装好该 skill。
- planner 与 executor 配套使用：planner 出计划三件套 → executor 执行并回写 ledger → 需要多轮压缩时 executor 按 planner 持有的规则自行处理。
- session-handoff-prompt 与 tech-doc-docx 可独立使用。

## 配套纪律（通用）

- 全程用中文；代码、命令、路径、标识符保留原文。
- 事实带证据，假设要标注；没验证的只能写待验证。
- 任务具体内容只进任务工作区，不写回 skill 母版。

## 版本

| 版本 | 日期 | 说明 |
|---|---|---|
| 2.1.0 | 2026-11-21 | 修复 6 项质量缺陷、plan-ops.sh 随包、版本注释 |
