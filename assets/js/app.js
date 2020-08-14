// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "mdn-polyfills/Object.assign";
import "mdn-polyfills/CustomEvent";
import "mdn-polyfills/String.prototype.startsWith";
import "mdn-polyfills/Array.from";
import "mdn-polyfills/Array.prototype.find";
import "mdn-polyfills/Array.prototype.some";
import "mdn-polyfills/NodeList.prototype.forEach";
import "mdn-polyfills/Element.prototype.closest";
import "mdn-polyfills/Element.prototype.matches";
import "mdn-polyfills/Node.prototype.remove";
import "child-replace-with-polyfill";
import "url-search-params-polyfill";
import "formdata-polyfill";
import "classlist-polyfill";
import "@webcomponents/template";
import "shim-keyboard-event-key";
import "core-js/features/set";

import "../css/app.scss";

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html";
import { Socket } from "phoenix";
import NProgress from "nprogress";
import { LiveSocket } from "phoenix_live_view";

let Hooks = {};

let scrollAt = () => {
  let scrollTop = document.documentElement.scrollTop || document.body.scrollTop;
  let scrollHeight =
    document.documentElement.scrollHeight || document.body.scrollHeight;
  let clientHeight = document.documentElement.clientHeight;

  return (scrollTop / (scrollHeight - clientHeight)) * 100;
};

Hooks.InfiniteScroll = {
  page() {
    return this.el.dataset.page;
  },
  mounted() {
    this.pending = this.page();
    window.addEventListener("scroll", (e) => {
      if (this.pending == this.page() && scrollAt() > 90) {
        this.pending = this.page() + 1;
        this.pushEvent("load-more", {});
      }
    });
  },
  updated() {
    this.pending = this.page();
  },
  //   const target = document.querySelector("#scroller");
  //   const options = {
  //     rootMargin: "150px",
  //     threshold: 1.0,
  //   };
  //
  //   const observer = new IntersectionObserver(() => {
  //     this.pushEvent("load-more", {});
  //   }, options);
  //
  //   observer.observe(target);
  // },
};

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
  hooks: Hooks,
  params: { _csrf_token: csrfToken },
});

// Show progress bar on live navigation and form submits
window.addEventListener("phx:page-loading-start", (info) => NProgress.start());
window.addEventListener("phx:page-loading-stop", (info) => NProgress.done());

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;
