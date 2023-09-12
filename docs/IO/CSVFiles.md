# CSV Files

## Overview

Practically all the input data in GRAPE can be imported and exported via *.csv* files. The only exception is the Doc29 data, which can only be imported from ANP folders. The following applies to all *.csv* files:

- **import**: the order of the columns must be respected.
- **import**: the delimiter will be detected based on the first 100 rows (`,`, `;` and `tab` supported).
- **import**: leading and trailing spaces, tabs and new lines will be stripped from names.
- **import**: the variable unit (if applicable) will be detected from the column name (e.g. `Weight (KG)`, `Weight_kg` and `Weight##kG__` will all be interpreted as `kg`). If no unit is detected, the unit selected in the [settings](../Application/index.md#units) will be used. Check the [conversion tables](./ConversionTables.md) for the supported short name of each unit (case insensitive).
- **import**: the decimal separator must be a `.`.
- **export**: the first row will be set to the variables names including the variable unit if applicable (e.g. `Weight (kg)`)

Each of the following sections provides a description of the column order of each *.csv* known to GRAPE. If the column is mandatory, any row with an empty cell on that column will generate an error on import. The tables in the [Datasets](#datasets) and [Input Data](#input-data) sections can be imported/exported via the respective menus in the `Edit` section of the menu bar. Go through the menu to import/export any of the supported files. Clicking on the root nodes (`Datasets` or `Input Data`) will prompt the user to select a folder for which all of the respective files will be imported/exported. The root node `All Files` will import/export all files of both sections. The exported files will have the default names of each supported *.csv*, and when importing from a folder only this names will be recognized.

???+ info
	The default names correspond to the names of the sections below (case sensitive).

The [outputs](#outputs) section below describes tables containing output, which can only be exported. While all the input data can be imported and exported via the `Edit` menu, the output data can only be exported in the `Scenarios` panel, under the respective run. The columns *Mandatory* and *Constraint* do not apply to output tables.

## Datasets

### LTO Engines

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

### SFI Coefficients

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

### Fleet

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

## Input Data

### Airports

| Variable              | Mandatory | Constraint                 | Unit        |
|-----------------------|:---------:|----------------------------|-------------|
| ID                    | &#10003;  |                            |             |
| Longitude             | &#10003;  | -180 &#8804; x &#8804; 180 |             |
| Latitude              | &#10003;  | -90 &#8804; x &#8804; 90   |             |
| Elevation             | &#10003;  |                            | Altitude    |
| Reference Temperature |           | &#8805; 0                  | Temperature |
| Reference Pressure    |           | &#8805; 0                  | Pressure    |

### Runways

| Variable   | Mandatory | Constraint                 | Unit     |
|------------|:---------:|----------------------------|----------|
| Airport ID | &#10003;  |                            |          |
| ID         | &#10003;  |                            |          |
| Longitude  | &#10003;  | -180 &#8804; x &#8804; 180 |          |
| Latitude   | &#10003;  |  -90 &#8804; x &#8804; 90  |          |
| Elevation  | &#10003;  |                            | Altitude |
| Length     | &#10003;  | > 0                        | Distance |
| Heading    | &#10003;  | 0 &#8804; x &#8804; 360    |          |
| Gradient   |           |                            |          |

### Routes Simple

| Variable   | Mandatory | Constraint                 | Unit |
|------------|:---------:|----------------------------|------|
| Airport ID | &#10003;  |                            |      |
| Runway ID  | &#10003;  |                            |      |
| Operation  | &#10003;  | `Arrival`, `Departure`     |      |
| Route ID   | &#10003;  |                            |      |
| Longitude  | &#10003;  | -180 &#8804; x &#8804; 180 |      |
| Latitude   | &#10003;  | -90 &#8804; x &#8804; 90   |      |

### Routes Vectors

| Variable       | Mandatory | Constraint               | Unit     |
|----------------|:---------:|--------------------------|----------|
| Airport ID     | &#10003;  |                          |          |
| Runway ID      | &#10003;  |                          |          |
| Operation      | &#10003;  | `Arrival`, `Departure`   |          |
| Route ID       | &#10003;  |                          |          |
| Vector Type    | &#10003;  | `Straight`, `Turn`       |          |
| Distance       |           |  > 0                     | Distance |
| Turn Radius    |           |  > 0                     | Distance |
| Heading        |           |  0 &#8804; x &#8804; 360 |          |
| Turn Direction |           | `Right`, `Left`          |          |

### Routes RNP
  
| Variable          | Mandatory | Constraint                      | Unit     |
|-------------------|:---------:|---------------------------------|----------|
| Airport ID        | &#10003;  |                                 |          |
| Runway ID         | &#10003;  |                                 |          |
| Operation         | &#10003;  | `Arrival`, `Departure`          |          |
| Route ID          | &#10003;  |                                 |          |
| Step Type         | &#10003;  | `Track to Fix`, `Radius to Fix` |          |
| Longitude         | &#10003;  | -180 &#8804; x &#8804; 180      |          |
| Latitude          | &#10003;  | -90 &#8804; x &#8804; 90        |          |
| Center Longitude  |           | -180 &#8804; x &#8804; 180      |          |
| Center Latitude   |           | -90 &#8804; x &#8804; 90        |          |

### Flights

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
| Takeoff Thrust    |           | 0.5 &#8804; x &#8804; 1 |        |
| Climb Thrust      |           | 0.5 &#8804; x &#8804; 1 |        |

### Tracks 4D

| Variable  | Mandatory | Constraint             | Unit   |
|-----------|:---------:|------------------------|--------|
| ID        | &#10003;  |                        |        |
| Operation | &#10003;  | `Arrival`, `Departure` |        |
| Time      | &#10003;  | yyyy-mm-dd HH:MM:SS    |        |
| Count     | &#10003;  | &#8805; 0              |        |
| Fleet ID  | &#10003;  |                        |        |

### Tracks 4D Points
| Variable                        | Mandatory | Constraint                                                          | Unit      |
|---------------------------------|:---------:|---------------------------------------------------------------------|-----------|
| ID                              | &#10003;  |                                                                     |           |
| Operation                       | &#10003;  | `Arrival`, `Departure`                                              |           |
| Flight Phase                    | &#10003;  | `Approach`, `Landing Roll`, `Takeoff Roll`, `Initial Climb` `Climb` |           |
| Cumulative Ground Distance      | &#10003;  |                                                                     |           |
| Longitude                       | &#10003;  | -180 &#8804; x &#8804; 180                                          |           |
| Latitude                        | &#10003;  | -90 &#8804; x &#8804; 90                                            |           |
| Altitude MSL                    | &#10003;  |                                                                     | Altitude  |
| True Airspeed                   | &#10003;  | &#8805; 0                                                           | Speed     |
| Groundspeed                     | &#10003;  | &#8805; 0                                                           | Speed     |
| Corrected Net Thrust per Engine | &#10003;  |                                                                     | Thrust    |
| Bank Angle                      | &#10003;  | -90 &#8804; x &#8804; 90                                            |           |
| Fuel Flow per Engine            | &#10003;  | &#8805; 0                                                           | Fuel Flow |

???+ warning
	The track 4D operation must already exist in the study.

### Scenarios

| Variable | Mandatory | Constraint | Unit |
|----------|:---------:|------------|------|
| ID       | &#10003;  |            |      |

### Scenarios Operations

| Variable     | Mandatory | Constraint             | Unit   |
|--------------|:---------:|------------------------|--------|
| Scenario ID  | &#10003;  |                        |        |
| Operation ID | &#10003;  |                        |        |
| Operation    | &#10003;  | `Arrival`, `Departure` |        |
| Type         | &#10003;  | `Flight`, `Track 4D`   |        |

???+ info
	If Scenario ID is not found in the study, it will be added.

### Performance Runs

| Variable                                      | Mandatory | Constraint                                  | Unit        |
|-----------------------------------------------|:---------:|---------------------------------------------|-------------|
| Scenario ID                                   | &#10003;  |                                             |             |
| ID                                            | &#10003;  |                                             |             |
| Coordinate System Type                        | &#10003;  | `Geodesic WGS84`, `Local Cartesian`         |             |
| Longitude 0                                   |           | -180 &#8804; x &#8804; 180                  |             |
| Latitude 0                                    |           | -90 &#8804; x &#8804; 90                    |             |
| Filter Minimum Altitude MSL                   |           | > Filter Maximum Altitude MSL               | Altitude    |
| Filter Maximum Altitude MSL                   |           | < Filter Minimum Altitude MSL               | Altitude    |
| Filter Minimum Cumulative Ground Distance     |           | < Filter Maximum Cumulative Ground Distance | Distance    |
| Filter Maximum Cumulative Ground Distance     |           | > Filter Minimum Cumulative Ground Distance | Distance    |
| Filter Ground Distance Threshold              |           |                                             | Distance    |
| Segmentation Speed Delta Threshold            |           | > 0                                         | Speed       |
| Flights Performance Model                     | &#10003;  | `Doc29`                                     |             |
| Flights Enable Doc29 Segmentation             |           | `0`, `1`                                    |             |
| Tracks 4D Minimum Points                      |           | &#8805; 0                                   |             |
| Tracks Recalculate Cumulative Ground Distance |           | `0`, `1`                                    |             |
| Tracks Recalculate Groundspeed                |           | `0`, `1`                                    |             |
| Tracks Recalculate Fuel Flow                  |           | `0`, `1`                                    |             |
| Fuel Flow Model                               | &#10003;  | `None`, `LTO`, `LTO Doc9889`, `SFI`         |             |

### Performance Runs Atmospheres

| Variable           | Mandatory | Constraint                           | Unit        |
|--------------------|:---------:|--------------------------------------|-------------|
| Scenario ID        | &#10003;  |                                      |             |
| Performance Run ID | &#10003;  |                                      |             |
| Time               | &#10003;  | yyyy-mm-dd HH:MM:SS                  |             |
| Temperature Delta  | &#10003;  | -100 K &#8804; x &#8804; 100 K       | Temperature |
| Pressure Delta     | &#10003;  | -150 hPa &#8804; x &#8804; 150.0 hPa | Pressure    |
| Wind Speed         | &#10003;  |                                      | Speed       |
| Wind Direction     |           | 0 &#8804; x &#8804; 360              |             |
| Relative Humidity  | &#10003;  | 0 &#8804; x &#8804; 1                |             |

### Noise Runs

| Variable                  | Mandatory | Constraint                            | Unit        |
|---------------------------|:---------:|---------------------------------------|-------------|
| Scenario ID               | &#10003;  |                                       |             |
| Performance Run ID        | &#10003;  |                                       |             |
| ID                        | &#10003;  |                                       |             |
| Noise Model               | &#10003;  | `Doc29`                               |             |
| Atmospheric Absorption    | &#10003;  | `None`, `SAE ARP 866`, `SAE ARP 5534` |             |
| Receptor Set Type         | &#10003;  | `Grid`, `Points`                      |             |
| Save Single Event Metrics | &#10003;  | `0`, `1`                              |             |

### Noise Runs Grid Receptors

| Variable               | Mandatory | Constraint                                                       | Unit     |
|------------------------|:---------:|------------------------------------------------------------------|----------|
| Scenario ID            | &#10003;  |                                                                  |          |
| Performance Run ID     | &#10003;  |                                                                  |          |
| Noise Run ID           | &#10003;  |                                                                  |          |
| ID                     | &#10003;  |                                                                  |          |
| Reference Location     | &#10003;  | `Center`, `Bottom Left`, `Bottom Right`, `Top Left`, `Top Right` |          |
| Reference Longitude    | &#10003;  | -180 &#8804; x &#8804; 180                                       |          |
| Reference Latitude     | &#10003;  | -90 &#8804; x &#8804; 90                                         |          |
| Reference Altitude MSL | &#10003;  |                                                                  | Altitude |
| Horizontal Spacing     | &#10003;  | > 0                                                              | Distance |
| Vertical Spacing       | &#10003;  | > 0                                                              | Distance |
| Horizontal Count       | &#10003;  | &#8805; 1                                                        |          |
| Vertical Count         | &#10003;  | &#8805; 1                                                        |          |
| Grid Rotation          | &#10003;  | -180 &#8804; x &#8804; 180                                       |          |

### Noise Runs Point Receptors

| Variable           | Mandatory | Constraint                 | Unit     |
|--------------------|:---------:|----------------------------|----------|
| Scenario ID        | &#10003;  |                            |          |
| Performance Run ID | &#10003;  |                            |          |
| Noise Run ID       | &#10003;  |                            |          |
| ID                 | &#10003;  |                            |          |
| Longitude          | &#10003;  | -180 &#8804; x &#8804; 180 |          |
| Latitude           | &#10003;  | -90 &#8804; x &#8804; 90   |          |
| Altitude MSL       | &#10003;  |                            | Altitude |

### Noise Runs Cumulative Metrics

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

### Noise Runs Cumulative Metrics Weights

| Variable             | Mandatory | Constraint | Unit |
|----------------------|:---------:|------------|------|
| Scenario ID          | &#10003;  |            |      |
| Performance Run ID   | &#10003;  |            |      |
| Noise Run ID         | &#10003;  |            |      |
| Cumulative Metric ID | &#10003;  |            |      |
| Time                 | &#10003;  | HH:MM:SS   |      |
| Weight               | &#10003;  |            |      |

### Emissions Runs

| Variable                                  | Mandatory | Constraint                                  | Unit     |
|-------------------------------------------|:---------:|---------------------------------------------|----------|
| Scenario ID                               | &#10003;  |                                             |          |
| Performance Run ID                        | &#10003;  |                                             |          |
| ID                                        | &#10003;  |                                             |          |
| Emissions Model                           | &#10003;  | `None`, `Boeing Fuel Flow Method 2`         |          |
| Filter Minimum Altitude MSL               |           | > Filter Maximum Altitude MSL               | Altitude |
| Filter Maximum Altitude MSL               |           | < Filter Minimum Altitude MSL               | Altitude |
| Filter Minimum Cumulative Ground Distance |           | < Filter Maximum Cumulative Ground Distance | Distance |
| Filter Maximum Cumulative Ground Distance |           | > Filter Minimum Cumulative Ground Distance | Distance |
| Save Segment Results                      | &#10003;  | `0`, `1`                                    |          |

## Outputs

### Performance Run Output

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
| Groundspeed                     |           |            | Speed     |
| Corrected Net Thrust per Engine |           |            | Thrust    |
| Bank Angle                      |           |            |           |
| Fuel Flow per Engine            |           |            | Fuel Flow |

### Performance Run Output Single Event

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
| Groundspeed                     |           |            | Speed     |
| Corrected Net Thrust per Engine |           |            | Thrust    |
| Bank Angle                      |           |            |           |
| Fuel Flow per Engine            |           |            | Fuel Flow |

### Noise Run Output Cumulative Metric

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
| # Above X                |           |            |          |

???+ info
	The last column (# Above X) can occur 0 or more times, depending on the number of thresholds defined for the metric. The value of  X is replaced in each column ba the respective threshold.

### Noise Run Output Single Event

| Variable    | Mandatory | Constraint | Unit     |
|-------------|:---------:|------------|----------|
| Receptor ID |           |            |          |
| Longitude	  |           |            |          |
| Latitude	  |           |            |          |
| Elevation	  |           |            | Altitude |
| Maximum	  |           |            |          |
| Exposure	  |           |            |          |

### Emissions Run Output

| Variable  | Mandatory | Constraint | Unit             |
|-----------|:---------:|------------|------------------|
| Name      |           |            |                  |
| Operation |           |            |                  |
| Type      |           |            |                  |
| Fuel      |           |            | Emissions Weight |
| HC        |           |            | Emissions Weight |
| CO        |           |            | Emissions Weight |
| NOx       |           |            | Emissions Weight |

???+ info
	The first row of this output file contains the total emissions of the emissions run. The `Name` column is set to `Total` and both `Operation` and `Type` are left empty.

### Emissions Run Output Segments

| Variable      | Mandatory | Constraint | Unit             |
|---------------|:---------:|------------|------------------|
| Segment Index |           |            |                  |
| Fuel          |           |            | Emissions Weight |
| HC            |           |            | Emissions Weight |
| CO            |           |            | Emissions Weight |
| NOx           |           |            | Emissions Weight |

???+ info
	The first row of this output file contains the total emissions of the operation. The `Segment Index` column is set to `Total`.