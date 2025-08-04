#let poster(body) = {
  grid(
    columns: 1,
    rows: (10%, 1%, 85%, 4%),
    
    // Top = title row
    [
      #box(
        stroke: none,
        fill: white,
        height: 100%,
        width: 100%,
        inset: 4%,

        grid(
          columns: (12%, 76%, 12%),
          rows: 100%,
          stroke: none,
                
          // Left
          [
            #place(horizon+left, figure(image("princeton-logo.svg", width: auto, height: 240pt)))
          ],
          // Center
          [
            #place(horizon+center)[
                #set text(size: 68pt,
                fill: black,
                )
                *Recent developments in the Awkward Array world* \
                #set text(size: 48pt)
                *Peter Fackeldey*, Ianna Osborne, Jim Pivarski \
                Princeton University
              ]  
          ],
          [
            #place(horizon+right, figure(image("Iris-hep-5-just-graphic.svg", width: auto, height: 240pt)))
          ]
        )
      )
    ],

    [
    #box(
      stroke: none,
      fill: white,
      height: 100%,
      width: 100%,
      inset: 1%,

      line(length: 100%, stroke: (paint: black, thickness: 4pt, cap: "round"))
      )
    ],

    // Middle = body
    [
      #box(
        height: 100%,    
        inset: 1%,
        fill: white,
        
        columns(2)[#body]
      )
    ],
    
    // Bottom = footer
    [
      #box(
        stroke: none,
        fill: white,
        height: 100%,
        width: 100%,
        inset: 4%,

        align(horizon+center)[#emoji.mail peter.fackeldey\@cern.ch]
      )
    ]
  )
}