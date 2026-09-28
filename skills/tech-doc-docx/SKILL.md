---
name: tech-doc-docx
description: Generate or revise formal Chinese technical documentation in Word-compatible structure. Use when Codex needs to turn debugging records, hardware analysis, deployment steps, API specs, or module surveys into a polished .docx document that follows strict professional Chinese prose, three-line tables, cross-discipline readability, and one of four document patterns (technical report, operations manual, API spec, module description). Trigger when the user asks for 技术文档、技术报告、操作手册、接口文档、模块说明、手册、部署指南、烧录指南、引脚配置文档、寄存器分析、.docx 技术文档, or otherwise needs to convert raw engineering material into a formal Chinese technical document with three-line tables and Songti/Times New Roman typography.
---

# 技术文档与手册生成

Use this skill to write Chinese technical documents in Word-compatible structure from raw materials (debugging logs, hardware analysis, deployment steps, API signatures, source surveys). The skill supports four document types, two writing registers, and strict typography rules.

## When to trigger

Trigger whenever the user wants to convert engineering material into a formal Chinese `.docx` technical document. Common signals:
- 技术报告 / 硬件调试总结 / 方案选型文档 / 整改报告
- 操作手册 / 烧录指南 / 部署手册 / 环境搭建
- API 文档 / 接口说明 / SDK 集成文档
- 模块说明 / 组件文档 / 子系统职责说明
- "把这些调试记录整理成技术文档"
- "写一份 .docx 技术文档"

Do not trigger for weekly reports or progress summaries; use `weekly-report-docx` for those.

## Workflow

1. **Decide the document type.**
   Apply the decision tree in [references/doctype-patterns.md](references/doctype-patterns.md). When ambiguous, default to technical report and confirm with the user.

2. **Build the factual base.**
   Extract completed actions, observed results, verified numbers, unresolved items, and next steps from the source material. Do not invent facts; if source data is missing, state the gap.

3. **Pick the register.**
   Technical report → report register (背景—方案—验证—结论).
   Operations manual → procedural register (前置—步骤—预期—故障处理).
   API/module docs → reference register (清单—典型调用—数据结构—限制).
   The writing-style rules in [references/content-style.md](references/content-style.md) apply to all registers.

4. **Draft using the correct section template.**
   Follow the matching template in [references/doctype-patterns.md](references/doctype-patterns.md). Section titles may be renamed, but core sections must not be dropped; if a section lacks material, write a short paragraph stating the gap rather than skipping it.

5. **Apply cross-discipline readability.**
   Assume readers have engineering literacy but may not share the author's vocabulary. Explain `pinctrl`, `GRF`, `Maskrom`, and similar terms on first appearance. See [references/cross-discipline-style.md](references/cross-discipline-style.md).

6. **Build `.docx` with python-docx.**
   Use the bundled Python 3.12 runtime at `%LOCALAPPDATA%\Programs\Python\Python312\python.exe` and the installed `python-docx` package.
   - Fonts: 宋体 for CJK, Times New Roman for Latin.
   - Body: 12 pt (小四), 1.5 line spacing, 2-char first-line indent, justified.
   - Headings: Heading 1 = 16 pt bold; Heading 2 = 14 pt bold. No Heading 3.
   - Code blocks: Consolas 10.5 pt, left indent 0.5 cm, line spacing 1.15.
   - Tables: three-line only (top, header-bottom, bottom). No inside gridlines.
   - No cover page, no TOC, no header/footer, no auto-numbered paragraphs.
   Detailed implementation notes are in [references/format-template.md](references/format-template.md).

7. **Verify before delivering.**
   - Open the generated `.docx` via `python-docx` and confirm: paragraph count, heading levels, table row/col counts, table border topology (top=yes, bottom=yes, insideH=no, insideV=no).
   - Cross-check every number, register address, pin number, file path, and command string against the source material.
   - Verify each failure-summary paragraph explains both what was done and why the path failed, not only operations.

## Writing Rules

- Use objective, professional Chinese. Third person only. No slogans, no marketing tone.
- Write in connected, logically linked paragraphs. Use lists only for commands, files, checks, or other atomic items, not to replace argumentation.
- On first appearance, append a one-line functional explanation to abbreviations, module names, protocol names, and device codenames.
- Describe engineering purpose before implementation detail. End each major work item with the result and its effect on the next step.
- When verification is partial, say so explicitly. Do not overstate completion.
- Translate low-level operations into engineering purpose ("拆卸固定螺丝以便检查结构" rather than "拆了螺丝").
- Prefer problem-oriented statements ("为了确认信号通路是否可用，完成了输入输出测试") over activity-oriented ones ("测了输入输出").
- Technical term spellings, register addresses, command strings, and file paths must match the source exactly.

## Table Rules

- All tables are three-line: top border, header-bottom border, bottom border. No internal gridlines.
- Each table is preceded by one sentence introducing its purpose.
- Table titles sit above the table, centered, "表 N  …" format, numbered sequentially across the document.
- Header row cells center-aligned and bold. Body cells center-aligned.
- Cell paragraphs: first-line indent 0, line spacing 1.2.

## Output Notes

- If the user asks for Markdown only, preserve the same section structure and render three-line tables with the standard Markdown pipe syntax. Note where a real three-line table should appear in the `.docx` version.
- If the user asks for a `.docx` (default), generate it with python-docx following [references/format-template.md](references/format-template.md). Save to the user's writable workspace or the path the user specifies.
- Keep Chinese punctuation and spacing consistent throughout.
- When the audience is unspecified, default to a cross-discipline readable register that preserves technical detail while adding minimal background explanation.

## References

Read only the references needed for the current task:

- [references/content-style.md](references/content-style.md) — writing register, tone, first-use term rules, failure-summary style.
- [references/format-template.md](references/format-template.md) — `.docx` typography, three-line table implementation, code block layout.
- [references/doctype-patterns.md](references/doctype-patterns.md) — section templates for the four document types and the type-decision tree.
- [references/cross-discipline-style.md](references/cross-discipline-style.md) — cross-discipline translation rules and rewrite examples.

## Defaults and Assumptions

- Document language: Chinese. Embedded English terms keep their case.
- Default deliverable: `.docx` file in the user's writable workspace under the filename pattern `<topic>-tech-doc.docx` unless the user specifies otherwise.
- Python runtime: `%LOCALAPPDATA%\Programs\Python\Python312\python.exe`. Verify with `python -c "import docx"` before building.
- No cover page, no TOC, no header/footer, no auto-numbered placeholder text.
- When the user does not specify the audience, assume cross-discipline readability.
- When source material is inconsistent or missing, state the gap explicitly rather than fabricating.
