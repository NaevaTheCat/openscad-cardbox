// variables
spacing = 2;
card_height = 90;
card_width = 65;
card_protrusion = 20;
groove_depth = 20;
extra_width = 2;
// slot widths
class_width = 12;
firegem_width = 12;
market_width = 42;
baseset_width = 30;
// base params
wall_thickness = 4;
base_flare = 4;
// lid params
xy_tolerance = 1;
z_tolerance = 2;

$fn = 500;
slots = [
    class_width,
    class_width,
    class_width,
    class_width,
    class_width,
    market_width,
    firegem_width,
    baseset_width,
    ];
module cardslot(slot_width) {
    // gens a card slot 1 + slot_width + 1
    translate([0, extra_width/2, 0])
    difference() {
        union() {
        cube([card_height, slot_width, card_width]);
        translate([0, slot_width/2, card_width - card_protrusion]) {
        rotate([0, 90, 0]) {
            scale([2,1, 1]) {
            cylinder(h = card_height, d = slot_width + extra_width);
            }}}}
    translate([-0.5, -1.1, card_width - card_protrusion]) {
        cube([card_height + 1, slot_width + 3, card_protrusion + (slot_width + 2)*2]);}
}
}
function offsets(slots) =  [
        for (index = 1, offset = 0;
            index < len(slots);
            offset = offset + slots[index - 1] + extra_width + spacing, index = index + 1) offset + slots[index - 1] + extra_width + spacing];
function add(v, i = 0, r = 0) = i < len(v) ? add(v, i + 1, r + v[i]) : r;
module cardslot_array(slots, spacing) {
    offsets = offsets(slots);
        cardslot(slots[0]);
    for(s = [1: len(slots) - 1]) {
        translate([0, offsets[s - 1], 0]) {
                cardslot(slots[s]);
        }
    }
}
function slotLength(slots) = slots[len(slots) - 1] + offsets(slots)[len(offsets(slots)) - 1];

module basetray(slots, base_flare, wall_thickness) {
    union() {
    cube([base_flare * 2 + wall_thickness * 2 + card_height, base_flare * 2 + wall_thickness * 2 + slotLength(slots), wall_thickness - 0.1]);
    translate([base_flare, base_flare, 0]){
difference() {
cube([card_height + wall_thickness * 2, slotLength(slots) + wall_thickness * 2, card_width - card_protrusion + wall_thickness - 0.1]);
translate([wall_thickness, wall_thickness, wall_thickness]) cardslot_array(slots, spacing);
}}}
}

module lid(slots, base_flare, wall_thickness, xy_tolerance, z_tolerance) {
    difference() {
    translate([0,0, wall_thickness]) {
    cube([base_flare * 2 + wall_thickness * 2 + card_height, 
        base_flare * 2 + wall_thickness * 2 + slotLength(slots), 
        card_width + wall_thickness + z_tolerance]);
    }
    translate([base_flare - xy_tolerance, base_flare - xy_tolerance]) {
    cube([wall_thickness * 2 + card_height + xy_tolerance * 2, 
        wall_thickness * 2 + slotLength(slots) + xy_tolerance * 2, 
        card_width + z_tolerance + wall_thickness]);
    }
    }
}

color("yellow") basetray(slots, base_flare, wall_thickness);
difference() {
color("red", 0.7) lid(slots, base_flare, wall_thickness, xy_tolerance, z_tolerance);
translate([base_flare + wall_thickness + card_height/2, base_flare + wall_thickness + slotLength(slots)/2, wall_thickness + wall_thickness/2 + card_width + z_tolerance]) rotate([0,0,90]) linear_extrude(wall_thickness/2 + 0.1) {text("Hero Realms", size =20, font="MesloLGS NF:style=Bold",halign="center", valign="center");}
}