# memsync

> **语言:** [English](./README.md) · **简体中文**

一份开箱即用的 Markdown 脚手架,为 **Claude Code** 和 **Codex**(以及任何遵循
`AGENTS.md` / `CLAUDE.md` 约定的 agent)提供同一个、可纳入版本控制的共享项目
内存。从此两边工具不会再各自维护一套对项目的理解。

## 这是什么

`.ai/` 目录下的 7 个小型 Markdown 文件,加上根目录的两个轻量适配器:

```
.ai/
  README.md              # 约定与阅读顺序
  project.md             # 目的、相关方、范围、非目标
  architecture.md        # 技术栈、目录结构、组件、关键决策
  definition-of-done.md  # 本仓库的"完成"标准
  review-checklist.md    # PR 评审清单
  memory.md              # 稳定的共享知识
  handoff.md             # 最近一次任务的滚动状态
CLAUDE.md                # Claude Code 适配器 —— @./path 导入
AGENTS.md                # Codex / 通用适配器 —— 显式阅读顺序
```

`CLAUDE.md` 与 `AGENTS.md` 不会复制 `.ai/` 内的任何内容,它们只做指向。每个
agent 看到的是同一套文件、同样的顺序。

## 为什么需要它

- **Claude Code** 原生支持读取 `CLAUDE.md` 并解析 `@./path` 形式的导入。
- **Codex** 与若干其他 agent 把 `AGENTS.md` 当作纯指令文件来读。
- 没有统一布局时,两边会逐渐偏离:一边记得的决定另一边没有,人工合并成本越来
  越高。

本仓库提供的是让双方共享同一份项目内存所需的**最小约定**,不绑定具体语言、
框架或 agent 运行时。

## 快速上手

### 方式 A —— 作为模板仓库使用

1. 在 GitHub 上点 **Use this template**(需先在仓库设置中启用),或直接
   fork。
2. 克隆你自己的副本。
3. 修改 `.ai/project.md` 与 `.ai/architecture.md`,如实描述你的项目。
4. 把 `.ai/definition-of-done.md` 中的 *Required commands* 一节,替换为你
   项目真实的 build / test / lint 等命令。
5. 重写 `.ai/handoff.md`,把"接入本脚手架"作为最近一次任务记录下来。

### 方式 B —— 拷贝进已有仓库

```bash
git clone https://github.com/SUN-1024/memsync scaffold
cp -r scaffold/.ai ./
cp scaffold/CLAUDE.md scaffold/AGENTS.md ./
rm -rf scaffold
```

随后按方式 A 的步骤修改文件即可。

## agent 是如何读这套文件的

```
会话开始
  Claude Code   ─► CLAUDE.md  ─► 解析 @-imports ─► 按顺序加载 .ai/*
  Codex / 其他  ─► AGENTS.md  ─► 按编号清单读取 ─► 按顺序加载 .ai/*

agent 开始工作
  在报告"完成"之前:
    更新 .ai/handoff.md   (每次都更新)
    更新 .ai/memory.md    (出现稳定事实时)
```

阅读顺序固定为:
`README.md → project.md → architecture.md → definition-of-done.md → review-checklist.md → memory.md → handoff.md`。

## 唯一的运行时规则

在**任何一次**实现、调试、重构、评审、文档、初始化、依赖、配置、测试相关任务
之后,**先更新 `.ai/handoff.md`,再宣布任务完成**。如果在过程中发现了关于本
项目的稳定知识,请把它追加到 `.ai/memory.md`(或最相关的 `.ai/` 文件)中,
作为同一次变更的一部分提交。

不要在 `.ai/` 中写入 `TODO` / `TBD` 或占位文本。如果某个事实本仓库尚未定义,
请用一句话明确说明"未定义"。

## 这不是什么

- 它不是运行时、库、CLI,也不是特定语言的框架。
- 它不是 hook 系统或 `settings.json` 生成器(那些属于使用方项目)。
- 它不偏袒任何一个 agent —— 两个适配器是平等的。

## 许可证

[MIT](./LICENSE)
