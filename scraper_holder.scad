
// TODO FSC: chamfer the edges!


block_width = 20;
side_height = 10.4;
side_height2 = 5.1;
module endcap()
{
    cube([3,block_width,block_width]);
    hull()
    {
        translate([3,2,(block_width - side_height)/2]) cube([18,1.3,side_height]);
        translate([3,3.7,(block_width - side_height2)/2]) cube([18,1.3,side_height2]);
    }
    hull()
    {
        translate([3,block_width-2-1.3,(block_width - side_height)/2]) cube([18,1.3,side_height]);
        translate([3,block_width-3.7-1.3,(block_width - side_height2)/2]) cube([18,1.3,side_height2]);
    }
    translate([3, 10,10]) rotate([0,90,0]) cylinder(h=8, d=4, $fn=90);
}

module holder_arms()
{
    arm_separation = 15;
    arm_thickness = 2.5;
    arm_length = 12;
    arm_a = block_width/2 - arm_separation/2 - arm_thickness;
    arm_b = block_width/2 + arm_separation/2;
    translate([-arm_length,arm_a,(block_width-arm_thickness)/2]) cube([arm_length,arm_thickness,arm_thickness]);
    translate([-arm_length,arm_b,(block_width-arm_thickness)/2]) cube([arm_length,arm_thickness,arm_thickness]);

    translate([-arm_length,arm_a+4+arm_thickness,(block_width-arm_thickness)/2]) mirror([0,1,0]) rotate(90) rotate_extrude(angle=50, $fn=30) translate([4,0,0]) square([arm_thickness,arm_thickness]);
    translate([-arm_length,arm_b-(4),(block_width-arm_thickness)/2]) rotate(90) rotate_extrude(angle=50, $fn=30) translate([4,0,0]) square([arm_thickness,arm_thickness]);
}

module holder_prop()
{
    dist_from_endcap = 10;
    gap_for_tool = 8;
    structure_width = 3;
    tool_gap_length = 20;
    tool_holder_length = tool_gap_length + 2 * structure_width;
    
    // separation from endcap cube
    translate([-dist_from_endcap, (block_width - tool_gap_length) / 2, 0]) cube([dist_from_endcap, tool_gap_length, structure_width]);
    
    // support to endcap
    color("red") hull()
    {
        translate([0,0,structure_width+3]) cube([1,block_width,2]);
        translate([-4,0,structure_width-1]) cube([5,block_width,1]);
    }
    color("red") hull()
    {
        translate([0,0,-3]) cube([1,block_width,2]);
        translate([-4,0,0]) cube([5,block_width,1]);
    }
    
    // tool holder
    difference()
    {
        union()
        {
            // Nearest bar arm
            translate([-dist_from_endcap, (block_width - tool_holder_length) / 2, 0]) cube([structure_width, tool_holder_length + 0.9*structure_width, structure_width]);
            hull()
            {
                rad = structure_width / 4;
                translate([-dist_from_endcap + rad, structure_width - rad/2 + (block_width + tool_holder_length) / 2, 0]) cylinder(r=rad, h=structure_width, $fn=20);
                translate([-dist_from_endcap + structure_width - rad, structure_width - rad/2 + (block_width + tool_holder_length) / 2, 0]) cylinder(r=rad, h=structure_width, $fn=20);
            }
            
            // Furthest bar arm
            translate([-dist_from_endcap - gap_for_tool - structure_width, (block_width - tool_holder_length) / 2, 0]) cube([structure_width, tool_holder_length, structure_width]);
            
            // Connecting bar arm
            translate([-dist_from_endcap - gap_for_tool - structure_width, (block_width - tool_holder_length) / 2, 0]) cube([gap_for_tool + 2 * structure_width, structure_width, structure_width]);
            
            translate([-dist_from_endcap - gap_for_tool - 1.2*structure_width, (block_width + tool_holder_length) / 2, 0]) cylinder(r=structure_width+1, h = structure_width, $fn=20);
        }
        translate([-dist_from_endcap + 1.2*structure_width, (block_width + tool_holder_length) / 2, -1]) cylinder(r=2, h = structure_width + 2, $fn=20);
        translate([-dist_from_endcap - gap_for_tool - 1.2*structure_width, (block_width + tool_holder_length) / 2, -1]) cylinder(r=2, h = structure_width + 2, $fn=20);
    }
    
    // Loop
    translate([-dist_from_endcap + 1.2*structure_width, (block_width + tool_holder_length) / 2, -1])
    {
        loop_rad = 1.6;
        // Two rods
        cylinder(r = loop_rad, h = structure_width+2, $fn = 20);
        translate([ - gap_for_tool - 2.4*structure_width, 0, 0]) cylinder(r = loop_rad, h = structure_width+2, $fn = 20);
        
        // Extra rod
        translate([ - gap_for_tool, 0, -loop_rad]) cylinder(r = loop_rad - 0.3, h = structure_width + 2 + 2*loop_rad, $fn = 20);
        
        //Two bars
        translate([-loop_rad,0,-loop_rad]) rotate([0,-90,0]) cylinder(r = loop_rad, h = gap_for_tool + 2.4*structure_width - 2*loop_rad, $fn = 20);
        translate([-loop_rad,0,structure_width + 2 + loop_rad]) rotate([0,-90,0]) cylinder(r = loop_rad, h = gap_for_tool + 2.4*structure_width - 2*loop_rad, $fn = 20);
        
        // Corners
        translate([-(gap_for_tool + 2.4*structure_width - loop_rad),0,0]) rotate([90, 0, 0]) rotate_extrude(angle=90, $fn=20) translate([-loop_rad,0,0]) circle(r=loop_rad, $fn=20);
        translate([-(gap_for_tool + 2.4*structure_width - loop_rad),0,structure_width + 2]) rotate([90, 90, 0]) rotate_extrude(angle=90, $fn=20) translate([-loop_rad,0,0]) circle(r=loop_rad, $fn=20);
        translate([-loop_rad,0,structure_width + 2]) rotate([90, 180, 0]) rotate_extrude(angle=90, $fn=20) translate([-loop_rad,0,0]) circle(r=loop_rad, $fn=20);
        translate([-loop_rad,0,0]) rotate([90, 270, 0]) rotate_extrude(angle=90, $fn=20) translate([-loop_rad,0,0]) circle(r=loop_rad, $fn=20);
    }
    
}

endcap();
translate([0, 0, 1+2+1.6]) holder_prop();


