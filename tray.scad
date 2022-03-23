/*
 * tray.scad
 *
 * Allows the design of trays with optional subdivisions. Many different configuration
 * options.
 *
 * Copyright (C) 2021 Sofian Audry https://github.com/sofian
 * 
 * This program is free software: you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation, either version 3 of the License, or (at your option) any
 * later version.
 * 
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU General Lesser Public License for more
 * details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 *
 * Usage:
 * 
 * Basic tray with curved inside:
 * tray([100, 60, 30]);
 *
 * Basic straight tray with specific thickness.
 * tray([100, 60, 30], thickness=3, curved=false);
 *
 * Multi-tray with equal subdividers (3 columns, 2 rows):
 * tray([100, 60, 30], n_columns=3, n_rows=2);
 *
 * Multi-tray with equal subdividers (3 columns, 2 rows). Dividers have lower height (20) than the main tray (30).
 * tray([100, 60, 30], n_columns=3, n_rows=2, dividers_height=20);
 *
 * Multi-tray with unequal subdividers (3 columns, 2 rows). First and last columns are at 30% of width from each side.
 * tray([100, 60, 30], n_columns=3, n_rows=2, columns=[0.3, 0.7]);
 *
 * Multi-tray with unequal subdividers (3 columns, 2 rows). First and last columns are at 30% of width from each side. 
 * Rows in first and last column are equally distributed but first row of middle column occupies only 25% of length.
 * tray([100, 60, 30], n_columns=3, n_rows=2, columns=[0.3, 0.7], rows=[false, [0.25], false]);
 *
 * Multi-tray with unequal number of rows per column, equally distributed: first column has 4 rows, second column has 2 rows and final column as 3 rows.
 * tray([100, 60, 30], n_columns=3, n_rows=[4,2,3]);
 *
 * Multi-tray with unequal number of rows per column, with specific distribution of rows and columns.
 * tray([100, 60, 30], n_columns=3, n_rows=[4,3,2], columns=[0.3, 0.7], rows=[false, [0.25, 0.5], false]);
 *
 * Multi-tray with unequal number of columns per row, equally distributed.
 * tray([100, 60, 30], n_rows=3, n_columns=[4,2,3], rows_first=true);
 * 
 * Multi-tray with unequal number of columns per row, with specific distribution of rows and columns.
 * tray([100, 60, 30], n_rows=3, n_columns=[4,3,2], rows=[0.3, 0.7], columns=[false, [0.25, 0.5], false], rows_first=true);
 *
*/

module tray(dimensions, n_columns=1, n_rows=1, columns=false, rows=false, thickness=2, curved=true,
                  bottom_thickness=undef,
                  dividers_height=undef, dividers_thickness=undef,
                  bottom_bevel_radius=undef, top_bevel_radius=undef,
                  dividers_bottom_bevel_radius=undef, dividers_top_bevel_radius=undef,
                  rows_first=false) {

	    // Main external box dimensions.
	    ext_width  = dimensions[0];
	    ext_length = dimensions[1];
	    ext_height = dimensions[2];
	    
	    // If using "rows_first" mode, tray is simply rotated with columns and rows inverted.
	    if (rows_first == true) {
	    	translate([ext_width, 0, 0])
	    	rotate([0,0,90])
	    		tray([ext_length, ext_width, ext_height], n_columns=n_rows, n_rows=n_columns, columns=rows, rows=columns,
	    		           thickness=thickness, curved=curved,
                                   dividers_height=dividers_height, dividers_thickness=dividers_thickness,
                                   bottom_bevel_radius=bottom_bevel_radius, top_bevel_radius=top_bevel_radius,
                                   dividers_bottom_bevel_radius=dividers_bottom_bevel_radius,
                                   dividers_top_bevel_radius=dividers_top_bevel_radius);
	    
            }
            
            // Default "columns_first" mode.
            else {
	    	int_width  = ext_width - 2*thickness;
	    	int_length  = ext_length - 2*thickness;
	    
	    	// Dimensions of inside trays (cells).
	    	cell_thickness = dividers_thickness!=undef ? dividers_thickness : thickness;
	    	thickness_diff = thickness - cell_thickness; // difference between exterior and interior thickness
	    	all_cells_width = (ext_width - 2*thickness_diff) + cell_thickness*(n_columns-1);
	    	cell_width = all_cells_width / n_columns;
	    	cell_bottom_bevel_radius = dividers_bottom_bevel_radius!=undef ? dividers_bottom_bevel_radius : bottom_bevel_radius;
	    	cell_top_bevel_radius    = dividers_top_bevel_radius!=undef ? dividers_top_bevel_radius : top_bevel_radius;
	    
	    	column_n_rows = n_rows[0] != undef ? n_rows : [ for (i = [0 : n_columns-1]) n_rows ];
	    	cell_height = ext_height - thickness_diff;
	    	all_cells_length = [ for (i = [0 : n_columns-1]) (ext_length - 2*thickness_diff) + cell_thickness*(column_n_rows[i]-1) ];
	    	cell_length = [ for (i = [0 : n_columns-1]) all_cells_length[i] / column_n_rows[i] ];

	    	// Draw main box.
	    	tray_outside(dimensions, thickness=thickness, curved=curved, top_bevel_radius=top_bevel_radius, bottom_thickness=bottom_thickness);

		// Create list of columns.
	    	column_width = [
			for (i = [0 : n_columns-1]) 
			    (columns == false ?
			    (i+1)*cell_width : 
			    (i != 0 && i == n_columns-1 ? 
				1 : 
				columns[i])
				* all_cells_width) 
				];
	        // Create list of rows.
	    	row_length = [
			for (i = [0 : n_columns-1]) 
			    [ for (j = [0 : column_n_rows[i]-1])
				(rows == false || rows[i] == false ?
				(j+1)*cell_length[i] : 
				(j != 0 && j == column_n_rows[i]-1 ? 
				    1 : 
				    rows[i][j]) 
				    * all_cells_length[i]) ]
			     ];

            
	        // Draw all cells.
	    	difference() {
		    translate([thickness_diff, thickness_diff, thickness_diff])
		    for (i = [0 : n_columns-1]) {
			for (j = [0 : column_n_rows[i]-1]) {
			    translate([i == 0 ? 0 : column_width[i-1] - i*cell_thickness, 
				       j == 0 ? 0 : row_length[i][j-1] - j*cell_thickness,
				       0])
			    tray_single([column_width[i] - (i == 0 ? 0 : column_width[i-1]),
				  row_length[i][j] - (j == 0 ? 0 : row_length[i][j-1]),              cell_height], 
				 thickness=cell_thickness, curved=curved, bottom_thickness=bottom_thickness, bottom_bevel_radius=cell_bottom_bevel_radius, top_bevel_radius=cell_top_bevel_radius);
			}
		    }
		    
		    // Scoop out top if dividers_height is provided.
		    if (dividers_height!=undef)
		    	tray_scoop(dimensions, dividers_height, thickness=thickness, curved=curved, top_bevel_radius=top_bevel_radius)
		    	_tray_rounded_cube([int_width, int_length, 2*(ext_height-dividers_height)],
		                     r=(top_bevel_radius >= 0 ? top_bevel_radius : (curved ? thickness : 0)), x=true, y=true, z=true);
	     	}
	     }
}

// Just creates the outside shell of main box.
module tray_outside(dimensions, thickness=2, curved=true, top_bevel_radius=undef, bottom_thickness=undef) {
	tray_single(dimensions, thickness=thickness, curved=curved, bottom_bevel_radius=0, top_bevel_radius=top_bevel_radius, bottom_thickness=bottom_thickness);
}

// Draws an inverted rounded cube used to scoop out inside using difference().
module tray_scoop(dimensions, dividers_height, thickness=2, curved=true,
                  dividers_thickness=undef, top_bevel_radius=undef) {

	    // Main external box dimensions.
	    ext_width  = dimensions[0];
	    ext_length = dimensions[1];
	    ext_height = dimensions[2];
	    int_width  = ext_width - 2*thickness;
	    int_length  = ext_length - 2*thickness;
	    translate([thickness, thickness, dividers_height])
		    	_tray_rounded_cube([int_width, int_length, 2*(ext_height-dividers_height)],
		                     r=(top_bevel_radius != undef ? top_bevel_radius : (curved ? thickness : 0)), x=true, y=true, z=true);
}

// Draws a single tray.
module tray_single(dimensions, thickness=2, curved=true, bottom_thickness=undef, bottom_bevel_radius=undef, top_bevel_radius=undef) {
    
    ext_top_bevel_radius = thickness * 0.05;
    
    // External box dimensions.
    ext_width = dimensions[0];
    ext_length = dimensions[1];
    ext_height = dimensions[2];
    
    // Inside box dimensions (to scoop out the external one).
    int_width = ext_width - 2*thickness;
    int_length = ext_length - 2*thickness;
    int_height = ext_height;
    int_top_bevel_radius = top_bevel_radius != undef ? top_bevel_radius : (curved ? thickness : 0);
    int_bottom_bevel_radius = bottom_bevel_radius != undef ? bottom_bevel_radius : (curved ? 2*thickness : 0);

    _bottom_thickness = bottom_thickness != undef ? bottom_thickness : thickness;

    // Create tray.
    difference() {
        _tray_rounded_cube([ext_width, ext_length, ext_height],
                     r=ext_top_bevel_radius,
                     x=true, rx=[0,ext_top_bevel_radius,ext_top_bevel_radius,0], 
                     y=true, ry=[ext_top_bevel_radius,ext_top_bevel_radius,0,0]);
        if (_bottom_thickness > 0)
	    translate([thickness, thickness, _bottom_thickness])
            	_tray_rounded_cube([int_width, int_length, ext_height],
                         r=int_top_bevel_radius,
                         x=true, rx=[int_bottom_bevel_radius,0,0,int_bottom_bevel_radius], 
                         y=true, ry=[0,0,int_bottom_bevel_radius,int_bottom_bevel_radius]);


	else
	    translate([thickness, thickness, 0])
            	_tray_rounded_cube([int_width, int_length, ext_height],
                         r=int_top_bevel_radius, x=false, y=false);
    }
}

/*
	roundeCube() v1.0.3 by robert@cosmicrealms.com from https://github.com/Sembiance/openscad-modules
	Allows you to round any edge of a cube
	
	Usage
	=====
	Prototype: _tray_rounded_cube(dim, r, x, y, z, xcorners, ycorners, zcorners, $fn)
	Arguments:
		-      dim = Array of x,y,z numbers representing cube size
		-        r = Radius of corners. Default: 1
		-        x = Round the corners along the X axis of the cube. Default: false
		-        y = Round the corners along the Y axis of the cube. Default: false
		-        z = Round the corners along the Z axis of the cube. Default: true
		- xcorners = Array of 4 booleans, one for each X side of the cube, if true then round that side. Default: [true, true, true, true]
		- ycorners = Array of 4 booleans, one for each Y side of the cube, if true then round that side. Default: [true, true, true, true]
		- zcorners = Array of 4 booleans, one for each Z side of the cube, if true then round that side. Default: [true, true, true, true]
		-       rx = Radius of the x corners. Default: [r, r, r, r]
		-       ry = Radius of the y corners. Default: [r, r, r, r]
		-       rz = Radius of the z corners. Default: [r, r, r, r]
		-   center = Whether to render the cube centered or not. Default: false
		-      $fn = How smooth you want the rounding to be. Default: 128

	Change Log
	==========
	2018-08-21: v1.0.3 - Added ability to set the radius of each corner individually with vectors: rx, ry, rz
	2017-05-15: v1.0.2 - Fixed bugs relating to rounding corners on the X axis
	2017-04-22: v1.0.1 - Added center option
	2017-01-04: v1.0.0 - Initial Release

	Thanks to Sergio Vilches for the initial code inspiration
*/

// Example code:

/*cube([5, 10, 4]);

translate([8, 0, 0]) { _tray_rounded_cube([5, 10, 4], r=1); }
translate([16, 0, 0]) { _tray_rounded_cube([5, 10, 4], r=1, zcorners=[true, false, true, false]); }

translate([24, 0, 0]) { _tray_rounded_cube([5, 10, 4], r=1, y=true, z=false); }
translate([32, 0, 0]) { _tray_rounded_cube([5, 10, 4], r=1, x=true, z=false); }
translate([40, 0, 0]) { _tray_rounded_cube([5, 10, 4], r=1, x=true, y=true, z=true); }
*/

module _tray_rounded_cube(dim, r=1, x=false, y=false, z=true, xcorners=[true,true,true,true], ycorners=[true,true,true,true], zcorners=[true,true,true,true], center=false, rx=[undef, undef, undef, undef], ry=[undef, undef, undef, undef], rz=[undef, undef, undef, undef], $fn=128)
{
	translate([(center==true ? (-(dim[0]/2)) : 0), (center==true ? (-(dim[1]/2)) : 0), (center==true ? (-(dim[2]/2)) : 0)])
	{
		difference()
		{
			cube(dim);

			if(z)
			{
				translate([0, 0, -0.1])
				{
					if(zcorners[0])
						translate([0, dim[1]-(rz[0]==undef ? r : rz[0])]) { _tray_rotate_around([0, 0, 90], [(rz[0]==undef ? r : rz[0])/2, (rz[0]==undef ? r : rz[0])/2, 0]) { _tray_meniscus(h=dim[2], r=(rz[0]==undef ? r : rz[0]), fn=$fn); } }
					if(zcorners[1])
						translate([dim[0]-(rz[1]==undef ? r : rz[1]), dim[1]-(rz[1]==undef ? r : rz[1])]) { _tray_meniscus(h=dim[2], r=(rz[1]==undef ? r : rz[1]), fn=$fn); }
					if(zcorners[2])
						translate([dim[0]-(rz[2]==undef ? r : rz[2]), 0]) { _tray_rotate_around([0, 0, -90], [(rz[2]==undef ? r : rz[2])/2, (rz[2]==undef ? r : rz[2])/2, 0]) { _tray_meniscus(h=dim[2], r=(rz[2]==undef ? r : rz[2]), fn=$fn); } }
					if(zcorners[3])
						_tray_rotate_around([0, 0, -180], [(rz[3]==undef ? r : rz[3])/2, (rz[3]==undef ? r : rz[3])/2, 0]) { _tray_meniscus(h=dim[2], r=(rz[3]==undef ? r : rz[3]), fn=$fn); }
				}
			}

			if(y)
			{
				translate([0, -0.1, 0])
				{
					if(ycorners[0])
						translate([0, 0, dim[2]-(ry[0]==undef ? r : ry[0])]) { _tray_rotate_around([0, 180, 0], [(ry[0]==undef ? r : ry[0])/2, 0, (ry[0]==undef ? r : ry[0])/2]) { _tray_rotate_around([-90, 0, 0], [0, (ry[0]==undef ? r : ry[0])/2, (ry[0]==undef ? r : ry[0])/2]) { _tray_meniscus(h=dim[1], r=(ry[0]==undef ? r : ry[0])); } } }
					if(ycorners[1])
						translate([dim[0]-(ry[1]==undef ? r : ry[1]), 0, dim[2]-(ry[1]==undef ? r : ry[1])]) { _tray_rotate_around([0, -90, 0], [(ry[1]==undef ? r : ry[1])/2, 0, (ry[1]==undef ? r : ry[1])/2]) { _tray_rotate_around([-90, 0, 0], [0, (ry[1]==undef ? r : ry[1])/2, (ry[1]==undef ? r : ry[1])/2]) { _tray_meniscus(h=dim[1], r=(ry[1]==undef ? r : ry[1])); } } }
					if(ycorners[2])
						translate([dim[0]-(ry[2]==undef ? r : ry[2]), 0]) { _tray_rotate_around([-90, 0, 0], [0, (ry[2]==undef ? r : ry[2])/2, (ry[2]==undef ? r : ry[2])/2]) { _tray_meniscus(h=dim[1], r=(ry[2]==undef ? r : ry[2])); } }
					if(ycorners[3])
						_tray_rotate_around([0, 90, 0], [(ry[3]==undef ? r : ry[3])/2, 0, (ry[3]==undef ? r : ry[3])/2]) { _tray_rotate_around([-90, 0, 0], [0, (ry[3]==undef ? r : ry[3])/2, (ry[3]==undef ? r : ry[3])/2]) { _tray_meniscus(h=dim[1], r=(ry[3]==undef ? r : ry[3])); } }
				}
			}

			if(x)
			{
				translate([-0.1, 0, 0])
				{
					if(xcorners[0])
						translate([0, dim[1]-(rx[0]==undef ? r : rx[0])]) { _tray_rotate_around([0, 90, 0], [(rx[0]==undef ? r : rx[0])/2, 0, (rx[0]==undef ? r : rx[0])/2]) { _tray_meniscus(h=dim[0], r=(rx[0]==undef ? r : rx[0])); } }
					if(xcorners[1])
						translate([0, dim[1]-(rx[1]==undef ? r : rx[1]), dim[2]-(rx[1]==undef ? r : rx[1])]) { _tray_rotate_around([90, 0, 0], [0, (rx[1]==undef ? r : rx[1])/2, (rx[1]==undef ? r : rx[1])/2]) { _tray_rotate_around([0, 90, 0], [(rx[1]==undef ? r : rx[1])/2, 0, (rx[1]==undef ? r : rx[1])/2]) { _tray_meniscus(h=dim[0], r=(rx[1]==undef ? r : rx[1])); } } }
					if(xcorners[2])
						translate([0, 0, dim[2]-(rx[2]==undef ? r : rx[2])]) { _tray_rotate_around([180, 0, 0], [0, (rx[2]==undef ? r : rx[2])/2, (rx[2]==undef ? r : rx[2])/2]) { _tray_rotate_around([0, 90, 0], [(rx[2]==undef ? r : rx[2])/2, 0, (rx[2]==undef ? r : rx[2])/2]) { _tray_meniscus(h=dim[0], r=(rx[2]==undef ? r : rx[2])); } } }
					if(xcorners[3])
						_tray_rotate_around([-90, 0, 0], [0, (rx[3]==undef ? r : rx[3])/2, (rx[3]==undef ? r : rx[3])/2]) { _tray_rotate_around([0, 90, 0], [(rx[3]==undef ? r : rx[3])/2, 0, (rx[3]==undef ? r : rx[3])/2]) { _tray_meniscus(h=dim[0], r=(rx[3]==undef ? r : rx[3])); } }
				}
			}
		}
	}
}

module _tray_meniscus(h, r, fn=128)
{
	$fn=fn;

	difference()
	{
		cube([r+0.2, r+0.2, h+0.2]);
		translate([0, 0, -0.1]) { cylinder(h=h+0.4, r=r); }
	}
}

module _tray_rotate_around(a, v) { translate(v) { rotate(a) { translate(-v) { children(); } } } }
