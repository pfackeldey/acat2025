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
        inset: 1%,

        grid(
          columns: (10%, 78%, 10%),
          rows: 100%,
          stroke: none,
                
          // Left
          [
            #place(horizon+left, figure(image("princeton-logo.svg", width: auto, height: 220pt)))
          ],
          // Center
          [
            #place(horizon+center)[
                #text(size: 70pt, fill: black)[
                  *Recent developments in the Awkward Array world*
                  #v(15%, weak: true)
                ]
                #text(size: 42pt)[
                  *Peter Fackeldey#super[1]*, 
                  Iason Krommydas#super[2], 
                  Ianna Osborne#super[1], 
                  Jim Pivarski#super[1], 
                  Andres Rios-Tascon#super[1]
                  \
                  Princeton University#super[1],
                  Rice University#super[2]
                ]
              ]  
          ],
          [
            #place(horizon+right, figure(image("Iris-hep-5-just-graphic.svg", width: auto, height: 220pt)))
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