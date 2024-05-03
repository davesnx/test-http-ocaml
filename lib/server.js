const crypto = require("crypto");

const blob = new Blob([crypto.randomFillSync(new Uint8Array(1024 * 512))]);

Bun.serve({
  port: "3000",
  fetch(_req) {
    return new Response(blob);
  },
});
