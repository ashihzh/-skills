# skills · 任务技能三件套

> task-planner(想清楚) + task-executor(干到底) + session-handoff-prompt(跨对话交接)，三份 skill 配套使用。
> 本仓库同时提供两种形态：根目录可直接阅读的 4 份 md，以及 skills 目录下可直接安装的原样文件。两边内容一致，根目录文件是入口，skills 是本体。

## 一页总览

| skill | 一句话 | 什么时候用 |
|---|---|---|
| [task-planner](task-planner.md) | 把不明确的需求变成可执行的计划，产出 plan.md + brief.md + ledger.md 三件套 | 用户说规划、做个计划、只出计划不执行、出个方案、怎么干、先想清楚、先规划后执行，或复杂任务想先对齐再动手 |
| [task-executor](task-executor.md) | 照三件套逐工作包执行，靠证据判定和止损稳定交付 | 用户说执行计划、开工、干活、继续、接着干、按计划做、接着上次做，或工作区已存在 plan.md 而用户要求推进 |
| [session-handoff-prompt](session-handoff-prompt.md) | 把本会话进展整理成给新对话的交接提示词文件 | 用户说总结一下、交接、给新对话、换个对话继续、接着上次做、继续优化 |

## 阅读顺序

1. 先读本文件(总览 + 目录)。
2. 按需读三份分册：task-planner.md -> task-executor.md -> session-handoff-prompt.md。
3. 三者的分工与状态载体：

| 项目 | task-planner | task-executor | session-handoff-prompt |
|---|---|---|---|
| 干什么 | 想清楚并写成计划三件套 | 照计划执行并回写台账 | 换对话的进度移交 |
| 状态载体 | 生成 .plan 三件套 | 持续回写 ledger.md | 一次性交接提示词文件 |
| 铁律 | 规划阶段只读、零副作用 | 证据判定、无证据不写完成 | 只写有证据的结论，推测进待验证 |

## 目录结构

```
README.md                      <- 本文件(总入口)
task-planner.md                <- 分册 1：可直接阅读的完整版(含模板与澄清清单附录)
task-executor.md               <- 分册 2：可直接阅读的完整版(含台账模板与方法附录)
session-handoff-prompt.md      <- 分册 3：可直接阅读的完整版(单文件 skill)
skills/
  task-planner/SKILL.md                  <- 可安装本体
  task-planner/assets/plan-template.md
  task-planner/assets/brief-template.md
  task-planner/references/clarify-checklist.md
  task-executor/SKILL.md                 <- 可安装本体
  task-executor/assets/ledger-template.md
  task-executor/references/method-and-selfcheck.md
  session-handoff-prompt/SKILL.md        <- 可安装本体(单文件)
tech-doc-docx/                   <- 原有目录(未动)
```

## 安装用法

- 把 skills 下对应目录复制到你的 skill 目录(如 DSH 的 skills 目录或项目的 .agents/skills)，即装好该 skill。
- 只想阅读：看根目录 4 份 md 即可，不用下钻。
- 三份 skill 配套使用：planner 出计划 -> executor 执行并回写 ledger -> 换对话时用 handoff 生成交接提示词。

## 配套纪律(通用)

- 全程用中文(含思维链)；代码、命令、路径、标识符保留原文。
- 事实带证据，假设要标注；没验证的只能写待验证。
- 任务具体内容只进任务工作区，不写回 skill 母版。
