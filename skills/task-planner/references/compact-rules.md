# 断链压缩规则（多轮规划压缩的唯一判定依据）

> 本规则由 task-planner 持有、task-executor 执行时遵守。多轮累积需要压缩历史轮时，四条候选条件全部满足才算候选，任一不满足 → 不压并说明原因。

## 候选判定（四条全满足才算候选）

1. **状态终态**：状态 ∈ {`done`, `superseded`, `superseded-by-rNN`, `archived`}。
   状态含 `draft` / `active` / `planned` / `awaiting_user` / `in_progress` 的一票否决。
2. **链已断**：没有任何**未归档**轮的「继承自」字段指向它。
   （终态轮之间互相继承是允许的——只要最下游那一轮自己也被压进同一组，或它已归档。）
3. **同主题成组 ≥ 3**：组内各轮 slug 共享主题词，或 `ROUND.md` 的「目标」有 ≥ 2 个共同关键词。
4. **不在保护窗内**：按轮号降序取最大 5 个轮号，这 5 轮永不参与压缩。

任一条件不满足 → 不压，向用户说明是哪条卡住。

## 执行顺序

1. `plan-ops.sh compact-audit`：只读，输出候选组、每组合并后体积、被删/被留清单。
2. 用户批准（`INDEX.md` 的 `压缩授权：auto` 时跳过），或按预授权直接执行。
3. `plan-ops.sh archive --rounds rNN-rMM`：三件套 → `archive/<轮>/`（evidence 删除前先落 `_evidence-manifest.tsv`）。
4. 写 `archive/topics/<主题>-rNN-rMM.md`（模板见 `assets/TOPIC.md`）。
5. 更新 `INDEX.md` 的「已压缩组」表与被压各轮的状态行（状态改 `archived`）。
6. 收尾 `plan-ops.sh check` 零红。

## 压缩产物必写项（丢了这些就等于丢决策）

- 轮次范围、每轮原状态、每轮一句话目标
- 该组共有的设计决策（含「为什么否决了另一个方案」）
- 关键路径 / 端口 / 服务名 / commit hash
- 踩过的坑与规避（可直接复用）
- 指向 `archive/<轮>/plan.md` 的链接（细节还查得到）

## 硬边界

- `_attic` 永不自动删；本技能不碰 `_attic`。
- 归档/清理默认 dry-run，实动前先看 dry-run 输出。
- 一次只压一组；多组分批，每组独立审批。
- `manual` 授权下没拿到用户明确点头，不得执行第 3 步。
