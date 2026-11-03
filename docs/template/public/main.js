// zh-TW site polish: language tag + DocFX template string localization.
// Loaded by the DocFX modern template when present in template/public.
(function () {
  document.documentElement.lang = 'zh-Hant-TW';

  function localizeStaticStrings() {
    var search = document.getElementById('search-query');
    if (search) {
      search.setAttribute('placeholder', '搜尋');
      search.setAttribute('aria-label', '搜尋');
    }
    // Navbar theme menu labels (Light / Dark / Auto)
    var themeLabels = { Light: '淺色', Dark: '深色', Auto: '自動' };
    document.querySelectorAll('header .dropdown-item, header .dropdown-menu *').forEach(function (el) {
      if (el.children.length === 0 && themeLabels[el.textContent.trim()]) {
        el.textContent = themeLabels[el.textContent.trim()];
      }
    });
  }

  function localizeAffixTitle() {
    // The "In this article" outline heading is rendered client-side by DocFX.
    document.querySelectorAll('.affix h5, #affix h5, .affix h6, #affix h6').forEach(function (el) {
      if (el.textContent.trim().toLowerCase() === 'in this article') {
        el.textContent = '本頁內容';
      }
    });
  }

  function run() {
    localizeStaticStrings();
    localizeAffixTitle();
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', run);
  } else {
    run();
  }

  // The affix outline is built after initial render; watch briefly for it.
  var observer = new MutationObserver(function () {
    localizeAffixTitle();
  });
  observer.observe(document.documentElement, { childList: true, subtree: true });
  setTimeout(function () { observer.disconnect(); }, 15000);
})();
