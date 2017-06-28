 output←regexes(op Run args)input;from;to;options;lines;Expand;repeat;s;r;last;fns;q;hasrepeat;postproc;combine;Quote;Nest;a;n
 output←⍬⊤⍬ ⍝ default result is empty matrix

 n←⎕UCS 10 ⍝ newline
 a←⎕UCS 39 ⍝ apostrofe
 ⍎'Nest←{⊂⍣(1=≡,⍵)⊢⍵}'
 ⍎'Quote←{a,a,⍨⍵/⍨1+⍵=a}'

 :Trap 11 22 ⍝ accept filename or actual input
     input←input ⎕NTIE 0
 :EndTrap

 :Trap 11 22 ⍝ accept filename or actual regex
     regexes←⊃⎕NGET regexes 1
 :EndTrap
 regexes←{,¨⍣(¯2=≡⍵)⊢⍵}Nest regexes

 repeat←⍎{×≢⍵:⍵ ⋄ '1'}args∩'≡',⎕D ⍝ extract repetition, if any, else 1
 hasrepeat←∨/args∊⍨'≡',⎕D
 ⍝ select options:
 options←('ResultText' 'Simple')('Greedy' 0)('IC' 1)('Mode' 'D')('Mode' 'M')('DotAll' 1)('UCP' 1)('OM' 1)/⍨1,'gidmauo'∊819⌶args~' -'
 s r←(∨/∊∘op)¨'Ss' 'Rr'
 :If s∨r
     options↓⍨←s ⍝ ResultText is not for ⎕S

     fns←+/∧\'⍵'∊¨regexes
     postproc←∊'⊢','∘{'∘,¨,∘'}'¨fns↑regexes ⍝ post-processing functions
     regexes↓⍨←fns

     last←⊃regexes↓⍨¯1+≢regexes
     :If '⍵'∊last ⍝ transformation function → many-to-function
     :OrIf 2|≢regexes ⍝ odd number of strings → many-to-one
         from←¯1↓regexes ⍝ remove transformation pattern/function
         :If ~'⍵'∊last ⍝ no ⍵ → pattern
             Expand←'⍵B' '⍵b' '⍵P' '⍵p' '⍵M' '⍵O' '⍵L' '⍵N'⎕R'⍵.Block' '⍵.BlockNum' '⍵.Pattern' '⍵.PatternNum' '⍵.Match' '⍵.Offsets' '⍵.Lengths' '⍵.Names'
         :OrIf ~≡⎕FX,⊂'to←{',(r/',⍕{'),(Expand last),(r/'}⍵'),'}' ⍝ if definition fails, revert to pattern (allows ⍵ in pattern)
             to←last
         :EndIf
     :Else
         lines←2÷⍨≢regexes
         from←regexes↓⍨-lines
         to←lines↓regexes
     :EndIf

     combine←'{⊃,/⍵↑¨⍨⌈/≢¨⍵}'
     q←⎕NS ⍬
     q.from←⍕Quote¨Nest from
     :If 0=≢q.from
         q.from←a a
     :EndIf
     :If 1∧.=≢¨from
         q.(from←'(,¨',from,')')
     :EndIf
     :If 3=⎕NC'to'
         q.to←1⌽'  ',3↓∊⎕NR'to'
     :Else
         q.to←⍕Quote¨Nest to
         :If 0=≢q.to
             q.to←a a
         :EndIf
         :If 1∧.=≢¨to
             q.(to←'(,¨',to,')')
         :EndIf
     :EndIf
     :If 3=⎕NC'repeat'
         q.repeat←'⍣',∊⎕NR'repeat'
     :ElseIf 1≢repeat
         q.repeat←'⍣',⍕repeat
     :Else
         q.repeat←''
     :EndIf
     :If ×≢options
         q.options←'⍠',∊{' (',(Quote⊃⍵),' ',({0 1∊⍨⊂⍵:⍕⍵ ⋄ Quote ⍵}⊃⌽⍵),')'}¨options
     :Else
         q.options←''
     :EndIf
     q.op←s r/'SR'
     q.postproc←2↓postproc
     q.postproc,←(hasrepeat∧s)/(''≡q.postproc)↓'∘',combine
     q.(expr←postproc,from,'⎕',op,to,options,repeat)
     :If '?'∊args
         ⍞←q.expr,n
     :EndIf

     :If 0=≢from
         from←''
     :EndIf
     :If 2=⎕NC'to'
     :AndIf 0=≢to
         to←''
     :EndIf

     :Trap 11
         :If r
             output←from ⎕R to⍠options⍣repeat⊢input
         :ElseIf s
             output←from ⎕S to⍠options⍣repeat⊢input
             output←(⍎combine)⍣hasrepeat⊢output ⍝ merge search results if we need to continue
         :EndIf
         output←(⍎postproc)output
     :Case 11 ⍝ faulty regex
         ⍞←'*** ',⎕DMX.(Message,(''≡Message)/⊃DM),' ***',n
         ⍞←'Attempted APL expression: ',q.expr,n
     :EndTrap
 :Else
     ⍞←'*** Left operand must be ''R'' or ''S'' ***'
 :EndIf
