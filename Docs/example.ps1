

## Steps - Example usage

# example #1

# 0. load the module
Import-Module C:\Coupacode\MonitorCalc

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

# 2. Show the specs in a siccinct and colorful way
Show-ScreenSpec $Spec


## example #2 - by using the internal functions

# 0 load the module
Remove-Module MonitorCalc -EA Ignore
using module C:\MyModules\MonitorCalc

# 1. Get the screen spec object
$params = @{
    Size       = 39.7
    HorizRes   = 5120
    VertRes    = 2160
    Scaling    = 125
    HorizRatio = 21.5
    VertRatio  = 9
    Curve      = 1800
    ColorDepth = 10
    Refresh    = 120
    Distance   = 95
}
$Spec = Get-ScreenSpec @params

# 2. get the values on their corresponding spot on the table
$Values = ConvertTo-LayoutValues -InputObject $Spec

# 3. get the cell items
$Cells = ConvertTo-Cell -Values $Values

# 4. get the box lines from the cells
$Lines = Get-BoxLine -Cell $Cells

# 5. now get the border specs
$BorderSpec = ConvertTo-Border -Values $Values

# 6. get the borders of the boxes
$Border = $BorderSpec | foreach {$_.ToBorder()}

# 7. get the individual boxes
$Boxes = Get-Box -Line $Lines -Border $Border

# 8. get the complete multi box lines
$Multi = Get-BoxMulti -Box $Boxes

# finally show the results
$Multi.MultiBoxText