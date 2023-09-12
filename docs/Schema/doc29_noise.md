# doc29_noise

## doc29_noise

| Variable                 | Type | NOT NULL | Constraint                      |
|--------------------------|------|:--------:|---------------------------------|
| id                       | TEXT | &#10003; |                                 |
| lateral_directivity      | TEXT | &#10003; | `Wing`, `Fuselage`, `Propeller` |
| start_of_roll_correction | TEXT | &#10003; | `None`, `Jet`, `Turboprop`      |

| Table Constraint | Details |
|------------------|---------|
| PRIMARY KEY      | id		 |

## doc29_noise_npd_data

| Variable     | Type | NOT NULL | Constraint             |
|--------------|------|:--------:|------------------------|
| noise_id     | TEXT | &#10003; |                        |
| operation    | TEXT | &#10003; | `Arrival`, `Departure` |
| noise_metric | TEXT | &#10003; | `LAMAX`, `SEL`         |
| thrust       | REAL | &#10003; |                        |
| l_200_ft     | REAL | &#10003; |                        |
| l_400_ft     | REAL | &#10003; |                        |
| l_630_ft     | REAL | &#10003; |                        |
| l_1000_ft    | REAL | &#10003; |                        |
| l_2000_ft    | REAL | &#10003; |                        |
| l_4000_ft    | REAL | &#10003; |                        |
| l_6300_ft    | REAL | &#10003; |                        |
| l_10000_ft   | REAL | &#10003; |                        |
| l_16000_ft   | REAL | &#10003; |                        |
| l_25000_ft   | REAL | &#10003; |                        |

| Table Constraint | Details                                   |
|------------------|-------------------------------------------|
| PRIMARY KEY      | noise_id, operation, noise_metric, thrust |
| FOREIGN KEY      | noise_id from [doc29_noise](#doc29_noise) |

## doc29_noise_spectrum

| Variable   | Type | NOT NULL | Constraint             |
|------------|------|:--------:|------------------------|
| noise_id   | TEXT | &#10003; |                        |
| operation  | TEXT | &#10003; | `Arrival`, `Departure` |
| l_50_hz    | REAL | &#10003; |                        |
| l_63_hz    | REAL | &#10003; |                        |
| l_80_hz    | REAL | &#10003; |                        |
| l_100_hz   | REAL | &#10003; |                        |
| l_125_hz   | REAL | &#10003; |                        |
| l_160_hz   | REAL | &#10003; |                        |
| l_200_hz   | REAL | &#10003; |                        |
| l_250_hz   | REAL | &#10003; |                        |
| l_315_hz   | REAL | &#10003; |                        |
| l_400_hz   | REAL | &#10003; |                        |
| l_500_hz   | REAL | &#10003; |                        |
| l_630_hz   | REAL | &#10003; |                        |
| l_800_hz   | REAL | &#10003; |                        |
| l_1000_hz  | REAL | &#10003; |                        |
| l_1250_hz  | REAL | &#10003; |                        |
| l_1600_hz  | REAL | &#10003; |                        |
| l_2000_hz  | REAL | &#10003; |                        |
| l_2500_hz  | REAL | &#10003; |                        |
| l_3150_hz  | REAL | &#10003; |                        |
| l_4000_hz  | REAL | &#10003; |                        |
| l_5000_hz  | REAL | &#10003; |                        |
| l_6300_hz  | REAL | &#10003; |                        |
| l_8000_hz  | REAL | &#10003; |                        |
| l_10000_hz | REAL | &#10003; |                        |

| Table Constraint | Details                                   |
|------------------|-------------------------------------------|
| PRIMARY KEY      | noise_id, operation                       |
| FOREIGN KEY      | noise_id from [doc29_noise](#doc29_noise) |