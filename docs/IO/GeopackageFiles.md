# GeoPackage Files

In a GRAPE study, the following types of data can be georeferenced:

- [airport structure](#airport-structure) (airports, runways, routes)
- [performance run outputs](#performance-run-outputs)
- [noise run outputs](#noise-run-output) (single event and cumulative metrics)

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

After running a performance run, the outputs can be visualized in a tabular form for each operation in the *Scenarios* panel. A GeoPackage file can be created for each performance run with a single layer:

| Layer                  | Type       | Description                          | Attributes                                   |
|------------------------|------------|--------------------------------------|----------------------------------------------|
| performance_run_output | LINESTRING | Performance output of each operation | name, operation, type, time, count, fleet id |

## Noise Run Outputs

WIP.

## Johnny
