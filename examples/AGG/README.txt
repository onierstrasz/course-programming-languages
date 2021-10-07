---------------------------------------------------------------------------
# AGG Instructions

---------------------------------------------------------------------------
- Download AGG from <http://tfs.cs.tu-berlin.de/agg/index.html>
	- Make sure you get the right version for the Java you have installed
- Copy the examples here to a new subdirectory of the agg folder
- Start AGG by running agg.sh or agg.bat (you may have to adapt these)
- File>Open an example
- You should see the graph grammar on the left, rules on top, and the current graph below.
- You can either run the example by pressing the "S" button, which will select rules non-deterministically and run to completion, or you can select a rule to apply and step by pressing the "Next Completion" and "=>" buttons.

---------------------------------------------------------------------------
# Hints:
- context-click on the GG and turn on "Check Rule Applicability" to see which rules are currently enabled.
- Select Preferences>Options to turn on automatic layouting

---------------------------------------------------------------------------
# FAQ
Q Why are there sometimes three windows for a rule?  
A If a rule has a negative application condition (NAC), the first window shows a pattern that must *not* be matched for the rule to be active.  

---------------------------------------------------------------------------
