function ConvertTo-LayoutValues {
<#
.DESCRIPTION
    The mapping of the values from Get-ScreenSpec
    To the appropriate cells in the layout output
#>
[Alias('Map-LayoutValues')]
[OutputType([hashtable])]
param (
    [PSTypeName('Monitor.Specification')]
    $InputObject  # <-- Get-ScreenSpec ....
)

$this = $InputObject

@{
    B1Title = 'Specs'
    B2Title = 'Throughput'
    B3Title = 'Scaling'
    B4Title = 'Dimensions'
    B5Title = 'Degrees'

    B1R1C1 = 'Size'
    B1R2C1 = 'Ratio'
    B1R3C1 = 'Resolution'
    B1R4C1 = 'Scaling'
    B1R1C2 = '{0}"' -f $this.Size    
    B1R2C2 = $this.AspectRatio    
    B1R3C2 = $this.Resolution    
    B1R4C2 = '{0}%' -f $this.Scaling

    B2R1C1 = 'Color Depth'
    B2R2C1 = 'Refresh Rate'
    B2R3C1 = 'Bandwidth'
    B2R4C1 = 'FitsIn'
    B2R1C2 = '{0}bits' -f $this.Color
    B2R2C2 = '{0}hz'   -f $this.Refresh
    B2R3C2 = '{0}gbps' -f $this.Bandwidth
    B2R4C2 = $this.FitsIn -join ','

    B3R1C1 = ''
    B3R2C1 = 'HorizRes'
    B3R3C1 = 'VertRes'
    B3R4C1 = 'PPI'
    B3R5C1 = 'MegaPixel'
    B3R1C2 = 'Orig'
    B3R2C2 = $this.PixelsX       -as [string]
    B3R3C2 = $this.PixelsY       -as [string]
    B3R4C2 = $this.PixelsPerInch -as [string]
    B3R5C2 = $this.MegaPixel     -as [string]
    B3R1C3 = 'Scaled'
    B3R2C3 = $this.ScaledPixelsX -as [string]
    B3R3C3 = $this.ScaledPixelsY -as [string]
    B3R4C3 = $this.ScaledPPI     -as [string]
    B3R5C3 = $this.ScaledMP      -as [string]

    B4R1C1 = 'Size'
    B4R2C1 = 'Curve'
    B4R3C1 = 'Height'
    B4R4C1 = 'Width'
    B4R5C1 = 'Pitch'
    B4R1C2 = @{Name = '{0}in' -f $this.Size ; Link = $this.DisplayWarsUrl}
    B4R2C2 = if ($this.Curve -gt 0) {'{0}R' -f $this.Curve} else {'--'}
    B4R3C2 = '{0}cm' -f $this.Height
    B4R4C2 = '{0}cm' -f $this.Width
    B4R5C2 = '{0}mm' -f $this.PixelPitch

    B5R1C1 = 'Distance'
    B5R2C1 = 'PPD'
    B5R3C1 = 'HorizFoV'
    B5R4C1 = 'VertFov'
    B5R5C1 = ''
    B5R1C2 = '{0}cm' -f $this.Distance
    B5R2C2 = $this.PixelsPerDegree -as [string]
    B5R3C2 = '{0}°' -f $this.FovHorizontal
    B5R4C2 = '{0}°' -f $this.FovVertical
    B5R5C2 = ''
}

}