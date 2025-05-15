README.txt
==========

Project Title:
--------------
*FlowLang Compiler using FLEX and BISON*

Description:
------------
This project is a simple compiler for a custom-designed language called *FlowLang*. The compiler is built using *FLEX* (Fast Lexical Analyzer) and *BISON* (GNU parser generator). The language supports variable declarations, arithmetic operations, assignment statements, conditionals (`if-else`), and looping constructs (`while`). The compiler takes a FlowLang source file (`input.txt`) and generates intermediate three-address code in `output.txt`.

FlowLang is intended to help learners understand the basics of compiler design, including lexical analysis, syntax parsing, code generation, temporary variable management, and label-based control flow.

Language Syntax Overview:
-------------------------
FlowLang includes the following features:
- Variable declaration using `set` and `let`
- Arithmetic operations: `+`, `-`, `*`, `/`
- Assignment using `=`
- Conditional statements using `if`, `then`, `else`
- Loops using `while`, `do`, `end`
- Comparison operators: `<`, `>`, `==`, `!=`, `<=`, `>=`
- Block structure with `{}` and parentheses `()`

Example Input (input.txt):
---------------------------
BEGIN

set x = 5
set y = 10
let z = x + y
let w = x - y
let v = x * y
let u = x / y

if (z > 10) then {
    z = z - 1
}
else {
    z = z + 1
}

while z < 20 do
    z = z + 1
end

CLOSE

How it Works:
-------------
1. *Lexical Analysis* (in `.l` file):
   - Uses FLEX to tokenize keywords like `set`, `let`, `if`, `while`, operators, symbols, identifiers, and numbers.
   - Skips whitespace and tracks line numbers for error reporting.
   - Sends tokens to BISON for parsing.

2. *Parsing and Intermediate Code Generation* (in `.y` file):
   - BISON defines grammar rules for valid FlowLang statements.
   - Implements semantic actions to generate intermediate three-address code.
   - Uses helper functions to create temporary variables and labels.
   - Outputs the generated code using `fprintf` into `output.txt`.

Compilation Instructions:
-------------------------
To compile and run the compiler, execute the following commands:

1) flex flowlang.l  
2) bison -d flowlang.y  
3) gcc lex.yy.c flowlang.tab.c -o flowlang  
4) ./flowlang  

Make sure `input.txt` is present in the directory. The output will be saved in `output.txt`.

Files:
------
- `flowlang.l` - FLEX file for lexical analysis  
- `flowlang.y` - BISON file for parsing and code generation  
- `input.txt` - Sample FlowLang source code  
- `output.txt` - Generated intermediate code  
- `flowlang.tab.h`, `flowlang.tab.c`, `lex.yy.c` - Generated during compilation  

Author:
-------
Alay Patel
