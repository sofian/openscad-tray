Allows the design of trays with optional subdivisions. Many different configuration options available.

Designed to quickly create trays with different configurations, for efficient storing of parts, such as hardware, small tools, board game inserts, etc.

# Usage

In order to use, simply install in your OpenSCAD library folder and include the file ```tray.scad```:

```openscad
include <tray.scad>
```

You can then use the function ```tray()``` which comes with many different options.

```openscad
tray(dimensions, thickness=2, curved=true,
    n_columns=1, n_rows=1, columns=false, rows=false,
    dividers_height=undef, dividers_thickness=undef,
    bottom_bevel_radius=undef, top_bevel_radius=undef,
    dividers_bottom_bevel_radius=undef, dividers_top_bevel_radius=undef,
    rows_first=false)
```

Arguments:
* **dimensions** The 3d dimensions of the tray.
* **thickness** The thickness of the tray outside walls (side and bottom) (default: ```2```).
* **curved** Whether the tray should be curved or not (default: ```true```).
* **n_columns** The number of subdivider columns (default: ```1```).
* **n_rows** The number of subdivider rows *or* an array of length ```n_columns``` with each item ```n_rows[i]``` containing the number of rows in column ```i``` (default: ```1```).
* **columns** An optional 1d array of length ```(n_columns-1)```. Should contain numbers in the range [0, ..., 1] that specify where column subdividers should be located as a proportion of the total width (default: ```false```).
* **rows** An optional array of length ```n_columns```. Each element ```rows[i]``` contains either the value ```false``` (to split that column evenly as specified by ```n_rows```) *or* an array of length ```n_rows[i]-1``` with numbers in the range [0, ..., 1] that specify where row subdividers should be located as a proportion of the total length of column ```i``` (default: ```false```).
* **dividers_height** The height of subdividers (should be less than or equal to tray's height) (default: same as tray).
* **dividers_thickness** The thickness of subdividers (should be less than or equal to tray's thickness) (default: same as tray).
* **bottom_bevel_radius** Radius of bottom bevel for curved trays (default: ```2 x thickness```).
* **top_bevel_radius** Radius of top/sides bevel for curved trays (default: ```thickness```).
* **dividers_bottom_bevel_radius** Radius of bottom bevel of subdivisions for curved trays (default: same as ```bottom_bevel_radius```)
* **dividers_top_bevel_radius** Radius of top/sides bevel of subdivisions for curved trays (default: same as ```top_bevel_radius).
* **rows_first*** Allows to draw the tray priorizing the rows instead of columns. If ```true```, arguments for rows and columns are inverted (default: ```false```).
