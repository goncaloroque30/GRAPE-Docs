# fleet

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

| Table Constraint | Details                                                                               |
|------------------|---------------------------------------------------------------------------------------|
| PRIMARY KEY      | id                                                                                    |
| FOREIGN KEY      | doc29_performance_id from [doc29_performance](doc29_performance.md#doc29_performance) |
| FOREIGN KEY      | sfi_id from [sfi_fuel](sfi_fuel.md#sfi_fuel)                                          |
| FOREIGN KEY      | lto_engine_id from [lto_fuel_emissions](lto_fuel_emissions.md#lto_fuel_emissions)     |
| FOREIGN KEY      | doc29_noise_id from [doc29_noise](doc29_noise.md#doc29_noise)                         |
