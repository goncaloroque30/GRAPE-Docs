# airports

## airports

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

## airports_runways

| Variable  | NOT NULL | Constraint                 |
|-----------|:--------:|----------------------------|
| airport_id | &#10003; |                            |
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

## airports_routes

| Variable  | Type | NOT NULL | Constraint                 |
|-----------|------|:--------:|----------------------------|
| airport_id | TEXT | &#10003; |                            |
| runway_id | TEXT | &#10003; |                            |
| operation | TEXT | &#10003; | `Arrival`, `Departure`     |
| id        | TEXT | &#10003; |                            |
| type      | TEXT | &#10003; | `Simple`, `Vectors`, `Rnp` |

| Table Constraint | Details                                                          |
|------------------|------------------------------------------------------------------|
| PRIMARY KEY      | airport_id, runway id, operation, id                             |
| FOREIGN KEY      | airport_id, runway_id from [airports_runways](#airports_runways) |

## airports_routes_simple

| Variable     | Type    | NOT NULL | Constraint                 |
|--------------|---------|:--------:|----------------------------|
| airport_id    | TEXT    | &#10003; |                            |
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

## airports_routes_vectors

| Variable    | Type    | NOT NULL | Constraint               |
|-------------|---------|:--------:|--------------------------|
| airport_id   | TEXT    | &#10003; |                          |
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

## airports_routes_rnp

| Variable         | Type    | NOT NULL | Constraint                      |
|------------------|---------|:--------:|---------------------------------|
| airport_id        | TEXT    | &#10003; |                                 |
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
  