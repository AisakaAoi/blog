// 修补 kramed：禁用下划线斜体，避免 $...$ 行内公式中的 _ 被解析为 <em>
// 由 package.json 的 postinstall 执行；hexo 启动时也会自动加载本文件（hexo 会执行 scripts/ 目录
// 下的所有 js），因此任何情况下都不得调用 process.exit，否则会杀掉 hexo 进程
const fs = require('fs');
const path = require('path');

const file = path.join(__dirname, '..', 'node_modules', 'kramed', 'lib', 'rules', 'inline.js');
const patched = '  em: /^\\*((?:\\*\\*|[\\s\\S])+?)\\*(?!\\*)/,';
const original = '  em: /^\\b_((?:__|[\\s\\S])+?)_\\b|^\\*((?:\\*\\*|[\\s\\S])+?)\\*(?!\\*)/,';

function main() {
  if (!fs.existsSync(file)) {
    console.log('[patch-kramed] kramed 未安装，跳过');
    return;
  }
  const src = fs.readFileSync(file, 'utf8');
  if (src.includes(patched)) {
    console.log('[patch-kramed] 已打过补丁');
    return;
  }
  if (!src.includes(original)) {
    console.error('[patch-kramed] 未找到预期代码，kramed 版本可能已变化，请人工检查');
    return;
  }
  fs.writeFileSync(file, src.replace(original, patched));
  console.log('[patch-kramed] 已禁用下划线斜体（*斜体* 与 **加粗** 不受影响）');
}

main();
