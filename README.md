# QuadR and QuadS

## Introduction
QuadR and QuadS are golfing languages which each are barely more than thin covers for [Dyalog APL](https://www.dyalog.com/)'s ⎕R [Replace operator](http://help.dyalog.com/16.0/Content/Language/System%20Functions/r.htm) and ⎕S [Search operator](http://help.dyalog.com/16.0/Content/Language/System%20Functions/r.htm). QuadR and QuadS code can in fact easily be translated to normal Dyalog APL. See [Arguments](https://github.com/abrudz/QuadRS#arguments) for information on how to do that.

⎕R and⎕S are PCRE based, but enhanced by Dyalog to include application of custom regular expressions-style transformations and arbitrary APL code (including preservation of information from call to call) on each match.

Feel free to contact me, [Adám](https://stackexchange.com/users/3114363/ad%C3%A1m), in Stack Exchange's [APL chat room](https://chat.stackexchange.com/rooms/52405/apl) to learn more about QuadR, QuadS, and Dyalog APL.

## User guide

[Try It Online](https://tio.run/#) is a code testing website for many programming languages, both practical and recreational ones, made by Stack Exchange user [Dennis](https://codegolf.stackexchange.com/users/12012). The following describes the relevant fields when using [QuadR on TIO](https://tio.run/#quadr) and [QuadS on TIO](https://tio.run/#quads). 

### Code
In the simple case, the number of lines determines how the lines are used. If there are an even number of lines, the first half of the lines are *search patterns* (the left operand) while the last half of the lines are *transformation patterns* (the right operand). If there are an odd number of lines, all but the last one are search patterns and the last one is a common transformation pattern for all of the search patterns. (See the last paragraph in this section for an exception to this odd/even rule.)

See [PCRE Regular Expression Syntax Summary](http://help.dyalog.com/16.0/Content/Language/Appendices/PCRE%20Regular%20Expression%20Syntax%20Summary.htm) and [PCRE Regular Expression Details](http://help.dyalog.com/16.0/Content/Language/Appendices/PCRE%20Regular%20Expression%20Details.htm) for details about the search patterns, and [the ⎕R documention](http://help.dyalog.com/16.0/Content/Language/System%20Functions/r.htm) under **Transformation pattern** for details about transformation patterns.

If the last line includes the character `⍵` (U+2375; APL Functional Symbol Omega), all preceding code lines are search patterns and the last line is a *transformation function* in the form of a [Dyalog APL dfn](http://help.dyalog.com/16.0/Content/Language/Defined%20Functions%20and%20Operators/DynamicFunctions/Dynamic%20Functions%20and%20Operators.htm). The function body will be wrapped in curly braces and multiple statements must be separated by diamonds (`⋄`) rather than newlines, as the function must stay on one line.  References to members of the transformation function's argument (a namespace) can optionally be shortened as follows:

| Short | Full name | |Short | Full name        | | Short | Full name | | Short | Full name |
| ----: | ------- | --- | ---: | ----------  | --- | ---: | ---------- | --- | -----: | ------------- |
| `⍵B` | `⍵.Block`    | | `⍵P` | `⍵.Pattern`   | | `⍵M` | `⍵.Match`   | | `⍵L` | `⍵.Lengths`  |
| `⍵b` | `⍵.BlockNum` | | `⍵p` | `⍵.PatternNum` | | `⍵O` | `⍵.Offsets` | | `⍵N` | `⍵.Names`    |

QuadR will format and ravel (flatten) the result of the transformation function before returning its result to ⎕R, since ⎕R's transformation function must return a simple character vector (string). See [the ⎕R documention](http://help.dyalog.com/16.0/Content/Language/System%20Functions/r.htm) under **Transformation Function** for further details about transformation functions.

Optionally, the code may be have one or more leading lines of post-processing dfn bodies. Like the transformation function, these are identified by the precence of `⍵`, and curly braces are added automatically. The post processing functions will be applied bottom-up: The last post-processing function will be applied to the result of ⎕R or ⎕S, and then the second-to-last will be applied to the result of that, etc. See [here](https://codegolf.stackexchange.com/a/128722/43319) for an example use of a post-processing function. Code lines dedicated to post-processing functions are not counted when determining whether there are an odd or even number of lines.

### Input
This is the input document – the data which is to be modified. Leave this blank for programs that produce output without input.
 
### Arguments
Options for ⎕R and ⎕S,  using `⍠` (see [documentation for Variant](http://help.dyalog.com/16.0/Content/Language/Primitive%20Operators/Variant.htm)), but in a shortened form only. The short forms correspond following full forms when using Dyalog APL:
 
| Short | Full syntax  | | Short | Full syntax  | |Short | Full syntax |  | Short | Full syntax | 
| ----: | ------------ | --- | ----: | ------- | --- | ----: | ---------- | --- | ----: | ------------|
| `g`   | `'Greedy' 0` | | `d`   | `'Mode' 'D'` |  | `a`   | `'DotAll' '1'` | | `o`   | `'OM' 1`    |
| `i`   | `'IC' 1`     | | `m`   | `'Mode' 'M'` |  | `u`   | `'UCP' 1`      | |      |             |
 
See [the Options documention](http://help.dyalog.com/16.0/Content/Language/System%20Functions/r.htm#kanchor706) for details.

The entire search/replace call can optionally be repeated *N* times by adding a numeric argument, or until no further transformations can be done by adding the argument `≡`. This is equivalent to appending `⍣N` or `⍣≡` in Dyalog APL. See [documentation for the Power Operator](http://help.dyalog.com/16.0/Content/Language/Primitive%20Operators/Power%20Operator.htm) for details.

`?` is a special argument which instead of running the program, will return a proper APL function equivalent, including Arguments and post-processing functions, if applicable. Use this tool to learn the proper syntax of ⎕R and ⎕S.

### Output

Is the result of the transformed input for QuadR, and a formatted list for QuadS. QuadS will merge the list elements together, padding with [fill elements](http://help.dyalog.com/16.0/Content/Language/Introduction/Variables/Prototypes%20and%20Fill%20Items.htm), if `≡` or any number is specified as Argument.

## Examples

### Hello, World!
```

Hello, World!
```
This takes an empty Input. Notice the leading empty line. What this does is replace all occurences of `''` with `'Hello, World!'`. PCRE will find one such match and, in the case of QuadR, make the replacement, and in the case of QuadS, return the string for that one match. [Try it online!](https://tio.run/##KyxNTCn6/5/LIzUnJ19HITy/KCdF8f9/AA "QuadR – Try It Online")

### Summation
```
.+
+/⍎⍵M
```
This will sum the numbers on each line of the Input and return one sum on each line. The first line matches the entire input line and the second line specifies a transformation function which takes the matched text (`⍵M`), executes it (`⍎`) to convert it to numbers, and sums it `+/`. [Try it online!](https://tio.run/##KyxNTCn6/19Pm0tb/1Fv36Perb7//xsrGCqYcBkpmANpCwA "QuadR – Try It Online")

### Primality checker
```
1+
~⍵L∊∘.×⍨1↓⍳⍵L
```
Each line of the Input is an integer in unary (using `1`s). For each such number, it takes the length (`⍵L`), generates the integers from 1 to that (`⍳`), drops the first number (`1↓`), creates a multiplication table (`∘.×⍨`), asks whether the match (`⍵L`) length is a member of that (`∊`), and finally negates the result. [Try it online!](https://tio.run/##KyxNTCn6/99Qm6vuUe9Wn0cdXY86Zugdnv6od4Xho7bJj3o3g4SBChQMQQiMDblABIQJp@C0IQA "QuadR – Try It Online")

### Given a string of `[a-zA-Z ]` reverse every word (QuadR only)
```
\w+
⌽⍵M
```
The first line matches every run of word character, while the second line reverses (`⌽`) the match (`⍵M`). [Try it online!](https://tio.run/##KyxNTCn6/z@mXJvrUc/eR71bff//D8lIVUjLLCouUcjJzEtVyE0sSc5ILVZILUstqlQoKs1TyE9TKM8vSlFIzkgsSkwuSS3SUSjPyMxJVSgB6ixOTc7PS4FoLQLpKQbq1QAargmWBpsG5ANt0tQDAA "QuadR – Try It Online")

### Transform into upper/lower case (QuadR)
```
(.)(.)
.
\u1\l2
\u&
```
The first line matches all runs of two characters and the third line converts the first to uppercase and the second to lowercase. The second line matches any leftover trailing character and the fourth line converts it to uppercase. [Try it online!](https://tio.run/##XY7BCsIwDIbve4qcRC8FfZYddwltagu1mWnq8OlrdbAxIRDIl//ne1Z00trZXPoMZpjqdUq3vk6tjYHARykKKWaCB6oNVABTAqm5AHvQhcEGFLRK0lF2oD2lIYpbU5bzi0TL7762KUOdZxKLhbZIof7pvizxsjIzjDs4KuQ3JPLKvRpUMHZ630W2Us9VNPyJxKOB@QA "QuadR – Try It Online")

### [What my dog really hears](https://codegolf.stackexchange.com/q/119718/43319) (QuadR)
```
rex
\w
&
*
```
The first line matches all cases of REX and the second all other word characters. The third line replaces all occorances of REX with themselves and the fourth line replaces all other word characters with stars. [Try it online!](https://tio.run/##HY6xDsIwEEP3fIXbASSE8h8MLIgFieXUROUgzYnkAs3Xh5TF0rNly@9CLrWW/GruX7Mzh9Yufj3iBJXgUKUginaAE@iD84CblH3yWOjFccbiQXFOFb02mC4I/PEZHDcnUHTWXAUThYD/8rNkRaaKseNozbn2UMEZs1fdJilK/8OTbfwD "QuadR – Try It Online")
