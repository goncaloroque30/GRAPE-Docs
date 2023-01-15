# Application

## GUI

The GUI provides user interactions to create, edit and delete all the data used by GRAPE, perform calculations and edit settings. The GUI ist split int two main parts:

- [menu bar](#menu-bar)
- [panels](#panels)

### Menu Bar

The menu bar is always visible and serves to perform main interactions with the application. The menu bar has the following sections:

- [File](#file)
- [Edit](#edit)
- [View](#view)
- [Help](#help)

#### File

This menu controls which GRAPE study is currently active and being worked on. There can only be one open study at a time. A GRAPE study is always associated with a [SQLite](https://sqlite.org/) database saved on the user computer. Therefore, when creating a new study, the user is prompted to choose the location to which this file will be saved. There is no save button in this menu as the changes made are always directly written to the file, GRAPE currently does not support any rollback of changes made.

#### Edit

This menu allows for:

- importing data: check the [IO Section](#io)
- exporting data: check the [IO Section](#io)
- clearing all outputs: this will delete all the outputs from a study, therefore reducing the study size. Consider using when moving large studies. 
- changing the application settings

#### View

In this menu the different panels can be made visible or hidden. The panels are split into types:

- databases (see the [datasets](Datasets.md) section)
- input data (see the [input data](InputData.md) section)
- scenarios, where all the runs are performed and outputs shown (see the [runs & outputs](Runs&Outputs.md) section)
- log panel

#### Help

Provides general information about the software and access to the documentation.

### Panels

The panels of the application serve to provide the user with information or enable the user to edit input data and run calculations. Every panel in GRAPE can be moved to any desired position on the screen, docked into another panel or into the main window. Check the [view](#view) section of the menu bar to see how to enable a panel.

## IO

Besides editing input data and analyzing outputs via the GUI, GRAPE supports the import and export of data in the following formats:

- [CSV files (*.csv*)](#csv-files) (import and export)
- [ANP folder](#anp-folder) (import)
- [GeoPackage Files (*.gpkg*)](#geopackage-files) (export)

### CSV Files

Pratically all the input data in GRAPE can be imported and exported via *.csv* files. The only exception is the Doc29 data, which can only be imported from ANP folders. The following applies to all *.csv* files:

- when importing data the first row will be ignored (column names)
- when exporting data the first row will be set to the variables names including the variable unit if applicable (e.g. `Weight (kg)`)
- the order of the columns must be respected
- the separating character between two columns must be a comma (`,`)

Each of the following sections provides a description of the column order of each *.csv* known to GRAPE. If the column is mandatory, any row with an empty cell on that column will generate an error on import. For variables that have units, GRAPE will interpret the unit as being the one set in the settings (`Edit->Settings`).

The last sections below, with output in their name, describe tables containing output data that can only be exported. While all the input data can be imported and exported via the `Edit` menu, the output data can only be exported in the Scenarios panel, under the respective run. The columns *Mandatory* and *Constraint* do not apply to output tables.

#### LTO Engines

| Variable                              | Mandatory | Constraint      | Unit           |
|---------------------------------------|:---------:|-----------------|----------------|
| ID                                    | &#10003;  |                 |                |
| Fuel Flow Idle                        | &#10003;  | &#8805; 0       | Fuel Flow      |
| Fuel Flow Approach                    | &#10003;  | &#8805; 0       | Fuel Flow      |
| Fuel Flow Climb Out                   | &#10003;  | &#8805; 0       | Fuel Flow      |
| Fuel Flow Takeoff                     | &#10003;  | &#8805; 0       | Fuel Flow      |
| Fuel Flow Correction Factor Idle      |           | &#8805; 0       |                |
| Fuel Flow Correction Factor Approach  |           | &#8805; 0       |                |
| Fuel Flow Correction Factor Climb Out |           | &#8805; 0       |                |
| Fuel Flow Correction Factor Takeoff   |           | &#8805; 0       |                |
| Emission Index HC Idle                | &#10003;  | &#8805; 0       | Emission Index |
| Emission Index HC Approach            | &#10003;  | &#8805; 0       | Emission Index |
| Emission Index HC Climb Out           | &#10003;  | &#8805; 0       | Emission Index |
| Emission Index HC Takeoff             | &#10003;  | &#8805; 0       | Emission Index |
| Emission Index CO Idle                | &#10003;  | &#8805; 0       | Emission Index |
| Emission Index CO Approach            | &#10003;  | &#8805; 0       | Emission Index |
| Emission Index CO Climb Out           | &#10003;  | &#8805; 0       | Emission Index |
| Emission Index CO Takeoff             | &#10003;  | &#8805; 0       | Emission Index |
| Emission Index NOx Idle               | &#10003;  | &#8805; 0       | Emission Index |
| Emission Index NOx Approach           | &#10003;  | &#8805; 0       | Emission Index |
| Emission Index NOx Climb Out          | &#10003;  | &#8805; 0       | Emission Index |
| Emission Index NOx Takeoff            | &#10003;  | &#8805; 0       | Emission Index |

#### SFI Coefficients

| Variable | Mandatory | Constraint      | Unit |
|----------|:---------:|-----------------|------|
| ID       | &#10003;  |                 |      |
| A        | &#10003;  |                 |      |
| B1       | &#10003;  |                 |      |
| B2       | &#10003;  |                 |      |
| B3       | &#10003;  |                 |      |
| K1       | &#10003;  |                 |      |
| K2       | &#10003;  |                 |      |
| K3       | &#10003;  |                 |      |
| K4       | &#10003;  |                 |      |

#### Fleet

| Variable                          | Mandatory | Constraint         | Unit        |
|-----------------------------------|:---------:|--------------------|-------------|
| ID                                | &#10003;  |                    |             |
| Engine Count                      | &#10003;  | `1`, `2`, `3`, `4` |             |
| Maximum Sea Level Static Thrust   | &#10003;  | &#8805; 0          | Thrust      |
| Engine Breakpoint Temperature     | &#10003;  | &#8805; 0          | Temperature |
| Doc29 Performance ID              |           |                    |             |
| SFI Coefficients ID               |           |                    |             |
| LTO Engine ID                     |           |                    |             |
| Doc29 Noise ID                    |           |                    |             |
| Doc29 Noise Arrival &#916; (dB)   |           |                    |             |
| Doc29 Noise Departure &#916; (dB) |           |                    |             |

#### Airports

| Variable              | Mandatory | Constraint                 | Unit        |
|-----------------------|:---------:|----------------------------|-------------|
| ID                    | &#10003;  |                            |             |
| Longitude             | &#10003;  | -180 &#8804; x &#8804; 180 |             |
| Latitude              | &#10003;  | -90 &#8804; x &#8804; 90   |             |
| Elevation             | &#10003;  |                            | Altitude    |
| Reference Temperature |           | &#8805; 0                  | Temperature |
| Reference Pressure    |           | &#8805; 0                  | Pressure    |

#### Runways

| Variable  | Mandatory | Constraint                 | Unit     |
|-----------|:---------:|----------------------------|----------|
| Aiport ID | &#10003;  |                            |          |
| ID        | &#10003;  |                            |          |
| Longitude | &#10003;  | -180 &#8804; x &#8804; 180 |          |
| Latitude  | &#10003;  |  -90 &#8804; x &#8804; 90  |          |
| Elevation | &#10003;  |                            | Altitude |
| Length    | &#10003;  | > 0                        | Distance |
| Heading   | &#10003;  | 0 &#8804; x &#8804; 360    |          |
| Gradient  |           |                            |          |

#### Routes

| Variable  | Mandatory | Constraint                 | Unit |
|-----------|:---------:|----------------------------|------|
| Aiport ID | &#10003;  |                            |      |
| Runway ID | &#10003;  |                            |      |
| Operation | &#10003;  | `Arrival`, `Departure`     |      |
| ID        | &#10003;  |                            |      |
| Type      | &#10003;  | `Simple`, `Vectors`, `Rnp` |      |

#### Routes Simple

| Variable  | Mandatory | Constraint                 | Unit |
|-----------|:---------:|----------------------------|------|
| Aiport ID | &#10003;  |                            |      |
| Runway ID | &#10003;  |                            |      |
| Operation | &#10003;  | `Arrival`, `Departure`     |      |
| Route ID  | &#10003;  |                            |      |
| Longitude | &#10003;  | -180 &#8804; x &#8804; 180 |      |
| Latitude  | &#10003;  | -90 &#8804; x &#8804; 90   |      |

#### Routes Vectors

| Variable    | Mandatory | Constraint               | Unit     |
|-------------|:---------:|--------------------------|----------|
| Aiport ID   | &#10003;  |                          |          |
| Runway ID   | &#10003;  |                          |          |
| Operation   | &#10003;  | `Arrival`, `Departure`   |          |
| Route ID    | &#10003;  |                          |          |
| Vector Type | &#10003;  | `Straight`, `Turn`       |          |
| Distance    |           |  > 0                     | Distance |
| Turn Radius |           |  > 0                     | Distance |
| Heading     |           |  0 &#8804; x &#8804; 360 |          |

#### Routes RNP
  
| Variable         | Mandatory | Constraint                      | Unit     |
|------------------|:---------:|---------------------------------|----------|
| Aiport ID        | &#10003;  |                                 |          |
| Runway ID        | &#10003;  |                                 |          |
| Operation        | &#10003;  | `Arrival`, `Departure`          |          |
| Route ID         | &#10003;  |                                 |          |
| Step Type        | &#10003;  | `Track to Fix`, `Radius to Fix` |          |
| Longitude        | &#10003;  | -180 &#8804; x &#8804; 180      |          |
| Latitude         | &#10003;  | -90 &#8804; x &#8804; 90        |          |
| Center Longitude |           | -180 &#8804; x &#8804; 180      |          |
| Center Latitude  |           | -90 &#8804; x &#8804; 90        |          |

#### Flights

| Variable          | Mandatory | Constraint              | Unit   |
|-------------------|:---------:|-------------------------|--------|
| ID                | &#10003;  |                         |        |
| Airport ID        | &#10003;  |                         |        |
| Runway ID         | &#10003;  |                         |        |
| Operation         | &#10003;  | `Arrival`, `Departure`  |        |
| Route ID          | &#10003;  |                         |        |
| Time              | &#10003;  | yyyy-mm-dd HH:MM:SS     |        |
| Count             | &#10003;  | &#8805; 0               |        |
| Fleet ID          | &#10003;  |                         |        |
| Weight            | &#10003;  | > 0                     | Weight |
| Doc29 Profile     |           |                         |        |
| Thrust Percentage |           | 0.5 &#8804; x &#8804; 1 |        |

#### Tracks 4D

| Variable  | Mandatory | Constraint             | Unit   |
|-----------|:---------:|------------------------|--------|
| ID        | &#10003;  |                        |        |
| Operation | &#10003;  | `Arrival`, `Departure` |        |
| Time      | &#10003;  | yyyy-mm-dd HH:MM:SS    |        |
| Count     | &#10003;  | &#8805; 0              |        |
| Fleet ID  | &#10003;  |                        |        |

#### Tracks 4D Points
| Variable                        | Mandatory | Constraint                                              | Unit      |
|---------------------------------|:---------:|---------------------------------------------------------|-----------|
| ID                              | &#10003;  |                                                         |           |
| Operation                       | &#10003;  | `Arrival`, `Departure`                                  |           |
| Flight Phase                    | &#10003;  | `Approach`, `Landing Roll`, `Takeoff Roll`, `Departure` |           |
| Longitude                       | &#10003;  | -180 &#8804; x &#8804; 180                              |           |
| Latitude                        | &#10003;  | -90 &#8804; x &#8804; 90                                |           |
| Altitude MSL                    | &#10003;  |                                                         | Altitude  |
| True Airspeed                   | &#10003;  | &#8805; 0                                               | Speed     |
| Corrected Net Thrust per Engine | &#10003;  |                                                         | Thrust    |
| Bank Angle                      | &#10003;  | -90 &#8804; x &#8804; 90                                |           |
| Fuel Flow per Engine            | &#10003;  | &#8805; 0                                               | Fuel Flow |

#### Scenario

| Variable | Mandatory | Constraint | Unit |
|----------|:---------:|------------|------|
| ID       | &#10003;  |            |      |

#### Scenario Operations

| Variable     | Mandatory | Constraint             | Unit   |
|--------------|:---------:|------------------------|--------|
| Scenario ID  | &#10003;  |                        |        |
| Operation ID | &#10003;  |                        |        |
| Operation    | &#10003;  | `Arrival`, `Departure` |        |
| Type         | &#10003;  | `Flight`, `Track 4D`   |        |

Hint: if Scenario ID is not found in the study, it will be added.

#### Performance Runs

| Variable                                | Mandatory | Constraint                           | Unit        |
|-----------------------------------------|:---------:|--------------------------------------|-------------|
| Scenario ID                             | &#10003;  |                                      |             |
| ID                                      | &#10003;  |                                      |             |
| Coordinate System Type                  | &#10003;  | `Geodesic WGS84`, `Local Cartesian`  |             |
| Longitude 0                             |           | -180 &#8804; x &#8804; 180           |             |
| Latitude 0                              |           | -90 &#8804; x &#8804; 90             |             |
| Atmosphere Reference Altitude MSL       |           | &#8804; 11000 m                      | Altitude    |
| Atmosphere Reference Temperature        |           | &#8805; 0                            | Temperature |
| Atmosphere Reference Sea Level Pressure |           | &#8805; 0                            | Pressure    |
| Atmosphere Headwind                     | &#10003;  |                                      | Speed       |
| Atmosphere Relative Humidity            | &#10003;  | 0 &#8804; x &#8804; 1                |             |
| Performance Model                       | &#10003;  | `Doc29`                              |             |
| Minimum Altitude MSL                    |           | > Maximum Altitude MSL               | Altitude    |
| Maximum Altitude MSL                    |           | < Minimum Altitude MSL               | Altitude    |
| Minimum Cumulative Ground Distance      |           | < Maximum Cumulative Ground Distance | Distance    |
| Maximum Cumulative Ground Distance      |           | > Minimum Cumulative Ground Distance | Distance    |
| Minimum Tracks 4D Point Count           |           | &#8805; 0                            |             |
| Speed Delta Segmentation Threshold      |           | > 0                                  | Speed       |
| Ground Distance Filter Threshold        |           | > 0                                  | Distance    |
| Fuel Flow Model                         | &#10003;  | `None`, `LTO`, `SFI`                 |             |

#### Performance Run Output

| Variable                        | Mandatory | Constraint | Unit      |
|---------------------------------|:---------:|------------|-----------|
| Name                            |           |            |           |
| Operation                       |           |            |           |
| Type                            |           |            |           |
| Point Number                    |           |            |           |
| Point Origin                    |           |            |           |
| Flight Phase                    |           |            |           |
| Cumulative Ground Distance      |           |            | Distance  |
| Longitude                       |           |            |           |
| Latitude                        |           |            |           |
| Altitude MSL                    |           |            | Altitude  |
| True Airspeed                   |           |            | Speed     |
| Ground Speed                    |           |            | Speed     |
| Corrected Net Thrust per Engine |           |            | Thrust    |
| Bank Angle                      |           |            |           |
| Fuel Flow per Engine            |           |            | Fuel Flow |

#### Noise Runs

| Variable                  | Mandatory | Constraint                            | Unit        |
|---------------------------|:---------:|---------------------------------------|-------------|
| Scenario ID               | &#10003;  |                                       |             |
| Performance Run ID        | &#10003;  |                                       |             |
| ID                        | &#10003;  |                                       |             |
| Noise Model               | &#10003;  | `Doc29`                               |             |
| Atmospheric Absorption    | &#10003;  | `None`, `SAE ARP 866`, `SAE ARP 5534` |             |
| Receptor Set Type         | &#10003;  | `Grid`, `Points`                      |             |
| Save Single Event Metrics | &#10003;  | `0`, `1`                              |             |

#### Noise Runs Grid Receptors

| Variable               | Mandatory | Constraint                                                       | Unit     |
|------------------------|:---------:|------------------------------------------------------------------|----------|
| Scenario ID            | &#10003;  |                                                                  |          |
| Performance Run ID     | &#10003;  |                                                                  |          |
| Noise Run ID           | &#10003;  |                                                                  |          |
| Reference Location     | &#10003;  | `Center`, `Bottom Left`, `Bottom Right`, `Top Left`, `Top Right` |          |
| Reference Longitude    | &#10003;  | -180 &#8804; x &#8804; 180                                       |          |
| Reference Latitude     | &#10003;  | -90 &#8804; x &#8804; 90                                         |          |
| Reference Altitude MSL | &#10003;  |                                                                  | Altitude |
| Horizontal Spacing     | &#10003;  | > 0                                                              | Distance |
| Vertical Spacing       | &#10003;  | > 0                                                              | Distance |
| Horizontal Count       | &#10003;  | &#8805; 1                                                        |          |
| Vertical Count         | &#10003;  | &#8805; 1                                                        |          |
| Grid Rotation          | &#10003;  | -180 &#8804; x &#8804; 180                                       |          |

#### Noise Runs Point Receptors

| Variable           | Mandatory | Constraint                 | Unit     |
|--------------------|:---------:|----------------------------|----------|
| Scenario ID        | &#10003;  |                            |          |
| Performance Run ID | &#10003;  |                            |          |
| Noise Run ID       | &#10003;  |                            |          |
| Longitude          | &#10003;  | -180 &#8804; x &#8804; 180 |          |
| Latitude           | &#10003;  | -90 &#8804; x &#8804; 90   |          |
| Altitude MSL       | &#10003;  |                            | Altitude |

#### Noise Runs Cumulative Metrics

| Variable                     | Mandatory | Constraint          | Unit |
|------------------------------|:---------:|---------------------|------|
| Scenario ID                  | &#10003;  |                     |      |
| Performance Run ID           | &#10003;  |                     |      |
| Noise Run ID                 | &#10003;  |                     |      |
| ID                           | &#10003;  |                     |      |
| Threshold (dB)               | &#10003;  |                     |      |
| Averaging Time Constant (dB) | &#10003;  |                     |      |
| Start Time Point             | &#10003;  | yyyy-mm-dd HH:MM:SS |      |
| End Time Point               | &#10003;  | yyyy-mm-dd HH:MM:SS |      |
| Number Above Thresholds      |           | # # ...             |      |

#### Noise Runs Cumulative Metrics Weights

| Variable             | Mandatory | Constraint | Unit |
|----------------------|:---------:|------------|------|
| Scenario ID          | &#10003;  |            |      |
| Performance Run ID   | &#10003;  |            |      |
| Noise Run ID         | &#10003;  |            |      |
| Cumulative Metric ID | &#10003;  |            |      |
| Time                 | &#10003;  | HH:MM:SS   |      |
| Weight               | &#10003;  |            |      |

#### Fuel & Emissions Run

| Variable             | Mandatory | Constraint                          | Unit |
|----------------------|:---------:|-------------------------------------|------|
| Scenario ID          | &#10003;  |                                     |      |
| Performance Run ID   | &#10003;  |                                     |      |
| ID                   | &#10003;  |                                     |      |
| Emissions Model      | &#10003;  | `None`, `Boeing Fuel Flow Method 2` |      |
| Save Segment Results | &#10003;  | `0`, `1`                            |      |

#### Performance Output

| Variable                        | Mandatory | Constraint | Unit      |
|---------------------------------|:---------:|------------|-----------|
| Point Number                    |           |            |           |
| Point Origin                    |           |            |           |
| Flight Phase                    |           |            |           |
| Cumulative Ground Distance      |           |            | Distance  |
| Longitude                       |           |            |           |
| Latitude                        |           |            |           |
| Altitude MSL                    |           |            | Altitude  |
| True Airspeed                   |           |            | Speed     |
| Ground Speed                    |           |            | Speed     |
| Corrected Net Thrust per Engine |           |            | Thrust    |
| Bank Angle                      |           |            |           |
| Fuel Flow per Engine            |           |            | Fuel Flow |

#### Noise Single Event Output

| Variable    | Mandatory | Constraint | Unit     |
|-------------|:---------:|------------|----------|
| Receptor ID |           |            |          |
| Longitude	  |           |            |          |
| Latitude	  |           |            |          |
| Elevation	  |           |            | Altitude |
| Maximum	  |           |            |          |
| Exposure	  |           |            |          |

#### Noise Cumulative Metric Output

| Variable                 | Mandatory | Constraint | Unit     |
|--------------------------|:---------:|------------|----------|
| Receptor ID              |           |            |          |
| Longitude	               |           |            |          |
| Latitude	               |           |            |          |
| Elevation	               |           |            | Altitude |
| Weighted Operation Count |           |            |          |
| Maximum Absolute	       |           |            |          |
| Maximum Average	       |           |            |          |
| Exposure	               |           |            |          |

#### Fuel & Emissions Run Output

| Variable  | Mandatory | Constraint | Unit   |
|-----------|:---------:|------------|--------|
| Name      |           |            |        |
| Operation |           |            |        |
| Type      |           |            |        |
| Fuel      |           |            | Weight |
| HC        |           |            | Weight |
| CO        |           |            | Weight |
| NOx       |           |            | Weight |

### ANP Folder

GRAPE comes with integrated support for directly importing the [ANP database](https://www.aircraftnoisemodel.org/) into a study. Download and unzip the database into a local folder on your computer and then import it via `Edit->Import` (check the [edit](#edit) section). Unlike the other IO operations, the units of measurement set in the settings do not influence how GRAPE interprets the data. It is assumed that all ANP data is in its original units of measurement.

### GeoPackage Files

In a GRAPE study, the following types of data can be georeferenced:

- [airport structure](#airport-structure) (airports, runways, routes)
- [performance run outputs](#performance-run-outputs)
- [noise run outputs](#noise-run-output) (single event and cumulative metrics)

GRAPE can export this data in the [GeoPackage format](https://www.geopackage.org/). The exported layers types and attributes are specified in the following sections.

#### Airport Structure

The airport structure of all airports defined in a study can be exported via `Edit->Export->Airports`. The following layers are exported:

| Layer          | Type       | Description                                                        | Attributes      |
|----------------|------------|------------------------------------------------------------------- |-----------------|
| airports       | POINT      | Airport reference location                                         | airport         |
| runways_points | POINT      | Runway reference location                                          | airport, runway |
| runways_lines  | LINESTRING | Runway line (based on reference location, length and heading)      | airport, runway |
| routes         | LINESTRING | Output of each route as calculated on the WGS84 coordinate system  | airport, runway, route, operation, type |

#### Performance Run Outputs

After running a performance run, the outputs can be visualized in a tabular form for each operation in the *Scenarios* panel. A GeoPackage file can be created for each performance run with a single layer:

| Layer                  | Type       | Description                          | Attributes |
|------------------------|------------|--------------------------------------|------------|
| performance_run_output | LINESTRING | Performance output of each operation | name, operation, type, time, count, fleet id |

#### Noise Run Outputs

WIP.

## Command Line Tool

The same executable used to start the GUI can be used from the command line to automate certain actions. The following options are available:

- [-h] - Display this help. Equivalent to [-h -x].
- [-o] - Open a GRAPE study located at the path specified by the following argument.
- [-d] - Delete all outputs from the study. Use only in conjunction with -o.
- [-rp] - Start the performance run specified by the following argument as `<scenario name>-<performance run name>`. Use only in conjunction with -o.
- [-rn] - Start the noise run specified by the following argument as `<scenario name>-<performance run name>-<noise run name>`. Use only in conjunction with -o.
- [-rfe] - Start the fuel and emissions run specified by the following argument as `<scenario name>-<performance run name>-<fuel & emissions run name>`. Use only in conjunctio with -o.
- [-x] - Close after processing the command line options, do not run the application.

The options do not need to be passed in any specific order. For the run options, only one run of each type is supported. Example usages (in Windows):

```
GRAPE.exe -h
GRAPE.exe -x -d -o "Studies/Grape Study.exe" -rp "My Performance Run" -rn "My Noise Run"
GRAPE.exe -x -o "Studies/Grape Study.exe" -rfe "My Fuel & Emissions Run"
```
