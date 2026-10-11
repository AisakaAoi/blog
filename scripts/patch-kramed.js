// 修补 kramed：禁用下划线斜体，避免 $...$ 行内公式中的 _ 被解析为 <em>
// 通过 package.json 的 postinstall 自动执行，另一台电脑 npm install 后同样生效
const fs = require('fs');
const path = require('path');

const file = path.join(__dirname, '..', 'node_modules', 'kramed', 'lib', 'rules', 'inline.js');
if (!fs.existsSync(file)) {
  console.log('[patch-kramed] kramed 未安装，跳过');
  process.exit(0);
}

const patched = '  em: /^\\*((?:\\*\\*|[\\s\\S])+?)\\*(?!\\*)/,';
const original = '  em: /^\\b_((?:__|[\\s\\S])+?)_\\b|^\\*((?:\\*\\*|[\\s\\S])+?)\\*(?!\\*)/,';

let src = fs.readFileSync(file, 'utf8');
if (src.includes(patched)) {
  console.log('[patch-kramed] 已打过补丁');
  process.exit(0);
}
if (!src.includes(original)) {
  console.error('[patch-kramed] 未找到预期代码，kramed 版本可能已变化，请人工检查');
  process.exit(1);
}
src = src.replace(original, patched);
fs.writeFileSync(file, src);
console.log('[patch-kramed] 已禁用下划线斜体（*斜体* 与 **加粗** 不受影响）');
