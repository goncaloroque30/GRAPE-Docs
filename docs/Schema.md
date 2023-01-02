# Intro
GRAPE uses [SQLite](https://www.sqlite.org/) as an application file format (.grp). A basic understanding of SQL is needed in order to understand the GRAPE schema documented in this file. It should be used as a reference to create '.grp' files using third party tools or scripts and to obtain the raw output data of GRAPE for further processing. The same file is used to store user inputs as well as application outputs.

All data is stored in SI units, angles are stored in degrees and percentages stored as a real number (1 corresponds to 100%). For conversions to other units please see the [conversion table](/docs/ConversionTable.md). In the vertical plane, positive angles or gradients always indicate a climb and negative angles or gradients indicate a descent. For convenience, the tables in the GRAPE schema are organized into [sections](##sections). Each section has a specific function in GRAPE. The name of every table in the schema begins with the section name.

For every table, a documentation of its variables, primary key and foreign keys is given. The foreign key is specified by giving the table variables which are part of the foreign key and the foreign table. In GRAPE, the unique index of the foreign table is always its primary key. For example, the table *airport_routes* has the variables *airport_id* and *runway_id* as foreign key from the table *airport_runways*. This means that for every entry in the *airport_routes* table, the pair of values *airport_id*, *runway_id* must be found in the table *airports_runways* as a primary key, meaning its variables *airport_id*, *id*.

All tables which are filled by GRAPE after calculating results have the word *output* in its name. This tables are intended to be read from, but should not be directly edited. The input and output tables are defined in the same schema and file so that a GRAPE study can be entirely contained in a single '.grp' file.

## Sections

1.  [airports](#airports)
2.  [doc29_performance](#doc29_performance)
3.  [doc29_noise](#doc29_noise)
4.  [lto_fuel](#lto_fuel)
5.  [sfi_fuel](#sfi_fuel)
6.  [fleet](#fleet)
7.  [operations_flights](#operations_flights)
8.  [operations_tracks_4d](#operations_tracks_4d)
9.  [scenarios](#scenarios)
10. [performance_run](#performance_run)
11. [noise_run](#noise_run)
12. [fuel_emissions_run](#fuel_emissions_run)

# 1. airports
A flight operation ground path, meaning the sequence of longitude latitude points covered by each flight, is calculated by GRAPE based on a route. This section provides the route definitions and groups them into airports and runways. A route always belongs to a runway, and a runways always belongs to an airport.

## Tables

### airports

| Variable | Type | Constraint | Not Null |
| --- | --- | --- | --- |
| id | TEXT |  | Yes |
| longitude | REAL | -180.000000 &#8804; longitude &#8804; 180.000000 | Yes |
| latitude | REAL | -90.000000 &#8804; latitude &#8804; 90.000000 | Yes |
| elevation | REAL |  | Yes |
| reference_temperature | REAL |  | No |
| reference_pressure | REAL |  | No |

Primary Key: id

### airports_runways

| Variable | Type | Constraint | Not Null |
| --- | --- | --- | --- |
| airport_id | TEXT |  | Yes |
| id | TEXT |  | Yes |
| longitude | REAL | -180.000000 &#8804; longitude &#8804; 180.000000 | Yes |
| latitude | REAL | -90.000000 &#8804; latitude &#8804; 90.000000 | Yes |
| elevation | REAL |  | Yes |
| length | REAL |  | Yes |
| heading | REAL | 0.000000 &#8804; heading &#8804; 360.000000 | Yes |
| gradient | REAL | -1.000000 &#8804; gradient &#8804; 1.000000 | Yes |

Primary Key: airport_id, id

| Foreign Key | From Table |
| --- | --- |
| airport_id | airports |

### airports_routes

| Variable | Type | Constraint | Not Null |
| --- | --- | --- | --- |
| airport_id | TEXT |  | Yes |
| runway_id | TEXT |  | Yes |
| operation | TEXT | 'Arrival', 'Departure' | Yes |
| id | TEXT |  | Yes |
| type | TEXT | 'Simple', 'Vectors', 'Rnp' | Yes |

Primary Key: airport_id, runway_id, operation, id

| Foreign Key | From Table |
| --- | --- |
| airport_id, runway_id | airports_runways |

### airports_routes_simple

| Variable | Type | Constraint | Not Null |
| --- | --- | --- | --- |
| airport_id | TEXT |  | Yes |
| runway_id | TEXT |  | Yes |
| operation | TEXT | 'Arrival', 'Departure' | Yes |
| route_id | TEXT |  | Yes |
| point_number | INTEGER |  | Yes |
| longitude | REAL | -180.000000 &#8804; longitude &#8804; 180.000000 | Yes |
| latitude | REAL | -90.000000 &#8804; latitude &#8804; 90.000000 | Yes |

Primary Key: airport_id, runway_id, operation, route_id, point_number

| Foreign Key | From Table |
| --- | --- |
| airport_id, runway_id, operation, route_id | airports_routes |

### airports_routes_vectors

| Variable | Type | Constraint | Not Null |
| --- | --- | --- | --- |
| airport_id | TEXT |  | Yes |
| runway_id | TEXT |  | Yes |
| operation | TEXT | 'Arrival', 'Departure' | Yes |
| route_id | TEXT |  | Yes |
| step_number | INTEGER |  | Yes |
| type | TEXT | 'Straight', 'Turn' | Yes |
| distance | REAL |  | No |
| turn_radius | REAL |  | No |
| heading | REAL | 0.000000 &#8804; heading &#8804; 360.000000 | No |

Primary Key: airport_id, runway_id, operation, route_id, step_number

| Foreign Key | From Table |
| --- | --- |
| airport_id, runway_id, operation, route_id | airports_routes |

### airports_routes_rnp

| Variable | Type | Constraint | Not Null |
| --- | --- | --- | --- |
| airport_id | TEXT |  | Yes |
| runway_id | TEXT |  | Yes |
| operation | TEXT | 'Arrival', 'Departure' | Yes |
| route_id | TEXT |  | Yes |
| step_number | INTEGER |  | Yes |
| type | TEXT | 'Track to Fix', 'Radius to Fix' | Yes |
| longitude | REAL | -180.000000 &#8804; longitude &#8804; 180.000000 | Yes |
| latitude | REAL | -90.000000 &#8804; latitude &#8804; 90.000000 | Yes |
| center_longitude | REAL | -180.000000 &#8804; center_longitude &#8804; 180.000000 | No |
| center_latitude | REAL | -90.000000 &#8804; center_latitude &#8804; 90.000000 | No |

Primary Key: airport_id, runway_id, operation, route_id, step_number

| Foreign Key | From Table |
| --- | --- |
| airport_id, runway_id, operation, route_id | airports_routes |

# 2. doc29_performance

This section contains the data needed to apply the performance model described in the Doc.29 to a flight operation. It is in structure very similar to the ANP database which accompanies Doc.29. The major diference lies in the aircraft definition and in the definition of arrival and departure procedural profiles. An aircraft is GRAPE only has the absolute necessary variables to apply the performance model. Procedural profiles are defined by a sequence of steps, which coupled with a performance model fully define the vertical profile of a flight (sequence of cumulative ground distances, altitudes, ground speeds and thrust values). The data in this section is grouped into Doc.29 aircrafts. A Doc.29 aircraft can have an arbitrary number of arrival and departure profiles which can be defined with procedural steps or points. An aircraft has a set of engine coefficients and aerodynamic coefficients, which are used by the procedural profiles to calculate the aircraft vertical profile. Point profiles already define every variable needed and therefore do not require engine or aerodynamic coefficients for calculations.

## Arrival procedural profiles

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

Altitudes are given above threshold elevation. The term above threshold elevation is used to indicate that the the profiles are aligned to the runway threshold elevation, not the airport elevation. Therefore, altitude above mean sea level (MSL) is calculated by adding the threshold elevation to the altitudes ATE. Speeds are given as calibrated airspeed, which allows to account for specific atmopsheric conditions. Besides the arrival start step, the information provided in each step is interpreted as 'go to' conditions. For example, a descend step has a certain flap setting, a descent angle and an altitude ATE. This means descend **TO** that altitude with that descent angle and the given flap settings.

The difference between the step types with and without 'Idle' at the end of the name lies solely with how the thrust is calculated. In steps withouth 'Idle', thrust is calculated with a force balance equation, which requires a flap setting in order to account for the drag component. In 'Idle' steps, idle thrust coefficients are used which must be present in the engine coefficients table. 'Idle' step types can only be used by aircraft with jet engines (as defined in the Doc.29 aircrafts table).

The first step of each arrival procedural profile must be an *Arrival Start* step. This step type is only allowed as the first step of a profile. Following this step, an arbitrary number of the different types of *Descend* and *Level* steps can be given. Thereafter, the *Descend Land* step must be given. In this step, a descent angle and the altitude at which the aircraft crosses the runway threshold is defined. This is the alignment point of the vertical profile with the associated flight route. The flap setting for this step must be of 'Land' type. After the Descend Land, an arbitrary number of Ground Decelerate steps can be given. This defines the deceleration of the aircraft during the landing roll.

## Departure procedural profiles

In a departure procedural profile, each step is defined by a thurst cutback flag indicating if the thrust cutback occurs at this step, a mandatory flap setting and three parameters. The following table defines the three parameters for each step type:

| Step Type                   | Parameter 1                 | Parameter 2             | Parameter 3    |
| --------------------------- | --------------------------- | ----------------------- | -------------- |
| Takeoff                     | Initial Calibrated Airspeed |                         |                |
| Climb                       | End Altitude AFE            |                         |                |
| Climb Accelerate            | End Altitude AFE            | End Calibrated Airspeed | Climb Rate     |
| Climb Accelerate Percentage | End Altitude AFE            | End Calibrated Airspeed | Acceleration % |

The first step of each departure procedural profile must be a *Takeoff* step. This step type is only allowed as the first step of the profile. A flap setting of type 'Takeoff' and the initial calibrated airspeed must be given. Normally, the aircraft will start from a still position and the initial speed will be 0. In case of rolling departures, the initial calibrated airspeed can be set to a higher value. The thrust cutback flag can't be set in the *Takeoff* step. After *Takeoff*, an arbitrary number of Climb steps can be given.

## Tables

### doc29_performance_thrust

| Variable | Type | Constraint | Not Null |
| --- | --- | --- | --- |
| aircraft_id | TEXT |  | Yes |
| type | TEXT | 'None', 'Rating', 'Propeller' | Yes |

Primary Key: aircraft_id

| Foreign Key | From Table |
| --- | --- |
| aircraft_id | doc29_aircrafts |

### doc29_performance_thrust_ratings

| Variable | Type | Constraint | Not Null |
| --- | --- | --- | --- |
| aircraft_id | TEXT |  | Yes |
| thrust_rating | TEXT |  | Yes |

Primary Key: aircraft_id, thrust_rating

| Foreign Key | From Table |
| --- | --- |
| aircraft_id | doc29_performance_thrust |

### doc29_performance_thrust_coefficients_rating

| Variable | Type | Constraint | Not Null |
| --- | --- | --- | --- |
| aircraft_id | TEXT |  | Yes |
| thrust_rating | TEXT |  | Yes |
| e | REAL |  | Yes |
| f | REAL |  | Yes |
| ga | REAL |  | Yes |
| gb | REAL |  | Yes |
| h | REAL |  | Yes |

Primary Key: aircraft_id, thrust_rating

| Foreign Key | From Table |
| --- | --- |
| aircraft_id, thrust_rating | doc29_performance_thrust_ratings |

### doc29_performance_thrust_coefficients_propeller

| Variable | Type | Constraint | Not Null |
| --- | --- | --- | --- |
| aircraft_id | TEXT |  | Yes |
| thrust_rating | TEXT |  | Yes |
| efficiency | REAL | 0.000001 &#8804; efficiency &#8804; 1.000000 | Yes |
| propulsive_power | REAL |  | Yes |

Primary Key: aircraft_id, thrust_rating

| Foreign Key | From Table |
| --- | --- |
| aircraft_id, thrust_rating | doc29_performance_thrust_ratings |

### doc29_performance_aerodynamic_coefficients

| Variable | Type | Constraint | Not Null |
| --- | --- | --- | --- |
| aircraft_id | TEXT |  | Yes |
| flap_id | TEXT |  | Yes |
| type | TEXT | 'Takeoff', 'Land', 'Cruise' | Yes |
| r | REAL |  | Yes |
| b | REAL |  | No |
| c | REAL |  | No |
| d | REAL |  | No |

Primary Key: aircraft_id, flap_id

| Foreign Key | From Table |
| --- | --- |
| aircraft_id | doc29_aircrafts |

### doc29_performance_profiles

| Variable | Type | Constraint | Not Null |
| --- | --- | --- | --- |
| aircraft_id | TEXT |  | Yes |
| operation | TEXT | 'Arrival', 'Departure' | Yes |
| id | TEXT |  | Yes |
| type | TEXT | 'Points', 'Procedural' | Yes |

Primary Key: aircraft_id, operation, id

| Foreign Key | From Table |
| --- | --- |
| aircraft_id | doc29_aircrafts |

### doc29_performance_profiles_points

| Variable | Type | Constraint | Not Null |
| --- | --- | --- | --- |
| aircraft_id | TEXT |  | Yes |
| operation | TEXT | 'Arrival', 'Departure' | Yes |
| profile_id | TEXT |  | Yes |
| cumulative_ground_Distance | REAL |  | Yes |
| altitude_afe | REAL |  | Yes |
| true_airspeed | REAL |  | Yes |
| thrust | REAL |  | Yes |

Primary Key: aircraft_id, operation, profile_id, cumulative_ground_Distance

| Foreign Key | From Table |
| --- | --- |
| aircraft_id, operation, profile_id | doc29_performance_profiles |

### doc29_performance_profiles_arrival_procedural

| Variable | Type | Constraint | Not Null |
| --- | --- | --- | --- |
| aircraft_id | TEXT |  | Yes |
| operation | TEXT | 'Arrival' | Yes |
| profile_id | TEXT |  | Yes |
| step_number | INTEGER |  | Yes |
| step_type | TEXT | 'Arrival Start', 'Descend', 'Descend Decelerate', 'Descend Idle', 'Level', 'Level Decelerate', 'Level Idle', 'Descend Land', 'Ground Decelerate' | Yes |
| flap_id | TEXT |  | No |
| parameter_1 | REAL |  | No |
| parameter_2 | REAL |  | No |
| parameter_3 | REAL |  | No |

Primary Key: aircraft_id, operation, profile_id, step_number

| Foreign Key | From Table |
| --- | --- |
| aircraft_id, operation, profile_id | doc29_performance_profiles |
| aircraft_id, flap_id | doc29_performance_aerodynamic_coefficients |

### doc29_performance_profiles_departure_procedural

| Variable | Type | Constraint | Not Null |
| --- | --- | --- | --- |
| aircraft_id | TEXT |  | Yes |
| operation | TEXT | 'Departure' | Yes |
| profile_id | TEXT |  | Yes |
| step_number | INTEGER |  | Yes |
| step_type | TEXT | 'Takeoff', 'Climb', 'Climb Accelerate', 'Climb Accelerate Percentage' | Yes |
| thrust_cutback | INTEGER | '0', '1' | Yes |
| flap_id | TEXT |  | No |
| parameter_1 | REAL |  | No |
| parameter_2 | REAL |  | No |
| parameter_3 | REAL |  | No |

Primary Key: aircraft_id, operation, profile_id, step_number

| Foreign Key | From Table |
| --- | --- |
| aircraft_id, operation, profile_id | doc29_performance_profiles |
| aircraft_id, flap_id | doc29_performance_aerodynamic_coefficients |

# 3. doc29_noise

This section contains the data needed to apply the noise model described in the Doc.29 to the output of the performance models. It is in structure very similar to the ANP database which accompanies Doc.29. However, the noise data in GRAPE is completely decoupled from the performance data. This means that the data defined in the [doc29_performance](#doc29_performance) section has no influence on the calculations done by the Doc.29 noise model. Furthermore, each noise entry is given its own spectrum, instead of a spectral class as its done in the ANP database.

## Tables

### doc29_noise

| Variable | Type | Constraint | Not Null |
| --- | --- | --- | --- |
| id | TEXT |  | Yes |
| lateral_directivity | TEXT | 'Wing', 'Fuselage', 'Propeller' | Yes |
| start_of_roll_correction | TEXT | 'None', 'Jet', 'Turboprop' | Yes |

Primary Key: id

### doc29_noise_spectrum

| Variable | Type | Constraint | Not Null |
| --- | --- | --- | --- |
| noise_id | TEXT |  | Yes |
| operation | TEXT | 'Arrival', 'Departure' | Yes |
| l_50_hz | REAL |  | Yes |
| l_63_hz | REAL |  | Yes |
| l_80_hz | REAL |  | Yes |
| l_100_hz | REAL |  | Yes |
| l_125_hz | REAL |  | Yes |
| l_160_hz | REAL |  | Yes |
| l_200_hz | REAL |  | Yes |
| l_250_hz | REAL |  | Yes |
| l_315_hz | REAL |  | Yes |
| l_400_hz | REAL |  | Yes |
| l_500_hz | REAL |  | Yes |
| l_630_hz | REAL |  | Yes |
| l_800_hz | REAL |  | Yes |
| l_1000_hz | REAL |  | Yes |
| l_1250_hz | REAL |  | Yes |
| l_1600_hz | REAL |  | Yes |
| l_2000_hz | REAL |  | Yes |
| l_2500_hz | REAL |  | Yes |
| l_3150_hz | REAL |  | Yes |
| l_4000_hz | REAL |  | Yes |
| l_5000_hz | REAL |  | Yes |
| l_6300_hz | REAL |  | Yes |
| l_8000_hz | REAL |  | Yes |
| l_10000_hz | REAL |  | Yes |

Primary Key: noise_id, operation

| Foreign Key | From Table |
| --- | --- |
| noise_id | doc29_noise |

### doc29_noise_npd_data

| Variable | Type | Constraint | Not Null |
| --- | --- | --- | --- |
| noise_id | TEXT |  | Yes |
| operation | TEXT | 'Arrival', 'Departure' | Yes |
| noise_metric | TEXT | 'LAMAX', 'SEL' | Yes |
| thrust | REAL |  | Yes |
| l_200_ft | REAL |  | Yes |
| l_400_ft | REAL |  | Yes |
| l_630_ft | REAL |  | Yes |
| l_1000_ft | REAL |  | Yes |
| l_2000_ft | REAL |  | Yes |
| l_4000_ft | REAL |  | Yes |
| l_6300_ft | REAL |  | Yes |
| l_10000_ft | REAL |  | Yes |
| l_16000_ft | REAL |  | Yes |
| l_25000_ft | REAL |  | Yes |

Primary Key: noise_id, operation, noise_metric, thrust

| Foreign Key | From Table |
| --- | --- |
| noise_id | doc29_noise |

# 4. lto_fuel

## Tables

# 5. sfi_fuel

## Tables

# 6. fleet

This section comprises of a single table. Its purpose is to glue the different databases supporting the different models into a single id. The collection of these ids defines the fleet of a GRAPE study. An operation, defined as either a flight or a track 4D, must be given a fleet id. Based on the associations defined in this table, the different models can be applied to an operation with a given fleet id.

## Tables

### fleet

| Variable | Type | Constraint | Not Null |
| --- | --- | --- | --- |
| id | TEXT |  | Yes |
| doc29_aircraft_id | TEXT |  | No |
| doc29_noise_id | TEXT |  | No |

Primary Key: id

| Foreign Key | From Table |
| --- | --- |
| doc29_aircraft_id | doc29_aircrafts |
| doc29_noise_id | doc29_noise |

# 7. operations_flights

A flight operation is one of the main types of operations in GRAPE. To define such an operation, three things are needed:

- a route from the [airports](#airports_ID) section. This will define the sequence of longitude latitude points of this operation.
- an id from the [fleet](#fleet_ID) section. With it, the different models can be applied.
- the operation weight. Performance models can take the weight of the aircraft into account for calculating the vertical profile.

For arrival or departure flight operations, a Doc.29 arrival or departure profile must be specified in order to use the Doc.29 performance model. The profile must belong to the Doc.29 aircraft associated with the fleet id. Additionally, for departure flights, the thrust percentage can be specified which accounts for thrust reduction during takeoff. Performance models can take this percentage into account when calculating the vertical profile of the flight.

## Tables

### operations_flights

| Variable | Type | Constraint | Not Null |
| --- | --- | --- | --- |
| id | TEXT |  | Yes |
| airport_id | TEXT |  | Yes |
| runway_id | TEXT |  | Yes |
| operation | TEXT |  | Yes |
| route_id | TEXT |  | Yes |
| fleet_id | TEXT |  | Yes |
| weight | REAL |  | Yes |

Primary Key: id, operation

| Foreign Key | From Table |
| --- | --- |
| airport_id, runway_id, operation, route_id | airports_routes |
| fleet_id | fleet |

### operations_flights_arrival

| Variable | Type | Constraint | Not Null |
| --- | --- | --- | --- |
| operation_id | TEXT |  | Yes |
| operation | TEXT |  | Yes |
| doc29_profile | TEXT |  | No |

Primary Key: operation_id, operation

| Foreign Key | From Table |
| --- | --- |
| operation_id, operation | operations_flights |

### operations_flights_departure

| Variable | Type | Constraint | Not Null |
| --- | --- | --- | --- |
| operation_id | TEXT |  | Yes |
| operation | TEXT |  | Yes |
| doc29_profile | TEXT |  | No |
| thrust_percentage | REAL | 0.500000 &#8804; thrust_percentage &#8804; 1.000000 | No |

Primary Key: operation_id, operation

| Foreign Key | From Table |
| --- | --- |
| operation_id, operation | operations_flights |

# 8. operations_tracks_4d

Four dimensional tracks is one of the main types of operations in GRAPE. Operations of this type do not need a performance model, as the full sequence of all the variables needed must be provided. However, a fleet id from the [fleet](#fleet_ID) section is still necessary in order to apply the noise and emissions models.

## Tables

### operations_tracks_4d

| Variable | Type | Constraint | Not Null |
| --- | --- | --- | --- |
| id | TEXT |  | Yes |
| operation | TEXT | 'Arrival', 'Departure' | Yes |
| fleet_id | TEXT |  | Yes |

Primary Key: id, operation

| Foreign Key | From Table |
| --- | --- |
| fleet_id | fleet |

### operations_tracks_4d_points

| Variable | Type | Constraint | Not Null |
| --- | --- | --- | --- |
| operation_id | TEXT |  | Yes |
| operation | TEXT | 'Arrival', 'Departure' | Yes |
| point_number | INTEGER |  | Yes |
| flight_phase | TEXT | 'Approach', 'Landing Roll', 'Takeoff Roll', 'Departure' | Yes |
| longitude | REAL | -180.000000 &#8804; longitude &#8804; 180.000000 | Yes |
| latitude | REAL | -90.000000 &#8804; latitude &#8804; 90.000000 | Yes |
| altitude_msl | REAL |  | Yes |
| true_airspeed | REAL |  | Yes |
| thrust | REAL |  | Yes |
| bank_angle | REAL | -90.000000 &#8804; bank_angle &#8804; 90.000000 | No |

Primary Key: operation_id, operation, point_number

| Foreign Key | From Table |
| --- | --- |
| operation_id, operation | operations_tracks_4d |

# 9. scenarios

A scenario in GRAPE is defined as a collection of operations. In this section, operations are gouped into scenarios, on which models can then be applied. There are no restrictions regarding the operations type, any mix and number of flight and track 4D operations, arrivals and departures is allowed.

## Tables

### scenarios

| Variable | Type | Constraint | Not Null |
| --- | --- | --- | --- |
| id | TEXT |  | Yes |

Primary Key: id

### scenarios_flights

| Variable | Type | Constraint | Not Null |
| --- | --- | --- | --- |
| scenario_id | TEXT |  | Yes |
| flight_id | TEXT |  | Yes |
| operation | TEXT |  | Yes |

Primary Key: scenario_id, flight_id, operation

| Foreign Key | From Table |
| --- | --- |
| scenario_id | scenarios |
| flight_id, operation | operations_flights |

### scenarios_tracks_4d

| Variable | Type | Constraint | Not Null |
| --- | --- | --- | --- |
| scenario_id | TEXT |  | Yes |
| track_4d_id | TEXT |  | Yes |
| operation | TEXT |  | Yes |

Primary Key: scenario_id, track_4d_id, operation

| Foreign Key | From Table |
| --- | --- |
| scenario_id | scenarios |
| track_4d_id, operation | operations_tracks_4d |

# 10. performance_run

In this section, the parameters of each performance run are specified. The same scenario can have any given number of performance runs, which can have different parameters such as atmospheric variables, performance model, ... .

## Tables

### performance_runs

| Variable | Type | Constraint | Not Null |
| --- | --- | --- | --- |
| scenario_id | TEXT |  | Yes |
| id | TEXT |  | Yes |
| coordinate_system_type | TEXT | 'Geodesic WGS84', 'Local Cartesian' | Yes |
| coordinate_system_longitude_0 | REAL | -180.000000 &#8804; coordinate_system_longitude_0 &#8804; 180.000000 | No |
| coordinate_system_latitude_0 | REAL | -90.000000 &#8804; coordinate_system_latitude_0 &#8804; 90.000000 | No |
| atmosphere_reference_altitude | REAL |  | No |
| atmosphere_reference_temperature | REAL |  | No |
| atmosphere_reference_pressure | REAL |  | No |
| atmosphere_headwind | REAL |  | No |
| performance_model | TEXT | 'Doc. 29' | Yes |
| performance_minimum_altitude | REAL |  | No |
| performance_maximum_altitude | REAL |  | No |
| performance_minimum_cumulative_ground_distance | REAL |  | No |
| performance_maximum_cumulative_ground_distance | REAL |  | No |
| performance_minimum_track_4d_points | INTEGER |  | No |
| performance_speed_delta_segmentation_threshold | REAL |  | No |
| performance_ground_distance_delta_filter_threshold | REAL |  | No |

Primary Key: scenario_id, id

| Foreign Key | From Table |
| --- | --- |
| scenario_id | scenarios |

### performance_run_output

| Variable | Type | Constraint | Not Null |
| --- | --- | --- | --- |
| scenario_id | TEXT |  | Yes |
| performance_run_id | TEXT |  | Yes |
| operation_id | TEXT |  | Yes |
| operation | TEXT | 'Arrival', 'Departure' | Yes |
| operation_type | TEXT | 'Flight', 'Track 4D' | Yes |

Primary Key: scenario_id, performance_run_id, operation_id, operation, operation_type

| Foreign Key | From Table |
| --- | --- |
| scenario_id, performance_run_id | performance_runs |

### performance_run_output_points

| Variable | Type | Constraint | Not Null |
| --- | --- | --- | --- |
| scenario_id | TEXT |  | Yes |
| performance_run_id | TEXT |  | Yes |
| operation_id | TEXT |  | Yes |
| operation | TEXT |  | Yes |
| operation_type | TEXT |  | Yes |
| point_number | INTEGER |  | Yes |
| point_origin | TEXT | 'Route', 'Profile', 'Route & Profile', 'Track 4D', 'Distance Segmentation', 'Speed Segmentation' | Yes |
| flight_phase | TEXT | 'Approach', 'Landing Roll', 'Takeoff Roll', 'Departure' | Yes |
| cumulative_ground_distance | REAL |  | Yes |
| longitude | REAL | -180.000000 &#8804; longitude &#8804; 180.000000 | Yes |
| latitude | REAL | -90.000000 &#8804; latitude &#8804; 90.000000 | Yes |
| altitude_msl | REAL |  | Yes |
| true_airspeed | REAL |  | Yes |
| ground_speed | REAL |  | Yes |
| thrust | REAL |  | Yes |
| bank_angle | REAL |  | Yes |

Primary Key: scenario_id, performance_run_id, operation_id, operation, operation_type, point_number

| Foreign Key | From Table |
| --- | --- |
| scenario_id, performance_run_id, operation_id, operation, operation_type | performance_run_output |

# 11. noise_run

After obtaining the performance results from a scenario with a performance run, noise can be calculated with a noise run. For coherency, the same models applied to the performance run, e.g. atmospheric model, will also be applied to the noise run. This section defines the further parameters needed for performing a noise run, for example the coordinates at which noise will be calculated. This list of locations can be specified in two ways:

- Points: A list of longitude latitude coordinates and their elevation.
- Grid: A two dimensonal grid of points defined by a location which can be set to any corner of the grid or its center, the spacing between points as well as the number of points in each dimension and an optional rotation.

## Tables

### noise_run

| Variable | Type | Constraint | Not Null |
| --- | --- | --- | --- |
| scenario_id | TEXT |  | Yes |
| performance_run_id | TEXT |  | Yes |
| id | TEXT |  | Yes |
| noise_model | TEXT | 'Doc. 29' | Yes |
| atmospheric_absorption | TEXT | 'None', 'SAE ARP 866', 'SAE ARP 5534' | Yes |
| relative_humidity | REAL | 0.000000 &#8804; relative_humidity &#8804; 1.000000 | No |
| receptor_set_type | TEXT | 'Grid', 'Points' | Yes |
| save_single_event_metrics | INTEGER | '0', '1' | Yes |

Primary Key: scenario_id, performance_run_id, id

| Foreign Key | From Table |
| --- | --- |
| scenario_id, performance_run_id | performance_runs |

### noise_run_receptor_grid

| Variable | Type | Constraint | Not Null |
| --- | --- | --- | --- |
| scenario_id | TEXT |  | Yes |
| performance_run_id | TEXT |  | Yes |
| noise_run_id | TEXT |  | Yes |
| reference_location | TEXT | 'Center', 'Bottom Left', 'Bottom Right', 'Top Left', 'Top Right' | Yes |
| reference_longitude | REAL | -180.000000 &#8804; reference_longitude &#8804; 180.000000 | Yes |
| reference_latitude | REAL | -90.000000 &#8804; reference_latitude &#8804; 90.000000 | Yes |
| reference_altitude_msl | REAL |  | Yes |
| horizontal_spacing | REAL |  | Yes |
| vertical_spacing | REAL |  | Yes |
| horizontal_count | INTEGER |  | Yes |
| vertical_count | INTEGER |  | Yes |
| rotation | REAL | -180.000000 &#8804; rotation &#8804; 180.000000 | Yes |

Primary Key: scenario_id, performance_run_id, noise_run_id

| Foreign Key | From Table |
| --- | --- |
| scenario_id, performance_run_id, noise_run_id | noise_run |

### noise_run_receptor_points

| Variable | Type | Constraint | Not Null |
| --- | --- | --- | --- |
| scenario_id | TEXT |  | Yes |
| performance_run_id | TEXT |  | Yes |
| noise_run_id | TEXT |  | Yes |
| name | TEXT |  | Yes |
| longitude | REAL | -180.000000 &#8804; longitude &#8804; 180.000000 | Yes |
| latitude | REAL | -90.000000 &#8804; latitude &#8804; 90.000000 | Yes |
| altitude_msl | REAL |  | Yes |

Primary Key: scenario_id, performance_run_id, noise_run_id, name

| Foreign Key | From Table |
| --- | --- |
| scenario_id, performance_run_id, noise_run_id | noise_run |

### noise_run_output_receptors

| Variable | Type | Constraint | Not Null |
| --- | --- | --- | --- |
| scenario_id | TEXT |  | Yes |
| performance_run_id | TEXT |  | Yes |
| noise_run_id | TEXT |  | Yes |
| id | TEXT |  | Yes |
| longitude | REAL |  | Yes |
| latitude | REAL |  | Yes |
| altitude_msl | REAL |  | Yes |

Primary Key: scenario_id, performance_run_id, noise_run_id, id

| Foreign Key | From Table |
| --- | --- |
| scenario_id, performance_run_id, noise_run_id | noise_run |

### noise_run_output_single_event

| Variable | Type | Constraint | Not Null |
| --- | --- | --- | --- |
| scenario_id | TEXT |  | Yes |
| performance_run_id | TEXT |  | Yes |
| noise_run_id | TEXT |  | Yes |
| receptor_id | TEXT |  | Yes |
| operation_id | TEXT |  | Yes |
| operation | TEXT |  | Yes |
| operation_type | TEXT |  | Yes |
| lamax | REAL |  | Yes |
| sel | REAL |  | Yes |

Primary Key: scenario_id, performance_run_id, noise_run_id, receptor_id, operation_id, operation, operation_type

| Foreign Key | From Table |
| --- | --- |
| scenario_id, performance_run_id, noise_run_id, receptor_id | noise_run_output_receptors |
| scenario_id, performance_run_id, operation_id, operation, operation_type | performance_run_output |

# 12. fuel_emissions_run

After obtaining the performance results from a scenario with a performance run, fuel and emissions can be calculated with a fuel and emisions run.
## Tables

