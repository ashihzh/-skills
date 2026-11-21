# 变更记录（CHANGELOG）

本仓库遵循语义化版本（SemVer）。版本号标注在两张主技能 frontmatter 的 `version` 字段，并以 git tag 固化。

## v2.2.0 (2026-11-21)

### 能力升级（非格式补丁）

本次为两张主技能的**机制层能力升级**，从既往缺陷与改进出发，落地六项可核对能力：

- **单一状态机**（task-planner）：新建 `references/state-machine.md` 作为轮次/任务状态全集与合法/非法迁移的唯一权威，5 个模板改为引用，不再各自重复列全表。
- **开工契约校验 doctor**（共享）：`plan-ops.sh` 新增第 6 个子命令 `doctor`——只读、零副作用、只告警不阻断，校验生效轮行/轮目录白名单文件/INDEX 头部契约/ROUND 状态漂移/裸 evidence；task-executor 入口自发现改为第 3 步即调用，有告警停下确认。
- **意图层守护**（两技能）：brief 新增「用户原话决策（最高优先级）」区，决策表加「来源」列；书面结论与用户原话冲突时强制停下问用户，不得按书面结论执行。
- **反假阳性验收**（task-executor）：`references/method-and-selfcheck.md` 新增「反假阳性验收」——精确值断言（解析字段真值再比，禁「含字符串即 PASS」）+ 负向测试（证明断言能判 FAIL）+ 关键项现场复核。
- **反模式库**（task-planner）：新建 `references/anti-patterns.md`，把反复踩的坑抽象为通用反模式（现象/根因/规避/检测信号），两技能互相引用；只写抽象类型，不含具体任务内容。
- **版本语义与能力清单**（两技能）：两张 SKILL.md 新增「能力清单（v2.2.0）」节，逐条指向能力实现文件与验证方式，使版本号表达真实能力而非格式变动。

### Changed

- 两技能 `version` 升至 2.2.0，13 个 md 的文件级版本注释同步更新；历史教训里引用的旧版本号作为例子保留。
- CHANGELOG、README 同步本轮能力升级说明与版本表。

## v2.1.0 (2026-11-21)

- 修复 6 项质量缺陷（1 P0 + 2 P1 + 3 P2）：plan-ops.sh 随技能包分发、轮内文件矛盾、入口定位、manifest 路径、description 精简、自查措辞。
- 两技能 version 升至 2.1.0，13 个 md 加文件级版本注释；压缩能力保持内建（无独立技能）。

## [2.0.0] - 2026-11-21

### Added
- 多轮规划压缩能力内建到 task-planner / task-executor：断链压缩四条件（`references/compact-rules.md`）、合并产物模板（`assets/TOPIC.md`）、目标目录契约（`references/plan-layout.md`）。
- 新增本 CHANGELOG；两张主技能 frontmatter 加 `version: 2.0.0`。

### Changed
- 撤销独立 task-compactor 技能（推翻 r58 规划 D4），压缩能力并入两张主技能，不引入第三个技能。
- 重写 README.md：删除"根目录与 skills 两边内容一致"的失效承诺；目录树按真实文件清单补全；新增多轮压缩能力说明与版本表。
- 发布流程规范化：改动先落分支、开 PR、经审批后再合并，不再直接推 main。

### Removed
- 移除根目录 4 个单文件版（task-planner.md / task-executor.md / tech-doc-docx.md / session-handoff-prompt.md）：它们是返工前的旧版，长期与 `skills/` 本体不一致，是"新旧掺杂"的根源。仓库此后以 `skills/` 为唯一事实源。

### Notes
- tech-doc-docx 与 session-handoff-prompt 本次未改内容（本地无母版，无法核对是否最新），仅从 README 链接与结构上纳入统一说明。

## [1.x] - 历史（未单独标注语义化版本）

早期提交未使用语义化版本：`Add files via upload` / `upload skill trio` / `normalize tech-doc-docx` / `upgrade trio to latest versions`。历史内容可从 git 记录追溯。
