const server = "http://localhost:3000";
const fmt = new Intl.NumberFormat();
let total = 0;
const batch = 50;
const until = 500;

while (true) {
  const array = new Array(batch);
  for (let i = 0; i < batch; i++) {
    array[i] = fetch(server);
  }
  await Promise.all(array);
  if (total >= until) break;
  console.log(
    "RSS",
    (process.memoryUsage.rss() / 1024 / 1024) | 0,
    "MB after",
    fmt.format((total += batch)) + " fetch() requests"
  );
}
