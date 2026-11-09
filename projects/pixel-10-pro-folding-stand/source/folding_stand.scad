// Foldable phone stand for Google Pixel 10 Pro (152.8 x 72.0 x 8.6 mm)
//
// Print-in-place, no supports: print flat, front face up, in the orientation exported.
//   Ledge L  --hinge 1--  Back plate P (with window)  --hinge 2--  Leg G (sits in the window)
// Fold flat: swing the leg into the window, then fold the ledge over the back plate.
// All units mm.  Render a part with  -D 'part="flat|use|folded|ledge|plate|leg"'

/* [Phone] */
phone_w    = 72.0;  // Pixel 10 Pro width  (152.8 x 72.0 x 8.6 mm)
side_slack = 1.0;   // clearance per side between phone and posts (raise for a case)

/* [Stand] */
alpha    = 57;      // lean of back plate from horizontal (deg)
tau      = 10;      // leg tilt from vertical (deg); smaller = more friction margin
Y2       = 100;     // distance from hinge 1 to hinge 2 axis (sets plate / leg length)
TP       = 5.6;     // back plate + leg thickness
TL       = 3.2;     // ledge thickness
post_w   = 5;       // side post width
post_h   = 6;       // side post height above ledge
post_len = 18;      // side post length
Ld       = 28;      // ledge depth
strip    = 8;       // plate material above hinge 2
leg_w    = 44;      // leg width

/* [Hinges] */
c   = 0.5;          // clearance
g   = 0.5;          // axial gap between knuckles
rp  = 1.2;          // pin radius (hinge 2)
rb  = 1.6;          // bore radius (hinge 2)
rp1 = 1.5;          // pin radius (hinge 1)
rb1 = 1.9;          // bore radius (hinge 1)
R1  = 5.0;          // hinge 1 barrel radius (axis height; lets ledge stack above plate)
R2  = TP/2;         // hinge 2 barrel radius (flush with plate faces)
nseg = 5;

W   = phone_w + 2*side_slack + 2*post_w;
sl  = (W - (nseg-1)*g) / nseg;
function segx(i) = i*(sl+g);

zc1 = R1;
zc2 = R2;
y0  = R1 + c;                       // plate starts here
// use-pose geometry
phiG = -(90 - tau);
A_y  = Y2*cos(alpha) - (zc2-zc1)*sin(alpha);
A_z  = zc1 + Y2*sin(alpha) + (zc2-zc1)*cos(alpha);
gp   = 180 + phiG - alpha;          // leg swing relative to the plate (leg folds into window at 0)
psi  = alpha + gp;                  // leg orientation in the use pose
Lg   = (A_z + R2*abs(cos(psi)) - 1.0) / sin(psi);
wx0  = (W-leg_w)/2 - g;  wx1 = W - wx0;           // window x range
ywb  = Y2 - Lg - c;      ywt = Y2 + R2 + c;       // window y range
Pl   = ywt + strip - y0;

// ---------- hinge 1 helpers ----------
module seg1(i, thick, toward) {
    translate([segx(i), 0, 0]) {
        translate([0, 0, zc1]) rotate([0,90,0]) cylinder(r=R1, h=sl, $fn=64);
        translate([0, toward<0 ? -(R1+c) : 0, 0]) cube([sl, R1+c, thick]);
    }
}
module bore1(i) { translate([segx(i)-0.01, 0, zc1]) rotate([0,90,0]) cylinder(r=rb1, h=sl+0.02, $fn=32); }

// ---------- Ledge ----------
module ledge() {
    union() {
        translate([0, -y0-Ld, 0]) cube([W, Ld, TL]);
        for (i=[0,2,4]) seg1(i, TL, -1);
        translate([0, 0, zc1]) rotate([0,90,0]) cylinder(r=rp1, h=W, $fn=32);
        for (x=[0, W-post_w])
            translate([x, -y0-0.5-post_len, 0]) cube([post_w, post_len, TL+post_h]);
    }
}

// ---------- Back plate ----------
module back_plate() {
    difference() {
        union() {
            difference() {
                translate([0, y0, 0]) cube([W, Pl, TP]);
                // pockets that receive the ledge posts when folded
                for (x=[-0.01, W-post_w-0.5])
                    translate([x, y0-0.01, -1]) cube([post_w+0.51, post_len+0.5+0.5, TP+2]);
                // leg window
                translate([wx0, ywb, -1]) cube([wx1-wx0, ywt-ywb, TP+2]);
            }
            for (i=[1,3]) seg1(i, TP, +1);
            // hinge 2 pin, fused into the window side rails
            translate([wx0-8, Y2, zc2]) rotate([0,90,0]) cylinder(r=rp, h=wx1-wx0+16, $fn=32);
        }
        for (i=[1,3]) bore1(i);
    }
}

// ---------- Leg ----------
module leg_body() {
    x0 = (W-leg_w)/2;
    difference() {
        union() {
            translate([x0, Y2-Lg, 0]) cube([leg_w, Lg, TP]);
            translate([x0, Y2, zc2]) rotate([0,90,0]) cylinder(r=R2, h=leg_w, $fn=48);
        }
        translate([x0-0.01, Y2, zc2]) rotate([0,90,0]) cylinder(r=rb, h=leg_w+0.02, $fn=32);
        // lightening slot
        translate([x0+10, Y2-Lg+14, -1]) cube([leg_w-20, Lg-34, TP+2]);
    }
}
module leg() {   // foot bevelled flat to the table in the use pose
    difference() {
        leg_body();
        translate([0, Y2, zc2]) rotate([-psi,0,0]) translate([-1, -A_y, -A_z])
            translate([0,-500,-1000]) cube([W+2, 1000, 1000]);
    }
}

// ---------- poses ----------
module P_at(a) { translate([0,0,zc1]) rotate([a,0,0]) translate([0,0,-zc1]) children(); }
module G_at(b) { translate([0,Y2,zc2]) rotate([b,0,0]) translate([0,-Y2,-zc2]) children(); }
module pose_use()    { ledge(); P_at(alpha) { back_plate(); G_at(gp) leg(); } }
module pose_folded() { back_plate(); leg_body();
                       translate([0,0,zc1]) rotate([-180,0,0]) translate([0,0,-zc1]) ledge(); }

part = "flat";
if (part == "flat")        { ledge(); back_plate(); leg_body(); }
else if (part == "use")    pose_use();
else if (part == "folded") pose_folded();
else if (part == "ledge")  ledge();
else if (part == "plate")  back_plate();
else if (part == "leg")    leg();
echo(W=W, Lg=Lg, Pl=Pl, gp=gp, A_y=A_y, A_z=A_z, win_bottom=ywb, plate_start=y0,
     total_len=(Pl+y0)+(Ld+y0));
