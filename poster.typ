#import "template.typ": *

#import "@preview/gentle-clues:1.2.0": *
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()


// poster configuration
#set page(
  paper: "a0", 
  margin: 1in, 
  columns: 1  
)

// global styling & colors
#set text(size: 26pt)
#show link: set text(fill: blue)
#show link: underline

#let princeton-zebra-fill = rgb("#a0a0a01a")
#let princeton-orange = rgb("#E77500")


// poster content, function from `template.typ`
#poster[

#abstract(title: "Summary of new features")[
    #emoji.label Named axis for Awkward Arrays \
    #emoji.sparkles Virtual Arrays for Awkward Array \
    #emoji.page RNTuple support in Uproot (reading and writing) \
    #emoji.fire Performance improvements in Awkward Array and Vector \
    #emoji.brain Memory improvements in Awkward Array and Uproot \
]

= Named axis for Awkward Arrays

You can now add named axis (or algebraic shapes) to `ak.Array`, use them with awkward's operations, and leverage a new named axis based indexing syntax:


#codly(
  languages: codly-languages,
  zebra-fill: princeton-zebra-fill,
  highlights: (
  (line: 3, start: 48, end: 68, fill: princeton-orange),
  (line: 5, start: 15, end: 22, fill: princeton-orange),
  (line: 8, start: 7, end: 23, fill: princeton-orange),
)  
)
```python
import awkward as ak

array = ak.Array([[1, 2], [3], [], [4, 5, 6]], named_axis=("x", "y"))

ak.sum(array, axis="y")
# <Array [3, 3, 0, 15] x:0 type='4 * int64'>

array[{"y": np.s_[0:1]}]
# <Array [[1], [3], [], [4]] x:0,y:1 type='4 * var * int64'>
```

Named axis provide more safety and readability for array manipulations with Awkward Array.
For more details, check out the documentation: #link("https://awkward-array.org/doc/main/user-guide/how-to-array-properties-named-axis.html")[https://awkward-array.org/doc/main/user-guide/how-to-array-properties-named-axis.html]

= Virtual Arrays for Awkward Array

Awkward Array does support virtual arrays, i.e. representing not-yet-loaded arrays in memory.
These arrays are loaded on-demand when Awkward Arrays needs them to perform an operation.
An example of virtual arrays in the scope of the coffea 2025 project is shown in the following:

#codly(
  languages: codly-languages,
  zebra-fill: princeton-zebra-fill,
  highlights: (
    (line: 7, start: 5, end: 18, fill: princeton-orange),
  ),
)
```python
import awkward as ak
from coffea.nanoevents import NanoEventsFactory

# construct a coffea.NanoEvents collection without reading!
events = NanoEventsFactory.from_root(
    {"nanoaod.root": "Events"}, 
    mode="virtual",
    access_log=(log := []),
).events()


print(events.Jet.pt)
# [??, ??, ??, ??, ..., ??, ??, ??, ??]
```<varray-1>

`??` indicates that the values are not yet loaded into memory.
You can access the values of these virtual arrays in two ways.

1. Explicitly load them into memory using `ak.materialize()`:
#codly(
  languages: codly-languages,
  zebra-fill: princeton-zebra-fill,
  highlights: (
    (line: 14, start: 7, end: 20, fill: princeton-orange),
  ),
  offset-from: <varray-1>,
  display-icon: false,
  display-name: false,
)
```python
print(ak.materialize(events.Jet.pt))
# [[50.1, 47.3], ..., [62.4, ..., 16]]
```<varray-2>

2. Implicitly through any operation that needs the values:
#codly(
  languages: codly-languages,
  zebra-fill: princeton-zebra-fill,
  offset-from: <varray-2>,
  display-icon: false,
  display-name: false,
)
```python
print(events.Electron.pt)
# [??, ??, ??, ??, ..., ??, ??, ??, ??]
print(events.Electron.pt > 40.)
# [[True, True], ..., [True, False]]
```<varray-3>

Finally, let's make sure we only loaded the columns we need from the file:
#codly(
  languages: codly-languages,
  zebra-fill: princeton-zebra-fill,
  offset-from: <varray-3>,
  display-icon: false,
  display-name: false,
)
```python
print(log)
# ['nJet', 'Jet_pt', 'nElectron', 'Electron_pt']
```

The new virtual arrays in Awkward Array v2 have been carefully implemented at the lowest level enabling highly granular laziness.
This integrates well with modern file formats like ROOT's RNTuple that allows reading data at the same high granularity.


= RNTuple support in Uproot (reading and writing)
#lorem(50)
= Performance improvements in Awkward Array and Vector
#lorem(50)
= Memory improvements in Awkward Array and Uproot
#lorem(50)

]