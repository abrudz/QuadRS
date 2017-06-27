# QuadR and QuadS
Thin covers for Dyalog APL's [⎕R Replace operator](http://help.dyalog.com/16.0/Content/Language/System%20Functions/r.htm) and [⎕S Search operator](http://help.dyalog.com/16.0/Content/Language/System%20Functions/r.htm) to enable golfing.

## Guide

Usage is very much like using the APL operators.

### Code
In the simple case, the number of lines in the Code determines how the lines are used. If there are an even number of lines, the first half of the lines constitute are *search patterns* (the left operand) while the last half of the lines are transformation patterns (the right operand). If there are an odd number of lines, all but the last one are search patterns and the last one is a common transformation pattern for all of the search patterns.

See [PCRE Regular Expression Syntax Summary](http://help.dyalog.com/16.0/Content/Language/Appendices/PCRE%20Regular%20Expression%20Syntax%20Summary.htm) and [PCRE Regular Expression Details](http://help.dyalog.com/16.0/Content/Language/Appendices/PCRE%20Regular%20Expression%20Details.htm)

See [the documention](http://help.dyalog.com/16.0/Content/Language/System%20Functions/r.htm) under **transformation pattern** for details about transformation patterns.
 

If the last line of Code includes the character `⍵` (U+2375; APL Functional Symbol Omega) then that line is instead a transformation function body and will be wrapped in curly braces. All preceding Code lines are then search patterns. References to members of the transformation function's argument (a namespace) can optionally be shortened as follows:

 - `⍵B` is shorthand for `⍵.Block`
 - `⍵b` is shorthand for `⍵.BlockNum`
 - `⍵P` is shorthand for `⍵.Pattern`
 - `⍵p` is shorthand for `⍵.PatternNum`
 - `⍵M` is shorthand for `⍵.Match`
 - `⍵O` is shorthand for `⍵.Offsets`
 - `⍵L` is shorthand for `⍵.Lengths`
 - `⍵N` is shorthand for `⍵.Names`
 
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
 
 See [the Options documention](http://help.dyalog.com/16.0/Content/Language/System%20Functions/r.htm#kanchor706) for details.
