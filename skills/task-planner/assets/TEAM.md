<!-- skill-version: 2.2.0 -->
# r<N> 团队映射（Agent Teams）

> 本文件是**计划侧**的团队定义。运行期状态在 `.agent-teams/`（不入库，不要读）。
> 单向同步：计划 → agent-teams，不反向回写。

| 项 | 值 |
|---|---|
| team 名 | `<team-name>` |
| 轮目标（= team description） | … |
| 审批方式 | `approval=required`（默认，需人工确认）/ `automatic` |

## 成员

| 成员 | 角色 | 模型 | 工具策略 | 负责任务 |
|---|---|---|---|---|
| `<name>` | … | 继承 | 默认 | `<task-slug>` |

## 任务 → agent-teams 映射

| 计划侧 | task 类型 | assignee | dependencies | inScope | acceptance |
|---|---|---|---|---|---|
| `tasks/<slug>/TASK.md` | work/implementation/verification/review | `<name>` | … | … | … |

## 回收条件

所有任务 terminal 且成员 idle → 汇报结果 → `agent_teams_delete`。
未完成的工作未经授权不得丢弃。
