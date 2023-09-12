# performance_run

## performance_run

| Variable                                         | Type    | NOT NULL | Constraint                          |
|--------------------------------------------------|---------|:--------:|-------------------------------------|
| scenario_id                                      | TEXT    | &#10003; |                                     |
| id                                               | TEXT    | &#10003; |                                     |
| coordinate_system_type                           | TEXT    | &#10003; | `Geodesic WGS84`, `Local Cartesian` |
| coordinate_system_longitude_0                    | REAL    |          | -180 &#8804; x &#8804; 180          |
| coordinate_system_latitude_0                     | REAL    |          | -90 &#8804; x &#8804; 90            |
| filter_minimum_altitude                          | REAL    |          |                                     |
| filter_maximum_altitude                          | REAL    |          |                                     |
| filter_minimum_cumulative_ground_distance        | REAL    |          |                                     |
| filter_maximum_cumulative_ground_distance        | REAL    |          |                                     |
| filter_ground_distance_threshold                 | REAL    |          | &#8805; 0                           |
| segmentation_speed_delta_threshold               | REAL    |          | > 0                                 |
| flights_performance_model                        | TEXT    | &#10003; | `Doc29`                             |
| flights_doc29_low_altitude_segmentation          | INTEGER |          | `0`, `1`                            |
| tracks_4d_minimum_points                         | INTEGER |          | &#8805; 0                           |
| tracks_4d_recalculate_cumulative_ground_distance | INTEGER |          | `0`, `1`                            |
| tracks_4d_recalculate_groundspeed                | INTEGER |          | `0`, `1`                            |
| tracks_4d_recalculate_fuel_flow                  | INTEGER |          | `0`, `1`                            |
| fuel_flow_model                                  | TEXT    | &#10003; | `None`, `LTO`, `SFI`                |

| Table Constraint | Details                                              |
|------------------|------------------------------------------------------|
| PRIMARY KEY      | scenario_id, id                                      |
| FOREIGN KEY      | scenario_id from [scenarios](scenarios.md#scenarios) |

## performance_run_atmospheres

| Variable           | Type | NOT NULL | Constraint                     |
|--------------------|------|:--------:|--------------------------------|
| scenario_id        | TEXT | &#10003; |                                |
| performance_run_id | TEXT | &#10003; |                                |
| time               | TEXT | &#10003; | yyyy-mm-dd HH:MM:SS            |
| temperature_delta  | REAL | &#10003; | -100 &#8804; x &#8804; 100     |
| pressure_delta     | REAL | &#10003; | -15000 &#8804; x &#8804; 15000 |
| wind_speed         | REAL | &#10003; |                                |
| wind_direction     | REAL |          | 0 &#8804; x &#8804; 360        |
| relative_humidity  | REAL | &#10003; | 0 &#8804; x &#8804; 1          |

| Table Constraint | Details                                                                  |
|------------------|--------------------------------------------------------------------------|
| PRIMARY KEY      | scenario_id, performance_run_id, time                                    |
| FOREIGN KEY      | scenario_id, performance_run_id from [performance_run](#performance_run) |

???+ info
    If the wind direction is empty, GRAPE will interpret the wind speed as being a constant headwind.

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

| Variable                        | Type    | NOT NULL | Constraint                                                           |
|---------------------------------|---------|:--------:|----------------------------------------------------------------------|
| scenario_id                     | TEXT    | &#10003; |                                                                      |
| performance_run_id              | TEXT    | &#10003; |                                                                      |
| operation_id                    | TEXT    | &#10003; |                                                                      |
| operation                       | TEXT    | &#10003; |                                                                      |
| operation_type                  | TEXT    | &#10003; |                                                                      |
| point_number                    | INTEGER | &#10003; |                                                                      |
| point_origin                    | TEXT    | &#10003; | `Route`, `Profile`, `Route & Profile`, `Track 4D`, `Speed Segmentation`, `Doc29 Takeoff Roll Segmentation`, `Doc29 Final Approach Segmentation`, `Doc29 Initial Climb Segmentation` |
| flight_phase                    | TEXT    | &#10003; | `Approach`, `Landing Roll`, `Takeoff Roll`, `Initial Climb`, `Climb` |
| cumulative_ground_distance      | REAL    | &#10003; |                                                                      |
| longitude                       | REAL    | &#10003; |                                                                      |
| latitude                        | REAL    | &#10003; |                                                                      |
| altitude_msl                    | REAL    | &#10003; |                                                                      |
| true_airspeed                   | REAL    | &#10003; |                                                                      |
| ground_speed                    | REAL    | &#10003; |                                                                      |
| corrected_net_thrust_per_engine | REAL    | &#10003; |                                                                      |
| bank_angle                      | REAL    | &#10003; |                                                                      |
| fuel_flow_per_engine            | REAL    | &#10003; |                                                                      |

| Table Constraint | Details                                                                                |
|------------------|----------------------------------------------------------------------------------------|
| PRIMARY KEY      | scenario_id, performance_run_id, operation_id, operation, operation_type, point_number |
| FOREIGN KEY      | scenario_id, performance_run_id, operation_id, operation, operation_type from [performance_run_output](#performance_run_output) |
