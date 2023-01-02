# Datasets

Some of the models implemented in GRAPE require specific input data in order to be applied. While these models are normally associated with specific databases, GRAPE does not restrict any model to any specific database. Therefore the user is free to add any data to a study. This section describes the following datasets used by GRAPE to apply the different models and how they are structured:

- [Doc29](#doc29)
- [Landing and Takeoff (LTO) Cycle Data](#landing-and-takeoff-cycle-data)
- [Senzig Fleming Iovinelle Data](#senzig-fleming-iovinelle-data)

---

## Doc29

The [Doc29](https://ecac-ceac.org/documents/ecac-documents-and-international-agreements) provides comprehensive guidance for calculating aircraft noise around airports. The document contains a performance model, which can produce the vertical profile (a sequence of altitudes, true airspeeds and thrust values) along the ground track given a certain input. It also contains a noise model, which describes the propagation of noise from the source to any given location. Both models require a set of input data in order to be applied, the most common being the Aircraft Noise and Performance (ANP) database. In GRAPE, the [performance](#performance) model and the [noise](#noise) model within Doc29 are implemented completely separated. Therefore, the datasets that support these models are also treated separately.

### Performance

The data needed by the performance model described in Doc29 is grouped into Doc29 performance entries in GRAPE, which are uniquely defined by their name. A Doc29 performance entry can have any number of arrival profiles and departure profiles, which are uniquely identified by their name and type (arrival or departure). The vertical profile of a flight operation can be calculated according to two different profile descriptions:

- [points](#points)
- [procedural](#procedural)

Based on the profile description, the Doc29 performance model will calculate the vertical profile along the ground track (defined by the cumulative ground distance). In GRAPE, the following convention is used regarding the cumulative ground distance for flight operations:

- departures: the cumulative ground distance is 0 at the departure threshold and positive thereafter.
- arrivals: the cumulative ground distance is 0 at the arrival threshold, negative before and positive thereafter. Note that this differs from other used conventions where the arrival cumulative ground distance is 0 at touchdown.

#### Points
A points profile is basically the output of the performance model itself, defining a sequence of altitudes AFE, true airspeeds and thrust along the cumulative ground distance. No further data is needed to calculate the vertical profile.

#### Procedural
A procedural profile defines a sequence of steps that the aircraft shall follow. Depending on the step type, thrust rating dependent coefficients and aerodynamic coefficients may be needed to calculate the profile. Most of the data defined for a Doc29 performance entry is needed only by this type of profiles. These data is explained in the following sections:

- [thrust](#thrust)
- [aerodynamic configuration](#aerodynamic-configuration)
- [arrival profile](#arrival-profile)
- [departure profile](#departure-profile)

##### Thrust

For all the takeoff steps and for idle arrival steps, thrust is calculated based on thrust rating dependent coefficients. The coefficients can be based on altitude, speed and temperature or on propeller efficiency and propulsive power for turboprop aircraft. Due to this particularity for turboprop aircraft, the Doc29 performance entries in GRAPE have one of three types:

- jet
- turboprop
- piston

The only difference between each performance type is in the type of thrust rating coefficients allowed. The jet type may only have coefficients based on altitude, speed and temperature. The turboprop type may also define the thrust rating coefficients based on propeller efficiency and propulsive power. The piston type does not support any of the two thrust types, and therefore no procedural profiles can be defined for this performance type.

The following thrust ratings are supported by GRAPE:

- maximum takeoff
- maximum climb
- idle
- maximum takeoff high temperature
- maximum climb high temperature
- idle high temperature

Note that unlike other implementations, GRAPE restricts the thrust ratings supported. Furthermore, for performances of type turboprop with coefficients based on propeller eficiency and propulsive power, only maximum takeoff and maximum climb ratings are supported (no idle and no high temperature coefficients supported). The high temperature coefficients are used in case the air temperature exceeds the engine breakpoint temperature defined for that aircraft.

In order to add steps to an arrival profile that requires the use of idle thrust (descend idle and level idle), coefficients for the idle thrust rating must be given. In order to define departure procedural profiles, coefficients for both the maximum takeoff and maximum climb rating must be defined.

##### Aerodynamic Configuration
The performance model in Doc29 makes use of the following aerodynamic coefficients:

- R: used in the force balance equation
- B: used to calculate the takeoff roll distance
- C: used to calculate the initial climb speed
- D: used to calculate the final approach speed

Based on these requirements by the Doc29 performance model, three types of aerodynamic configurations and associated coefficients are defined in GRAPE:

- takeoff
- land
- cruise

A cruise configuration must have only the R coefficient defined. A takeoff configuration must have in addition to the R coefficient the B and C coefficients defined. In order to define a departure procedural profile, at least one aerodynamic configuration of type takeoff must be defined. A landing configuration must define both the R coefficient and the D coefficient. In order to define an arrival procedural profile, at least one aerodynamic configuration of type land must be defined. 

##### Arrival Profile

An arrival procedural profile is defined by a sequence of procedural steps. All arrival step types must be given an aerodynamic configuration. The following step types are supported:

- [arrival start](#arrival-start)
- [descend](#descend)
- [descend decelerate](#descend-decelerate)
- [descend idle](#descend-idle)
- [level](#level)
- [level decelerate](#level-decelerate)
- [level idle](#level-idle)
- [descend land](#descend-land)
- [ground decelerate](#ground-decelerate)


###### Arrival Start

Every arrival procedural profile starts with an arrival start step, which is the only arrival start step in the profile. The start altitude AFE and the start calibrated airspeed must be given.

###### Descend

A descend step represents a descent at constant calibrated airspeed. The end altitude AFE and the descent angle must be provided. Note that as these values are user defined, unrealistic values can be given.

###### Descend Decelerate

In this step type, the aircraft descends and decelerates at the same time. The end altitude AFE, the descent angle and the end calibrated airspeed are user inputs. Similar to the descend step, no checks are performed for unrealistic user inputs.

###### Descend Idle

A descend idle step represents a descent at idle thrust rating (idle thrust rating coefficients must be defined in order to add this step type to an arrival profile). The descent angle and end calibrated airspeed are given by the user.

###### Level

A level step is performed at constant altitude and calibrated airspeed. The ground distance covered at leve flight must be given.

###### Level Decelerate

A level and decelerate step is performed at constant altitude. The ground distance covered and end calibrated airspeed must be given.

###### Level Idle

A level idle step represents level flight at idle thrust rating (idle thrust rating coefficients must be defined in order to add this step type to an arrival profile). The end calibrated airspeed is an user input.

###### Descend Land

All arrival procedural profiles have a descend land step. Besides the descend angle, the threshold crossing altitutde AFE must be given. After this step, only ground decelerate steps are allowed.

###### Ground Decelerate

A ground decelerate step represents the aircraft deceleration during the landing roll. This step type is only allowed after the descend land step. The ground distance, end calibrated airspeed and end thrust percentage must be given.

##### Departure Profile

A departure procedural profile is defined by a sequence of procedural steps and by the index of the step number at which the thrust cutback from takeoff configuration to climb configuration occurs. Therefore, the thrust for all departure steps is calculated with either maximum takeoff or maximum climb thrust rating coefficients. If the cutback index is set to 0, no thrust cutback will be performed and all steps will be performed with maximum takeoff thrust. All departure step types must be given an aerodynamic configuration. The following step types are supported:

- [takeoff](#takeoff)
- [climb](#climb)
- [climb accelerate](#climb-accelerate)
- [climb accelerate percentage](#climb-accelerate-percentage)


###### Takeoff

Every departure procedural profile starts with a takeoff step, which is the only takeoff step in the profile. The aerodynamic configuration must be of takeoff type. An initial calibrated airspeed can be specified, which can be different than 0 in order to model a rolling start.

###### Climb

A climb step represents a climb at constant speed. The end altitude AFE must be given.

###### Climb Accelerate

In this step, the aircraft climbs and accelerates at the same time. The climb rate must be given as well as the end calibrated airspeed. 

###### Climb Accelerate Percentage

This step is similar to a climb and accelerate step. However, instead of using a fixed climb rate which does not consider atmospheric conditions, the percentage of energy to be attributed to acceleration must be provided.

### Noise

The Doc29 noise model also needs a significant amount of data in order to be applied. In GRAPE these data is grouped into noise entries uniquely identified by their name. In the ANP database, the most commonly used database with Doc29, a noise entry can be defined for a specific aircraft type, a specific engine or even for a certain group of aircraft. Each entry is attributed a lateral directivity specifier (wing, fuselage or propller) and a start of roll correction specifier (none, jet or turboprop). Each noise entry must have an arrival spectrum and a departure spectrum defined for the 24 one third octave bands. Note that this implementatino differs from the ANP database where the spectral data is grouped into spectral classes. The noise power distance curves found in the ANP database are equivalently implemented in GRAPE. However, GRAPE currently only supports A-weighted metrics (SEL and LAMAX) and thrust specified as corrected net thrust per engine.

---

## Landing and Takeoff Cycle Data

The ICAO engine certification process generates a significant amount of data for four specific engine conditions. This data can be summed as fuel flow values and emission indexes for different pollutants for those specific four data points. The most common sources for this type of data are:

- the [ICAO Aircraft Engine Emissions Databank](https://easa.europa.eu/en/domains/environment/icao-aircraft-engine-emissions-databank) for turbojet and turbofan engines
- the [FOCA database](https://www.bazl.admin.ch/bazl/de/home/themen/umwelt/schadstoffe/triebwerkemissionen/zusammenfassender-bericht--anhaenge-und-datenblaetter.html) for piston engines
- the [FOI confidential database](https://www.foi.se/en/foi/research/aeronautics-and-space-issues/environmental-impact-of-aircraft.html) for truboprop engines (obtainable only for specific purposes)

 GRAPE can use this data to calculate fuel flow and requires it in order to calculate emissions. In a GRAPE study, LTO data is added to LTO engines which must have an unique name. For each of the four stages, the following values must be provided:

- fuel flow
- fuel flow correction factor
- hydrocarbon emission index
- carbon monoxide emission index
- nitrogen oxides emission index

The correction factor can be used to correct the measured fuel flows to in flight values (e.g. due to engine bleed). 

---

## Senzig Fleming Iovinelle Data

The authors Senzig, Fleming and Iovinelle developed a thrust specific fuel flow model to calculate fuel consumption in the terminal area. The model is split into an arrival and a departure equation, and besides aircraft state and atmospheric conditions, six coefficients are needed for it to be applied. Each set of coefficients is given an ID in GRAPE, which can then be attributed to any number of aircraft in the [fleet](./InputData.md#fleet). The coefficients are named as followed:

- *&alpha;*
- *&beta;<sub>1</sub>*
- *&beta;<sub>2</sub>*
- *K<sub>1</sub>*
- *K<sub>2</sub>*
- *K<sub>3</sub>*
- *K<sub>4</sub>*

The *&alpha;* and *&beta;* coefficients are needed to calculate fuel flow for arrival operations and the *K* coefficients for departure operations.