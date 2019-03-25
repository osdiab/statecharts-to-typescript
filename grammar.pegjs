statechart
  = content:(state / whitespace / comments)+ {
    return content.filter(x => x !== undefined)
  }

state
  = comments? stateName:stateName stateFlag:stateFlag? whitespace? newline block:block? {
  	return { type: "state", stateName, ...(stateFlag ? {stateFlag} : {}), ...(block ? {block} : {})}
  }
stateFlag
  = flag:[*&?] {
    switch(flag) {
      case "*": return "starting";
      case "&": return "parallel";
      case "?": return "transient";
    }
  }

transition
  = comments? eventName:eventName whitespace? arrow whitespace? stateName:stateName newline {
  	return { type: "transition", eventName, transitionsTo: stateName }
  }

block
  = indent newline? content:(transition / state / whitespace / comments)+ dedent {
  	return content.filter(x => x !== undefined)
  }

comments
  = comment (newline comment)* newline { return; }
comment
  = "#" commentChar*
commentChar
  = [^\n\r]

stateName = name
eventName = name

name
  = head:word rest:(whitespace word)* {
    return [head, ...rest.flat()].filter(x => x !== undefined).join(" ")
  }
word = !(indent / dedent / arrow) segments:[a-zA-Z0-9_]+ {
  return segments.flat().join("")
}

arrow = "->"
whitespace = [ \t]+ { return; }
newline = [\n\r]*
indent = newline? "INDENT" newline?
dedent = newline? "DEDENT" newline?
