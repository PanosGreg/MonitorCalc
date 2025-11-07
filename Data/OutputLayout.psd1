# The Layout and Formatting of the output


# Dimensions: 13 lines x 63 columns (total)

# 5 boxes, each box has its own length
# the height of the box is determined by the number of lines of content that it's in there

<# This is how the Template looks like when rendered in the console:

┌Box1────────────────────┐┌Box2───────────────────────────────┐
│ Box1Col1   Box1Col2    ││ Box2Col1     Box2Col2             │
│ Box1Col1   Box1Col2    ││ Box2Col1     Box2Col2             │
│ Box1Col1   Box1Col2    ││ Box2Col1     Box2Col2             │
│ Box1Col1   Box1Col2    ││ Box2Col1     Box2Col2             │
└────────────────────────┘└───────────────────────────────────┘
┌Box3────────────────────┐┌Box4────────────┐┌Box5─────────────┐
│ Box3Col1  Col2  Col3   ││ Col1   Col2    ││ Box5Col1  Col2  │
│ Box3Col1  Col2  Col3   ││ Col1   Col2    ││ Box5Col1  Col2  │
│ Box3Col1  Col2  Col3   ││ Col1   Col2    ││ Box5Col1  Col2  │
│ Box3Col1  Col2  Col3   ││ Col1   Col2    ││ Box5Col1  Col2  │
│ Box3Col1  Col2  Col3   ││ Col1   Col2    ││ Box5Col1  Col2  │
└────────────────────────┘└────────────────┘└─────────────────┘
#>


## The data for this template

@{
Format = @{   # BnRnCn = Box n , Row n , Column n
    Default  = @{
        Col1 = @{ColorName = 'Gra' ; ColorTone = 'Lite' ; FontStyle = 'Normal'}
        Col2 = @{ColorName = 'Wht' ; ColorTone = 'Norm' ; FontStyle = 'Normal'}
        Col3 = @{ColorName = 'Wht' ; ColorTone = 'Norm' ; FontStyle = 'Normal'}
        Highlight = @{ColorName = 'Grn' ; ColorTone = 'Lite' ; FontStyle = 'Normal'}
    }

    BoxProperties = @{
        Box1 = @{Length = 26 ; LeftSpace = 1 ; RightSpace = 0}
        Box2 = @{Length = 37 ; LeftSpace = 1 ; RightSpace = 0}
        Box3 = @{Length = 26 ; LeftSpace = 1 ; RightSpace = 0}
        Box4 = @{Length = 18 ; LeftSpace = 1 ; RightSpace = 0}
        Box5 = @{Length = 19 ; LeftSpace = 1 ; RightSpace = 0}
    }

    BoxMulti = @(
        @{MultiBoxLine = 1 ; Boxes = 1,2}   # <-- order in "Boxes" matters
        @{MultiBoxLine = 2 ; Boxes = 3,4,5}
    )

    ColumnLength = @{
        B1C1 = 11
        B1C2 = 12
        B2C1 = 13
        B2C2 = 21
        B3C1 = 10
        B3C2 = 6
        B3C3 = 7
        B4C1 = 7
        B4C2 = 8
        B5C1 = 10
        B5C2 = 6
    }

    # Box 1 Formats
    B1Border = @{ColorName = 'Blu' ; ColorTone = 'Norm' ; LineType  = 'Single'}
    B1Title  = @{ColorName = 'Blu' ; ColorTone = 'Norm' ; FontStyle = 'Normal'}
    B1R1C2   = @{ColorName = 'Blu' ; ColorTone = 'Lite' ; FontStyle = 'Normal'}
    B1R2C2   = @{ColorName = 'Blu' ; ColorTone = 'Lite' ; FontStyle = 'Normal'}
    B1R3C2   = @{ColorName = 'Blu' ; ColorTone = 'Lite' ; FontStyle = 'Normal'}
    B1R4C2   = @{ColorName = 'Blu' ; ColorTone = 'Lite' ; FontStyle = 'Normal'}

    # Box 2 Formats
    B2Border = @{ColorName = 'Mag' ; ColorTone = 'Dark' ; LineType  = 'Single'}
    B2Title  = @{ColorName = 'Mag' ; ColorTone = 'Lite' ; FontStyle = 'Normal'}
    B2R3C2   = @{IsHighlighted = $true ; FontStyle = 'Normal'}

    # Box 3 Formats
    B3Border = @{ColorName = 'Grn' ; Colortone = 'Norm' ; LineType  = 'Single'}
    B3Title  = @{ColorName = 'Grn' ; Colortone = 'Norm' ; FontStyle = 'Normal'}
    B3R1C2   = @{ColorName = 'Gra' ; Colortone = 'Lite' ; FontStyle = 'Underline'}
    B3R1C3   = @{ColorName = 'Gra' ; Colortone = 'Lite' ; FontStyle = 'Underline'}
    B3R2C3   = @{IsHighlighted = $true ; FontStyle = 'Normal'}
    B3R3C3   = @{IsHighlighted = $true ; FontStyle = 'Normal'}
    B3R4C3   = @{IsHighlighted = $true ; FontStyle = 'Normal'}
    
    # Box 4 Formats
    B4Border = @{ColorName = 'Mag' ; ColorTone = 'Dark' ; LineType  = 'Single'}
    B4Title  = @{ColorName = 'Mag' ; ColorTone = 'Lite' ; FontStyle = 'Normal'}
    B4R3C2   = @{IsHighlighted = $true ; FontStyle = 'Normal'}

    # Box 5 Formats
    B5Border = @{ColorName = 'Mag' ; ColorTone = 'Dark' ; LineType  = 'Single'}
    B5Title  = @{ColorName = 'Mag' ; ColorTone = 'Lite' ; FontStyle = 'Normal'}
} #Format

} #main hashtable