const path = require("path");
const esbuild = require("esbuild");
const plugin = require("node-stdlib-browser/helpers/esbuild/plugin");
const stdLibBrowser = require("node-stdlib-browser");

(async () => {
  await esbuild.build({
    entryPoints: ["./index.js"],
    bundle: true,
    // format: "esm",
    format: "cjs",
    outfile: "./asc.js",
    inject: [require.resolve("node-stdlib-browser/helpers/esbuild/shim")],
    define: {
      global: "global",
      process: "process",
      Buffer: "Buffer",
    },
    plugins: [plugin(stdLibBrowser)],
  });
})();
