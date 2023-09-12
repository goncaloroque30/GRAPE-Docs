# noise_run

## noise_run

| Variable                  | Type    | NOT NULL | Constraint                            |
|---------------------------|---------|:--------:|---------------------------------------|
| scenario_id               | TEXT    | &#10003; |                                       |
| performance_run_id        | TEXT    | &#10003; |                                       |
| id                        | TEXT    | &#10003; |                                       |
| noise_model               | TEXT    | &#10003; | `Doc29`                               |
| atmospheric_absorption    | TEXT    | &#10003; | `None`, `SAE ARP 866`, `SAE ARP 5534` |
| receptor_set_type         | TEXT    | &#10003; | `Grid`, `Points`                      |
| save_single_event_metrics | INTEGER | &#10003; | `0`, `1`                              |

| Table Constraint | Details                                                                                    |
|------------------|--------------------------------------------------------------------------------------------|
| PRIMARY KEY      | scenario_id, performance_run_id, id                                                        |
| FOREIGN KEY      | scenario_id, performance_run_id from [performance_run](performance_run.md#performance_run) |

## noise_run_cumulative_metrics

| Variable                     | Type | NOT NULL | Constraint          |
|------------------------------|------|:--------:|---------------------|
| scenario_id                  | TEXT | &#10003; |                     |
| performance_run_id           | TEXT | &#10003; |                     |
| noise_run_id                 | TEXT | &#10003; |                     |
| id                           | TEXT | &#10003; |                     |
| threshold_db                 | REAL | &#10003; | &#8805; 0           |
| averaging_time_constant_db   | REAL | &#10003; | &#8805; 0           |
| start_time_point             | TEXT | &#10003; | yyyy-mm-dd HH:MM:SS |
| end_time_point               | TEXT | &#10003; | yyyy-mm-dd HH:MM:SS |

| Table Constraint | Details                                                                    |
|------------------|----------------------------------------------------------------------------|
| PRIMARY KEY      | scenario_id, performance_run_id, noise_run_id, id                          |
| FOREIGN KEY      | scenario_id, performance_run_id, noise_run_id from [noise_run](#noise_run) |

## noise_run_cumulative_metrics_number_above_thresholds

| Variable                       | Type | NOT NULL | Constraint |
|--------------------------------|------|:--------:|------------|
| scenario_id                    | TEXT | &#10003; |            |
| performance_run_id             | TEXT | &#10003; |            |
| noise_run_id                   | TEXT | &#10003; |            |
| noise_run_cumulative_metric_id | TEXT | &#10003; |            |
| threshold                      | REAL | &#10003; | &#8805; 0  |

| Table Constraint | Details                                                                       |
|------------------|-------------------------------------------------------------------------------|
| PRIMARY KEY      | scenario_id, performance_run_id, noise_run_id, noise_run_cumulative_metric_id |
| FOREIGN KEY      | scenario_id, performance_run_id, noise_run_id, noise_run_cumulative_metric_id from [noise_run_cumulative_metrics](#noise_run_cumulative_metrics) |

## noise_run_cumulative_metrics_weights

| Variable                       | Type | NOT NULL | Constraint |
|--------------------------------|------|:--------:|------------|
| scenario_id                    | TEXT | &#10003; |            |
| performance_run_id             | TEXT | &#10003; |            |
| noise_run_id                   | TEXT | &#10003; |            |
| noise_run_cumulative_metric_id | TEXT | &#10003; |            |
| time_of_day                    | TEXT | &#10003; |            |
| weight                         | REAL | &#10003; |            |

| Table Constraint | Details                                                                       |
|------------------|-------------------------------------------------------------------------------|
| PRIMARY KEY      | scenario_id, performance_run_id, noise_run_id, noise_run_cumulative_metric_id |
| FOREIGN KEY      | scenario_id, performance_run_id, noise_run_id, noise_run_cumulative_metric_id from [noise_run_cumulative_metrics](#noise_run_cumulative_metrics) |

## noise_run_output_cumulative

| Variable                       | Type | NOT NULL | Constraint |
|--------------------------------|------|:--------:|------------|
| scenario_id                    | TEXT | &#10003; |            |
| performance_run_id             | TEXT | &#10003; |            |
| noise_run_id                   | TEXT | &#10003; |            |
| noise_run_cumulative_metric_id | TEXT | &#10003; |            |
| receptor_id                    | TEXT | &#10003; |            |
| count                          | REAL | &#10003; |            |
| maximum_absolute_db            | REAL | &#10003; |            |
| maximum_average_db             | REAL | &#10003; |            |
| exposure_db                    | REAL | &#10003; |            |

| Table Constraint | Details                                                                                    |
|------------------|--------------------------------------------------------------------------------------------|
| PRIMARY KEY      | scenario_id, performance_run_id, noise_run_id, noise_run_cumulative_metric_id, receptor_id |
| FOREIGN KEY      | scenario_id, performance_run_id, noise_run_id, noise_run_cumulative_metric_id from [noise_run_cumulative_metrics](#noise_run_cumulative_metrics) |
| FOREIGN KEY      | scenario_id, performance_run_id, noise_run_id, receptor_id from [noise_run_output_receptors](#noise_run_output_receptors) |

## noise_run_output_cumulative_number_above

| Variable                       | Type | NOT NULL | Constraint |
|--------------------------------|------|:--------:|------------|
| scenario_id                    | TEXT | &#10003; |            |
| performance_run_id             | TEXT | &#10003; |            |
| noise_run_id                   | TEXT | &#10003; |            |
| noise_run_cumulative_metric_id | TEXT | &#10003; |            |
| threshold_db                   | TEXT | &#10003; |            |
| receptor_id                    | TEXT | &#10003; |            |
| number_above                   | REAL | &#10003; |            |

| Table Constraint | Details                                                                                               |
|------------------|-------------------------------------------------------------------------------------------------------|
| PRIMARY KEY      | scenario_id, performance_run_id, noise_run_id, noise_run_cumulative_metric_id, threshold, receptor_id |
| FOREIGN KEY      | scenario_id, performance_run_id, noise_run_id, noise_run_cumulative_metric_id, threshold from [noise_run_cumulative_metrics_number_above_thresholds](#noise_run_cumulative_metrics_number_above_thresholds) |
| FOREIGN KEY      | scenario_id, performance_run_id, noise_run_id, receptor_id from [noise_run_output_receptors](#noise_run_output_receptors) |

## noise_run_output_receptors

| Variable           | Type | NOT NULL | Constraint |
|--------------------|------|:--------:|------------|
| scenario_id        | TEXT | &#10003; |            |
| performance_run_id | TEXT | &#10003; |            |
| noise_run_id       | TEXT | &#10003; |            |
| id                 | TEXT | &#10003; |            |
| longitude          | REAL | &#10003; |            |
| latitude           | REAL | &#10003; |            |
| altitude_msl       | REAL | &#10003; |            |

| Table Constraint | Details                                                                    |
|------------------|----------------------------------------------------------------------------|
| PRIMARY KEY      | scenario_id, performance_run_id, noise_run_id, _id                         |
| FOREIGN KEY      | scenario_id, performance_run_id, noise_run_id from [noise_run](#noise_run) |

## noise_run_output_single_event

| Variable           | Type | NOT NULL | Constraint |
|--------------------|------|:--------:|------------|
| scenario_id        | TEXT | &#10003; |            |
| performance_run_id | TEXT | &#10003; |            |
| noise_run_id       | TEXT | &#10003; |            |
| receptor_id        | TEXT | &#10003; |            |
| operation_id       | TEXT | &#10003; |            |
| operation          | TEXT | &#10003; |            |
| operation_type     | TEXT | &#10003; |            |
| maximum_db         | REAL | &#10003; |            |
| exposure_db        | REAL | &#10003; |            |

| Table Constraint | Details                                                                                             |
|------------------|-----------------------------------------------------------------------------------------------------|
| PRIMARY KEY      | scenario_id, performance_run_id, noise_run_id, receptor_id, operation_id, operation, operation_type |
| FOREIGN KEY      | scenario_id, performance_run_id, operation_id, operation, operation_type from [performance_run_output](performance_run.md#performance_run_output) |
| FOREIGN KEY      | scenario_id, performance_run_id, noise_run_id, receptor_id from [noise_run_output_receptors](#noise_run_output_receptors) |

## noise_run_receptor_grid

| Variable               | Type    | NOT NULL | Constraint                                                       |
|------------------------|---------|:--------:|------------------------------------------------------------------|
| scenario_id            | TEXT    | &#10003; |                                                                  |
| performance_run_id     | TEXT    | &#10003; |                                                                  |
| noise_run_id           | TEXT    | &#10003; |                                                                  |
| reference_location     | TEXT    | &#10003; | `Center`, `Bottom Left`, `Bottom Right`, `Top Left`, `Top Right` |
| reference_longitude    | REAL    | &#10003; | -180 &#8804; x &#8804; 180                                       |
| reference_latitude     | REAL    | &#10003; | -90 &#8804; x &#8804; 90                                         |
| reference_altitude_msl | REAL    | &#10003; |                                                                  |
| horizontal_spacing     | REAL    | &#10003; | > 0                                                              |
| vertical_spacing       | REAL    | &#10003; | > 0                                                              |
| horizontal_count       | INTEGER | &#10003; | &#8805; 1                                                        |
| vertical_count         | INTEGER | &#10003; | &#8805; 1                                                        |
| grid_rotation          | REAL    | &#10003; | -180 &#8804; x &#8804; 180                                       |

| Table Constraint | Details                                                                    |
|------------------|----------------------------------------------------------------------------|
| PRIMARY KEY      | scenario_id, performance_run_id, noise_run_id                              |
| FOREIGN KEY      | scenario_id, performance_run_id, noise_run_id from [noise_run](#noise_run) |

## noise_run_receptor_points

| Variable           | Type    | NOT NULL | Constraint                 |
|--------------------|---------|:--------:|----------------------------|
| scenario_id        | TEXT    | &#10003; |                            |
| performance_run_id | TEXT    | &#10003; |                            |
| noise_run_id       | TEXT    | &#10003; |                            |
| id                 | TEXT    | &#10003; |                            |
| longitude          | REAL    | &#10003; | -180 &#8804; x &#8804; 180 |
| latitude           | REAL    | &#10003; | -90 &#8804; x &#8804; 90   |
| altitude_msl       | REAL    | &#10003; |                            |

| Table Constraint | Details                                                                    |
|------------------|----------------------------------------------------------------------------|
| PRIMARY KEY      | scenario_id, performance_run_id, noise_run_id, id                          |
| FOREIGN KEY      | scenario_id, performance_run_id, noise_run_id from [noise_run](#noise_run) |
