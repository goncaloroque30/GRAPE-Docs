<h1 align="center">
    <img src="Icon/GrapeIcon512.png" alt="GRAPE">
    <br />
    GRAPE - GReen AirPort Environment
</h1>

<p align="center">
    GRAPE is a desktop application for calculating the environmental impacts of aircraft operations at airports. The scope is limited to flight operations (excludes taxiing, ground handling, ...). Aircraft noise and pollutant emissions are the main focus of GRAPE.
</p>

---

## Features

- Graphical user interface (GUI) to edit all the input data, run calculations and visualize outputs.
- Models based implementation, meaning as little hard coded variables as possible.
- [SQLite](https://sqlite.org/) as an application file format (.grp). All user inputs can be automated by creating this file and inserting values into it. Further information can be found in the [schema documentation](Schema.md).
- GRAPE.exe can be called from a command line with arguments to automate certain actions. Check the [user guide](userguide/Gui&CommandLineTool.md) or run `GRAPE.exe -h` from the command line for further information.
- Supported models:
    - Performance:
        - Model specified in the [Doc29](https://ecac-ceac.org/documents/ecac-documents-and-international-agreements)
        - User provided 4D trajectories
    - Noise:
        - Model specified in the [Doc29](https://ecac-ceac.org/documents/ecac-documents-and-international-agreements)
    - Fuel flow:
        - [Senzig Fleming Iovinelle Fuel Flow Model](https://arc.aiaa.org/doi/10.2514/1.42025)
        - LTO Phase based fuel flow
    - Emissions:
        - [Boeing Fuel Flow Model 2](https://jstor.org/stable/44657657)

## Features not (yet) implemented

- BADA4 performance model (you can use the 4D Trajectories if you have access to BADA4 from other sources)
- Vector route dispersion
- AzB noise model
- Noise contour generation from a noise grid (you can use the GeoPackage export feature, and then import that file into a GIS software with contour generation capabilities, e.g. [QGIS](https://qgis.org))