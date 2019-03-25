import peg from "pegjs";
import fs from "fs";
import path from "path";

const grammar = fs
  .readFileSync(path.join(__dirname, "grammar.pegjs"))
  .toString();
const parser = peg.generate(grammar);
const result = parser.parse(
  fs.readFileSync(path.join(__dirname, "..", "test.txt")).toString()
);
console.log(JSON.stringify(result, null, 2));
