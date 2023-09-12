# Command Line Tool

The same executable used to start the GUI can be used from the command line to automate certain actions. The following options are available:

- [-h]   - Display this help. Equivalent to [-h -x].
- [-x]   - Close after processing the command line options, do not run the application.
- [-c]   - Create a GRAPE study located at the path specified by the following argument.
- [-o]   - Open a GRAPE study located at the path specified by the following argument.
- [-anp] - Import the ANP database at the folder path specified by the following argument. Use only in conjunction with -c or -o.
- [-d]   - Delete all outputs from the study. Use only in conjunction with -o.
- [-rp]  - Start the performance run specified by the following argument as <scenario name\>-<performance run name\>. Use only in conjunction with -o.
- [-rn]  - Start the noise run specified by the following argument as <scenario name\>-<performance run name\>-<noise run name\>. Use only in conjunction with -o.
- [-re] - Start the emissions run specified by the following argument as <scenario name\>-<performance run name\>-<emissions run name\>. Use only in conjunction with -o.

The options do not need to be passed in any specific order. Example usages (in Windows):

```
GRAPE.exe -h
GRAPE.exe -x -d -o "Studies/Grape Study.grp" -rp "scenario-performance" -rn "scenario-noise"
GRAPE.exe -x -o "Studies/Grape Study.grp" -re "scenario-performance-emissions1" -re "scenario-performance-emissions2"
```

???+ warning
	Names containing the character `-` might break this functionality.
