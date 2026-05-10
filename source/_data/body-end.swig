<script>
(function() {
  function showEncryptedToc() {
    var tocDiv = document.getElementById('toc-div');
    if (tocDiv) tocDiv.style.display = 'block';

    // 切换 sidebar 标签到"文章目录"
    var tocWrap = document.querySelector('.post-toc-wrap');
    var overview = document.querySelector('.site-overview-wrap') || document.querySelector('.site-overview');
    if (tocWrap && overview) {
      tocWrap.classList.add('sidebar-panel-active');
      overview.classList.remove('sidebar-panel-active');
    }
    var tocNav = document.querySelector('.sidebar-nav-toc');
    var overviewNav = document.querySelector('.sidebar-nav-overview');
    if (tocNav && overviewNav) {
      tocNav.classList.add('sidebar-nav-active');
      overviewNav.classList.remove('sidebar-nav-active');
    }

    var postToc = document.querySelector('.post-toc');
    if (!postToc) return;

    // 如果服务端已经生成了原生目录，直接显示即可
    if (postToc.querySelector('ol.nav')) {
      return;
    }

    var container = document.querySelector('.post-body') || document.getElementById('hexo-blog-encrypt');
    if (!container) return;

    var headings = Array.from(container.querySelectorAll('h1, h2, h3, h4, h5, h6'));
    if (headings.length === 0) return;

    headings.forEach(function(h, i) {
      if (!h.id) h.id = 'toc-heading-' + i;
    });

    // 构建与原生 toc() 完全一致的 <ol class="nav"> 嵌套结构
    var rootOl = document.createElement('ol');
    rootOl.className = 'nav';

    // 栈：记录每一层对应的 ol 元素
    var stack = [{ level: 0, ol: rootOl }];
    var counters = [0, 0, 0, 0, 0, 0]; // h1-h6 计数器

    headings.forEach(function(h) {
      var level = parseInt(h.tagName.charAt(1));

      // 更新计数器
      counters[level - 1]++;
      for (var i = level; i < 6; i++) counters[i] = 0;

      // 构建编号字符串，如 "1."、"1.1."、"1.1.1."
      var numberStr = '';
      for (var i = 0; i < level; i++) {
        if (counters[i] > 0) {
          numberStr += (numberStr ? '.' : '') + counters[i];
        }
      }
      numberStr += '.';

      // 找到正确的父级 ol
      while (stack.length > 1 && stack[stack.length - 1].level >= level) {
        stack.pop();
      }
      var parentOl = stack[stack.length - 1].ol;

      var li = document.createElement('li');
      li.className = 'nav-item nav-level-' + level;

      var a = document.createElement('a');
      a.className = 'nav-link';
      a.href = '#' + h.id;

      var numSpan = document.createElement('span');
      numSpan.className = 'nav-number';
      numSpan.textContent = numberStr;

      var textSpan = document.createElement('span');
      textSpan.className = 'nav-text';
      textSpan.textContent = ' ' + h.textContent.trim();

      a.appendChild(numSpan);
      a.appendChild(textSpan);
      li.appendChild(a);

      // 创建子级容器（原生结构是 <ol class="nav-child">）
      var childOl = document.createElement('ol');
      childOl.className = 'nav-child';
      li.appendChild(childOl);
      parentOl.appendChild(li);

      stack.push({ level: level, ol: childOl });
    });

    // 清理空的 <ol class="nav-child">
    (function cleanEmpty(ol) {
      Array.from(ol.children).forEach(function(li) {
        var childOls = li.querySelectorAll(':scope > ol.nav-child');
        childOls.forEach(function(col) {
          if (col.children.length === 0) {
            col.parentNode.removeChild(col);
          } else {
            cleanEmpty(col);
          }
        });
      });
    })(rootOl);

    postToc.innerHTML = '';
    postToc.appendChild(rootOl);

    // 重新初始化 NexT 的 TOC 滚动监听
    if (window.NexT && window.NexT.utils && window.NexT.utils.initSidebarTOC) {
      setTimeout(function() {
        window.NexT.utils.initSidebarTOC();
      }, 200);
    }
  }

  window.addEventListener('hexo-blog-decrypt', showEncryptedToc);

  var observer = new MutationObserver(function() {
    var hbe = document.getElementById('hexo-blog-encrypt');
    if (!hbe) return;
    if (hbe.querySelector('hbe-prefix') || !document.getElementById('hbePass')) {
      setTimeout(showEncryptedToc, 200);
    }
  });
  observer.observe(document.body, { childList: true, subtree: true });

  (function check() {
    var hbe = document.getElementById('hexo-blog-encrypt');
    if (hbe && (hbe.querySelector('hbe-prefix') || !document.getElementById('hbePass'))) {
      setTimeout(showEncryptedToc, 200);
      return;
    }
    setTimeout(check, 500);
  })();
})();
</script>