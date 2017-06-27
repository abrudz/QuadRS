 output←regexes(op Run options)input;from;to;options;lines;trans;Expand;repeat

 :Trap 11 22 ⍝ accept filename or actual input
     input←input ⎕NTIE 0
 :EndTrap

 :Trap 11 22 ⍝ accept filename or actual regex
     regexes←⊃⎕NGET regexes 1
 :EndTrap

 repeat←⍎{×≢⍵:⍵ ⋄ '1'}options∩'≡',⎕D ⍝ extract repetition, if any, else 1
 ⍝ select options:
 options←('ResultText' 'Simple')('Greedy' 0)('IC' 1)('Mode' 'D')('Mode' 'M')('DotAll' '1')('UCP' 1)('OM' 1)/⍨1,'gidmauo'∊819⌶options~' -'
 options↓⍨←∨/'Ss'∊op ⍝ ResultText is not for ⎕S

 :If 2|≢regexes ⍝ odd number of strings → many-to-one
 :OrIf '⍵'∊⊃⌽regexes ⍝ transformation function → many-to-function
     from←¯1↓regexes ⍝ remove transformation pattern/function
     :If ~'⍵'∊⊃⌽regexes ⍝ no ⍵ → pattern
         Expand←'⍵B' '⍵b' '⍵P' '⍵p' '⍵M' '⍵O' '⍵L' '⍵N'⎕R'⍵.Block' '⍵.BlockNum' '⍵.Pattern' '⍵.PatternNum' '⍵.Match' '⍵.Offsets' '⍵.Lengths' '⍵.Names'
     :OrIf ~≡⎕FX'to←{,⍕{'(Expand⊃⌽regexes)'}⍵}' ⍝ if definition fails, revert to pattern (allows ⍵ in pattern)
         to←⊃⌽regexes
     :EndIf
 :Else
     lines←2÷⍨≢regexes
     from←lines↑regexes
     to←lines↓regexes
 :EndIf

 :If ∨/'Rr'∊op
     output←from ⎕R to⍠options⍣repeat⊢input
 :ElseIf ∨/'Ss'∊op
     output←from ⎕S to⍠options⍣repeat⊢input
 :Else
     'Left operand must be ''R'' or ''S'''⎕SIGNAL 11
 :EndIf
