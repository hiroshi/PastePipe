// The entry file of your WebAssembly module.

// export function add(a: i32, b: i32): i32 {
//   return a + b;
// }

let buff = new ArrayBuffer(0);
process.stdin.read(buff);

console.log("Hello: " + buff);
