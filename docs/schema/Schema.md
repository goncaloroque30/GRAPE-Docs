# Intro
GRAPE uses [SQLite](https://www.sqlite.org/) as an application file format (.grp). A basic understanding of SQL is needed in order to understand the GRAPE schema documented in this file. It should be used as a reference to create '.grp' files using third party tools or scripts and to obtain the raw output data of GRAPE for further processing. The same file is used to store user inputs as well as application outputs.

All data is stored in SI units, angles are stored in degrees and percentages stored as a real number (1 correspond to 100%). For conversions to other units please see the [conversion table](/docs/ConversionTable.md). In the vertical plane, positive angles or gradients always indicate a climb and negative angles or gradients indicate a descent. For convenience, the tables in the GRAPE schema are organized into [sections](##sections). Each section has a specific function in GRAPE. The name of every table in the schema begins with the section name.

For every table, a documentation of its variables, primary key and foreign keys is given. The foreign key is specified by giving the table variables which are part of the foreign key and the foreign table. In GRAPE, the unique index of the foreign table is always its primary key. For example, the table *airport_routes* has the variables *airport_id* and *runway_id* as foreign key from the table *airport_runways*. This means that for every entry in the *airport_routes* table, the pair of values *airport_id*, *runway_id* must be found in the table *airports_runways* as a primary key, meaning its variables *airport_id*, *id*.

All tables which are filled by GRAPE after calculating results have the word *output* in their name. This tables are intended to be read from, but should not be directly edited. The input and output tables are defined in the same schema and file so that a GRAPE study can be entirely contained in a single '.grp' file.

## Sections

[airports](#airports)
[doc29_performance](#doc29_performance)
[doc29_noise](#doc29_noise)
[fleet](#fleet)
[fuel_emissions_run](#fuel_emissions_run)
[lto_fuel](#lto_fuel)
[noise_run](#noise_run)
[operations_flights](#operations_flights)
[operations_tracks_4d](#operations_tracks_4d)
[performance_run](#performance_run)
[scenarios](#scenarios)
[sfi_fuel](#sfi_fuel)

# airports

A flight operation ground path, meaning the sequence of longitude latitude points covered by each flight, is calculated by GRAPE based on a route. This section provides the route definitions and groups them into airports and runways. A route always belongs to a runway, and a runways always belongs to an airport.
 
# doc29_performance

This section contains the data needed to apply the performance model described in the Doc29 to a flight operation. It is in structure very similar to the ANP database which accompanies Doc29. The major diference lies in the aircraft definition and in the definition of arrival and departure procedural profiles. An aircraft in GRAPE only has the absolute necessary variables to apply the performance model. Procedural profiles are defined by a sequence of steps, which coupled with a performance model fully define the vertical profile of a flight (sequence of cumulative ground distances, altitudes, ground speeds and thrust values). The data in this section is grouped into Doc29 performance entries. A Doc29 performance can have an arbitrary number of arrival and departure profiles which can be defined with procedural steps or points. A performance ebtry has a set of engine coefficients and aerodynamic coefficients, which are used by the procedural profiles to calculate the vertical profile. Point profiles already define every variable needed and therefore do not require engine or aerodynamic coefficients for calculations.

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

Altitudes are given above threshold elevation. The term above threshold elevation is used to indicate that the profiles are aligned to the runway threshold elevation, not the airport elevation. Therefore, altitude above mean sea level (MSL) is calculated by adding the threshold elevation to the altitudes AFE. Speeds are given as calibrated airspeed, which allows to account for specific atmopsheric conditions. Besides the arrival start step, the information provided in each step is interpreted as 'go to' conditions. For example, a descend step has a certain flap setting, a descent angle and an altitude ATE. This means descend **TO** that altitude with that descent angle and the given flap settings.

The difference between the step types with and without 'Idle' at the end of the name lies solely with how the thrust is calculated. In steps withouth 'Idle', thrust is calculated with a force balance equation, which requires a flap setting in order to account for the drag component. In 'Idle' steps, idle thrust coefficients are used which must be present in the engine coefficients table. 'Idle' step types can only be used by aircraft with jet engines (as defined in the Doc29 aircrafts table).

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

# 3. doc29_noise

This section contains the data needed to apply the noise model described in the Doc29 to the output of the performance models. It is in structure very similar to the ANP database which accompanies Doc29. However, the noise data in GRAPE is completely decoupled from the performance data. This means that the data defined in the [doc29_performance](#doc29_performance) section has no influence on the calculations done by the Doc29 noise model. Furthermore, each noise entry is given its own spectrum, instead of a spectral class as its done in the ANP database.

# 4. lto_fuel

# 5. sfi_fuel

# 6. fleet

This section comprises of a single table. Its purpose is to glue the different databases supporting the different models into a single id. The collection of these ids defines the fleet of a GRAPE study. An operation, defined as either a flight or a track 4D, must be given a fleet id. Based on the associations defined in this table, the different models can be applied to an operation with a given fleet id.

# 7. operations_flights

A flight operation is one of the main types of operations in GRAPE. To define such an operation, three things are needed:

- a route from the [airports](#airports_ID) section. This will define the sequence of longitude latitude points of this operation.
- an id from the [fleet](#fleet_ID) section. With it, the different models can be applied.
- the operation weight. Performance models can take the weight of the aircraft into account for calculating the vertical profile.

For arrival or departure flight operations, a Doc29 arrival or departure profile must be specified in order to use the Doc29 performance model. The profile must belong to the Doc29 aircraft associated with the fleet id. Additionally, for departure flights, the thrust percentage can be specified which accounts for thrust reduction during takeoff. Performance models can take this percentage into account when calculating the vertical profile of the flight.

# 8. operations_tracks_4d

Four dimensional tracks is one of the main types of operations in GRAPE. Operations of this type do not need a performance model, as the full sequence of all the variables needed must be provided. However, a fleet id from the [fleet](#fleet_ID) section is still necessary in order to apply the noise and emissions models.

# 9. scenarios

A scenario in GRAPE is defined as a collection of operations. In this section, operations are gouped into scenarios, on which models can then be applied. There are no restrictions regarding the operations type, any mix and number of flight and track 4D operations, arrivals and departures is allowed.

# 10. performance_run

In this section, the parameters of each performance run are specified. The same scenario can have any given number of performance runs, which can have different parameters such as atmospheric variables, performance model, ... .

# 11. noise_run

After obtaining the performance results from a scenario with a performance run, noise can be calculated with a noise run. For coherency, the same models applied to the performance run, e.g. atmospheric model, will also be applied to the noise run. This section defines the further parameters needed for performing a noise run, for example the coordinates at which noise will be calculated. This list of locations can be specified in two ways:

- Points: A list of longitude latitude coordinates and their elevation.
- Grid: A two dimensonal grid of points defined by a location which can be set to any corner of the grid or its center, the spacing between points as well as the number of points in each dimension and an optional rotation.

# 12. fuel_emissions_run

After obtaining the performance results from a scenario with a performance run, fuel and emissions can be calculated with a fuel and emisions run.
