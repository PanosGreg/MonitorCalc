function Show-ScreenSpec {
<#
.EXAMPLE
    $s = Get-ScreenSpec -Size 47 -HorizRes 8192 -VertRes 3456 -Scaling 200 -HorizRatio 21 -Refresh 144
    Show-ScreenSpec $s
#>
[OutputType([string])]
[cmdletbinding()]
param (
    [PSTypeName('Monitor.Specification')]
    $InputObject  # <-- Get-ScreenSpec ....    
)

# 1. map the values to their corresponding spot on the output tables
$Values = ConvertTo-LayoutValues -InputObject $InputObject

# 2. get the cell items
$Cells = ConvertTo-Cell -Values $Values

# 3. get the box lines from the cells
$Lines = Get-BoxLine -Cell $Cells

# 4. now get the border specs
$BorderSpec = ConvertTo-Border -Values $Values

# 5. get the borders of the boxes
$Border = $BorderSpec | foreach {$_.ToBorder()}

# 6. get the individual boxes
$Boxes = Get-Box -Line $Lines -Border $Border

# 7. get the complete multi box lines
$Multi = Get-BoxMulti -Box $Boxes

# 8. finally show the results
$Multi.MultiBoxText

}