# QuadRS
Thin covers for Dyalog APL's ⎕R and ⎕S

## ⎕R
### TIO languages.json entry
```
			"quad-r": {
				"name": "Replace (Dyalog APL)",
				"encoding": "SBCS",
				"link": "http://help.dyalog.com/16.0/Content/Language/System%20Functions/r.htm",
				"prettify": "apl",
				"update": "manual",
				"tests": {
					"helloWorld": {
						"request": [{
							"command": "F",
							"payload": {
								".code.tio": "\nHello, World!"
							}
						}],
						"response": "Hello, World!"
					}
				}
			},
```
### TIO wrapper
```
#!/usr/bin/env bash

export DYALOG=${DYALOG:-/opt/mdyalog/15.0/64/unicode}
export MAXWS=128M WSPATH=$DYALOG/ws

{
	echo "⎕PW←9999"
	echo "{}2⎕FIX'file:///opt/QuadRS/Run.dyalog'"
	echo "'.code.tio'('R'Run '$@')'.input.tio'"
	echo
} | $DYALOG/dyalog -script
```

## ⎕S
### TIO languages.json entry
```
			"quad-s": {
				"name": "Search (Dyalog APL)",
				"encoding": "SBCS",
				"link": "http://help.dyalog.com/16.0/Content/Language/System%20Functions/s.htm",
				"prettify": "apl",
				"update": "manual",
				"tests": {
					"helloWorld": {
						"request": [{
							"command": "F",
							"payload": {
								".code.tio": "\nHello, World!"
							}
						}],
						"response": "Hello, World!"
					}
				}
			},
```
### TIO wrapper
```
#!/usr/bin/env bash

export DYALOG=${DYALOG:-/opt/mdyalog/15.0/64/unicode}
export MAXWS=128M WSPATH=$DYALOG/ws

{
	echo "⎕PW←9999"
	echo "{}2⎕FIX'file:///opt/QuadRS/Run.dyalog'"
	echo "'.code.tio'('S'Run '$@')'.input.tio'"
	echo
} | $DYALOG/dyalog -script
```
