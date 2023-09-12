# emissions_run

## emissions_run

| Variable              | Type    | NOT NULL | Constraint                          |
|-----------------------|---------|:--------:|-------------------------------------|
| scenario_id           | TEXT    | &#10003; |                                     |
| performance_run_id    | TEXT    | &#10003; |                                     |
| id                    | TEXT    | &#10003; |                                     |
| emissions_model       | TEXT    | &#10003; | `None`, `Boeing Fuel Flow Method 2` |
| save_segment_results  | INTEGER | &#10003; | `0`, `1`                            |

| Table Constraint | Details                                                                                    |
|------------------|--------------------------------------------------------------------------------------------|
| PRIMARY KEY      | scenario_id, performance_run_id, id                                                        |
| FOREIGN KEY      | scenario_id, performance_run_id from [performance_run](performance_run.md#performance_run) |

### fuel_emissions_run_output

| Variable           | Type | NOT NULL | Constraint |
|--------------------|------|:--------:|------------|
| scenario_id        | TEXT | &#10003; |            |
| performance_run_id | TEXT | &#10003; |            |
| emissions_run_id   | TEXT | &#10003; |            |
| fuel               | REAL | &#10003; |            |
| hc                 | REAL | &#10003; |            |
| co                 | REAL | &#10003; |            |
| nox                | REAL | &#10003; |            |

| Table Constraint | Details                                                                                |
|------------------|----------------------------------------------------------------------------------------|
| PRIMARY KEY      | scenario_id, performance_run_id, emissions_run_id                                      |
| FOREIGN KEY      | scenario_id, performance_run_id, emissions_run_id from [emissions_run](#emissions_run) |

## emissions_run_output_operations

| Variable           | Type | NOT NULL | Constraint |
|--------------------|------|:--------:|------------|
| scenario_id        | TEXT | &#10003; |            |
| performance_run_id | TEXT | &#10003; |            |
| emissions_run_id   | TEXT | &#10003; |            |
| operation_id       | TEXT | &#10003; |            |
| operation          | TEXT | &#10003; |            |
| operation_type     | TEXT | &#10003; |            |
| fuel               | REAL | &#10003; |            |
| hc                 | REAL | &#10003; |            |
| co                 | REAL | &#10003; |            |
| nox                | REAL | &#10003; |            |

| Table Constraint | Details                                                                                              |
|------------------|------------------------------------------------------------------------------------------------------|
| PRIMARY KEY      | scenario_id, performance_run_id, emissions_run_id, operation_id, operation, operation_type           |
| FOREIGN KEY      | scenario_id, performance_run_id, emissions_run_id from [emissions_run_output](#emissions_run_output) |
| FOREIGN KEY      | scenario_id, performance_run_id, operation_id, operation, operation_type from [performance_run_output](performance_run.md#performance_run_output) |

## emissions_run_output_segments

| Variable           | Type    | NOT NULL | Constraint |
|--------------------|---------|:--------:|------------|
| scenario_id        | TEXT    | &#10003; |            |
| performance_run_id | TEXT    | &#10003; |            |
| emissions_run_id   | TEXT    | &#10003; |            |
| operation_id       | TEXT    | &#10003; |            |
| operation          | TEXT    | &#10003; |            |
| operation_type     | TEXT    | &#10003; |            |
| segment_number     | INTEGER | &#10003; |            |
| fuel               | REAL    | &#10003; |            |
| hc                 | REAL    | &#10003; |            |
| co                 | REAL    | &#10003; |            |
| nox                | REAL    | &#10003; |            |

| Table Constraint | Details                                                                                                    |
|------------------|------------------------------------------------------------------------------------------------------------|
| PRIMARY KEY      | scenario_id, performance_run_id, emissions_run_id, operation_id, operation, operation_type, segment_number |
| FOREIGN KEY      | scenario_id, performance_run_id, emissions_run_id, operation_id, operation, operation_type from [emissions_run_output_operation](#emissions_run_output_operations) |
