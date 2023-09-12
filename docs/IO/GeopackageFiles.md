# GeoPackage Files

In a GRAPE study, the following types of data can be georeferenced:

- [airport structure](#airport-structure) (airports, runways, routes)
- [performance run outputs](#performance-run-outputs)
- [noise run outputs](#noise-run-output) (cumulative metrics)

GRAPE can export this data in the [GeoPackage format](https://www.geopackage.org/). The exported layers types and attributes are specified in the following sections.

## Airport Structure

The airport structure of all airports defined in a study can be exported via `Edit->Export->Airports`. The following layers are exported:

| Layer          | Type       | Description                                                        | Attributes      |
|----------------|------------|------------------------------------------------------------------- |-----------------|
| airports       | POINT      | Airport reference location                                         | airport         |
| runways_points | POINT      | Runway reference location                                          | airport, runway |
| runways_lines  | LINESTRING | Runway line (based on reference location, length and heading)      | airport, runway |
| routes         | LINESTRING | Output of each route as calculated on the WGS84 coordinate system  | airport, runway, route, operation, type |

## Performance Run Outputs

After running a performance run, the outputs can be visualized in a tabular form for each operation. In the *Scenarios* panel, select a performance run which has the status *Done*, open the *Output* collapsible, click on the orange button and select `Export as .gpkg`. A GeoPackage file will be created with a single layer:

| Layer                  | Type       | Description                          | Attributes                                   |
|------------------------|------------|--------------------------------------|----------------------------------------------|
| performance_run_output | LINESTRING | Performance output of each operation | name, operation, type, time, count, fleet id |

## Noise Run Outputs

After running a noise run which has cumulative metrics defined, the outputs can be visualised in a tabular form for each cumulative metric defined. In the *Scenarios* panel, select a noise run which has the status *Done*, open the *Output Cumulative Metric* collapsible, click the orange button and select `Export as .gpkg`. A GeoPackage file will be created with the following layers:

| Layer                             | Type  | Description                              | Attributes                           |
|-----------------------------------|-------|------------------------------------------|--------------------------------------|
| noise_run_receptors               | POINT | Receptors for which noise was calculated |                                      |
| noise_run_cumulative_noise        | POINT | Cumulative metric output                 | cumulative_metric, count, count_weighted, maximum_absolute_db, maximum_average_db, exposure_db   |
| noise_run_cumulative_number_above | POINT | Cumulative metric number above output    | cumulative_metric, threshold, number |

The geographical representation of all three layers is identical (the receptors at which noise is calculated). Only the attributes change.
