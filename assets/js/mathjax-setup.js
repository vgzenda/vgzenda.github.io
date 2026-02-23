const siteMathJaxMacros = window.siteMathJaxMacros || {};
const pageMathJaxMacros = window.pageMathJaxMacros || {};

window.MathJax = {
  tex: {
    tags: "ams",
    inlineMath: [
      ["$", "$"],
      ["\\(", "\\)"],
    ],
    macros: {
      ...siteMathJaxMacros,
      ...pageMathJaxMacros,
    },
  },
  options: {
    renderActions: {
      addCss: [
        200,
        function (doc) {
          const style = document.createElement("style");
          style.innerHTML = `
          .mjx-container {
            color: inherit;
          }
        `;
          document.head.appendChild(style);
        },
        "",
      ],
    },
  },
};
