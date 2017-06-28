 output←regexes(op Run args)input;from;to;options;lines;trans;Expand;repeat;s;r;last;fns;Quote;q;hasrepeat;postproc;combine

 :Trap 11 22 ⍝ accept filename or actual input
     input←input ⎕NTIE 0
 :EndTrap

 :Trap 11 22 ⍝ accept filename or actual regex
     regexes←⊃⎕NGET regexes 1
 :EndTrap

 repeat←⍎{×≢⍵:⍵ ⋄ '1'}args∩'≡',⎕D ⍝ extract repetition, if any, else 1
 hasrepeat←∨/args∊⍨'≡',⎕D
 ⍝ select options:
 options←('ResultText' 'Simple')('Greedy' 0)('IC' 1)('Mode' 'D')('Mode' 'M')('DotAll' 1)('UCP' 1)('OM' 1)/⍨1,'gidmauo'∊819⌶args~' -'
 s r←(∨/∊∘op)¨'Ss' 'Rr'
 options↓⍨←s ⍝ ResultText is not for ⎕S

 fns←+/∧\'⍵'∊¨regexes
 postproc←∊'{⍵}','∘{'∘,¨,∘'}'¨fns↑regexes ⍝ post-processing functions
 regexes↓⍨←fns

 last←⊃⌽regexes
 :If 2|≢regexes ⍝ odd number of strings → many-to-one
 :OrIf '⍵'∊last ⍝ transformation function → many-to-function
     from←¯1↓regexes ⍝ remove transformation pattern/function
     :If ~'⍵'∊last ⍝ no ⍵ → pattern
         Expand←'⍵B' '⍵b' '⍵P' '⍵p' '⍵M' '⍵O' '⍵L' '⍵N'⎕R'⍵.Block' '⍵.BlockNum' '⍵.Pattern' '⍵.PatternNum' '⍵.Match' '⍵.Offsets' '⍵.Lengths' '⍵.Names'
     :OrIf ~≡⎕FX,⊂'to←{',(r/',⍕{'),(Expand last),(r/'}⍵'),'}' ⍝ if definition fails, revert to pattern (allows ⍵ in pattern)
         to←⊃⌽regexes
     :EndIf
 :Else
     lines←2÷⍨≢regexes
     from←lines↑regexes
     to←lines↓regexes
 :EndIf

 combine←'{⊃,/⍵↑¨⍨⌈/≢¨⍵}'
 q←⎕NS ⍬
 :If s r∨.∧'?'∊args
     Quote←{q,q,⍨⍵/⍨1+⍵=q←''''}
     q.from←⍕Quote¨from
     :If 3=⎕NC'to'
         q.to←1⌽'  ',3↓∊⎕NR'to'
     :Else
         q.to←⍕Quote¨to
     :EndIf
     :If 3=⎕NC'repeat'
         q.repeat←'⍣',∊⎕NR'repeat'
     :ElseIf 1≢repeat
         q.repeat←'⍣',⍕repeat
     :Else
         q.repeat←''
     :EndIf
     :If ×≢options
         q.options←'⍠',∊{' (',(Quote⊃⍵),' ',({0 1∊⍨⊂⍵:⍕⍵ ⋄ '''',⍵,''''}⊃⌽⍵),')'}¨options
     :Else
         q.options←''
     :EndIf
     q.op←s r/'SR'
     q.postproc←4↓postproc
     q.postproc,←(hasrepeat∧s)/(''≡q.postproc)↓'∘',combine
     output←q.(postproc,from,'⎕',op,to,options,repeat)
 :Else
     :Trap 6 11
         :If r
             output←from ⎕R to⍠options⍣repeat⊢input
         :ElseIf s
             output←from ⎕S to⍠options⍣repeat⊢input
             output←(⍎combine)⍣hasrepeat⊢output ⍝ merge search results if we need to continue
         :EndIf
         output←(⍎postproc)output
     :Case 6 ⍝ no output
         output←'*** Left operand must be ''R'' or ''S'' ***'
     :Case 11 ⍝ faulty regex
         output←'*** ',⎕DMX.Message,' ─ try adding ? to the Arguments to see the attempted APL expression ***'
     :EndTrap
 :EndIf
