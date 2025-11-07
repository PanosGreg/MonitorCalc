function Get-ScreenSpec {
<#
.SYNOPSIS
    Calculates all the various aspects of a display specification

    All of the input parameters have a default value, so none is required.
.DESCRIPTION
    Calculates all the various aspects of a display specification

    Given the following input:
    - Diagonal display size in inches
    - Horizontal Resolution in number of pixels
    - Vertical Resolution in number of pixels
    - Resolution scaling factor in percentage
    - Horizontal display ratio
    - Vertical display ratio
    - Curvature in radius, if not flat screen
    - Color depth in bits
    - Refresh rate in Hertz
    - Viewing distance from screen in centimeters

    It calculates the following items:
    - Absolute display ratio
    - Scaled Resolution
    - Original mega pixel (MP) count
    - Scaled mega pixel (MP) count
    - Screen width in centimeters, taking into account for any curvature
    - Screen height in centimeters
    - Pixels per inch (PPI) density
    - Scaled pixels per inch (PPI) density
    - Pixels per centimetre and also scaled pixels per cm
    - Pixel pitch size in millimeters
    - Uncompressed bandwidth requirements in gbps, based on the CVT-R2 Timing Format
    - Pixels per degree (PPD)
    - Horizontal field of view (HFOV) in degrees
    - Vertical field of view (VFOV) in degrees
    - A link of the screen on the Display Wars website


    The output object also has a custom .ToString() method.
    The following example shows the format of the string it returns:

    32" 16:9 5120x2880 200% 93PPI (2560x1440) 120Hz 87gbps 93cm x 52cm

.EXAMPLE
    # show a spec with the function's default values

    Get-ScreenSpec

    This returns the specs of a 27" screen at 4K 

.EXAMPLE
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
    Get-ScreenSpec @params
.EXAMPLE
    Get-ScreenSpec -Size 47 -HorizRes 8192 -VertRes 3456 -Scaling 200 -HorizRatio 21 -Refresh 144
#>
[cmdletbinding()]
param (
    ## Base Parameters
    [Parameter(HelpMessage='The diagonal screen size in inches, it accepts decimals')]
    [ValidateRange(1,100)]
    [Alias('SizeDiagonalInch')]
    [double]$Size = '27',

    [Parameter(HelpMessage='The horizontal number of pixels')]
    [ValidateRange(1,20000)]
    [Alias('HorizontalPixels')]
    [int]$HorizRes = 3840,

    [Parameter(HelpMessage='The vertical number of pixels')]
    [ValidateRange(1,20000)]
    [Alias('VerticalPixels')]
    [int]$VertRes = 2160,

    [Parameter(HelpMessage='The amount of screen scaling percentage')]
    [ValidateRange(100,500)]
    [Alias('ScalingPercent')]
    [int]$Scaling = 150,

    [Parameter(HelpMessage='The horizontal ratio, ex. 16:9 has 16 horizontal ratio, it accepts decimals')]
    [ValidateRange(1,100)]
    [Alias('HorizontalRatio')]
    [double]$HorizRatio = 16,

    [Parameter(HelpMessage='The vertical ratio, ex. 16:9 has 9 vertical ratio, it accepts decimals')]
    [ValidateRange(1,100)]
    [Alias('VerticalRatio')]
    [double]$VertRatio = 9,

    [Parameter(HelpMessage='The curve radius in mm, if left empty means a flat screen')]
    [ValidateRange(400,4000)]
    [Alias('CurveRadius')]
    [int]$Curve = 0,  # <-- 0 means a flat screen, no curve at all

    ## Additional Parameters
    [Parameter(HelpMessage='The color depth in bits per pixel, usually 8bits to get 24bit color')]
    [ValidateRange(4,16)]
    [Alias('ColorBits')]
    [int]$ColorDepth = 8,

    [Parameter(HelpMessage='The refresh rate in hertz')]
    [ValidateRange(20,1000)]
    [Alias('RefreshHertz')]
    [int]$Refresh = 60,

    [Parameter(HelpMessage='The distance from the screen in cm')]
    [ValidateRange(10,1000)]
    [Alias('DistanceCentimeter')]
    [int]$Distance = 80
)

# calculate number of pixels after scaling
$PixelsXScaled   = ($HorizRes/$Scaling)*100
$PixelsYScaled   = ($VertRes/$Scaling)*100
$MegaPixel       = ($HorizRes*$VertRes)/1000000
$MegaPixelScaled = ($PixelsXScaled*$PixelsYScaled)/1000000

# calculate PPI -> SQRT of (X2 + Y2) and divide by size
$ScaleDiv        = $Scaling/100  # <-- scaling divider, ex. 1.5 for 150% scaling
$ResXPower       = $HorizRes * $HorizRes
$ResYPower       = $VertRes  * $VertRes
$ResXPowerScaled = ($HorizRes/$ScaleDiv) * ($HorizRes/$ScaleDiv)
$ResYPowerScaled = ($VertRes/$ScaleDiv)  * ($VertRes/$ScaleDiv)
$PixelsPerInch   = [math]::Sqrt($ResXPower+$ResYPower)/$Size
$ScaledPPI       = [math]::Sqrt($ResXPowerScaled+$ResYPowerScaled)/$Size

# calculate screen size
$HorizRatioPower = $HorizRatio*$HorizRatio
$VertRatioPower  = $VertRatio*$VertRatio
$SizePower       = $Size*$Size
$NumberA         = [math]::Sqrt( $SizePower / ($HorizRatioPower+$VertRatioPower) )
$WidthFlat       = $NumberA * $HorizRatio * 2.54
$Height          = $NumberA * $VertRatio * 2.54

# calculate curved width size
if ($Curve -gt 0) {
    $Width = 2 * ($Curve/10) * [math]::Sin( ($WidthFlat/2) / ($Curve/10) )
}
else {$Width = $WidthFlat}

# calculate pixel pitch size
$PixelPitch = ($Height/$VertRes)*10

# calculate bandwidth in giga bits per second (not gigabytes)
$Vmin   = 0.00046  # <-- CVT-R2 Timing Format Vertical Minimum Constant in Seconds
$Hblank = 80       # <-- CVT-R2 Timing Format Horizontal Blank constant in Pixels
$Vblank = 169      # <-- CVT-R2 Timing Format Vertical Blank constant in Pixels
$Bandwidth = (($HorizRes+$Hblank)*($VertRes+$Vblank)*$Refresh*($ColorDepth*3))/1000000000

# calculate PPD - pixels per degree
$PixelsPerDegree = 1 / ( ( ($PixelPitch/1000)/($Distance/100) ) * (180/[math]::PI) )

# calulate Field of View in degrees angle
$FovHorizontal = 2*[math]::Atan($Width/(2*$Distance)) * (180/[math]::PI)
$FovVertical   = 2*[math]::Atan($Height/(2*$Distance)) * (180/[math]::PI)

# get the display wars link
$UrlSize   = ([string]$Size).Replace('.',',')
$UrlRatioX = ([string]$HorizRatio).Replace('.',',')
$UrlRatioY = ([string]$VertRatio).Replace('.',',')
$UrlLink = "https://www.displaywars.com/${UrlSize}-inch-d%7B${UrlRatioX}x${UrlRatioY}%7D-vs-1-inch-16x9"
$UrlName = "$($Size)in"

if ($PSVersionTable.PSVersion.Major -ge 7 -and $Env:WT_SESSION) {
    $Link = "`e]8;;$UrlLink`e\$UrlName`e]8;;`e\"
}
else {$Link = 'N/A'}

# helper function
function round ($Number,[int]$RoundTo, [bool]$Dynamic=$false) {
    if     ($RoundTo -eq 0)                {[math]::Round($Number,$RoundTo) -as [int]}
    elseif ($Dynamic -and $Number -ge 100) {[math]::Round($Number,0) -as [int]}
    else                                   {[math]::Round($Number,$RoundTo)}
}

$obj = [pscustomobject] @{
    # object type
    PSTypeName  = 'Monitor.Specification'

    # input values
    Size        = $Size
    PixelsX     = $HorizRes
    PixelsY     = $VertRes
    Scaling     = $Scaling
    RatioX      = $HorizRatio
    RatioY      = $VertRatio
    Curve       = $Curve
    Color       = $ColorDepth
    Refresh     = $Refresh
    Distance    = $Distance

    # calculated values
    Resolution      = '{0}x{1}' -f $HorizRes,$VertRes
    AspectRatio     = '{0}:{1}' -f $HorizRatio,$VertRatio
    Ratio           = round ($HorizRatio/$VertRatio) 3
    ScaledResolution= '{0}x{1}' -f (round $PixelsXScaled 0),(round $PixelsYScaled 0)
    ScaledPixelsX   = round $PixelsXScaled 0    # <-- horizontal amount of pixels after scaling
    ScaledPixelsY   = round $PixelsYScaled 0    # <-- vertical amount of pixels after scaling
    ScaledMP        = round $MegaPixelScaled 1  # <-- Mega Pixel count after scaling
    MegaPixel       = round $MegaPixel 1        # <-- Mega Pixel count
    PixelsPerInch   = round $PixelsPerInch 1 $true
    ScaledPPI       = round $ScaledPPI 1 $true  # <-- pixels per inch after scaling
    PixelsPerCm     = round ($PixelsPerInch / 2.54) 1
    ScaledPixelPerCm= round ($ScaledPPI / 2.54) 1
    Width           = round $Width 1            # <-- in cm (centimetre)
    Height          = round $Height 1           # <-- in cm (centimetre)
    PixelPitch      = round $PixelPitch 3       # <-- in mm (millimetre)
    Bandwidth       = round $Bandwidth 2        # <-- in gbps
    PixelsPerDegree = round $PixelsPerDegree 1
    FovHorizontal   = round $FovHorizontal 1    # <-- horizontal field of view degrees
    FovVertical     = round $FovVertical 1      # <-- vertical field of view degrees
    FitsIn          = Measure-DisplayBandwidth -Bandwidth $Bandwidth
    DisplayWarsLink = $Link
    DisplayWarsUrl  = $UrlLink
}

# ToString() method
$ToString = {
    $out = '{0}" {1} {2} {3}% {4}PPI ({5}) {6}Hz {7}gbps {8}cm x {9}cm' -f
        $this.Size,             # {0}
        $this.AspectRatio,      # {1}
        $this.Resolution,       # {2}
        $this.Scaling,          # {3}
        $this.ScaledPPI,        # {4}
        $this.ScaledResolution, # {5}
        $this.Refresh,          # {6}
        $this.Bandwidth,        # {7}
        $this.Width,            # {8}
        $this.Height            # {9}

    Write-Output $out  # <-- ex. 32" 16:9 5120x2880 200% 93PPI (2560x1440) 120Hz 87gbps 93cm x 52cm
}
$obj | Add-Member -MemberType ScriptMethod -Name ToString -Value $ToString -Force

# finally return the object
Write-Output $obj

} #function