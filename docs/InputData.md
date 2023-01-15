# Input Data

## Operations

There are two main ways to describe an operation in GRAPE:

- [flights](#flights)
- [4D tracks](#4d-tracks)

While the input data needed to describe each of these two types is vastly different, both produce the same set of output data after a performance run, describing the trajectory of an aircraft on the 3D space as well as other necessary variables for each trajectory point such as speed and thrust.

An operation is uniquely identified by its name, its type (arrival or departure) and how its described (flight or 4D track). Note than it is therefore possible for an arrival flight to have the same name as a departure flight, as well as an arrival track 4D.

Independet of type or description, all operations must have the following information:

- Time: the specific second at which the operation occurs. It is used with cumulative noise metrics, to determine which weight should be applied to the operation.
- Count: the multiplier used in the accumulation of noise, fuel and emissions.
- Fleet ID: the fleet entry to be used for this operation.

### Flights

A flight is the type of operation for which the least amount of known data is needed. To describe its trajectory along the ground plane (sequence of longitudes and latitudes), a route must be attributed to the flight (see the [Airports](#airports) section). In order to describe the vertical profile of the flight, including any needed additional data such as speed and thrust, a performance model must be applied. GRAPE currently only supports the [Doc29](https://ecac-ceac.org/documents/ecac-documents-and-international-agreements) performance model. To use this model, a flight profile must be selected from the associated Doc29 performance entry in the Fleet ID. There are two types of profiles:

- [points](#points)
- [procedural](#procedural)

More detailed information of how this data is structured can be found in the [Doc29 performance dataset](./Datasets.md#performance) section.

#### Points

A points profile defines a sequence of altitudes AFE, true airspeeds and thrust along the ground track (the cumulative ground distance). These values are not influenced by any other variable, such as the operation weight, thrust reduction or atmospheric conditions.

#### Procedural

The vertical profile of the operation is obtained by applying the Doc29 performance model to the sequence of steps defined in the selected profile. Additionally to the profile definition itself, the atmospheric conditions, operation weight and in the case of departure operations the amount of thrust percentage influence the vertical profile of the operation. The thrust percentage is applied to the portion of the flight with thrust set at maximum takeoff. After the cutback, if the thrust percentage set is not 100%, a constant percentage of 90% is used.

### 4D Tracks

A 4D track describes the whole flight path of a given operation, including the necessary additional variables. It requires the most amount of data in order to be used. Typical uses for this type of input include radar data, output from fast time airport simulation models as well as output from extern performance models. The track is described as a sequence of points with the following variables:

- flight phase
- longitude
- latitude
- altitude MSL
- true airspeed
- corrected net thrust per engine
- bank angle
- fuel flow per engine

While a performance run may generate new track points by interpolation or remove track points which are to close together, the input values are never changed. A small exception is the fuel flow, which the user can choose to ignore and recalculate by using one of the supported fuel flow models.

---

## Airports

A flight operation ground path, meaning the sequence of longitude and latitude points covered by a flight, is calculated by GRAPE based on a route. A route always belongs to a runway, and a runways always belongs to an airport. GRAPE supports the definition of multiple airports in a single study.

### Airport

An airport is only used as a means to group runways, it has no influence on any of the models used by GRAPE. The airport name must be unique within a study. Besides runways, an airport has a location (longitude, latitude and elevation) and reference atmospheric conditions (temperature and sea level pressure). The location is used as a convenience to give a default location to runways attributed to the airport and the reference atmospheric conditions as a convenience to set the atmospheric conditions of a performance run.

### Runway

 A runway is used as a means to group arrival and departure routes. Within an airport a runway must have an unique name. A runway has a threshold (longitude, latitude, elevation) which is always set as the beginning of each departure route and the end of each arrival route. Note that while a departure flight initial point will always be the runway threshold, an arrival flight final point will most likely be after the runway threshold, as aircraft normally overfly the threshold at a certain height and then touchdown and decelerate. The runway heading is used to define the final heading of arrival routes and the initial heading of a departure route. The runway length and gradient can be used by the performance model to calculate the aircraft altitude during the takeoff or landing roll (currently only used by the Doc29 performance model for procedural step profiles).

### Routes

 A route produces a sequence of longitude and latitude points which can then be used by flights as a ground track. Routes can be described in three different ways:

- [simple](#simple)
- [vector](#vector)
- [RNP](#rnp)

#### Simple

A simple route is defined by a sequence of longitude latitude points. The only processing applied to it during performance runs is the addition of the runway threshold.

#### Vector

A route can be defined by a sequence of straight and turn segments. For departures, the first segment starts at the runway threshold. This should always be a straight segment. For arrivals, the last segment ends at the runway threshold and should also always be a straight segment. Note that in order to accomodate extreme cases there is no enforcement of straight segments at either the begin of a departure route or the end of an arrival route. A straight segment is defined by its distance. A turn segment is defined by the turn radius and the final heading. The turn direction (left or right) is set to be the one which provides the shortest path. 

#### RNP

Required Navigation Performance allow aircraft to fly certain legs with high precision. GRAPE supports two types of legs:

- Track to Fix: the next longitude latitude point in the route. A sequence of track to fix legs is equivalent to a simple route, a sequence of longitude latitude points.
- Radius to Fix: a radius to fix turn is defined by the turn center location, the initial point and the final point. The initial point is defined by the previous leg and the final point is defined in the radius to fix leg. Note that if the distance between the turn center and the initial point is not similar to the distance between the turn center and the final turn, the route is not well defined.

---

## Scenarios

A scenario is simply a collection of operations to which the models can be applied in order to calculate the desired outputs.