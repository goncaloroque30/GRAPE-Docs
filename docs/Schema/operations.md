# operations

## operations_flights

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

| Table Constraint | Details                                                                                        |
|------------------|------------------------------------------------------------------------------------------------|
| PRIMARY KEY      | id, operation                                                                                  |
| FOREIGN KEY      | airport_id, runway_id, operation, route_id from [airports_routes](airports.md#airports_routes) |
| FOREIGN KEY      | fleet_id from [fleet](fleet.md#fleet)                                                          |

## operations_flights_arrival

| Variable         | Type | NOT NULL | Constraint |
|------------------|------|:--------:|------------|
| operation_id     | TEXT | &#10003; |            |
| operation        | TEXT | &#10003; |            |
| doc29_profile_id | TEXT |          |            |

| Table Constraint | Details                                                                |
|------------------|------------------------------------------------------------------------|
| PRIMARY KEY      | operation_id, operation                                                |
| FOREIGN KEY      | operation_id, operation from [operations_flights](#operations_flights) |

## operations_flights_departure

| Variable                  | Type | NOT NULL | Constraint              |
|---------------------------|------|:--------:|-------------------------|
| operation_id              | TEXT | &#10003; |                         |
| operation                 | TEXT | &#10003; |                         |
| doc29_profile_id          | TEXT |          |                         |
| thrust_percentage_takeoff | REAL | &#10003; | 0.5 &#8804; x &#8804; 1 |
| thrust_percentage_climb   | REAL | &#10003; | 0.5 &#8804; x &#8804; 1 |

| Table Constraint | Details                                                                |
|------------------|------------------------------------------------------------------------|
| PRIMARY KEY      | operation_id, operation                                                |
| FOREIGN KEY      | operation_id, operation from [operations_flights](#operations_flights) |

## operations_tracks_4d

| Variable  | Type | NOT NULL | Constraint             |
|-----------|------|:--------:|------------------------|
| id        | TEXT | &#10003; |                        |
| operation | TEXT | &#10003; | `Arrival`, `Departure` |
| time      | TEXT | &#10003; | yyyy-mm-dd HH:MM:SS    |
| count     | REAL | &#10003; | &#8805; 0              |
| fleet_id  | TEXT | &#10003; |                        |

| Table Constraint | Details                               |
|------------------|---------------------------------------|
| PRIMARY KEY      | id, operation                         |
| FOREIGN KEY      | fleet_id from [fleet](fleet.md#fleet) |

## operations_tracks_4d_points

| Variable                        | Type    | NOT NULL | Constraint                                                           |
|---------------------------------|---------|:--------:|----------------------------------------------------------------------|
| operation_id                    | TEXT    | &#10003; |                                                                      |
| operation                       | TEXT    | &#10003; | `Arrival`, `Departure`                                               |
| point_number                    | INTEGER | &#10003; | &#8805; 1                                                            |
| flight_phase                    | TEXT    | &#10003; | `Approach`, `Landing Roll`, `Takeoff Roll`, `Initial Climb`, `Climb` |
| cumulative_ground_distance      | REAL    | &#10003; |                                                                      |
| longitude                       | REAL    | &#10003; | -180 &#8804; x &#8804; 180                                           |
| latitude                        | REAL    | &#10003; | -90 &#8804; x &#8804; 90                                             |
| altitude_msl                    | REAL    | &#10003; |                                                                      |
| true_airspeed                   | REAL    | &#10003; | &#8805; 0                                                            |
| groundspeed                     | REAL    | &#10003; | &#8805; 0                                                            |
| corrected_net_thrust_per_engine | REAL    | &#10003; |                                                                      |
| bank_angle                      | REAL    | &#10003; | -90 &#8804; x &#8804; 90                                             |
| fuel_flow_per_engine            | REAL    | &#10003; | &#8805; 0                                                            |

| Table Constraint | Details                                                                   |
|------------------|---------------------------------------------------------------------------|
| PRIMARY KEY      | operation_id, operation, point_number                                     |
| FOREIGN KEY      | operation_id, operation from [operation_tracks_4d](#operations_tracks_4d) |
