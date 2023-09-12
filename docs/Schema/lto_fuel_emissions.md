## lto_fuel_emissions

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
