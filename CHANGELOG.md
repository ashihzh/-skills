# 变更记录（CHANGELOG）

本仓库遵循语义化版本（SemVer）。版本号标注在两张主技能 frontmatter 的 `version` 字段，并以 git tag 固化。

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
