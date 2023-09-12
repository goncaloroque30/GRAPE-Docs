# Schema

GRAPE uses [SQLite](https://www.sqlite.org/) as an application file format (*.grp*). A basic understanding of SQL is needed in order to understand the GRAPE schema documented in this page. It should be used as a reference to edit *.grp* files using third party tools or scripts and to obtain the raw output data of GRAPE for further processing. The same file is used to store user inputs as well as application outputs.

All data is stored in SI units, angles are stored in degrees and percentages stored as a real number (1 corresponds to 100%). For conversions to other units please see the [conversion tables](../IO/ConversionTables.md). In the vertical plane, positive angles or gradients always indicate a climb and negative angles or gradients indicate a descent. 

For convenience, the tables in the GRAPE schema are organized into [sections](#sections), which are sorted in alphabetical order in this documentation. Each section has a specific function in GRAPE. The name of every table in the schema begins with the section name. All tables which are filled by GRAPE after calculating results have the word *output* in their name. This tables are intended to be read from, but should not be directly edited. The input and output tables are defined in the same schema and file so that a GRAPE study can be entirely contained in a single *.grp* file.

## Sections

- [airports](airports.md)
- [doc29_noise](doc29_noise.md)
- [doc29_performance](doc29_performance.md)
- [emissions_run](emissions_run.md)
- [fleet](fleet.md)
- [lto_fuel](lto_fuel_emissions.md)
- [noise_run](noise_run.md)
- [operations](operations.md)
- [performance_run](performance_run.md)
- [scenarios](scenarios.md)
- [sfi_fuel](sfi_fuel.md)
