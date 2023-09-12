# ANP Folder

## Overview

GRAPE comes with integrated support for directly importing the [ANP database](https://www.easa.europa.eu/en/downloads/138164/en) into a study. Download and unzip the ANP database into a local folder on your computer and then import it via `Edit->Import->Database->ANP`. All *.csv* import rules defined in the [CSV Files](./CSVFiles.md#Overview) section must be respected.

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

## Limitations

The Doc29 data structure in GRAPE, into which the ANP database is imported, does not currently support all of the ANP data. This is mostly due to the more restrictive nature of the data structure in GRAPE.

### Thrust Rating

The jet and propeller engine coefficients in the ANP database are necessary to apply the equations B-1, B-4 and B-5 of the [Doc29](https://ecac-ceac.org/documents/ecac-documents-and-international-agreements) Volume II, which allow to estimate thrust based on a thrust rating and the aircraft state. While in the ANP database the thrust rating can be anything (the most common ones being `MaxTakeoff` and `MaxClimb`), GRAPE only supports the thrust ratings in the following table:

| GRAPE                            | ANP                |
|----------------------------------|--------------------|
| Maximum Takeoff                  | MaxTakeoff         |
| Maximum Takeoff High Temperature | MaxTkoffHiTemp     |
| Maximum Climb                    | MaxClimb           |
| Maximum Climb High Temperature   | MaxClimbHiTemp     |
| Idle                             | IdleApproach       |
| Idle High Temperature            | IdleApproachHiTemp |

This restriction enables two functionalities in GRAPE:

- Doc29 departure procedural profiles do not need to specify the thrust rating for each step. Instead only the step at which thrust cutback is performed needs to be specified. All steps before are assumed to use the `Maximum Takeoff` rating, and all steps after the `Maximum Climb` rating. The high temperature ratings are automatically used if present and the temperature is above the engine breakpoint temperature (which can be defined for each aircraft). If high temperature ratings are not present, equation B-4 of [Doc29](https://ecac-ceac.org/documents/ecac-documents-and-international-agreements) is used.
- For departure flights, thrust reductions can be specified for the `Maximum Takeoff` and `Maximum Climb` phases of flight, which will be directly applied when using the Doc29 performance model, without modifying the underlying Doc29 profile description. One of the examples in the `examples` folder demonstrates this use case.

For the ANP version 2.3, the following thrust ratings and the applicable aircraft will not be imported:

| Thrust Rating                | Aircraft                    |
|------------------------------|-----------------------------|
| ReduceTakeoff                | `GII`, `GIIB`               |
| ReduTkoffHiTemp              | `GII`, `GIIB`               |
| ReduceClimb                  | `ECLISPE500`, `GII`, `GIIB` |
| ReduceClimbHiTemp            | `ECLISPE500`                |
| MaxContinuous                | `727QF`                     |
| MaxContHiTemp                | `727QF`                     |

Given the relatively low number of aircraft to which the alternative thrust ratings apply, the tradeoff was made for the added functionality described above. GRAPE will log an error when importing these thrust coefficients from the ANP database.

???+ warning
    The ANP database additionally provides `General` thrust coefficients for most of its aircraft. These coefficients are intended to be used with equations B-2 and B-3 of the [Doc29](https://ecac-ceac.org/documents/ecac-documents-and-international-agreements), which require knowledge of the engine state (Engine Pressure Ratio or N1 value). GRAPE currently does not support these and will silently ignore the `General` thrust coefficients.

### Noise Thrust Parameter

In GRAPE, a performance output will always contain the *Corrected Net Thrust Per Engine* for every point. The Doc29 noise data in GRAPE follows this principle, and the required Noise-Power-Distance (NPD) tables to apply the Doc29 noise model always have the thrust parameter in *Corrected Net Thrust Per Engine*. GRAPE parses the *aircraft* and *npd_data* tables of the ANP database, and the following cases can occur:

- Aircraft *Power Parameter* is either `Pounds` or `CNT (lb)`: if not yet existent, the corresponding NPD data and spectral classes will be imported into a new Doc29 Noise entry named with the NPD ID, without modifications.
- Aircraft *Power Parameter* is either `Percent` or `CNT (% of Max Static Thrust)`: a new Doc29 Noise entry will be created, named with the NPD ID followed by the ANP aircraft name. The NPD power parameter will be converted to *Corrected Net Thrust Per Engine* by multiplying the existing parameter with the aircraft maximum sea level static thrust. The spectral class data will be imported without modifications.
- Aircraft *Power Parameter* is anything else: GRAPE does not support other types of thrust parameter, both aircraft and noise data will not be imported.

For the ANP version 2.3, this limitation excludes the following aircraft and NPD data from being imported into GRAPE:

| Aircraft | Thrust Parameter | NPD ID   |
|----------|------------------|----------|
| `CNA206` | Other (RPM)      | `IO540`  |
| `CNA20T` | Other (RPM)      | `TIO540` |
| `PA28`   | Other (RPM)      | `O320D3` |
| `PA31`   | Other (RPM)      | `TIO542` |

Again the number of affected aircraft is relatively low, and all general aviation aircraft. The tradeoff of not supporting this type of aircraft, in order to have a coherent representation of the thrust state of each aircraft for all performance outputs was made. This enables for fuel flow, noise and emissions models to be applied independent of the databases used to achieve the performance output.

### Noise Metrics

GRAPE currently only supports A-Weighted noise metrics. For single events this correspond to the A weighted maximum level (LAmax) and sound equivalent level (SEL). The ANP database additionally contains EPNL and PNLTM data in the NPD tables. It is part of the roadmap to develop support for these metrics in GRAPE. Currently, this ANP data is simply ignored.

???+ warning
    When importing the ANP database, the EPNL and PNLTM data of the NPD tables will be silently ignored.
