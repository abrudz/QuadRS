# QuadR and QuadS
These are two closely related golfing languages. They are barely more than thin covers for [Dyalog APL](https://www.dyalog.com/)'s ⎕R [Replace operator](http://help.dyalog.com/16.0/Content/Language/System%20Functions/r.htm) and ⎕S [Search operator](http://help.dyalog.com/16.0/Content/Language/System%20Functions/r.htm) but with some enhancements for golfing purposes. They are based on PCRE, but enhanced by Dyalog to include application of custom regular expressions-style transformations and arbitrary APL code (including preservation of information from call to call) on each match.

## Guide

Usage is very much like using the APL operators.

### Code
In the simple case, the number of lines in the Code determines how the lines are used. If there are an even number of lines, the first half of the lines are *search patterns* (the left operand) while the last half of the lines are *Transformation patterns* (the right operand). If there are an odd number of lines, all but the last one are search patterns and the last one is a common transformation pattern for all of the search patterns.

See [PCRE Regular Expression Syntax Summary](http://help.dyalog.com/16.0/Content/Language/Appendices/PCRE%20Regular%20Expression%20Syntax%20Summary.htm) and [PCRE Regular Expression Details](http://help.dyalog.com/16.0/Content/Language/Appendices/PCRE%20Regular%20Expression%20Details.htm) for details about the search patterns.

See [the documention](http://help.dyalog.com/16.0/Content/Language/System%20Functions/r.htm) under **transformation pattern** for details about transformation patterns.

If the last line of Code includes the character `⍵` (U+2375; APL Functional Symbol Omega), all preceding Code lines are search patterns and the last line is a *transformation function* in the form of a [Dyalog APL dfn](http://help.dyalog.com/16.0/Content/Language/Defined%20Functions%20and%20Operators/DynamicFunctions/Dynamic%20Functions%20and%20Operators.htm). The function body will be wrapped in curly braces and multiple statements must be separated by diamonds (`⋄`) rather than newlines, as the function must stay on one line.  References to members of the transformation function's argument (a namespace) can optionally be shortened as follows:

 - `⍵B` is shorthand for `⍵.Block`
 - `⍵b` is shorthand for `⍵.BlockNum`
 - `⍵P` is shorthand for `⍵.Pattern`
 - `⍵p` is shorthand for `⍵.PatternNum`
 - `⍵M` is shorthand for `⍵.Match`
 - `⍵O` is shorthand for `⍵.Offsets`
 - `⍵L` is shorthand for `⍵.Lengths`
 - `⍵N` is shorthand for `⍵.Names`

The result of the transformation function will be formatted and raveled before returning the result to ⎕R or ⎕S.

See [the documention](http://help.dyalog.com/16.0/Content/Language/System%20Functions/r.htm) under **Transformation Function** for details.
 
### Input
This is the input document – the data which is to be modified. Leave this blank for programs that produce output without input.
 
### Arguments
This field accepts the options (using `⍠`) to apply, as follows:
 
 - `g` is shorthand for `'Greedy' 0`; 
 - `i` is shorthand for `'IC' 1`
 - `d` is shorthand for `Mode' 'D'`
 - `m` is shorthand for `'Mode' 'M'`
 - `a` is shorthand for `'DotAll' '1'`
 - `u` is shorthand for `'UCP' 1`
 - `o` is shorthand for `'OM' 1`
 
See [the Options documention](http://help.dyalog.com/16.0/Content/Language/System%20Functions/r.htm#kanchor706) for details.
 
### Output

Is the result of the transformed input, for QuadR, and a formatted list

## Examples

### Hello, World!
```

Hello, World!
```
This takes an empty Input. Notice the leading empty line. What this does is replace all occurences of `''` with `'Hello, World!'`. PCRE will find one such match and, in the case of QuadR, make the replacement, and in the case of QuadS, return the string for that one match.

### Number adder
```
.+
+/⍎⍵M
```
This will sum the numbers on each line of the Input and return one sum on each line. The first line matches the entire input line and the second line specifies a transformation function which takes the matched text (`⍵M`), executes it (`⍎`) to convert it to numbers, and sums it `+/`. 

### Primality checker
```
.+
~⍵L∊∘.×⍨1↓⍳⍵L
```
Each line of the Input is an integer in unary (using any symbol). For each one, it takes the length (`⍵L`), generates the integers from 1 to that (`⍳`), drop the first one (`1↓`), creates a multiplication table (`∘.×⍨`), asks whether the match length is a member of that (`⍵L∊`), and negates the result.

### Given a string of [a-zA-Z ] reverse every word (QuadR only)
```
\w+
⌽⍵M
```
The first line matches every run of word character, while the second line reverses (`⌽`) the match (`⍵M`)

### Transform into upper/lower case (QuadR only)
```
(.)(.)
.
\u1\l2
\u&
```
The first line matches all runs of two characters and the third line converts the first to uppercase and the second to lowercase. The second line matches any leftover trailing character and the fourth line converts it to uppercase.

### [What my dog really hears](https://codegolf.stackexchange.com/q/119718/43319)
```
rex
\w
\0
*
```
Only 11 bytes plus 1 byte for the `i` option.
