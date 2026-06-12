# 设计类 Skill 选型与资源

## 四个设计 skill 怎么选

| 场景 | 用哪个 | 说明 |
|------|--------|------|
| 落地页 / 营销页 / 作品集 / 重设计 | **design-taste-frontend** | 反模板审美（anti-slop），先读 brief 再推断设计方向；这类页面优先于通用前端 skill |
| Dashboard / 多步产品 UI / 通用组件 | **ui-ux-pro-max** 或 **frontend-design** | design-taste-frontend 明确不适用于产品型 UI |
| 指定某种风格实现（如 Glassmorphism、Neubrutalism） | **ui-ux-pro-max** | 内置 84 种风格的结构化规范（配色/动效/适用与禁用场景），报风格名即可 |
| 海报 / 静态视觉 / 艺术作品 | **canvas-design** | 输出 PNG/PDF 而非网页 |

## design-taste-frontend 使用须知

- 来源 Leonxlnx/taste-skill（GitHub 40k+ star，star 有水分，更可靠指标是 skills.sh 13.4 万安装量）
- **Token 开销大**：单个 SKILL.md 约 87KB（触发时注入约 2 万 token），值得用在落地页类任务，日常小改动注意别误触发
- 强绑 React/Next.js + Tailwind，Vue/Svelte 移植性差
- 同仓库其余 12 个兄弟 skill 经评估**不建议常驻安装**：redesign/minimalist/soft/gpt-taste/v1/stitch/output 直接跳过（与主 skill 重复或为单一风格硬模板）；brandkit/imagegen-web/imagegen-mobile/brutalist 按需临时装

## 设计风格百科（自建资源）

**https://cc.gjs.ink/design-styles** —— ui-ux-pro-max 全部 84 种 UI 风格的中文图鉴（源文件 `site/design-styles.html`）：

- 每种风格：实时 CSS 渲染预览 + 设计史脉络 + 品味要点（高手用法/新手翻车点）+ 适用/禁用场景 + 一键复制调用指令
- 分类：通用 49 / 落地页 8 / 数据看板 10 / 移动端 17
- 顶部导读：9 大风格族系 + 5 阶段学习路径 + 日常练眼方法
- 数据源：ui-ux-pro-max skill 的 `data/styles.csv`（22 字段结构化数据，另有 161 套配色、57 组字体配对可检索）

典型用法：浏览百科选定风格 → 对 Claude 说"用 ui-ux-pro-max 的 <风格英文名> 风格做 XX 页面"。
