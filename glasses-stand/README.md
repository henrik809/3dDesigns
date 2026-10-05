# Bedside Glasses Stand

A small stand for a nightstand/bedside table that holds a pair of glasses
open: the bridge rests in a shallow seat at the top of the arch, the lenses
drape down either side, and the temples (arms) open and rest on the base in
front of and behind the arch.

- `glasses-stand.scad` — parametric OpenSCAD source
- `glasses-stand.stl` — exported binary STL, ready to slice and print

## Dimensions

- Base: 140 x 90 x 8 mm, rounded corners
- Arch: ~90 mm span, ~59 mm tall overall (base + arch), 12 mm diameter bar
- Fits most standard eyeglass/sunglass frames

## Printing notes

- No supports needed — the arch is self-supporting up to a 45° overhang
  limit on most printers (it's a smooth semicircle).
- Suggested: 0.2 mm layer height, 15-20% infill, 2-3 perimeters.
- Print with the base flat on the print bed.

## Customizing

Open `glasses-stand.scad` in OpenSCAD and adjust the parameters at the top
of the file (`base_length`, `base_width`, `arch_radius`, `arch_tube_r`,
etc.) to resize for a specific pair of glasses, then re-export the STL.
