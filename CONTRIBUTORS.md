# Contribution history

Implementation of RAKE - Rapid Automatic Keyword Extraction algorithm
as described in:
Rose, S., D. Engel, N. Cramer, and W. Cowley (2010).
Automatic keyword extraction from individual documents.
In M. W. Berry and J. Kogan (Eds.), Text Mining: Applications and Theory.unknown: John Wiley and Sons, Ltd.

The original code (from https://github.com/aneesha/RAKE)
has been extended by a_medelyan (zelandiya)
with a set of heuristics to decide whether a phrase is an acceptable candidate
as well as the ability to set frequency and phrase length parameters
important when dealing with longer documents

The code published by a_medelyan (https://github.com/zelandiya/RAKE-tutorial)
has been additionally extended by Marco Pegoraro to implement the adjoined candidate
feature described in section 1.2.3 of the original paper. Note that this creates the
need to modify the metric for the candidate score, because the adjoined candidates
have a very high score (because of the nature of the original score metric)

This library was converted to Julia from the Python library by a_medelyan 
(https://github.com/zelandiya/RAKE-tutorial)
