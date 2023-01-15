# Runs & Outputs

Having defined a scenario with all the necessary input data, runs can be defined and outputs calculated for that scenario.

---

## Performance

A performance run has the job of transforming the operations listed in the scenario, which can be of different types and have different input data, into a common set of output data describing each operation's trajectory in the 3D space as well as additional variables such as speed, thrust and fuel flow. A performance run name must be unique within a scenario. The following parameters can be tweaked in a performance run:

- [coordinate reference system](#coordinate-reference-system)
- [atmospheric conditions](#atmospheric-conditions)
- [flight operations performance model](#performance-models)
- [spatial filters](#spatial-filters)
- [thresholds](#thresholds)


### Coordinate Reference System

While all coordinates in the input data must be provided in the WGS84 coordinate system, the calculations in GRAPE (solutions to the direct and indirect problem) can be made either in the WGS84 ellipsoid or in a local cartesian system. The conversion from the WGS84 coordinates to the local cartesian system is done by providing the center location of this reference system. Note that regardless of chosen coordinate system, all the outputs will be in WGS84 coordinates as well.

### Atmospheric Conditions

GRAPE has implemented the ISA mathematical model that describes the variation of temperature, pressure and density with altitude based on the conditions found at different layers. Changes can be made to the first layer of the standard model to represent non standard conditions. This is done by providing an altitude at which the conditions are observed, a reference temperature and a reference sea level pressure.

A relative humidity value must be defined for the performance run. Although the output of the performance run itself is not influeced by the relative humidity, this value will be used by noise runs and fuel and emissions runs defined for this performance run to estimate the environmental impacts. A headwind can also be defined, interpreted in GRAPE as a constant headwind.

### Performance Settings

For operations defined as flights, a performance model is needed in order to generate the common output. Currently GRAPE only supports the performance model defined in Doc29.

GRAPE supports three different ways for defining the fuel flow for each point of the performance output. The chosen method is set in the performance run definition under *fuel flow model*:

- [None](#none)
- [LTO](#lto)
- [SFI](#sfi)

#### None

In this fuel flow mode, the fuel flow values defined for each point of a track 4D are kept. For operations defined as flights, the fuel flow is set to 0 for every output point.

#### LTO

In this mode, the values found in the LTO Engine associated with each operation fleet ID are used to define the fuel flow at each output point. Note that the fuel flow defined for each point of a track 4D will be ignored. In order to use this model, every fleet entry used in the operations attributed to the scenario must have an associated LTO Engine ID. The fuel flow defined in the LTO Engine ID is corrected for the atmospheric conditions observed at each point altitude and with the fuel flow correction factor defined for the respective flight phase. The conversion between the flight phases defined in GRAPE and the LTO phase is provided in the following table.

|  GRAPE Phase | LTO Phase |
|:------------:|:---------:|
| Approach     | Approach  |
| Landing Roll | Approach  |
| Takeoff Roll | Takeoff   |
| Departure    | Climb     |

#### SFI

This mode uses the [SFI fuel flow model](https://arc.aiaa.org/doi/10.2514/1.42025) to calculate fuel flow at every output point. Note that the fuel flow defined for each point of a track 4D will be ignored. In order to use this model, every fleet entry used in the operations attributed to the scenario must have an associated SFI ID.

### Spatial Filters

A filter on altitude MSL can be defined which will influence the output of both flight operations and tracks 4D. Output points which are noth within the defined minimum and maximum altitudes MSL will be removed from the performance output.

The cumulative ground distance filter is only applied to flight operations, as the input from tracks 4D has no common point defined in the trajectory.

### Thresholds

The minimum number of points that a track 4D requires in order to generate an output can be defined. If any track 4D for the respective scenario does not have this minimum amount of points, an error will be generated and the performance run canceled.

The speed delta segmentation threshold can be defined to ensure a minimum speed change between two adjacent output points. If the speed difference between two adjacent points is higher than minimum speed delta, extra points are added between those two adjacent points at an equal speed interval which is at least the speed delta minimum.

The ground distance delta filter threshold can be defined to ensure that any two adjacent points in the output are spatially separated from one another by at least a minimum ground distance. If the ground distance between two adjacent points is smaller than the threshold defined, a point will be deleted.

---

## Noise

Following a performance run, there is a common ouput defined as a sequence of points for every operation associated with the scenario. A noise run has the job of transforming that common output for each operation into single event noise levels at any given location and then accumulate those events according to a specified metric. The following parameters can be defined in a noise run:

- [models](#models)
- [receptor set](#receptor-set)
- [cumulative metrics](#metrics)

### Models

Currently only the noise model specified in Doc29 is implemented. This model uses Noise-Power-Distance (NPD) tables, which apply to standardized atmospheric conditions. GRAPE allows to correct this data for non standard atmospheric conditions by using the amtospheric absorption models defined in either the SAE ARP 866 or the SAE ARP 5534. The atmospheric conditions used are the ones set in the performance run which owns the noise run. 

### Receptor Sets

A receptor set defines the list of locations for which noise will be calculated. It can be defined as a:

- [grid](#grid)
- [list of points](#points)

#### Grid

A grid is a collection of equally spaced points in a given rectangle. This is defined by proving:

- a reference location, and the point of the rectangle to which that position refers to (one of the four vertices of the rectangle or the center)
- the distance between each grid point in the horizontal and vertical directions
- the number of points in the horizontal and vertical directions
- the grid rotation around its center

#### Points
 
 In this type of receptor set, each individual location at which noise will be calculated must be defined by the user.

### Cumulative Metrics

A noise cumulative metric specifies how to accumulate the noise generated by multiple operations at any given location into a single value. GRAPE provides the following parameters to define a cumulative metric:

- start and end time: operations which do not occur in this time interval, will not be considered.
- averaging time constant (dB): used to average the exposure value (`= 10 log[Duration])`).
- cutoff threshold (dB): operations with a maximum value below this threshold at any given point will not be considered for that point.
- weights: different weights can be attributed to operations for different times of day, for example to penalize operations occuring at night. GRAPE supports the definition of different weights for different times of a day. Currently not supported are:
    - Different weights for different days of the week
    - A linear variation of the weight between two time points (as the time interval for a given weight can be as low as one second, a linear or any other kind of variation can be achieved with some extra work)

Every cumulative metric will always produce for each location:

- the absolute maximum value
- the average maximum value
- the exposure value

Additionaly, any number of maximum value thresholds may be defined for which GRAPE will calculate the number of operations in the cumulative metric which exceeded that threshold.

---

## Fuel & Emissions

Following a performance run, there is a common ouput defined as a sequence of points for every operation associated with the scenario. A fuel & emissions run has the job of calculating the fuel consumption and emissions of that common output for each segment of the operation and then accumulate those results for each operation and subsequently for the whole scenario.

The common output defined as a sequence of points is transformed into a sequence of segments, meaning there will be exactly one less segment that points in the output. The values of any variable for each segment is the simple average of that variable for the two points that define the segment.

As the fuel flow is already part of the information calculated by the performance run, fuel consumption for each segment can be directly calculated. For emissions, currently only the [BFFM2](https://jstor.org/stable/44657657) is supported. This model converts the segment fuel flow into emission indexes for:

- Hydrocarbons (HC)
- Carbon Monoxide (CO)
- Nitrogen Oxides (NOx)