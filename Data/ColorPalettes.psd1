
# Color Specs for Red,Green,Blue (RGB)
# Could not find exact ones from [System.Drawing.Color] , so I did my own color palette
# Nor could I find them in $PSStyle (PSv7+) , so again I opted to do this color palette

@{    
    # Normal Colors
    Norm = @{
        Blu = @{R =  61 ; G = 148 ; B = 243} # <-- Blue
        Grn = @{R = 146 ; G = 208 ; B =  80} # <-- Green
        Ora = @{R = 255 ; G = 126 ; B =   0} # <-- Orange
        Yel = @{R = 240 ; G = 230 ; B = 140} # <-- Yellow
        Red = @{R = 231 ; G =  72 ; B =  86} # <-- Red
        Mag = @{R = 254 ; G = 140 ; B = 255} # <-- Magenta
        Gra = @{R = 128 ; G = 128 ; B = 128} # <-- Gray
        Wht = @{R = 233 ; G = 232 ; B = 235} # <-- White
    }

    # Lite Colors
    Lite = @{
        Blu = @{R = 153 ; G = 204 ; B = 255}
        Grn = @{R = 139 ; G = 231 ; B = 139}
        Ora = @{R = 255 ; G = 179 ; B = 102}
        Yel = @{R = 248 ; G = 248 ; B =   0}
        Red = @{R = 232 ; G =  82 ; B =  83}
        Mag = @{R = 247 ; G = 179 ; B = 247}
        Gra = @{R = 192 ; G = 192 ; B = 176}
        Wht = @{R = 253 ; G = 252 ; B = 255}
    }

    # Dark Colors
    Dark = @{
        Blu = @{R =  68 ; G = 114 ; B = 196}
        Grn = @{R =   0 ; G = 128 ; B =   0}
        Ora = @{R = 191 ; G =  96 ; B =   0}
        Yel = @{R = 148 ; G = 148 ; B =   0}
        Red = @{R = 124 ; G =  35 ; B =  35}
        Mag = @{R = 153 ; G =  51 ; B = 255}
        Gra = @{R =  80 ; G =  80 ; B =  80}
        Wht = @{R = 213 ; G = 212 ; B = 215}
    }
}