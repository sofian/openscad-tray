# OpenSCAD Tray Library

Allows the design of trays with optional subdivisions. Many different configuration options available.

Designed to quickly create trays with different configurations, for efficient storing of parts, such as hardware, small tools, board game inserts, etc.

## Table of Contents

- [Usage](#usage)
- [Examples](#examples)
  * [Basics](#basics)
    + [Simple tray](#simple-tray)
    + [Simple subdivisions](#simple-subdivisions)
    + [Column subdivisions of unequal size](#column-subdivisions-of-unequal-size)
    + [Subdivisions with different numbers of rows per column](#subdivisions-with-different-numbers-of-rows-per-column)
  * [Advanced subdivisions](#advanced-subdivisions)
    + [Unequal subdivisions for both rows and columns](#unequal-subdivisions-for-both-rows-and-columns)
    + [Subdivisions with different numbers of rows per column (specific distribution)](#subdivisions-with-different-numbers-of-rows-per-column--specific-distribution-)
  * [Options](#options)
    + [Thickness](#thickness)
    + [Divider options](#divider-options)
    + [Bevel options](#bevel-options)

## Usage

In order to use, simply install in your OpenSCAD library folder and include the file ```tray.scad```:

```openscad
include <tray.scad>
```

You can then use the function ```tray()``` which comes with many different options.

```openscad
tray(dimensions, thickness=2, curved=true,
    n_columns=1, n_rows=1, columns=false, rows=false,
    bottom_thickness=undef,
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
* **bottom_thickness** The thickness of the bottom wall (default: same as ```thickness```).
* **dividers_height** The height of subdividers (should be less than or equal to tray's height) (default: same as tray).
* **dividers_thickness** The thickness of subdividers (should be less than or equal to tray's thickness) (default: same as tray).
* **bottom_bevel_radius** Radius of bottom bevel for curved trays (default: ```2 x thickness```).
* **top_bevel_radius** Radius of top/sides bevel for curved trays (default: ```thickness```).
* **dividers_bottom_bevel_radius** Radius of bottom bevel of subdivisions for curved trays (default: same as ```bottom_bevel_radius```)
* **dividers_top_bevel_radius** Radius of top/sides bevel of subdivisions for curved trays (default: same as ```top_bevel_radius```).
* **rows_first** Allows to draw the tray priorizing the rows instead of columns. If ```true```, arguments for rows and columns are inverted (default: ```false```).


## Examples

### Basics

#### Simple tray

Simple tray with curved inside (default):
```openscad
tray([100, 60, 30]);
```
![tray_example_basic](https://user-images.githubusercontent.com/791244/151715318-17cfad2f-fbd2-43f9-9e35-d561f216f50a.png)

#### Simple subdivisions

Tray with equal subdividers (3 columns, 2 rows):
```openscad
tray([100, 60, 30], n_columns=3, n_rows=2);
```

![tray_example_subdividers_equal](https://user-images.githubusercontent.com/791244/159578560-ce96ea43-26b2-4420-987e-1641d51ca921.png)

#### Column subdivisions of unequal size

Tray with unequal subdividers (3 columns, 2 rows). First and last columns are at 25% of width from each side.
```openscad
tray([100, 60, 30], n_columns=3, n_rows=2, columns=[0.25, 0.75]);
```
![tray_example_subdividers_unequal](https://user-images.githubusercontent.com/791244/151715333-58a6b24d-582c-48ac-9bda-a060da336190.png)

#### Subdivisions with different numbers of rows per column

Tray with unequal number of rows per column, equally distributed: first column has 4 rows, second column has 2 rows and final column as 3 rows.
```openscad
tray([100, 60, 30], n_columns=3, n_rows=[4,2,3]);
```
![tray_example_subdividers_unequal_n_rows](https://user-images.githubusercontent.com/791244/151715427-ec4976b6-a0dc-4d7f-ad88-d4f3d9f0723e.png)

Same but with unequal number of *columns per row*, equally distributed.
```openscad
tray([100, 60, 30], n_rows=3, n_columns=[4,2,3], rows_first=true);
```
![tray_example_subdividers_unequal_n_columns](https://user-images.githubusercontent.com/791244/151715872-2ad8439a-8d7c-4465-9b81-0d60bcc71f7b.png)


### Advanced subdivisions

#### Unequal subdivisions for both rows and columns

Traw with unequal subdividers (3 columns, 2 rows). First and last columns are at 25% of width from each side. Rows in first and last column are equally distributed but first row of middle column occupies only one third of length.
```openscad
tray([100, 60, 30], n_columns=3, n_rows=2, columns=[0.25, 0.75], rows=[false, [1/3], false]);
```
![tray_advanced_example1](https://user-images.githubusercontent.com/791244/151715600-0b6faa30-b02a-4b38-a1db-0b92f049dc8b.png)

#### Subdivisions with different numbers of rows per column (specific distribution)

Tray with unequal number of rows per column: first column has 4 rows, second column has 2 rows and final column as 3 rows. First and last columns are at 25% of width from each side. Rows in first and last column are equally distributed but the first two rows of middle column each occupyp 25% of column length.
```openscad
tray([100, 60, 30], n_columns=3, n_rows=[4,3,2], columns=[0.25, 0.75], rows=[false, [0.25, 0.5], false]);
```
![tray_advanced_example2](https://user-images.githubusercontent.com/791244/151715821-8bf5c8da-3543-458f-a0fe-f72d3c410ac2.png)

Same but with unequal number of *columns per row*.
```openscad
tray([100, 60, 30], n_rows=3, n_columns=[4,3,2], rows=[0.25, 0.75], columns=[false, [0.25, 0.5], false], rows_first=true);
```
![tray_advanced_example3](https://user-images.githubusercontent.com/791244/151715975-e99d159d-875f-447a-9a6f-d8190a8cc968.png)

### Options

#### Thickness

Simple tray with different side and bottom thickness:
```openscad
tray([100, 60, 30], thickness=3, bottom_thickness=20);
```

![tray_example_thickness](https://user-images.githubusercontent.com/791244/159580106-61a44c22-0d6e-4b9a-8d1b-db496e837277.png)

#### Divider options

Tray with thinner and lower dividers:
```openscad
tray([100, 60, 30], n_columns=3, n_rows=2, thickness=2, dividers_height=25, dividers_thickness=1);
```

![tray_example_subdividers_options](https://user-images.githubusercontent.com/791244/159579496-b27120ed-e3df-499e-a711-695c3ac14bab.png)

#### Bevel options

Same but with larger bevel radius at top and bottom:
```openscad
tray([100, 60, 30], n_columns=3, n_rows=2, thickness=2, dividers_height=25, dividers_thickness=1,
     top_bevel_radius=6, bottom_bevel_radius=10, 
     dividers_top_bevel_radius=3, dividers_bottom_bevel_radius=10);
```

![Untitled](https://user-images.githubusercontent.com/791244/159581150-6eb42989-da9d-473d-839f-03c979309bc6.png)
