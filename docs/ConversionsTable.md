# Intro

GRAPE uses [SQLite](https://www.sqlite.org/) as an application file format (.grp). All user inputs can be automated by creating this file and inserting values into it. Further information can be found in the [schema documentation](/docs/Schema.md). All data in a '.grp' file is saved in [SI units](https://en.wikipedia.org/wiki/International_System_of_Units). This file provides the conversion tables used by GRAPE.

## Sections

- [Distance](#Distance)
- [Force](#Distance)
- [Pressure](#Pressure)
- [Temperature](#Temperature)
- [Time](#Time)
- [Weight](#Weight)
- [Volume](#Volume)

# Distance
SI Unit: m

| Unit | Conversion from SI |
| ---- | ------------------ |
| km   | km = m / 1000      |
| ft   | ft = m / 0.3048    |
| NM   | NM = m / 1852      |          
| mi   | mi = m / 1609.344  |     

# Force
SI Unit: N

| Unit | Conversion from SI           |
| ---- | ---------------------------- |
| lbf  | lbf = N x 2.204623 / 9.80665 |

# Pressure
SI Unit: Pa

| Unit | Conversion from SI        |
| ---- | ------------------------- |
| hPa  | hPa = Pa / 100            |
| inHg | inHg = Pa / 3386.39       |
| mmHg | mmHg = Pa / 133.322387415 |          
| bar  | bar = Pa / 100000         |

# Temperature
SI Unit: K

| Unit | Conversion from SI           |
| ---- | ---------------------------- |
| °C   | °C = K - 273.15              |
| °F   | °F = (K - 273.25) * 9/5 + 32 |

# Time
SI Unit: s

| Unit | Conversion from SI |
| ---- | ------------------ |
| min  | min = s / 60       |
| h    | h = s / 3600       |

# Weight
SI Unit: kg

| Unit | Conversion from SI |
| ---- | ------------------ |
| lb   | lb = kg x 2.204623 |
| t    | t = kg / 1000      |

# Volume
SI Unit: m^3^

| Unit   | Conversion from SI      |
| ------ | ----------------------- |
| US gal | US gal = m^3^ x 264.172 |
| qt     | qt = m^3^ x 1056.69     |