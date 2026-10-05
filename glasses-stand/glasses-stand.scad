// Bedside glasses stand
// A rounded arch cradles the glasses (bridge resting at the apex, lenses
// draping down either side, temples opened resting on the base) atop a
// stable rounded base plate.

$fn = 64;

// ---- Parameters ----------------------------------------------------------

base_length   = 140;   // X extent of the base (mm)
base_width    = 90;    // Y extent of the base (mm) - front-to-back depth
base_thickness = 8;    // base plate thickness (mm)
base_corner_r = 10;    // base plate corner rounding radius (mm)

arch_radius   = 45;    // arch centerline radius, i.e. half the span between
                        // the two points where the arch meets the base (mm)
arch_tube_r   = 6;     // radius of the round bar the arch is made from (mm)

groove_r      = 4.5;   // radius of the shallow seat cut at the apex for the
                        // glasses' bridge/nose piece to rest in (mm)
groove_depth  = 2.2;   // how deep the seat cut sinks into the arch (mm)

leg_embed     = base_thickness - 1.5; // how far the support legs sink into
                                       // the base, leaving a solid floor

// ---- Base plate ------------------------------------------------------------

module base_plate() {
    linear_extrude(height = base_thickness)
        offset(r = base_corner_r)
            square([base_length - 2 * base_corner_r,
                     base_width  - 2 * base_corner_r],
                    center = true);
}

// ---- Arch --------------------------------------------------------------

// A semicircular tube (an "arch") standing upright, spanning the X axis,
// with its apex above the origin.
module arch() {
    rotate([90, 0, 0])
        rotate_extrude(angle = 180)
            translate([arch_radius, 0])
                circle(r = arch_tube_r);
}

// Vertical legs that fuse the arch's ground-tangent ends solidly into the
// base plate (a tangent line alone would be a weak, hard-to-print joint).
module arch_legs() {
    for (x = [-arch_radius, arch_radius])
        translate([x, 0, -leg_embed])
            cylinder(r = arch_tube_r * 0.95, h = leg_embed + arch_tube_r * 0.7);
}

// Shallow seat at the apex so the glasses' bridge/nose piece has a flat
// spot to rest in rather than balancing on a bare round bar.
module apex_seat_cut() {
    translate([0, 0, arch_radius + arch_tube_r - groove_depth])
        rotate([0, 90, 0])
            cylinder(r = groove_r, h = arch_tube_r * 3, center = true);
}

// ---- Assembly ------------------------------------------------------------

module glasses_stand() {
    translate([0, 0, base_thickness])
        difference() {
            union() {
                arch();
                arch_legs();
            }
            apex_seat_cut();
        }
    base_plate();
}

glasses_stand();
