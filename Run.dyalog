 output←regexes(op Run options)input;from;to;options;lines;trans;Expand

 :Trap 11 22 ⍝ accept filename or actual input
     input←input ⎕NTIE 0
 :EndTrap

 :Trap 11 22 ⍝ accept filename or actual regex
     regexes←⎕NGET regexes 1
 :EndTrap

 :Trap 11 22 ⍝ accept filename or actual options
     options←⎕NGET options
 :EndTrap
 options←(0⍴⊂⍬),('Greedy' 0)('IC' 1)('Mode' 'D')('Mode' 'M')('DotAll' '1')('UCP' 1)('OM')/⍨'GIDM.UO'∊options

 :If 2|≢regexes
 :OrIf '⍵'∊⊃⌽regexes
     from←¯1↓regexes
     :If ~'⍵'∊⊃⌽regexes
     Expand←'⍵B' '⍵b' '⍵P' '⍵p' '⍵M' '⍵O' '⍵L' '⍵N'⎕R'⍵.Block' '⍵.BlockNum' '⍵.Pattern' '⍵.PatternNum' '⍵.Match' '⍵.Offsets' '⍵.Lengths' '⍵.Names'
     :OrIf ~≡⎕FX'to←{,⍕{'(Expand⊃⌽regexes)'}⍵}'
         to←⊃⌽regexes
     :EndIf
 :Else
     lines←2÷⍨≢regexes
     from←lines↑regexes
     to←lines↓regexes
 :EndIf

 :If ∨/'Rr'∊op
     output←from ⎕R to⍠options⊢input
 :ElseIf ∨/'Ss'∊op
     output←from ⎕S to⍠options⊢input
 :Else
     'Left operand must be ''R'' or ''S'''⎕SIGNAL 11
 :EndIf
