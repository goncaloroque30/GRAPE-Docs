# ANP Folder

GRAPE comes with integrated support for directly importing the [ANP database](https://www.easa.europa.eu/en/downloads/138164/en) into a study. Download and unzip the database into a local folder on your computer and then import it via `Edit->Import->Database->ANP`. All *.csv* import rules defined in the [CSV Files](./CSVFiles.md#Overview) section must be respected.

???+ info
    An exception is the variable units. GRAPE assumes that all units are in the original ANP format, and does not interpret them based on column names. 

The following files must be found in the selected folder:

- aircraft
- jet_engine_coefficients
- propeller_engine_coefficients
- aerodynamic_coefficients
- default_approach_procedural_steps
- default_departure_procedural_steps
- default_fixed_point_profiles
- spectral_classes
- npd_data

The file matching is case insensitive, and the file name must merely contain the names above. This means that the files

```
Aircraft.csv
my_aircraft.csv
AiRcRaFt_strange.csv
```
would all be recognized as being the ANP aircraft file. The default_weights file is currently ignored. 
