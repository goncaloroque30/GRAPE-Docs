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

## Processing outputs with QGIS

GeoPackage files exported by GRAPE can be displayed and analized in GIS software. As an example, a workflow for displaying and styling outputs is provided in [QGIS](https://qgis.org).

Open QGIS and open (CTRL+O) the example project provided in `GRAPE/res/Examples`. After saving the GeoPackage files (Performance run or Noise run) to your machine, locate the `.gpkg` by using the file explorer. Then simply add the file to your QGIS project by drag-and-drop. You can either add the whole file or open the GeoPackage and select the vector file you want to analyze.    

#### Styling of vector layers

For styling vector layers, some QGIS style files are provided. Right click the vector layer and select `Properties`. Under `Symbology` on the bottom left, click `Style` and press `Load Style`. Navigate to `GRAPE/res/Examples/QGIS styles`. 

You have several options for styling. For routes and airports, you can choose between `Colors by operation` or `Colors by operation and type`. `Colors by operation` will set different colors for arrivals and departures, while `Colors by operation and type` also distinguishes between type (i.e. `Flight` and `Tracks 4D`). For styling a noise run output, choose the file `GRAPE/res/Examples/QGIS styles/Noise classes`. Now simply press `Load style` and `Apply`. 

#### Create Noise Contours from Noise Run Output

For presentational purposes it might be required to create noise contours. To accomplish that, it is necessary to interpolate the point data. In the QGIS toolbox, choose the `TIN interpolation` algorithm. Change the vector layer to the layer containing the noise run output and change the interpolation attribute to `exposure_db`. Press the green `+`. For `Extent` you can choose the same layer. `Output raster size` lets you set the resolution for your output. It is recommended to set a resolution of at least 100x100. Run the algorithm. A new layer `Interpolated` is added to the project containing the results.

Upon creation, the layer is temporary. To make it permanent, right click the layer and choose `Export`, then `Save as...`. For format, leave GeoTIFF. Under file name, choose the path where you want to save your interpolation (ideally your project folder). Make sure to set the CRS to your project CRS. Now press `OK`. You can now remove the temporary layer from your project. To restyle the new layer, right click and navigate to `Properties`. In the `Symbology` tab, select the render type `Singleband pseudocolor`. The folder symbol allows to import custom color maps. Click it, and navigate to `GRAPE/res/Examples/QGIS styles` and selct the provided color map. Press apply and close the symbology window to see the results.
