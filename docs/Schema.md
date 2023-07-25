GRAPE uses [SQLite](https://www.sqlite.org/) as an application file format (.grp). A basic understanding of SQL is needed in order to understand the GRAPE schema documented in this page. It should be used as a reference to edit '.grp' files using third party tools or scripts and to obtain the raw output data of GRAPE for further processing. The same file is used to store user inputs as well as application outputs.

All data is stored in SI units, angles are stored in degrees and percentages stored as a real number (1 corresponds to 100%). For conversions to other units please see the [conversion tables](ConversionTables.md). In the vertical plane, positive angles or gradients always indicate a climb and negative angles or gradients indicate a descent. 

For convenience, the tables in the GRAPE schema are organized into [sections](#sections). Each section has a specific function in GRAPE. The name of every table in the schema begins with the section name. All tables which are filled by GRAPE after calculating results have the word *output* in their name. This tables are intended to be read from, but should not be directly edited. The input and output tables are defined in the same schema and file so that a GRAPE study can be entirely contained in a single '.grp' file.

### Sections

- [airports](#airports)
- [doc29_noise](#doc29_noise)
- [doc29_performance](#doc29_performance)
- [fleet](#fleet)
- [fuel_emissions_run](#fuel_emissions_run)
- [lto_fuel](#lto_fuel_emissions)
- [noise_run](#noise_run)
- [operations](#operations)
- [performance_run](#performance_run)
- [scenarios](#scenarios)
- [sfi_fuel](#sfi_fuel)

---

## airports

### airports

| Variable              | Type | NOT NULL | Constraint                 |  
|-----------------------|------|:--------:|----------------------------|
| id                    | TEXT | &#10003; |                            |
| longitude             | REAL | &#10003; | -180 &#8804; x &#8804; 180 |
| latitude              | REAL | &#10003; | -90 &#8804; x &#8804; 90   |
| elevation             | REAL | &#10003; |                            |
| reference_temperature | REAL |          | &#8805; 0                  |
| reference_pressure    | REAL |          | &#8805; 0                  |

| Table Constraint | Details |
|------------------|---------|
| PRIMARY KEY      | id      |

### airports_runways

| Variable  | NOT NULL | Constraint                 |
|-----------|:--------:|----------------------------|
| aiport_id | &#10003; |                            |
| id        | &#10003; |                            |
| longitude | &#10003; | -180 &#8804; x &#8804; 180 |
| latitude  | &#10003; |  -90 &#8804; x &#8804; 90  |
| elevation | &#10003; |                            |
| length    | &#10003; | > 0                        |
| heading   | &#10003; | 0 &#8804; x &#8804; 360    |
| gradient  | &#10003; | -1 &#8804; x &#8804; 1     |

| Table Constraint | Details                               |
|------------------|---------------------------------------|
| PRIMARY KEY      | airport_id, id                        |
| FOREIGN KEY      | airport_id from [airports](#airports) |

### airports_routes

| Variable  | Type | NOT NULL | Constraint                 |
|-----------|------|:--------:|----------------------------|
| aiport_id | TEXT | &#10003; |                            |
| runway_id | TEXT | &#10003; |                            |
| operation | TEXT | &#10003; | `Arrival`, `Departure`     |
| id        | TEXT | &#10003; |                            |
| type      | TEXT | &#10003; | `Simple`, `Vectors`, `Rnp` |

| Table Constraint | Details                                                          |
|------------------|------------------------------------------------------------------|
| PRIMARY KEY      | airport_id, runway id, operation, id                             |
| FOREIGN KEY      | airport_id, runway_id from [airports_runways](#airports_runways) |

### airports_routes_simple

| Variable     | Type    | NOT NULL | Constraint                 |
|--------------|---------|:--------:|----------------------------|
| aiport_id    | TEXT    | &#10003; |                            |
| runway_id    | TEXT    | &#10003; |                            |
| operation    | TEXT    | &#10003; | `Arrival`, `Departure`     |
| route_id     | TEXT    | &#10003; |                            |
| point_number | INTEGER | &#10003; | &#8805; 1                  |
| longitude    | REAL    | &#10003; | -180 &#8804; x &#8804; 180 |
| latitude     | REAL    | &#10003; | -90 &#8804; x &#8804; 90   |

| Table Constraint | Details                                                                             |
|------------------|-------------------------------------------------------------------------------------|
| PRIMARY KEY      | airport_id, runway id, operation, route_id, point_number                            |
| FOREIGN KEY      | airport_id, runway_id, operation, route_id from [airports_routes](#airports_routes) |

### airports_routes_vectors

| Variable    | Type    | NOT NULL | Constraint               |
|-------------|---------|:--------:|--------------------------|
| aiport_id   | TEXT    | &#10003; |                          |
| runway_id   | TEXT    | &#10003; |                          |
| operation   | TEXT    | &#10003; | `Arrival`, `Departure`   |
| route_id    | TEXT    | &#10003; |                          |
| step_number | INTEGER | &#10003; | &#8805; 1                |
| vector_type | TEXT    | &#10003; | `Straight`, `Turn`       |
| distance    | REAL    |          |  > 0                     |
| turn_radius | REAL    |          |  > 0                     |
| heading     | REAL    |          |  0 &#8804; x &#8804; 360 |

| Table Constraint | Details                                                                             |
|------------------|-------------------------------------------------------------------------------------|
| PRIMARY KEY      | airport_id, runway id, operation, route_id, step_number                             |
| FOREIGN KEY      | airport_id, runway_id, operation, route_id from [airports_routes](#airports_routes) |
| CHECK            | case vector_type `Straight` - distance NOT NULL                                     |
| CHECK            | case vector_type `Turn` - turn_radius NOT NULL, heading NOT NULL                    |

### airports_routes_rnp

| Variable         | Type    | NOT NULL | Constraint                      |
|------------------|---------|:--------:|---------------------------------|
| aiport_id        | TEXT    | &#10003; |                                 |
| runway_id        | TEXT    | &#10003; |                                 |
| operation        | TEXT    | &#10003; | `Arrival`, `Departure`          |
| route_id         | TEXT    | &#10003; |                                 |
| step_number      | INTEGER | &#10003; | &#8805; 1                       |
| step_type        | TEXT    | &#10003; | `Track to Fix`, `Radius to Fix` |
| longitude        | REAL    | &#10003; | -180 &#8804; x &#8804; 180      |
| latitude         | REAL    | &#10003; | -90 &#8804; x &#8804; 90        |
| center_longitude | REAL    |          | -180 &#8804; x &#8804; 180      |
| center_latitude  | REAL    |          | -90 &#8804; x &#8804; 90        |

| Table Constraint | Details                                                                              |
|------------------|--------------------------------------------------------------------------------------|
| PRIMARY KEY      | airport_id, runway id, operation, route_id, step_number                              |
| FOREIGN KEY      | airport_id, runway_id, operation, route_id from [airports_routes](#airports_routes)  |
| CHECK            | case step_type `Radius to Fix` - center_longitude NOT NULL, center_latitude NOT NULL |  

---

## doc29_noise

### doc29_noise

| Variable                 | Type | NOT NULL | Constraint                      |
|--------------------------|------|:--------:|---------------------------------|
| id                       | TEXT | &#10003; |                                 |
| lateral_directivity      | TEXT | &#10003; | `Wing`, `Fuselage`, `Propeller` |
| start_of_roll_correction | TEXT | &#10003; | `None`, `Jet`, `Turboprop`      |

| Table Constraint | Details |
|------------------|---------|
| PRIMARY KEY      | id		 |

### doc29_noise_npd_data

| Variable     | Type | NOT NULL | Constraint             |
|--------------|------|:--------:|------------------------|
| noise_id     | TEXT | &#10003; |                        |
| operation    | TEXT | &#10003; | `Arrival`, `Departure` |
| noise_metric | TEXT | &#10003; | `LAMAX`, `SEL`         |
| thrust       | REAL | &#10003; |                        |
| l_200_ft     | REAL | &#10003; |                        |
| l_400_ft     | REAL | &#10003; |                        |
| l_630_ft     | REAL | &#10003; |                        |
| l_1000_ft    | REAL | &#10003; |                        |
| l_2000_ft    | REAL | &#10003; |                        |
| l_4000_ft    | REAL | &#10003; |                        |
| l_6300_ft    | REAL | &#10003; |                        |
| l_10000_ft   | REAL | &#10003; |                        |
| l_16000_ft   | REAL | &#10003; |                        |
| l_25000_ft   | REAL | &#10003; |                        |

| Table Constraint | Details                                   |
|------------------|-------------------------------------------|
| PRIMARY KEY      | noise_id, operation, noise_metric, thrust |
| FOREIGN KEY      | noise_id from [doc29_noise](#doc29_noise) |

### doc29_noise_spectrum

| Variable   | Type | NOT NULL | Constraint             |
|------------|------|:--------:|------------------------|
| noise_id   | TEXT | &#10003; |                        |
| operation  | TEXT | &#10003; | `Arrival`, `Departure` |
| l_50_hz    | REAL | &#10003; |                        |
| l_63_hz    | REAL | &#10003; |                        |
| l_80_hz    | REAL | &#10003; |                        |
| l_100_hz   | REAL | &#10003; |                        |
| l_125_hz   | REAL | &#10003; |                        |
| l_160_hz   | REAL | &#10003; |                        |
| l_200_hz   | REAL | &#10003; |                        |
| l_250_hz   | REAL | &#10003; |                        |
| l_315_hz   | REAL | &#10003; |                        |
| l_400_hz   | REAL | &#10003; |                        |
| l_500_hz   | REAL | &#10003; |                        |
| l_630_hz   | REAL | &#10003; |                        |
| l_800_hz   | REAL | &#10003; |                        |
| l_1000_hz  | REAL | &#10003; |                        |
| l_1250_hz  | REAL | &#10003; |                        |
| l_1600_hz  | REAL | &#10003; |                        |
| l_2000_hz  | REAL | &#10003; |                        |
| l_2500_hz  | REAL | &#10003; |                        |
| l_3150_hz  | REAL | &#10003; |                        |
| l_4000_hz  | REAL | &#10003; |                        |
| l_5000_hz  | REAL | &#10003; |                        |
| l_6300_hz  | REAL | &#10003; |                        |
| l_8000_hz  | REAL | &#10003; |                        |
| l_10000_hz | REAL | &#10003; |                        |

| Table Constraint | Details                                   |
|------------------|-------------------------------------------|
| PRIMARY KEY      | noise_id, operation                       |
| FOREIGN KEY      | noise_id from [doc29_noise](#doc29_noise) |

---

## doc29_performance

### doc29_performance

| Variable | Type | NOT NULL | Constraint                   |
|----------|------|:--------:|------------------------------|
| id       | TEXT | &#10003; |                              |
| type     | TEXT | &#10003; | `Jet`, `Turboprop`, `Piston` |

| Table Constraint | Details |
|------------------|---------|
| PRIMARY KEY      | id		 |

### doc29_performance_aerodynamic_coefficients

| Variable       | Type | NOT NULL | Constraint                  |
|----------------|------|:--------:|-----------------------------|
| performance_id | TEXT | &#10003; |                             |
| flap_id        | TEXT | &#10003; |                             |
| type           | TEXT | &#10003; | `Takeoff`, `Land`, `Cruise` |
| r              | REAL | &#10003; | > 0                         |
| b              | REAL |          | > 0                         |
| c              | REAL |          | > 0                         |
| d              | REAL |          | > 0                         |

| Table Constraint | Details                                                     |
|------------------|-------------------------------------------------------------|
| PRIMARY KEY      | performance_id, flap_id                                     |
| FOREIGN KEY      | performance_id from [doc29_performance](#doc29_performance) |
| CHECK            | case type `Takeoff` - b NOT NULL, c NOT NULL                |
| CHECK            | case type `Land` - d NOT NULL                               |

### doc29_performance_thrust

| Variable       | Type | NOT NULL | Constraint                           |
|----------------|------|:--------:|--------------------------------------|
| performance_id | TEXT | &#10003; |                                      |
| type           | TEXT | &#10003; | `None`, `Rating`, `Rating Propeller` |

| Table Constraint | Details                                                     |
|------------------|-------------------------------------------------------------|
| PRIMARY KEY      | performance_id                                              |
| FOREIGN KEY      | performance_id from [doc29_performance](#doc29_performance) |

### doc29_performance_thrust_ratings

| Variable       | Type | NOT NULL | Constraint |
|----------------|------|:--------:|------------|
| performance_id | TEXT | &#10003; |            |
| thrust_rating  | TEXT | &#10003; | `Maximum Takeoff`, `Maximum Climb`, `Idle`, `Maximum Takeoff High Temperature`, `Maximum Climb High Temperature`, `Idle High Temperature` |

| Table Constraint | Details                                                                   |
|------------------|---------------------------------------------------------------------------|
| PRIMARY KEY      | performance_id, thrust_rating                                             |
| FOREIGN KEY      | performance_id from [doc29_performance_thrust](#doc29_performance_thrust) |

### doc29_performance_thrust_rating_coefficients

| Variable       | Type | NOT NULL | Constraint |
|----------------|------|:--------:|------------|
| performance_id | TEXT | &#10003; |            |
| thrust_rating  | TEXT | &#10003; |            |
| e              | REAL | &#10003; |            |
| f              | REAL | &#10003; |            |
| ga             | REAL | &#10003; |            |
| gb             | REAL | &#10003; |            |
| h              | REAL | &#10003; |            |

| Table Constraint | Details                                                                                                  |
|------------------|----------------------------------------------------------------------------------------------------------|
| PRIMARY KEY      | performance_id, thrust_rating                                                                            |
| FOREIGN KEY      | performance_id, thrust_rating from [doc29_performance_thrust_ratings](#doc29_performance_thrust_ratings) |

### doc29_performance_thrust_rating_coefficients_propeller

| Variable         | Type | NOT NULL | Constraint |
|------------------|------|:--------:|------------|
| performance_id   | TEXT | &#10003; |            |
| thrust_rating    | TEXT | &#10003; |            |
| efficiency       | REAL | &#10003; |            |
| propulsive_power | REAL | &#10003; |            |

| Table Constraint | Details                                                                                                  |
|------------------|----------------------------------------------------------------------------------------------------------|
| PRIMARY KEY      | performance_id, thrust_rating                                                                            |
| FOREIGN KEY      | performance_id, thrust_rating from [doc29_performance_thrust_ratings](#doc29_performance_thrust_ratings) |

### doc29_performance_profiles

| Variable         | Type | NOT NULL | Constraint             |
|------------------|------|:--------:|------------------------|
| performance_id   | TEXT | &#10003; |                        |
| operation        | TEXT | &#10003; | `Arrival`, `Departure` |
| id               | TEXT | &#10003; |                        |
| type             | TEXT | &#10003; | `Points`, `Procedural` |

| Table Constraint | Details                                                     |
|------------------|-------------------------------------------------------------|
| PRIMARY KEY      | performance_id, operation, id                               |
| FOREIGN KEY      | performance_id from [doc29_performance](#doc29_performance) |

### doc29_performance_profiles_points

| Variable                        | Type | NOT NULL | Constraint |
|---------------------------------|------|:--------:|------------|
| performance_id                  | TEXT | &#10003; |            |
| operation                       | TEXT | &#10003; |            |
| profile_id                      | TEXT | &#10003; |            |
| cumulative_ground_distance      | REAL | &#10003; |            |
| altitude_afe                    | REAL | &#10003; |            |
| true_airspeed                   | REAL | &#10003; | &#8805; 0  |
| corrected_net_thrust_per_engine | REAL | &#10003; | > 0        |

| Table Constraint | Details                                                                                              |
|------------------|------------------------------------------------------------------------------------------------------|
| PRIMARY KEY      | performance_id, operation, id, profile_id, cumulative_ground_distance                                |
| FOREIGN KEY      | performance_id, operation, profile_id from [doc29_performance_profiles](#doc29_performance_profiles) |

### doc29_performance_profiles_arrival_procedural

Each step in the arrival procedural profiles table is defined by a flap setting and three parameters. The following table defines the three parameters for each step type:

| Step Type            | Parameter 1             | Parameter 2               | Parameter 3             |
| -------------------- | ------------------      | ------------------------- | ----------------------- |
| Arrival Start        | Start Altitude ATE      | Start Calibrated Airspeed |                         |
| Descend              | End Altitude ATE        | Descent Angle             |                         |
| Descend Decelerate   | End Altitude ATE        | Descent Angle             | End Calibrated Airspeed |
| Descend Idle         | Descent Angle           | End Calibrated Airspeed   |                         |
| Level                | Ground Distance         |                           |                         |
| Level Decelerate     | Ground Distance         | End Calibrated Airspeed   |                         |
| Level Idle           | End Calibrated Airspeed |                           |                         |
| Descend Land         | Descent Angle           | Threshold Crossing Height |                         |
| Ground Decelerate    | Ground Distance         | End Calibrated Airspeed   | Thrust Percentage       |

Altitudes are given above threshold elevation. The term above threshold elevation is used to indicate that the profiles are aligned to the runway threshold elevation, not the airport elevation. Therefore, altitude above mean sea level (MSL) is calculated by adding the threshold elevation to the altitudes ATE. Speeds are given as calibrated airspeed, which allows to account for specific atmopsheric conditions. Besides the arrival start step, the information provided in each step is interpreted as 'go to' conditions. For example, a descend step has a certain flap setting, a descent angle and an altitude ATE. This means descend **TO** that altitude with that descent angle and the given flap settings.

The first step of each arrival procedural profile should be an *Arrival Start* step. Following this step, an arbitrary number of the different types of *Descend* and *Level* steps can be given. Thereafter, the *Descend Land* step should be given. In this step, a descent angle and the altitude at which the aircraft crosses the runway threshold is defined. This is the alignment point of the vertical profile with the associated flight route. The flap setting for this step must be of *Land* type. After the *Descend Land* step, an arbitrary number of *Ground Decelerate* steps can be given. This defines the deceleration of the aircraft during the landing roll.

| Variable       | Type    | NOT NULL | Constraint |
|----------------|---------|:--------:|------------|
| performance_id | TEXT    | &#10003; |            |
| operation      | TEXT    | &#10003; |            |
| profile_id     | TEXT    | &#10003; |            |
| step_number    | INTEGER | &#10003; | &#8805; 1  |
| step_type      | TEXT    | &#10003; | `Arrival Start`, `Descend`, `Descend Decelerate`, `Descend Idle`, `Level`, `Level Decelerate`, `Level Idle`, `Descend Land`, `Ground Decelerate` |
| flap_id        | TEXT    |          |            |
| parameter_1    | REAL    |          |            |
| parameter_2    | REAL    |          |            |
| parameter_3    | REAL    |          |            |

| Table Constraint | Details                                                                                                      |
|------------------|--------------------------------------------------------------------------------------------------------------|
| PRIMARY KEY      | performance_id, operation, id, profile_id, step_number                                                       |
| FOREIGN KEY      | performance_id, operation, profile_id from [doc29_performance_profiles](#doc29_performance_profiles)         |
| FOREIGN KEY      | performance_id, flap_id from [doc29_performance_aerodynamic_coefficients](#doc29_performance_aerodynamic_coefficients) |
| CHECK            | case step_type `Arrival Start` - parameter_1 NOT NULL, parameter_2 &#8805; 0                                 |
| CHECK            | case step_type `Descend` - flap_id NOT NULL, parameter_1 NOT NULL, parameter_2 &#8804; 0                     |
| CHECK            | case step_type `Descend Decelerate` - flap_id NOT NULL, parameter_1 NOT NULL, parameter_2 &#8804; 0, parameter_3 > 0 |
| CHECK            | case step_type `Descend Idle` - flap_id NOT NULL, parameter_1 &#8804; 0, parameter_2 > 0                     |
| CHECK            | case step_type `Level` - flap_id NOT NULL, parameter_1 > 0                                                   |
| CHECK            | case step_type `Level Decelerate` - flap_id NOT NULL, parameter_1 > 0, parameter_2 > 0                       |
| CHECK            | case step_type `Level Idle` - flap_id NOT NULL, parameter_1 > 0                                              |
| CHECK            | case step_type `Descend Land` - flap_id NOT NULL, parameter_1 &#8804; 0, parameter_2 NOT NULL                |
| CHECK            | case step_type `Ground Decelerate` - parameter_1 > 0, parameter_2 &#8805; 0, 0 &#8804; parameter_3 &#8804; 1 |

### doc29_performance_profiles_departure_procedural

In a departure procedural profile, each step is defined by a thrust cutback flag indicating if the thrust cutback occurs at this step, a mandatory flap setting and three parameters. The following table defines the three parameters for each step type:

| Step Type                   | Parameter 1                 | Parameter 2             | Parameter 3    |
| --------------------------- | --------------------------- | ----------------------- | -------------- |
| Takeoff                     | Initial Calibrated Airspeed |                         |                |
| Climb                       | End Altitude ATE            |                         |                |
| Climb Accelerate            | End Altitude ATE            | End Calibrated Airspeed | Climb Rate     |
| Climb Accelerate Percentage | End Altitude ATE            | End Calibrated Airspeed | Acceleration % |

Altitudes are given above threshold elevation. The term above threshold elevation is used to indicate that the profiles are aligned to the runway threshold elevation, not the airport elevation. Therefore, altitude above mean sea level (MSL) is calculated by adding the threshold elevation to the altitudes ATE. Speeds are given as calibrated airspeed, which allows to account for specific atmopsheric conditions.

The first step of each departure procedural profile should be a *Takeoff* step. A flap setting of type *Takeoff* and the initial calibrated airspeed should be given. Normally, the aircraft will start from a still position and the initial speed will be 0. In case of rolling departures, the initial calibrated airspeed can be set to a higher value. After *Takeoff*, an arbitrary number of any of the other steps types should be provided.

| Variable       | Type    | NOT NULL | Constraint                                                            |
|----------------|---------|:--------:|-----------------------------------------------------------------------|
| performance_id | TEXT    | &#10003; |                                                                       |
| operation      | TEXT    | &#10003; |                                                                       |
| profile_id     | TEXT    | &#10003; |                                                                       |
| step_number    | INTEGER | &#10003; | &#8805; 1                                                             |
| step_type      | TEXT    | &#10003; | `Takeoff`, `Climb`, `Climb Accelerate`, `Climb Accelerate Percentage` |
| thrust_cutback | INTEGER | &#10003; | `0`, `1`                                                              |
| flap_id        | TEXT    | &#10003; |                                                                       |
| parameter_1    | REAL    |          |                                                                       |
| parameter_2    | REAL    |          |                                                                       |

| Table Constraint | Details                                                                                              |
|------------------|------------------------------------------------------------------------------------------------------|
| PRIMARY KEY      | performance_id, operation, id, profile_id, step_number                                               |
| FOREIGN KEY      | performance_id, operation, profile_id from [doc29_performance_profiles](#doc29_performance_profiles) |
| FOREIGN KEY      | performance_id, flap_id from [doc29_performance_aerodynamic_coefficients](#doc29_performance_aerodynamic_coefficients) |
| CHECK            | case step_type `Takeoff` - parameter_1 NOT NULL                                                      |
| CHECK            | case step_type `Climb` - parameter_1 NOT NULL                                                        |
| CHECK            | case step_type `Climb Accelerate` - parameter_1 > 0, parameter_2 > 0                                 |
| CHECK            | case step_type `Climb Accelerate Percentage` - parameter_1 > 0, 0 &#8804; parameter_3 &#8804; 1      |

---

## fleet

### fleet

| Variable                        | Type    | NOT NULL | Constraint         |
|---------------------------------|---------|:--------:|--------------------|
| id                              | TEXT    | &#10003; |                    |
| engine_count                    | INTEGER | &#10003; | `1`, `2`, `3`, `4` |
| maximum_sea_level_static_thrust | REAL    | &#10003; | &#8805; 1          |
| engine_breakpoint_temperature   | REAL    | &#10003; | &#8805; 0          |
| doc29_performance_id            | TEXT    |          |                    |
| sfi_id                          | TEXT    |          |                    |
| lto_engine_id                   | TEXT    |          |                    |
| doc29_noise_id                  | TEXT    |          |                    |
| doc29_noise_arrival_delta_db    | REAL    | &#10003; |                    |
| doc29_noise_departure_delta_db  | REAL    | &#10003; |                    |

| Table Constraint | Details                                                           |
|------------------|-------------------------------------------------------------------|
| PRIMARY KEY      | id                                                                |
| FOREIGN KEY      | doc29_performance_id from [doc29_performance](#doc29_performance) |
| FOREIGN KEY      | sfi_id from [sfi_fuel](#sfi_fuel)                                 |
| FOREIGN KEY      | lto_engine_id from [lto_fuel_emissions](#lto_fuel_emissions)      |
| FOREIGN KEY      | doc29_noise_id from [doc29_noise](#doc29_noise)                   |

---

## fuel_emissions_run

### fuel_emissions_run

| Variable              | Type    | NOT NULL | Constraint                          |
|-----------------------|---------|:--------:|-------------------------------------|
| scenario_id           | TEXT    | &#10003; |                                     |
| performance_run_id    | TEXT    | &#10003; |                                     |
| id                    | TEXT    | &#10003; |                                     |
| emissions_model       | TEXT    | &#10003; | `None`, `Boeing Fuel Flow Method 2` |
| save_segment_results  | INTEGER | &#10003; | `0`, `1`                            |

| Table Constraint | Details                                                                  |
|------------------|--------------------------------------------------------------------------|
| PRIMARY KEY      | scenario_id, performance_run_id, id                                      |
| FOREIGN KEY      | scenario_id, performance_run_id from [performance_run](#performance_run) |

### fuel_emissions_run_output

| Variable              | Type | NOT NULL | Constraint |
|-----------------------|------|:--------:|------------|
| scenario_id           | TEXT | &#10003; |            |
| performance_run_id    | TEXT | &#10003; |            |
| fuel_emissions_run_id | TEXT | &#10003; |            |
| fuel                  | REAL | &#10003; |            |
| hc                    | REAL | &#10003; |            |
| co                    | REAL | &#10003; |            |
| nox                   | REAL | &#10003; |            |

| Table Constraint | Details                                                                                               |
|------------------|-------------------------------------------------------------------------------------------------------|
| PRIMARY KEY      | scenario_id, performance_run_id, fuel_emissions_run_id                                                |
| FOREIGN KEY      | scenario_id, performance_run_id, fuel_emissions_run_id from [fuel_emissions_run](#fuel_emissions_run) |

### fuel_emissions_run_output_operations

| Variable              | Type | NOT NULL | Constraint |
|-----------------------|------|:--------:|------------|
| scenario_id           | TEXT | &#10003; |            |
| performance_run_id    | TEXT | &#10003; |            |
| fuel_emissions_run_id | TEXT | &#10003; |            |
| operation_id          | TEXT | &#10003; |            |
| operation             | TEXT | &#10003; |            |
| operation_type        | TEXT | &#10003; |            |
| fuel                  | REAL | &#10003; |            |
| hc                    | REAL | &#10003; |            |
| co                    | REAL | &#10003; |            |
| nox                   | REAL | &#10003; |            |

| Table Constraint | Details                                                                                                    |
|------------------|------------------------------------------------------------------------------------------------------------|
| PRIMARY KEY      | scenario_id, performance_run_id, fuel_emissions_run_id, operation_id, operation, operation_type            |
| FOREIGN KEY      | scenario_id, performance_run_id, fuel_emissions_run_id from [fuel_emissions_run_output](#fuel_emissions_run_output) |
| FOREIGN KEY      | scenario_id, performance_run_id, operation_id, operation, operation_type from [performance_run_output](#performance_run_output) |

### fuel_emissions_run_output_segments

| Variable              | Type    | NOT NULL | Constraint |
|-----------------------|---------|:--------:|------------|
| scenario_id           | TEXT    | &#10003; |            |
| performance_run_id    | TEXT    | &#10003; |            |
| fuel_emissions_run_id | TEXT    | &#10003; |            |
| operation_id          | TEXT    | &#10003; |            |
| operation             | TEXT    | &#10003; |            |
| operation_type        | TEXT    | &#10003; |            |
| segment_number        | INTEGER | &#10003; |            |
| fuel                  | REAL    | &#10003; |            |
| hc                    | REAL    | &#10003; |            |
| co                    | REAL    | &#10003; |            |
| nox                   | REAL    | &#10003; |            |

| Table Constraint | Details                                                                                                         |
|------------------|-----------------------------------------------------------------------------------------------------------------|
| PRIMARY KEY      | scenario_id, performance_run_id, fuel_emissions_run_id, operation_id, operation, operation_type, segment_number |
| FOREIGN KEY      | scenario_id, performance_run_id, fuel_emissions_run_id, operation_id, operation, operation_type from [fuel_emissions_run_output_operation](#fuel_emissions_run_output_operations) |

---

## lto_fuel_emissions

### lto_fuel_emissions

| Variable                              | Type | NOT NULL | Constraint      |
|---------------------------------------|------|:--------:|-----------------|
| id                                    | TEXT | &#10003; |                 |
| fuel_flow_idle                        | REAL | &#10003; | &#8805; 0       |
| fuel_flow_approach                    | REAL | &#10003; | &#8805; 0       |
| fuel_flow_climb_out                   | REAL | &#10003; | &#8805; 0       |
| fuel_flow_takeoff                     | REAL | &#10003; | &#8805; 0       |
| fuel_flow_correction_factor_idle      | REAL |          | &#8805; 0       |
| fuel_flow_correction_factor_approach  | REAL |          | &#8805; 0       |
| fuel_flow_correction_factor_climb_out | REAL |          | &#8805; 0       |
| fuel_flow_correction_factor_takeoff   | REAL |          | &#8805; 0       |
| emission_index_hc_idle                | REAL | &#10003; | &#8805; 0       |
| emission_index_hc_approach            | REAL | &#10003; | &#8805; 0       |
| emission_index_hc_climb Out           | REAL | &#10003; | &#8805; 0       |
| emission_index_hc_takeoff             | REAL | &#10003; | &#8805; 0       |
| emission_index_co_idle                | REAL | &#10003; | &#8805; 0       |
| emission_index_co_approach            | REAL | &#10003; | &#8805; 0       |
| emission_index_co_climb_out           | REAL | &#10003; | &#8805; 0       |
| emission_index_co_takeoff             | REAL | &#10003; | &#8805; 0       |
| emission_index_nox_idle               | REAL | &#10003; | &#8805; 0       |
| emission_index_nox_approach           | REAL | &#10003; | &#8805; 0       |
| emission_index_nox_climb_out          | REAL | &#10003; | &#8805; 0       |
| emission_index_nox_takeoff            | REAL | &#10003; | &#8805; 0       |

| Table Constraint | Details |
|------------------|---------|
| PRIMARY KEY      | id      |

---

## noise_run

### noise_run

| Variable                  | Type    | NOT NULL | Constraint                            |
|---------------------------|---------|:--------:|---------------------------------------|
| scenario_id               | TEXT    | &#10003; |                                       |
| performance_run_id        | TEXT    | &#10003; |                                       |
| id                        | TEXT    | &#10003; |                                       |
| noise_model               | TEXT    | &#10003; | `Doc29`                               |
| atmospheric_absorption    | TEXT    | &#10003; | `None`, `SAE ARP 866`, `SAE ARP 5534` |
| receptor_set_type         | TEXT    | &#10003; | `Grid`, `Points`                      |
| save_single_event_metrics | INTEGER | &#10003; | `0`, `1`                              |

| Table Constraint | Details                                                                  |
|------------------|--------------------------------------------------------------------------|
| PRIMARY KEY      | scenario_id, performance_run_id, id                                      |
| FOREIGN KEY      | scenario_id, performance_run_id from [performance_run](#performance_run) |

### noise_run_cumulative_metrics

| Variable                     | Type | NOT NULL | Constraint          |
|------------------------------|------|:--------:|---------------------|
| scenario_id                  | TEXT | &#10003; |                     |
| performance_run_id           | TEXT | &#10003; |                     |
| noise_run_id                 | TEXT | &#10003; |                     |
| id                           | TEXT | &#10003; |                     |
| threshold_db                 | REAL | &#10003; | &#8805; 0           |
| averaging_time_constant_db   | REAL | &#10003; | &#8805; 0           |
| start_time_point             | TEXT | &#10003; | yyyy-mm-dd HH:MM:SS |
| end_time_point               | TEXT | &#10003; | yyyy-mm-dd HH:MM:SS |

| Table Constraint | Details                                                                    |
|------------------|----------------------------------------------------------------------------|
| PRIMARY KEY      | scenario_id, performance_run_id, noise_run_id, id                          |
| FOREIGN KEY      | scenario_id, performance_run_id, noise_run_id from [noise_run](#noise_run) |

### noise_run_cumulative_metrics_number_above_thresholds

| Variable                       | Type | NOT NULL | Constraint |
|--------------------------------|------|:--------:|------------|
| scenario_id                    | TEXT | &#10003; |            |
| performance_run_id             | TEXT | &#10003; |            |
| noise_run_id                   | TEXT | &#10003; |            |
| noise_run_cumulative_metric_id | TEXT | &#10003; |            |
| threshold_db                   | REAL | &#10003; | &#8805; 0  |

| Table Constraint | Details                                                                       |
|------------------|-------------------------------------------------------------------------------|
| PRIMARY KEY      | scenario_id, performance_run_id, noise_run_id, noise_run_cumulative_metric_id |
| FOREIGN KEY      | scenario_id, performance_run_id, noise_run_id, noise_run_cumulative_metric_id from [noise_run_cumulative_metrics](#noise_run_cumulative_metrics) |

### noise_run_cumulative_metrics_weights

| Variable                       | Type | NOT NULL | Constraint |
|--------------------------------|------|:--------:|------------|
| scenario_id                    | TEXT | &#10003; |            |
| performance_run_id             | TEXT | &#10003; |            |
| noise_run_id                   | TEXT | &#10003; |            |
| noise_run_cumulative_metric_id | TEXT | &#10003; |            |
| time_of_day                    | TEXT | &#10003; |            |
| weight                         | REAL | &#10003; |            |

| Table Constraint | Details                                                                       |
|------------------|-------------------------------------------------------------------------------|
| PRIMARY KEY      | scenario_id, performance_run_id, noise_run_id, noise_run_cumulative_metric_id |
| FOREIGN KEY      | scenario_id, performance_run_id, noise_run_id, noise_run_cumulative_metric_id from [noise_run_cumulative_metrics](#noise_run_cumulative_metrics) |

### noise_run_output_cumulative

| Variable                       | Type | NOT NULL | Constraint |
|--------------------------------|------|:--------:|------------|
| scenario_id                    | TEXT | &#10003; |            |
| performance_run_id             | TEXT | &#10003; |            |
| noise_run_id                   | TEXT | &#10003; |            |
| noise_run_cumulative_metric_id | TEXT | &#10003; |            |
| receptor_id                    | TEXT | &#10003; |            |
| maximum_absolute_db            | REAL | &#10003; |            |
| maximum_average_db             | REAL | &#10003; |            |
| exposure_db                    | REAL | &#10003; |            |

| Table Constraint | Details                                                                                    |
|------------------|--------------------------------------------------------------------------------------------|
| PRIMARY KEY      | scenario_id, performance_run_id, noise_run_id, noise_run_cumulative_metric_id, receptor_id |
| FOREIGN KEY      | scenario_id, performance_run_id, noise_run_id, noise_run_cumulative_metric_id from [noise_run_cumulative_metrics](#noise_run_cumulative_metrics) |
| FOREIGN KEY      | scenario_id, performance_run_id, noise_run_id, receptor_id from [noise_run_output_receptors](#noise_run_output_receptors) |

### noise_run_output_cumulative_number_above

| Variable                       | Type | NOT NULL | Constraint |
|--------------------------------|------|:--------:|------------|
| scenario_id                    | TEXT | &#10003; |            |
| performance_run_id             | TEXT | &#10003; |            |
| noise_run_id                   | TEXT | &#10003; |            |
| noise_run_cumulative_metric_id | TEXT | &#10003; |            |
| threshold_db                   | TEXT | &#10003; |            |
| receptor_id                    | TEXT | &#10003; |            |
| number_above                   | REAL | &#10003; |            |

| Table Constraint | Details                                                                                               |
|------------------|-------------------------------------------------------------------------------------------------------|
| PRIMARY KEY      | scenario_id, performance_run_id, noise_run_id, noise_run_cumulative_metric_id, threshold, receptor_id |
| FOREIGN KEY      | scenario_id, performance_run_id, noise_run_id, noise_run_cumulative_metric_id, threshold from [noise_run_cumulative_metrics_number_above_thresholds](#noise_run_cumulative_metrics_number_above_thresholds) |
| FOREIGN KEY      | scenario_id, performance_run_id, noise_run_id, receptor_id from [noise_run_output_receptors](#noise_run_output_receptors) |

### noise_run_output_receptors

| Variable           | Type | NOT NULL | Constraint |
|--------------------|------|:--------:|------------|
| scenario_id        | TEXT | &#10003; |            |
| performance_run_id | TEXT | &#10003; |            |
| noise_run_id       | TEXT | &#10003; |            |
| id                 | TEXT | &#10003; |            |
| longitude          | REAL | &#10003; |            |
| latitude           | REAL | &#10003; |            |
| altitude_msl       | REAL | &#10003; |            |

| Table Constraint | Details                                                                    |
|------------------|----------------------------------------------------------------------------|
| PRIMARY KEY      | scenario_id, performance_run_id, noise_run_id, _id                         |
| FOREIGN KEY      | scenario_id, performance_run_id, noise_run_id from [noise_run](#noise_run) |

### noise_run_output_single_event

| Variable           | Type | NOT NULL | Constraint |
|--------------------|------|:--------:|------------|
| scenario_id        | TEXT | &#10003; |            |
| performance_run_id | TEXT | &#10003; |            |
| noise_run_id       | TEXT | &#10003; |            |
| receptor_id        | TEXT | &#10003; |            |
| operation_id       | TEXT | &#10003; |            |
| operation          | TEXT | &#10003; |            |
| operation_type     | TEXT | &#10003; |            |
| maximum_db         | REAL | &#10003; |            |
| exposure_db        | REAL | &#10003; |            |

| Table Constraint | Details                                                                                             |
|------------------|-----------------------------------------------------------------------------------------------------|
| PRIMARY KEY      | scenario_id, performance_run_id, noise_run_id, receptor_id, operation_id, operation, operation_type |
| FOREIGN KEY      | scenario_id, performance_run_id, operation_id, operation, operation_type from [performance_run_output](#performance_run_output) |
| FOREIGN KEY      | scenario_id, performance_run_id, noise_run_id, receptor_id from [noise_run_output_receptors](#noise_run_output_receptors) |

### noise_run_receptor_grid

| Variable               | Type    | NOT NULL | Constraint                                                       |
|------------------------|---------|:--------:|------------------------------------------------------------------|
| scenario_id            | TEXT    | &#10003; |                                                                  |
| performance_run_id     | TEXT    | &#10003; |                                                                  |
| noise_run_id           | TEXT    | &#10003; |                                                                  |
| reference_location     | TEXT    | &#10003; | `Center`, `Bottom Left`, `Bottom Right`, `Top Left`, `Top Right` |
| reference_longitude    | REAL    | &#10003; | -180 &#8804; x &#8804; 180                                       |
| reference_latitude     | REAL    | &#10003; | -90 &#8804; x &#8804; 90                                         |
| reference_altitude_msl | REAL    | &#10003; |                                                                  |
| horizontal_spacing     | REAL    | &#10003; | > 0                                                              |
| vertical_spacing       | REAL    | &#10003; | > 0                                                              |
| horizontal_count       | INTEGER | &#10003; | &#8805; 1                                                        |
| vertical_count         | INTEGER | &#10003; | &#8805; 1                                                        |
| grid_rotation          | REAL    | &#10003; | -180 &#8804; x &#8804; 180                                       |

| Table Constraint | Details                                                                    |
|------------------|----------------------------------------------------------------------------|
| PRIMARY KEY      | scenario_id, performance_run_id, noise_run_id                              |
| FOREIGN KEY      | scenario_id, performance_run_id, noise_run_id from [noise_run](#noise_run) |

### noise_run_receptor_points

| Variable           | Type    | NOT NULL | Constraint                 |
|--------------------|---------|:--------:|----------------------------|
| scenario_id        | TEXT    | &#10003; |                            |
| performance_run_id | TEXT    | &#10003; |                            |
| noise_run_id       | TEXT    | &#10003; |                            |
| id                 | TEXT    | &#10003; |                            |
| longitude          | REAL    | &#10003; | -180 &#8804; x &#8804; 180 |
| latitude           | REAL    | &#10003; | -90 &#8804; x &#8804; 90   |
| altitude_msl       | REAL    | &#10003; |                            |

| Table Constraint | Details                                                                    |
|------------------|----------------------------------------------------------------------------|
| PRIMARY KEY      | scenario_id, performance_run_id, noise_run_id, id                          |
| FOREIGN KEY      | scenario_id, performance_run_id, noise_run_id from [noise_run](#noise_run) |

---

## operations

### operations_flights

| Variable   | Type | NOT NULL | Constraint          |
|------------|------|:--------:|---------------------|
| id         | TEXT | &#10003; |                     |
| airport_id | TEXT | &#10003; |                     |
| runway_id  | TEXT | &#10003; |                     |
| operation  | TEXT | &#10003; |                     |
| route_id   | TEXT | &#10003; |                     |
| time       | TEXT | &#10003; | yyyy-mm-dd HH:MM:SS |
| count      | REAL | &#10003; | &#8805; 0           |
| fleet_id   | TEXT | &#10003; |                     |
| weight     | REAL | &#10003; | > 0                 |

| Table Constraint | Details                                                                             |
|------------------|-------------------------------------------------------------------------------------|
| PRIMARY KEY      | id, operation                                                                       |
| FOREIGN KEY      | airport_id, runway_id, operation, route_id from [airports_routes](#airports_routes) |
| FOREIGN KEY      | fleet_id from [fleet](#fleet)                                                       |

### operations_flights_arrival

| Variable         | Type | NOT NULL | Constraint |
|------------------|------|:--------:|------------|
| operation_id     | TEXT | &#10003; |            |
| operation        | TEXT | &#10003; |            |
| doc29_profile_id | TEXT |          |            |

| Table Constraint | Details                                                                |
|------------------|------------------------------------------------------------------------|
| PRIMARY KEY      | operation_id, operation                                                |
| FOREIGN KEY      | operation_id, operation from [operations_flights](#operations_flights) |

### operations_flights_departure

| Variable          | Type | NOT NULL | Constraint              |
|-------------------|------|:--------:|-------------------------|
| operation_id      | TEXT | &#10003; |                         |
| operation         | TEXT | &#10003; |                         |
| doc29_profile_id  | TEXT |          |                         |
| thrust_percentage | REAL | &#10003; | 0.5 &#8804; x &#8804; 1 |

| Table Constraint | Details                                                                |
|------------------|------------------------------------------------------------------------|
| PRIMARY KEY      | operation_id, operation                                                |
| FOREIGN KEY      | operation_id, operation from [operations_flights](#operations_flights) |

### operations_tracks_4d

| Variable  | Type | NOT NULL | Constraint             |
|-----------|------|:--------:|------------------------|
| id        | TEXT | &#10003; |                        |
| operation | TEXT | &#10003; | `Arrival`, `Departure` |
| time      | TEXT | &#10003; | yyyy-mm-dd HH:MM:SS    |
| count     | REAL | &#10003; | &#8805; 0              |
| fleet_id  | TEXT | &#10003; |                        |

| Table Constraint | Details                       |
|------------------|-------------------------------|
| PRIMARY KEY      | id, operation                 |
| FOREIGN KEY      | fleet_id from [fleet](#fleet) |

### operations_tracks_4d_points

| Variable                        | Type    | NOT NULL | Constraint                                              |
|---------------------------------|---------|:--------:|---------------------------------------------------------|
| operation_id                    | TEXT    | &#10003; |                                                         |
| operation                       | TEXT    | &#10003; | `Arrival`, `Departure`                                  |
| point_number                    | INTEGER | &#10003; | &#8805; 1                                               |
| flight_phase                    | TEXT    | &#10003; | `Approach`, `Landing Roll`, `Takeoff Roll`, `Departure` |
| longitude                       | REAL    | &#10003; | -180 &#8804; x &#8804; 180                              |
| latitude                        | REAL    | &#10003; | -90 &#8804; x &#8804; 90                                |
| altitude_msl                    | REAL    | &#10003; |                                                         |
| true_airspeed                   | REAL    | &#10003; | &#8805; 0                                               |
| corrected_net_thrust_per_engine | REAL    | &#10003; |                                                         |
| bank_angle                      | REAL    | &#10003; | -90 &#8804; x &#8804; 90                                |
| fuel_flow_per_engine            | REAL    | &#10003; | &#8805; 0                                               |

| Table Constraint | Details                                                                  |
|------------------|--------------------------------------------------------------------------|
| PRIMARY KEY      | operation_id, operation, point_number                                    |
| FOREIGN KEY      | operation_id, operation from [operation_tracks_4d](#operations_tracks_4d) |

---

## performance_run

### performance_run

| Variable                                       | Type    | NOT NULL | Constraint                          |
|-----------------------------------------------------|---------|:--------:|-------------------------------------|
| scenario_id                                         | TEXT    | &#10003; |                                     |
| id                                                  | TEXT    | &#10003; |                                     |
| coordinate_system_type                              | TEXT    | &#10003; | `Geodesic WGS84`, `Local Cartesian` |
| coordinate_system_longitude_0                       | REAL    |          | -180 &#8804; x &#8804; 180          |
| coordinate_system_latitude_0                        | REAL    |          | -90 &#8804; x &#8804; 90            |
| atmosphere_reference_altitude_msl                   | REAL    |          | &#8804; 11000                       |
| atmosphere_temperature_delta                        | REAL    |          | -100 &#8804; x &#8804; 100          |
| atmosphere_pressure_delta                           | REAL    |          | -15000 &#8804; x &#8804; 15000      |
| atmosphere_headwind                                 | REAL    | &#10003; |                                     |
| atmosphere_relative_humidity                        | REAL    | &#10003; | 0 &#8804; x &#8804; 1               |
| performance_model                                   | TEXT    | &#10003; | `Doc29`                             |
| performance_minimum_altitude_msl                    | REAL    |          |                                     |
| performance_maximum_altitude_msl                    | REAL    |          |                                     |
| performance_minimum_cumulative_ground_distance      | REAL    |          |                                     |
| performance_maximum_cumulative_ground_distance      | REAL    |          |                                     |
| performance_minimum_tracks_4d_point_count           | INTEGER |          | &#8805; 0                           |
| performance_speed_delta_segmentation_threshold      | REAL    |          | > 0                                 |
| performance_ground_distance_filter_threshold        | REAL    |          | &#8805; 0                           |
| performance_flights_doc29_low_altitude_segmentation | INTEGER |          | `0`, `1`                            |
| fuel_flow_model                                     | TEXT    | &#10003; | `None`, `LTO`, `SFI`                |

| Table Constraint | Details                                  |
|------------------|------------------------------------------|
| PRIMARY KEY      | scenario_id, id                          |
| FOREIGN KEY      | scenario_id from [scenarios](#scenarios) |

### performance_run_output

| Variable           | Type | NOT NULL | Constraint             |
|--------------------|------|:--------:|------------------------|
| scenario_id        | TEXT | &#10003; |                        |
| performance_run_id | TEXT | &#10003; |                        |
| operation_id       | TEXT | &#10003; |                        |
| operation          | TEXT | &#10003; | `Arrival`, `Departure` |
| operation_type     | TEXT | &#10003; | `Flight`, `Track 4D`   |

| Table Constraint | Details                                                                  |
|------------------|--------------------------------------------------------------------------|
| PRIMARY KEY      | scenario_id, performance_run_id, operation_id, operation, operation_type |
| FOREIGN KEY      | scenario_id, performance_run_id from [performance_run](#performance_run) |

### performance_run_output_points

| Variable                        | Type    | NOT NULL | Constraint                                              |
|---------------------------------|---------|:--------:|---------------------------------------------------------|
| scenario_id                     | TEXT    | &#10003; |                                                         |
| performance_run_id              | TEXT    | &#10003; |                                                         |
| operation_id                    | TEXT    | &#10003; |                                                         |
| operation                       | TEXT    | &#10003; |                                                         |
| operation_type                  | TEXT    | &#10003; |                                                         |
| point_number                    | INTEGER | &#10003; |                                                         |
| point_origin                    | TEXT    | &#10003; | `Route`, `Profile`, `Route & Profile`, `Track 4D`, `Distance Segmentation`, `Speed Segmentation`           |
| flight_phase                    | TEXT    | &#10003; | `Approach`, `Landing Roll`, `Takeoff Roll`, `Departure` |
| cumulative_ground_distance      | REAL    | &#10003; |                                                         |
| longitude                       | REAL    | &#10003; |                                                         |
| latitude                        | REAL    | &#10003; |                                                         |
| altitude_msl                    | REAL    | &#10003; |                                                         |
| true_airspeed                   | REAL    | &#10003; |                                                         |
| ground_speed                    | REAL    | &#10003; |                                                         |
| corrected_net_thrust_per_engine | REAL    | &#10003; |                                                         |
| bank_angle                      | REAL    | &#10003; |                                                         |
| fuel_flow_per_engine            | REAL    | &#10003; |                                                         |

| Table Constraint | Details                                                                                |
|------------------|----------------------------------------------------------------------------------------|
| PRIMARY KEY      | scenario_id, performance_run_id, operation_id, operation, operation_type, point_number |
| FOREIGN KEY      | scenario_id, performance_run_id, operation_id, operation, operation_type from [performance_run_output](#performance_run_output) |

---

## scenarios

### scenarios

| Variable | Type | NOT NULL | Constraint |
|----------|------|:--------:|------------|
| id       | TEXT | &#10003; |            |

| Table Constraint | Details |
|------------------|---------|
| PRIMARY KEY      | id      |

### scenarios_flights

| Variable          | Type | NOT NULL | Constraint |
|-------------------|------|:--------:|------------|
| scenario_id       | TEXT | &#10003; |            |
| operation_id      | TEXT | &#10003; |            |
| operation         | TEXT | &#10003; |            |

| Table Constraint | Details                                                                |
|------------------|------------------------------------------------------------------------|
| PRIMARY KEY      | scenario_id, operation_id, operation                                   |
| FOREIGN KEY      | scenario_id from [scenarios](#scenarios)                               |
| FOREIGN KEY      | operation_id, operation from [operations_flights](#operations_flights) |

### scenarios_tracks_4d

| Variable          | Type | NOT NULL | Constraint |
|-------------------|------|:--------:|------------|
| scenario_id       | TEXT | &#10003; |            |
| operation_id      | TEXT | &#10003; |            |
| operation         | TEXT | &#10003; |            |

| Table Constraint | Details                                                                    |
|------------------|----------------------------------------------------------------------------|
| PRIMARY KEY      | scenario_id, operation_id, operation                                       |
| FOREIGN KEY      | scenario_id from [scenarios](#scenarios)                                   |
| FOREIGN KEY      | operation_id, operation from [operations_tracks_4d](#operations_tracks_4d) |

---

## sfi_fuel

### sfi_fuel

| Variable | Type | NOT NULL | Constraint |
|----------|------|:--------:|------------|
| id       | TEXT | &#10003; |            |
| a        | REAL | &#10003; |            |
| b1       | REAL | &#10003; |            |
| b2       | REAL | &#10003; |            |
| b3       | REAL | &#10003; |            |
| k1       | REAL | &#10003; |            |
| k2       | REAL | &#10003; |            |
| k3       | REAL | &#10003; |            |
| k4       | REAL | &#10003; |            |

| Table Constraint | Details |
|------------------|---------|
| PRIMARY KEY      | id      |