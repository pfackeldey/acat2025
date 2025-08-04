#import "template.typ": *

#import "@preview/cetz:0.4.0": canvas, draw
#import "@preview/cetz-plot:0.1.2": plot
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
#set text(size: 28pt)
#show link: set text(fill: blue)
#show link: underline

#let princeton-zebra-fill = rgb("#a0a0a01a")
#let princeton-orange = rgb("#E77500")


// poster content, function from `template.typ`
#poster[

= #emoji.label Named axis for Awkward Arrays

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
For more details, check out the #link("https://awkward-array.org/doc/main/user-guide/how-to-array-properties-named-axis.html")[named axis documentation].

= #emoji.sparkles Virtual Arrays for Awkward Array

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


= #emoji.page RNTuple support in Uproot (reading and writing)

ROOT's RNTuple format is a modern file format for columnar data storage.
Uproot supports reading (since #link("https://github.com/scikit-hep/uproot5/releases/tag/v5.5.1")[v5.5.1]) and writing (since #link("https://github.com/scikit-hep/uproot5/releases/tag/v5.6.0")[v5.6.0]) #link("https://cds.cern.ch/record/2923186")[RNTuple v1.0.0.0] files.

An example of inspecting an RNTuple file with Uproot is shown in the following:
#codly(
  languages: codly-languages,
  zebra-fill: princeton-zebra-fill,
  highlights: (
    (line: 5, start: 15, end: 29, fill: princeton-orange),
  ),
  display-icon: true,
  display-name: true,
)
```python
import uproot

file = uproot.open("staff_rntuple_v1-0-0-0.root")
print(file.classnames())
# {'Staff;1': 'ROOT::RNTuple'}
```<rntuple-1>

Reading the RNTuple's contents is as easy as reading TTrees with Uproot:
#codly(
  languages: codly-languages,
  zebra-fill: princeton-zebra-fill,
  offset-from: <rntuple-1>,
  display-icon: false,
  display-name: false,
)
```python
rntuple = file["Staff"]

print(rntuple["Age"].array())
# [58, 63, 56, 61, 52, 60, 53, ..., 38, 26, 51, 25, 35, 28, 43]
print(rntuple.arrays(["Age", "Cost", "Nation"]))
# [{Age: 58, Cost: 11975, ...}, ..., {Age: 43, Cost: 12716, ...}]
```
(full link to this rntuple file can be found #link("https://raw.githubusercontent.com/scikit-hep/scikit-hep-testdata/refs/heads/main/src/skhep_testdata/data/ntpl001_staff_rntuple_v1-0-0-0.root")[here].)

= #emoji.fire Performance gains in Awkward Array and Vector

Several performance improvements have been made in Awkward Array and Vector.
For example, the #link("https://github.com/iris-hep/idap-200gbps/blob/main/agc-coffea-2024.ipynb")[trijet mass reconstruction of the _Analysis Grand Challenge_ (AGC)] runs ~15-20% faster since Awkward Array #link("https://github.com/scikit-hep/awkward/releases/tag/v2.7.3")[v2.7.3].
This is achieved by reducing the metadata overhead on the Python side of Awkward Array for any `ak.layout.RecordArray`, see the improvements for the trijet mass reconstruction with 100.000 events below:

#underline[CPU backend:] #h(1fr) Relative improvement:
- Runtime: 29.3 ms ± 434 μs $->$ *25.1 ms ± 126 μs* #h(1fr) *14.3%*
- Allocations: 3691 $->$ *2633* #h(1fr) *39.3%*

#underline[TypeTracer backend:]
- Runtime: 30.3 ms ± 145 μs $->$ *24.4 ms ± 195 μs* #h(1fr) *19.5%*
- Allocations: 2882 $->$ *1816* #h(1fr) *36.9%*

The Vector library has also seen performance improvements with #link("https://github.com/scikit-hep/vector/releases/tag/v1.6.1")[v1.6.1] and newer.
By by-passing metadata overhead and grouping operations, the performance of the _whole_ Vector library is often improved by factors of 2 and more, see the $p_T$ calculation of a four-vector below:

#codly(
  languages: codly-languages,
  zebra-fill: princeton-zebra-fill,
  highlights: (
    (line: 8, start: 3, end: 19, fill: princeton-orange),
    (line: 12, start: 3, end: 21, fill: princeton-orange),
  ),
  display-icon: true,
  display-name: true,
)
```python
import vector
vector.register_awkward()

vec = vector.awk([{"x": 1.0, "y": 2.0, "z": 3.0, "t": 4.0}])

# pip install --upgrade "vector>1.6.0"
$timeit vec.rho
# 305 μs ± 659 ns

# pip install --upgrade "vector<1.6.0"
%timeit vec.rho
# 731 μs ± 2.26 μs
```

These Vector improvements further bring down the runtime of the trijet mass reconstruction of the AGC with 100.000 events to *19.1 ms ± 203 μs* (*18.2 ms ± 49.6 μs*) in the CPU (TypeTracer) backend.


= #emoji.brain Memory improvements in Awkward Array and Uproot

Several memory improvements have been made in Awkward Array and Uproot resolving cyclic references on the Python side.
This allows for more efficient memory management and thus usually reduces the memory footprint of physics analyses.

Especially, the memory footprint of performing multiple reads of the same file with Uproot has been improved significantly since #link("https://github.com/scikit-hep/uproot5/releases/tag/v5.4.1")[v5.4.1], essentially eliminating growing memory usage, see the following figure (with Python's GC disabled):

#align(center,
  canvas({
    import draw: *

    // Set-up a thin axis style
    set-style(axes: (stroke: .5pt, tick: (stroke: .5pt)),
              legend: (stroke: none, orientation: ttb, item: (spacing: .3), scale: 80%))

    plot.plot(
      size: (32, 8),
      x-tick-step: 1,
      x-label: "# Read call",
      y-tick-step: 1, 
      y-min: 2, 
      y-max: 7,
      y-label: "Max RSS [GB]",
      x-grid: true, y-grid: true,
      legend: "inner-north-west",
      {
        // read values
        let v541 = array(json("uproot_v5.4.1__maxrss.json"))
        let v564 = array(json("uproot_v5.6.4__maxrss.json"))

        // convert to GB
        let v541GB = v541.map(x => x / calc.pow(1024., 3))
        let v564GB = v564.map(x => x / calc.pow(1024., 3))

        // start & stop value slice
        let start = 1
        let stop = 9

        let domain = array(range(v541GB.len()-1)).slice(start, stop)

        let v541points = domain.zip(v541GB.slice(start, stop))
        plot.add(
          v541points, 
          label: " Uproot v5.4.1", 
          mark: "o", 
          mark-size: 0.3, 
          mark-style: (stroke: black), 
          style: (stroke: black, thickness: 3.0),
        )
        
        let v564points = domain.zip(v564GB.slice(start, stop))
        plot.add(
          v564points, 
          label: " Uproot v5.6.4", 
          mark: "o", 
          mark-size: 0.3, 
          mark-style: (stroke: princeton-orange), 
          style: (stroke: princeton-orange, thickness: 3.0)
        )
      })
  })
)

#clue(
  accent-color: princeton-orange,
  title: "Additional Information and Tips",
  icon: emoji.clip,
)[
    Checkout the new features and improvements in the Awkward Array world! \
    \
    If you're already a coffea user: `coffea v2025.7` (July, CalVer) release (and newer) includes all of these improvements. \
    \
    Stay up-to-date and join us on the IRIS-HEP Slack workspace at #link("iris-hep.slack.com")[iris-hep.slack.com].
]

]