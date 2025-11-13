function Compare-ScreenSpec {
<#
.SYNOPSIS
    Compares two screen specifications and returns the gain or loss of the screen real estate after scaling
.EXAMPLE
    $s1 =  Get-ScreenSpec -Size 31.5 -HorizRes 3840 -VertRes 2160 -Scaling 150
    $s2 =  Get-ScreenSpec -Size 39.7 -HorizRes 5120 -VertRes 2160 -Scaling 150 -HorizRatio 21.33
    Compare-ScreenSpec -ReferenceSpec $s1 -DifferenceSpec $s2

.NOTES
    About string formatting:
    0.1295, 0.1244, -0.15, 0 | foreach { '{0:+#.#%;-#.#%;0}' -f $_ }
    # also: [string]::Format('{0:+#.#%;-#.#%;0}',0.129)

    a) {0: means the first variable
    b) then there are 3 sections separated by a semicolon ;
       each section has a specific formatting
       the 1st section applies to positive values,
       the 2nd section applies to negative values
       and the 3rd section applies to zeros
    c) the format on the 1st section (positive values): +#.#%  means:
       show the plus sign, then show a number with up to 1 decimal (rounded),
       then multiply by 100 and show the percent sign at the end
       similarly on the 2nd section (negative values): -#.#%
       finally on the 3rd section (applies to zeros): 0 means:
       a zero will be shown on the results

    returns:
    +13%
    +12.4%
    -15%
    0
#>
[OutputType('MonitorComparison')]
[CmdletBinding()]
param (
    [Parameter(Mandatory,Position = 0)]
    [PSTypeName('Monitor.Specification')]$ReferenceSpec,

    [Parameter(Mandatory,Position = 1)]
    [PSTypeName('Monitor.Specification')]$DifferenceSpec
)
$RealEstate = '{0:+#%;-#%;0}' -f (($DifferenceSpec.ScaledMP / $ReferenceSpec.ScaledMP) - 1)

# compare difference of scaled mega pixels to find which one has more screen real estate
$MegaPixelDiff = $DifferenceSpec.ScaledMP - $ReferenceSpec.ScaledMP
if     ($MegaPixelDiff -lt -0.5) {$MorePixels = 'Screen A (Reference Spec)'}  # from -0.5 or less (million pixels difference)
elseif ($MegaPixelDiff -le 0.5)  {$MorePixels = 'Same number of pixels'}      # from -0.5 to +0.5
elseif ($MegaPixelDiff -gt 0.5)  {$MorePixels = 'Screen B (Difference Spec)'} # from +0.5 or more

# compare difference of the scaling factor to find which one has more clarity
$ScaleDiff = $DifferenceSpec.Scaling - $ReferenceSpec.Scaling
if     ($ScaleDiff -lt -10) {$MoreClarity = 'Screen A (Reference Spec)'}  # from -10 or less (scaling factor difference)
elseif ($ScaleDiff -le 10)  {$MoreClarity = 'Same screen clarity'}        # from -10 to +10
elseif ($ScaleDiff -gt 10)  {$MoreClarity = 'Screen B (Difference Spec)'} # from +10 or more

# compare difference of the scaled PPI to find which one has smaller text
$PpiDiff = $DifferenceSpec.ScaledPPI - $ReferenceSpec.ScaledPPI
if     ($PpiDiff -lt -5) {$SmallerText = 'Screen A (Reference Spec)'}  # from -5 or less (scaled PPI difference)
elseif ($PpiDiff -le 5)  {$SmallerText = 'Same text size'}             # from -5 to +5
elseif ($PpiDiff -gt 5)  {$SmallerText = 'Screen B (Difference Spec)'} # from +5 or more

# compare difference of width to find which one is wider
$WidthDiff = $DifferenceSpec.Width - $ReferenceSpec.Width
if     ($WidthDiff -lt -4) {$Wider = 'Screen A (Reference Spec)'}  # from -4 or less (cm width difference)
elseif ($WidthDiff -le 4)  {$Wider = 'Same screen width'}          # from -4 to +4
elseif ($WidthDiff -gt 4)  {$Wider = 'Screen B (Difference Spec)'} # from +4 or more

# compare difference of height to find which one is taller
$HeightDiff = $DifferenceSpec.Height - $ReferenceSpec.Height
if     ($HeightDiff -lt -2) {$Taller = 'Screen A (Reference Spec)'}  # from -2 or less (cm height difference)
elseif ($HeightDiff -le 2)  {$Taller = 'Same screen height'}         # from -2 to +2
elseif ($HeightDiff -gt 2)  {$Taller = 'Screen B (Difference Spec)'} # from +2 or more

[MonitorComparison] @{
    RealEstate  = $RealEstate
    MorePixels  = $MorePixels
    MoreClarity = $MoreClarity
    SmallerText = $SmallerText
    Wider       = $Wider
    Taller      = $Taller
    WidthDiff   = '{0:+0.#;-0.#;0}cm' -f $WidthDiff
    HeightDiff  = '{0:+0.#;-0.#;0}cm' -f $HeightDiff
    PpiDiff     = '{0:+0.#;-0.#;0} PPI' -f $PpiDiff
}

}