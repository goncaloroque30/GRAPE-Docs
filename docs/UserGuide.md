# Overview

GRAPE implements the models used to calculate the environmental impacts of aircraft operations around airports. It focus solely on arrival and departure operations (taxi, overflight and circuit operations are currently not supported). Based on the same input data, noise, fuel consumption and pollutant emissions can be calculated.

A study in GRAPE can be defined as a collection of the input data and its associated databases, the defined scenarios and runs to apply the models to that data and the outputs that those runs produce. A study is saved as a single [SQLite](https://sqlite.org/) file with the *.grp* extension.

---

# Sections

- [GUI & Command Line Tool](Gui&CommandLineTool.md): guidance on how to interact with the application
- [Datasets](Datasets.md): how different known databases are structured  and implemented
- [Input Data](InputData.md): describes the necessary data to define a scenario and where it is used in the calculations
- [Runs & Outputs](Runs&Outputs.md): explains the types of models that can be applied to the input data, what settings can be tweaked and the outputs produced
- [Models](Models.md): detailed explanation of the implemented models and how they interact with each other (WIP)