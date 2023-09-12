# doc29_performance

## doc29_performance

| Variable | Type | NOT NULL | Constraint                   |
|----------|------|:--------:|------------------------------|
| id       | TEXT | &#10003; |                              |
| type     | TEXT | &#10003; | `Jet`, `Turboprop`, `Piston` |

| Table Constraint | Details |
|------------------|---------|
| PRIMARY KEY      | id		 |

## doc29_performance_aerodynamic_coefficients

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

## doc29_performance_thrust

| Variable       | Type | NOT NULL | Constraint                           |
|----------------|------|:--------:|--------------------------------------|
| performance_id | TEXT | &#10003; |                                      |
| type           | TEXT | &#10003; | `None`, `Rating`, `Rating Propeller` |

| Table Constraint | Details                                                     |
|------------------|-------------------------------------------------------------|
| PRIMARY KEY      | performance_id                                              |
| FOREIGN KEY      | performance_id from [doc29_performance](#doc29_performance) |

## doc29_performance_thrust_ratings

| Variable       | Type | NOT NULL | Constraint |
|----------------|------|:--------:|------------|
| performance_id | TEXT | &#10003; |            |
| thrust_rating  | TEXT | &#10003; | `Maximum Takeoff`, `Maximum Climb`, `Idle`, `Maximum Takeoff High Temperature`, `Maximum Climb High Temperature`, `Idle High Temperature` |

| Table Constraint | Details                                                                   |
|------------------|---------------------------------------------------------------------------|
| PRIMARY KEY      | performance_id, thrust_rating                                             |
| FOREIGN KEY      | performance_id from [doc29_performance_thrust](#doc29_performance_thrust) |

## doc29_performance_thrust_rating_coefficients

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

## doc29_performance_thrust_rating_coefficients_propeller

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

## doc29_performance_profiles

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

## doc29_performance_profiles_points

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

## doc29_performance_profiles_arrival_procedural

Each step in the arrival procedural profiles table is defined by a flap setting and three parameters. The following table defines the three parameters for each step type:

| Step Type          | Parameter 1             | Parameter 2               | Parameter 3               |
|--------------------|-------------------------|---------------------------|---------------------------|
| Descend Decelerate | Start Altitude ATE      | Descent Angle             | Start Calibrated Airspeed |
| Descend Idle       | Start Altitude ATE      | Descent Angle             | Start Calibrated Airspeed |
| Level              | Ground Distance         |                           |                           |
| Level Decelerate   | Ground Distance         | Start Calibrated Airspeed |                           |
| Level Idle         | Ground Distance         | Start Calibrated Airspeed |                           |
| Descend Land       | Descent Angle           | Threshold Crossing Height |                           |
| Ground Decelerate  | Ground Distance         | Start Calibrated Airspeed | Thrust Percentage         |

??? info
Altitudes are given above threshold elevation. The term above threshold elevation is used to indicate that the profiles are aligned to the runway threshold elevation, not the airport elevation. Therefore, altitude above mean sea level (MSL) is calculated by adding the threshold elevation to the altitudes ATE.

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

| Table Constraint | Details                                                                                                        |
|------------------|----------------------------------------------------------------------------------------------------------------|
| PRIMARY KEY      | performance_id, operation, id, profile_id, step_number                                                         |
| FOREIGN KEY      | performance_id, operation, profile_id from [doc29_performance_profiles](#doc29_performance_profiles)           |
| FOREIGN KEY      | performance_id, flap_id from [doc29_performance_aerodynamic_coefficients](#doc29_performance_aerodynamic_coefficients) |
| CHECK            | case step_type `Descend Decelerate` - flap_id NOT NULL, parameter_1 NOT NULL, parameter_2 &#8804; 0, parameter_3 > 0 |
| CHECK            | case step_type `Descend Idle` - flap_id NOT NULL, parameter_1 NOT NULL, parameter_2 < 0, parameter3 &#8805; 0  |
| CHECK            | case step_type `Level` - flap_id NOT NULL, parameter_1 > 0                                                     |
| CHECK            | case step_type `Level Decelerate` - flap_id NOT NULL, parameter_1 > 0, parameter_2 > 0                         |
| CHECK            | case step_type `Level Idle` - flap_id NOT NULL, parameter_1 > 0, parameter 2 &#8805; 0                         |
| CHECK            | case step_type `Descend Land` - flap_id NOT NULL, parameter_1 &#8804; 0, parameter_2 NOT NULL, parameter_3 > 0 |
| CHECK            | case step_type `Ground Decelerate` - parameter_1 &#8805; 0, parameter_2 &#8805; 0, 0 &#8804; parameter_3 &#8804; 1 |

### doc29_performance_profiles_departure_procedural

In a departure procedural profile, each step is defined by a thrust cutback flag indicating if the thrust cutback occurs at this step, a mandatory flap setting and three parameters. The following table defines the three parameters for each step type:

| Step Type                   | Parameter 1                 | Parameter 2             | Parameter 3    |
| --------------------------- | --------------------------- | ----------------------- | -------------- |
| Takeoff                     | Initial Calibrated Airspeed |                         |                |
| Climb                       | End Altitude ATE            |                         |                |
| Climb Accelerate            | End Altitude ATE            | End Calibrated Airspeed | Climb Rate     |
| Climb Accelerate Percentage | End Altitude ATE            | End Calibrated Airspeed | Acceleration % |

??? info
Altitudes are given above threshold elevation. The term above threshold elevation is used to indicate that the profiles are aligned to the runway threshold elevation, not the airport elevation. Therefore, altitude above mean sea level (MSL) is calculated by adding the threshold elevation to the altitudes ATE.

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
| CHECK            | case step_type `Climb Accelerate Percentage` - parameter_1 > 0, 0 < parameter_3 &#8804; 1            |
