// We import the CSS which is extracted to its own file by esbuild.
// Remove this line if you add a your own CSS build pipeline (e.g postcss).
import "../css/app.css"
import "./custom.js";
import Trix from "./Trix.js"


// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "./vendor/some-package.js"
//
// Alternatively, you can `npm install some-package` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")

// Define hooks
let Hooks = { Trix };

Hooks.InfiniteScroll = {
  mounted() {
    this.el.addEventListener("scroll", e => {
      const scrollPercent = this.el.scrollTop / (this.el.scrollHeight - this.el.clientHeight) * 100;
      if (scrollPercent > 90) {
        this.pushEvent("load-more");
    }
  })
},
};

Hooks.AutoClearFlash = {
  mounted() {
    const flashInfo = document.getElementById("flash-info");
    const flashError = document.getElementById("flash-err");

    if (flashInfo && flashInfo.innerText.trim() !== "") {
      setTimeout(() => {
        this.pushEvent("lv:clear-flash", { key: "info" });
      }, 3000); // Adjust the timeout as needed (3 seconds)
    }

    if (flashError && flashError.innerText.trim() !== "") {
      setTimeout(() => {
        this.pushEvent("lv:clear-flash", { key: "error" });
      }, 3000); // Adjust the timeout as needed (3 seconds)
    }
  }
}


Hooks.LocalTime = {
  mounted() {
    this.updated();
  },
  updated() {
    const el = this.el;
    // const date = new Date(el.dateTime);
    // this.el.textContent = `${date.toLocaleString()} ${Intl.DateTimeFormat().resolvedOptions().timeZone}`;

    const date = new Date(el.dateTime).getTime();

    var one_day_in_milliseconds = 1000 * 60 * 60 * 24;
    const diffTime = Math.abs(date - Date.now());
    this.el.textContent = `${Math.ceil(diffTime / one_day_in_milliseconds)} days ago`;
  },
};

Hooks.Modal = {
  mounted() {
    this.el.addEventListener("click", e => {
      if (e.target.id === "close") {
        this.pushEventTo("#modal", "close_modal");
      }
    });
  }
};

let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}, hooks: Hooks})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket
