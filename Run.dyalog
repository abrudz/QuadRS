 output←regexes(op Run args)input;from;to;options;lines;trans;Expand;repeat;s;r

 :Trap 11 22 ⍝ accept filename or actual input
     input←input ⎕NTIE 0
 :EndTrap

 :Trap 11 22 ⍝ accept filename or actual regex
     regexes←⊃⎕NGET regexes 1
 :EndTrap

 repeat←⍎{×≢⍵:⍵ ⋄ '1'}args∩'≡',⎕D ⍝ extract repetition, if any, else 1
 ⍝ select options:
 options←('ResultText' 'Simple')('Greedy' 0)('IC' 1)('Mode' 'D')('Mode' 'M')('DotAll' '1')('UCP' 1)('OM' 1)/⍨1,'gidmauo'∊819⌶args~' -'
 s r←(∨/∊∘op)¨'Ss' 'Rr'
 options↓⍨←s ⍝ ResultText is not for ⎕S

 :If 2|≢regexes ⍝ odd number of strings → many-to-one
 :OrIf '⍵'∊⊃⌽regexes ⍝ transformation function → many-to-function
     from←¯1↓regexes ⍝ remove transformation pattern/function
     :If ~'⍵'∊⊃⌽regexes ⍝ no ⍵ → pattern
         Expand←'⍵B' '⍵b' '⍵P' '⍵p' '⍵M' '⍵O' '⍵L' '⍵N'⎕R'⍵.Block' '⍵.BlockNum' '⍵.Pattern' '⍵.PatternNum' '⍵.Match' '⍵.Offsets' '⍵.Lengths' '⍵.Names'
     :OrIf ~≡⎕FX('to←{',(r/',⍕'),'{')(Expand⊃⌽regexes)'}⍵}' ⍝ if definition fails, revert to pattern (allows ⍵ in pattern)
         to←⊃⌽regexes
     :EndIf
 :Else
     lines←2÷⍨≢regexes
     from←lines↑regexes
     to←lines↓regexes
 :EndIf

 :If r
     output←from ⎕R to⍠options⍣repeat⊢input
 :ElseIf s
     output←from ⎕S to⍠options⍣repeat⊢input
     output←{⊃,/⍵↑¨⍨⌈/≢¨⍵}⍣(∨/args∊⍨'≡',⎕D)⊢output ⍝ merge search results if we need to continue
 :Else
     'Left operand must be ''R'' or ''S'''⎕SIGNAL 11
 :EndIf
