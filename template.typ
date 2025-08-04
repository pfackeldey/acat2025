#let poster(body) = {
  grid(
    columns: 1,
    rows: (10%, 1%, 85%, 1%, 3%),
    
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

    // Second row = horizontal line
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


    // Fourth row = horizontal line
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
    
    // Bottom = footer
    [
      #box(
        stroke: none,
        fill: white,
        height: 100%,
        width: 100%,
        inset: 1%,

        grid(
          columns: (60%, 40%),
          rows: 100%,
          stroke: none,
          
          // Left
          [
            #place(horizon+left)[
              #text(size: 36pt)[
                *Acknowledgements:* This work was supported by the National Science Foundation under Cooperative Agreement PHY-2323298 and grant OAC-2103945
              ]
            ]
          ],
          // Right
          [
            #place(horizon+right)[
              #text(size: 36pt)[
                *Contact:*\ #link("peter.fackeldey\@cern.ch")[peter.fackeldey\@cern.ch]
              ]
            ]
          ]
        )
      )
    ]
  )
}