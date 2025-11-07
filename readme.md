

## Overview

A module to get all the various aspects of a display specification.

For example it finds the PPI (pixels per inch), the effective resolution after scaling, the bandwidth requirements for a given refresh rate, and a few others.

Now because there are so many properties on the output object, there is also an option to get a nice colorful string with all the relevant data.

Some context behind this.  
I've been trying to find the "ideal" monitor for myself for more than a decade now (and still searching to be honest).  
I originally created an excel sheet that did all the calculations, and so the time came to put that into PowerShell.

## Usage

The main reason to use this, is to find out if a given (theoritical) spec has adequate PPI after scaling for your use-case.  
Furthermore you can also check the dimensions of the given screen, if it's too tall for your sitting position or too wide for your desk.  
Finally it shows the required bandwidth based on a refresh rate in order to get an idea of what's needed to run this display.

## Excel Sheet

I've also included an excel file in this repo. The first tab has the same calulator as the function in this module, but in an easy to use graphical way, since excel can provide that.  
In addition it also has a few more more things. For example a sheet with tables for different screens given a target PPI along with  the required scaling to get that result.  
Some interesting findings from my part in regards to displays on a separate excel sheet. And finally a comparison table where I show the actual screen real estate uplift, from a potential upgrade based on a given screen.

The **monitor calculator** in excel:
![The monitor calculator in excel](/Docs/Sample_Excel.png)

## Example

This a sample screenshot of the output from the `Show-ScreenSpec` function:
![This a sample screenshot of the output from the `Show-ScreenSpec` function](/Docs/Sample_Function.png)

A quick example on how to use this module.

```PowerShell

# 0. Load the module
Import-Module MonitorCalc

# 1. Get the screen specifications for a sample monitor
$params = @{
    Size       = 39.7  # <-- inches
    HorizRes   = 5120  # <-- pixels
    VertRes    = 2160  # <-- pixels
    Scaling    = 125   # <-- percent
    HorizRatio = 21.5  # <-- aspect ratio for X
    VertRatio  = 9     # <-- asepct ratio for Y
    Curve      = 1800  # <-- radius
    ColorDepth = 10    # <-- bits
    Refresh    = 120   # <-- hertz
    Distance   = 95    # <-- centimeters
}
$Spec = Get-ScreenSpec @params

# 2. Show the specs in a short and colorful way
Show-ScreenSpec $Spec

```

**sample output**
```
┌Specs───────────────────┐┌Throughput─────────────────────────┐
│ Size       39.7"       ││ Color Depth  10bits               │
│ Ratio      21.5:9      ││ Refresh Rate 120hz                │
│ Resolution 5120x2160   ││ Bandwidth    43.6gbps             │
│ Scaling    125%        ││ FitsIn       ...                  │
└────────────────────────┘└───────────────────────────────────┘
┌Scaling─────────────────┐┌Dimensions──────┐┌Degrees──────────┐
│           Orig  Scaled ││ Size   39.7in  ││ Distance  95cm  │
│ HorizRes  5120  4096   ││ Curve  1800R   ││ PPD       92    │
│ VertRes   2160  1728   ││ Height 38.9cm  ││ HorizFoV  51.7° │
│ PPI       140   112    ││ Width  92cm    ││ VertFov   23.2° │
│ MegaPixel 11.1  7.1    ││ Pitch  0.18mm  ││                 │
└────────────────────────┘└────────────────┘└─────────────────┘
```
