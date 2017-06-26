# QuadRS
Thin covers for Dyalog APL's ⎕R and ⎕S

### TIO wrapper for ⎕R

```
#!/usr/bin/env bash

export DYALOG=${DYALOG:-/opt/mdyalog/15.0/64/unicode}
export MAXWS=128M WSPATH=$DYALOG/ws

{
	echo "⎕PW←9999"
	echo "{}2⎕FIX'file:///opt/QuadRS/Run.dyalog'"
	echo "'.code.tio'('R'Run '.arguments.tio')'.input.tio'"
	echo
} | $DYALOG/dyalog -script "$@"
```

### TIO wrapper for ⎕S
```
#!/usr/bin/env bash

export DYALOG=${DYALOG:-/opt/mdyalog/15.0/64/unicode}
export MAXWS=128M WSPATH=$DYALOG/ws

{
	echo "⎕PW←9999"
	echo "{}2⎕FIX'file:///opt/QuadRS/Run.dyalog'"
	echo "'.code.tio'('S'Run '.arguments.tio')'.input.tio'"
	echo
} | $DYALOG/dyalog -script "$@"
```
