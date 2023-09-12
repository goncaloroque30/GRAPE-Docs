# scenarios

## scenarios

| Variable | Type | NOT NULL | Constraint |
|----------|------|:--------:|------------|
| id       | TEXT | &#10003; |            |

| Table Constraint | Details |
|------------------|---------|
| PRIMARY KEY      | id      |

## scenarios_flights

| Variable          | Type | NOT NULL | Constraint |
|-------------------|------|:--------:|------------|
| scenario_id       | TEXT | &#10003; |            |
| operation_id      | TEXT | &#10003; |            |
| operation         | TEXT | &#10003; |            |

| Table Constraint | Details                                                                             |
|------------------|-------------------------------------------------------------------------------------|
| PRIMARY KEY      | scenario_id, operation_id, operation                                                |
| FOREIGN KEY      | scenario_id from [scenarios](#scenarios)                                            |
| FOREIGN KEY      | operation_id, operation from [operations_flights](operations.md#operations_flights) |

### scenarios_tracks_4d

| Variable          | Type | NOT NULL | Constraint |
|-------------------|------|:--------:|------------|
| scenario_id       | TEXT | &#10003; |            |
| operation_id      | TEXT | &#10003; |            |
| operation         | TEXT | &#10003; |            |

| Table Constraint | Details                                                                                 |
|------------------|-----------------------------------------------------------------------------------------|
| PRIMARY KEY      | scenario_id, operation_id, operation                                                    |
| FOREIGN KEY      | scenario_id from [scenarios](#scenarios)                                                |
| FOREIGN KEY      | operation_id, operation from [operations_tracks_4d](operations.md#operations_tracks_4d) |
