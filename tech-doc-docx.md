> 本文件是 skill(tech-doc-docx)的可读完整版：正文 = skills/tech-doc-docx/SKILL.md 原样，附录收录 agents 与 references 原样。想安装请直接复制 skills/tech-doc-docx 目录。

---

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


---

# 附录 A：agents/openai.yaml

```yaml
interface:
  display_name: "技术文档与手册生成"
  short_description: "生成中文技术报告、操作手册、API 文档与模块说明 .docx"
  default_prompt: "用 $tech-doc-docx 把这些调试记录整理成一份技术文档"
```

---

# 附录 B：references/content-style.md

# 写作语体与风格规范

本文件给出 tech-doc-docx 技能在内容层面的写作要求：语体选择、语气、首现术语、失败总结与结果表述。

## 语体

根据文档类型选择对应语体，同一段内不要混用多种语体。

- 技术报告：报告语体（背景→方案→验证→结论）
- 操作手册：程序语体（前置→步骤→预期→故障处理）
- API / 接口文档：参考语体（清单→典型调用→数据结构→限制）
- 模块说明 / 组件文档：参考语体同上

## 语气

- 使用客观、正式的中文。第三人称行文，不出现"我""我们"。
- 无口号、无宣传语、无主观评价。
- 描述工程目的优先于操作细节。
- 用"由于 …""为了 …""由此 …""为此 …"等连词推进因果，而非罗列现象。

## 段落组织

- 段落叙述为主，不用项目符号列表去展开方案设计或论证。
- 列表仅用于命令、文件、检查项等硬性条目。
- 每段大块工作叙述按"任务目标→实施动作→系统含义→当前结果→下一步影响"组织，融在一段连贯叙述里，不暴露为编号列表。
- 保持每段只聚焦一件事，避免一段内堆叠多个不相关动作。

## 首现术语

- 缩写、模块名、协议名、设备代号在首次出现时附一句话功能说明。
- 括号注释示例：`pinctrl`（pin controller，即管理引脚复用和上下拉配置的内核子系统）。
- 后文可省略括号注，但保留术语本体。
- 一句话里不要堆叠 3 个以上未解释缩写。

## 失败总结风格

- 每段保持"尝试→根因→为什么否决"三段式。
- 不堆叠完整调试史，只取关键失败项。
- 篇幅不超过报告三分之一。
- 失败段落要同时说明做了什么、为什么此路径不通，而非仅列举操作。

## 结果表述

- 验证了一条路径
- 缩窄了故障定位范围
- 明确了接口职责
- 降低了集成阶段的不确定性
- 暴露了尚未解决的依赖关系或已识别风险

## 避免出现

- 整段只写操作不写目的。
- 把局部验证写成全部完成。源材料仅支持部分进度时，明确写"已完成 …、尚待验证 …"。
- 退化成科普或教材，从基础知识讲起。
- 用口语化模糊词替换精确术语（例：把"GPIO 上拉"写成"把脚变成高电平"）。
- 占位符（如 TODO、XXXX）。
- 跨语言混排自动切换（保持中文字段用宋体，英文字段用 Times New Roman，不要全文某一字体）。

---

# 附录 C：references/cross-discipline-style.md

# 跨学科可读性

本文件给出 tech-doc-docx 技能如何让技术文档在被跨学科读者阅读时仍能保持自洽。

## 默认读者模型

具备工程素养，但可能不熟悉：
- 项目的特定缩写
- 模块、包名、文件名
- 硬件接口、引脚、寄存器
- 通信协议、控制算法
- 系统特定的运维术语与代名词

不要从基础知识讲起，只在断层点补一句话。

## 段落骨架

每段大块工作叙述时优先按以下顺序组织，但不要暴露成可见的编号列表，而是融在一段连贯叙述里：

1. 任务目标（这件事要解决什么问题）
2. 实施动作（具体做了什么）
3. 系统含义（在整个系统的位置、对其他模块的影响）
4. 当前结果（验证到哪一步、暴露了什么）
5. 下一步影响（为后续工作开了什么口子、挡了什么路）

## 翻译规则

### 首现术语

首次出现的术语、模块、协议、设备，附一句话功能说明。示例：

- `pinctrl`（pin controller，即管理引脚复用和上下拉配置的内核子系统）
- `GRF` 即 General Register Files，是 RK3588 用于配置 GPIO 上下拉和驱动强度的寄存器组
- `Maskrom` 模式，即 Rockchip 芯片最底层的 USB 烧写模式，U-Boot 都进不去时仍能进入

### 底层动作转工程目的

不要写“拆下电机螺丝”，写“拆卸目标电机固定螺丝，以便检查电机本体和安装结构”；
不要写“复现历史驱动方法”，写“重新梳理并复现历史驱动方法，确认旧方案在新硬件状态下是否仍然适用”。

### 问题导向而非操作导向

- 弱：“本周测试了输入输出模块。”
- 强：“为确认控制器硬件与外部执行部件之间的信号通路是否可用，完成了输入输出模块测试。输入输出模块承担现场信号接入与动作触发的基础作用，因此这一步主要用于先排除底层 I/O 通道异常，为后续联调减少定位范围。”

## 结果表述用工程视角

- 验证了一条路径
- 缩窄了故障定位范围
- 明确了接口职责
- 降低了集成阶段的不确定性
- 暴露了尚未解决的依赖关系或已识别风险

用“由于 …”“为了 …”“由此 …”等连词推进因果。

## 避免

- 一句话里堆叠 3 个以上未解释缩写
- 整段只写操作不写目的
- 把局部验证写成全部完成
- 退化成科普或教材
- 用口语化模糊词替换精确术语（例：把“GPIO 上拉”写成“把脚变成高电平”）

## 改写示例

**操作流版本**：“完成了 PLC 扩展模块输入输出测试。”

**跨学科可读版本**：“为确认控制器与外部执行部件之间的信号通路是否可用，完成了 PLC 扩展模块（扩展模块，即用于在控制器之外接入更多现场信号并触发动作的接口模块）的输入输出测试。该模块承担现场信号接入和动作触发的基础作用，这一步主要用于先排除底层 I/O 通道异常，为后续联调减少定位范围。”

**仅复盘版本**：“测试了遗留电机驱动方法。”

**跨学科可读版本**：“对遗留电机驱动方法进行了重新梳理和复现测试，目的是建立对当前控制链路的共同理解，并判断历史方案在现有硬件状态下是否仍然适用。该工作不仅服务于方法复现，也用于缩小后续问题定位范围。”

---

# 附录 D：references/doctype-patterns.md

# 各类文档分节模板

本文件给出 tech-doc-docx 支持的四类文档的分节结构。SKILL.md 负责文体选择，这里负责确定章节顺序与每节应写什么。

## 通用原则

- 根据用户请求或源材料判断文档类型后，按对应分节模板组织正文。
- 模板是骨架，章节标题可调整，但**不能省略关键章节**。若材料不足以支撑某节，写一段简短说明表明依据不足，而非留空跳过。
- 生成的 .docx 不含目录、不含封面；用户另有要求时再补充。

## 一、技术报告

适用：硬件调试总结、方案选型与验证、整改报告、问题排查报告。

### 章节模板

1. **任务背景**（或问题描述）— 这件事为什么发生、目标是什么、约束条件是什么。
2. **环境与边界**（硬件 / 软件版本、引脚、寄存器、依赖与前提）— 用三线表列出关键参数。
3. **方案设计 / 选定路径**（核心章节，最详）— 选了什么方法、为什么选它、相比其他路径的优势。
4. **验证方法**（命令、测试装置、读取方式）— 让读者照做即可复现。
5. **关键失败总结**（可选）— 保持每段“尝试—根因—为什么否决”三段式，不堆叠完整调试史。
6. **结论**（或后续建议）— 现在可用什么、还差什么、近期和中长期方向。

### 写作要点

- 段落叙述，**不用**项目符号列表去展开方案设计。列表仅用于命令、文件、检查项等硬性条目。
- 寄存器地址、引脚编号、命令字符串一律等宽字体。
- 技术术语首现加功能说明，后文可省略括号注。
- 失败总结不超过报告篇幅三分之一，避免喧宾夺主。

## 二、操作手册

适用：烧录指南、环境搭建、固件升级、部署流程。

### 章节模板

1. **概述**（30 字内说清本手册能够完成的目标，例：“本手册描述如何将 Neardi PI4 通过 Maskrom 模式恢复 eMMC 固件”）。
2. **前置条件**（材料、软件、权限、网络）— 列表或三线表清晰呈现，让读者准备齐再开始。
3. **操作步骤**（核心章节）— 编号步骤，每步一行命令或一段简短说明，长命令单独成行用等宽字体。
4. **预期输出**— 每组步骤后给一段“正确执行后，应看到 …”的判读标准。
5. **故障排查**— 列出常见错配、错误信息与对应解法，用三线表。
6. **后续操作**— 完成本手册后下一步可做什么，点出相关手册或参考链接，但不堆叠外链。

### 写作要点

- 步骤用 `1.`、`2.`、`3.` 编号，不加自动编号域。
- 命令、文件路径、配置行用等宽字体，单行。
- 每步只做一件事，不把多个动作写成一个长步骤。
- 故障排查用三线表（错误现象 / 可能原因 / 处理动作），不要写散文。

## 三、API / 接口文档

适用：内部函数接口、驱动 HAL、通信协议、SDK 集成说明。

### 章节模板

1. **模块概述**（一句话功能说明 + 整体在系统中位置）。
2. **接口清单**（三线表）：函数名 / 参数 / 返回 / 触发条件 / 是否阻塞。
3. **典型调用**（最小可用示例）— 用代码块，加 3 行内注释。
4. **数据结构**（结构体 / 枚举 / 状态码）— 用三线表，不要写成散文。
5. **错误码与重试逻辑**（三线表）。
6. **依赖与版本兼容**— 列依赖模块、版本范围、已知不兼容项与原因。
7. **已知限制**。

### 写作要点

- 函数名、参数名、类型名一律等宽字体。
- 默认假设读者会编程，不要解释“什么是参数”。
- 用功能而非实现细节作引出。“用于将 GPIO 设置为上拉输入”比“内部写 GRF 寄存器”更适合开头。

## 四、模块说明 / 组件文档

适用：源码模块、子系统、外设驱动模块、微服务的职责与边界说明。

### 章节模板

1. **模块概述**（系统层级图中的位置，一句话职责）。
2. **关键文件**（三线表：名称 / 路径 / 主要职责）。
3. **对外接口**（输入输出、依赖方向、消费方）。
4. **内部结构**（子组件、数据流、状态机、线程模型之一，按模块性质选一段）。
5. **关键算法或状态机**（仅在确有必要时才给；不必硬编一节）。
6. **配置项与启动顺序**。
7. **已知问题与未来方向**。

### 写作要点

- 罗列文件时保持文件名精确，不要缩写。
- 当材料是源码分析结果时，保留事实层面（做什么、被谁调用），在结论层不要硬下判断还没验证的事。
- 控制篇幅，模块文档不应超过 3 页，超出时考虑拆分。

## 文体判定决策树

判断流程：

1. 用户请求是否包含“手册”“指南”“怎么操作”“部署”“烧录”这类词？→ **操作手册**。
2. 否则，是否提到 API、函数、接口签名、请求/响应？→ **API 文档**。
3. 否则，是否提到某模块、子系统、组件的职责、文件清单、依赖关系？→ **模块说明**。
4. 否则，是否提到调试、方案、选型、验证、问题排查、整改？→ **技术报告**。
5. 仍判断不了，默认 **技术报告**，并向用户确认。

若一个请求既像操作手册又像技术报告（例：“先写烧录步骤，再讲为什么这么烧”），优先 **操作手册**骨架，在末尾加一节“为什么按此顺序”收尾。

---

# 附录 E：references/format-template.md

# .docx 排版规范

本文件给出 tech-doc-docx 技能生成 Word 文件的排版规则。所有技术文档类 .docx 必须遵守。

## 页面

- A4（默认），不强制修改
- 上下边距 2.54 cm，左右边距 3.18 cm
- 不生成封面页、不生成目录页、不生成页眉页脚
- 默认正文区从第一页第一行开始

## 段落

| 项 | 值 |
|---|---|
| 中文字体 | 宋体 |
| 英文字体 | Times New Roman |
| 正文字号 | 小四（12 pt） |
| 行距 | 1.5 倍 |
| 段前段后间距 | 0 pt |
| 首行缩进 | 2 字符（≈0.74 cm） |
| 对齐 | 两端对齐 |

标题、图表说明可放宽上述部分要求，见下文各小节。

## 标题层级

- 一级标题：16 pt 加粗，左对齐，段前段后各 6 pt，首行缩进 0，使用 Heading 1 段落样式。
- 二级标题：14 pt 加粗，左对齐，段前段后各 4 pt，首行缩进 0，使用 Heading 2 段落样式。
- 不出现三级及以上标题。需要细分小节时改用段落加粗首句开头的方式。
- 技术报告中一级标题建议用中文序号“一、二、三、”，如“一、任务背景”。

## 代码块

代码、shell 命令、配置片段用独立段落，左缩进 0.5 cm，行距 1.15 倍，无首行缩进，无段前后间距。字体用等宽字体（Consolas）。
- 字号 10.5 pt（五号）
- 长命令不要折行，必要时可超出页边距
- 命令块前后各空一行
- 多行命令按原始换行保留，不要硬塞成单行

## 三线表

技术文档所有表格一律用三线表，**不使用全网格线**：

- 顶边：一根横线
- 列头下方：一根横线
- 底边：一根横线
- 表体内部、表头与表体之间、列间一律**无分隔线**

操作要点：
- 表标题在表格上方，居中，字号 12 pt 加粗。命名格式“表 1  引脚与 sysfs 编号对照表”。
- 表前一段必须用一句话引出此表，如表的用途、为什么列这几列。
- 列头居中加粗，表体居中。重要对比列可加粗。
- 单元格内段落首行缩进置 0，行距 1.2 倍。
- 不画斜线表头、不合并行、不在表内嵌套表。

python-docx 实现要点：
- 通过 `w:tblBorders` 设 top/bottom = single, sz=8，insideH/insideV 不设或设 nil。
- 列头行各单元格 `tcBorders` 加 bottom = single, sz=8 作为分隔横线。
- 单元格段落 `first_line_indent` 置 0、`line_spacing = 1.2`、`alignment = CENTER`。

## 图与公式

- 图标题位于图下方，居中，加“图 1 …”。
- 图上方必须有一段引出文字。
- 公司或产品 logo 不作背景水印，不设页眉图案。
- 公式用 MathType 输入（用户若未强调，本技能不强制插入公式对象）。

## 命名与编号

- 表号、图号按出现顺序连续编号，不按章节分级。
- 操作手册的步骤编号用 `1.`、`2.`、`3.`，紧跟文字。示例：“1.  断开板子电源。\n2.  按住 BOOT 键不放。”
- 步骤内子项可用圆点项目符号，但不要形成超过两级嵌套。

## 不要出现

- 自动生成的 Word 目录（TOC）
- Word 自动编号段落
- 占位符（如 TODO、XXXX）
- 跨语言混排自动切换（保持中文字段用宋体，英文字段用 Times New Roman，不要全文某一字体）
- 在每段开头加缩进圆点（除非用项目符号列表）


