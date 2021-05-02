// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"
import {Socket} from "phoenix"
import topbar from "topbar"
import {LiveSocket} from "phoenix_live_view"


let Hooks = {}

Hooks.Topping = {
    mounted() {
        this.el.addEventListener("dragstart", e => {
            e.dataTransfer.dropEffect = "move";
            e.dataTransfer.setData("topping", e.target.attributes['data-topping'].value);
            e.dataTransfer.setData("image", e.target.attributes['src'].value);
            let table = e.target.attributes['data-table'];
            console.log("e", e);
            console.log("table");
            console.log(table);
            if (table !== undefined) {
                e.dataTransfer.setData("table", table.value);
            }
            e.dataTransfer.setData("topping", e.target.attributes['data-topping'].value);
        })

    }
}

Hooks.Crust = {
    mounted() {
        this.el.addEventListener("dragover", e => {
            e.preventDefault();
            e.dataTransfer.dropEffect = "move";
        })

        this.el.addEventListener("drop", e => {
            e.preventDefault();
            var topping = e.dataTransfer.getData("topping");
            var image = e.dataTransfer.getData("image");
            let to = e.target.attributes['phx-value-name'].value;
            this.pushEventTo("#kitchen", "drop", {"topping": topping, "image": image, "to": to});
            let table = e.dataTransfer.getData("table");
            console.log("crust table", table);
            if (table !== undefined && table !== "") {
                this.pushEventTo("#kitchen", "pop", {"from": table});

            }
        })
    }
}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")

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

