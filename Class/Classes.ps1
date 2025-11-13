enum FontStyle {
    Normal
    Italic
    Underline
}

enum ColorName {
    Blu
    Grn
    Ora
    Yel
    Red
    Mag
    Gra
    Wht
}

enum ColorTone {
    Norm
    Lite
    Dark    
}

enum BorderType {
    Single
    Double
    Bold
}


class Cell {
    [int]$Box
    [int]$Row
    [int]$Col  # <-- for Column

    # example usage [cell]::new('B3R2C1')
    # example usage [cell]::new(1,2,3)

    Cell ([string]$Position) {
        $Pattern  = '^B(?<Box>\d)R(?<Row>\d)C(?<Col>\d)$'
        $Regex    = [regex]::Match($Position,$Pattern)
        if (-not $Regex.Success) {throw 'Please enter a proper cell, ex. B3R2C1 for Box3 Row2 Col1'}
        $this.Box = $Regex.Groups['Box'].Value
        $this.Row = $Regex.Groups['Row'].Value
        $this.Col = $Regex.Groups['Col'].Value
    }
    Cell ([uint]$Box,[uint]$Row,[uint]$Col) {
        if ($Box -eq 0 -or $Box -ge 10) {throw 'Please enter a box number from 1 up to 9'}
        if ($Row -eq 0 -or $Row -ge 10) {throw 'Please enter a row number from 1 up to 9'}
        if ($Col -eq 0 -or $Col -ge 10) {throw 'Please enter a col number from 1 up to 9'}
        $this.Box = $Box
        $this.Row = $Row
        $this.Col = $Col
    }

    [string] ToString () {return ('B{0}R{1}C{2}' -f $this.Box,$this.Row,$this.Col)}
}

class CellItem {
    [Cell]$Position
    [string]$Name
    [ColorName]$Color
    [ColorTone]$Tone  = [ColorTone]::Norm
    [FontStyle]$Style = [FontStyle]::Normal
    [string]$Link
    [int]$Length

    CellItem () {}
    [string] ToString () {
        $Padding = $this.Length - $this.Name.Length
        $HasLink = -not [string]::IsNullOrWhiteSpace($this.Link)
        if ($HasLink) {$ThisName = "{0}]8;;{1}{0}\{2}{0}]8;;{0}\" -f [char]27,$this.Link,$this.Name}
        else          {$ThisName = $this.Name}
        if ($Padding -lt 0) {$Padding = 0}

        $ThisStyle  = $Script:Style[$this.Style.ToString()]
        $ThisColor  = $Script:Colour[$this.Tone.ToString()][$this.Color.ToString()]
        $out = '{0}{1}{2}{3}{4}' -f
            $ThisColor,        # 0
            $ThisStyle,        # 1
            $ThisName,         # 2
            "$([char]27)[0m",  # 3 (reset formatting)
            (' ' * $Padding)   # 4

        return $out
    }
}

class BoxLine {
    [int]$Box
    [int]$Row
    [string]$Txt

    BoxLine() {}
    [string] ToString() {return $this.Txt}
}

class BoxItem {
    [int]$BoxId
    [string]$BoxText

    BoxItem () {}

    [string] ToString () {return $this.BoxText}
}

class BoxMultiItem {
    [int]$MultiBoxLine
    [string]$MultiBoxText

    BoxMultiItem () {}
}

class BoxBorder {
    [int]   $BoxId
    [string]$Top
    [string]$Bottom
    [string]$Left
    [string]$Right
}

class BorderSpec {
    # id
    [int]$BoxId

    # title properties
    [string]   $TitleName
    [ColorName]$TitleColor
    [ColorTone]$TitleTone
    [FontStyle]$TitleStyle

    # box properties
    [int]$BoxLength
    [int]$BoxLeftSpace
    [int]$BoxRightSpace

    # border properties
    [ColorName] $BorderColor
    [ColorTone] $BorderTone
    [BorderType]$BorderType

    hidden [string] GetTopBar() {
        $TopBar = $this.BoxLength - (2 + $this.TitleName.Length)  # <-- Total_Length - (┌ + ┐ + Title_Length)

        $ThisBorderColor = $Script:Colour[$this.BorderTone.ToString()][$this.BorderColor.ToString()]
        $Icon            = $Script:Border[$this.BorderType.ToString()]

        $ThisTitleColor  = $Script:Colour[$this.TitleTone.ToString()][$this.TitleColor.ToString()]
        $ThisTitleStyle  = $Script:Style[$this.TitleStyle.ToString()]

        $Top = '{0}{1}{2}{3}{4}{8}{5}{6}{7}{8}' -f 
            $ThisBorderColor,             # 0
            $Icon.TopLeft,                # 1
            $ThisTitleColor,              # 2
            $ThisTitleStyle,              # 3
            $this.TitleName,              # 4
            $ThisBorderColor,             # 5
            ($Icon.Horizontal * $TopBar), # 6
            $Icon.TopRight,               # 7
            "$([char]27)[0m"              # 8 (reset formatting)
        
        return $Top
    }

    hidden [string] GetBottomBar() {
        $BottomBar = $this.BoxLength - 2  # <-- Total_Length - (└ + ┘)

        $ThisBorderColor = $Script:Colour[$this.BorderTone.ToString()][$this.BorderColor.ToString()]
        $Icon            = $Script:Border[$this.BorderType.ToString()]

        $Bottom = '{0}{1}{2}{3}{4}' -f
            $ThisBorderColor,                # 0
            $Icon.BottomLeft,                # 1
            ($Icon.Horizontal * $BottomBar), # 2
            $Icon.BottomRight,               # 3
            "$([char]27)[0m"                 # 4 (reset formatting)

        return $Bottom
    }

    hidden [string] GetLeftSide() {
        $ThisBorderColor = $Script:Colour[$this.BorderTone.ToString()][$this.BorderColor.ToString()]
        $Icon            = $Script:Border[$this.BorderType.ToString()]

        $Left = '{0}{1}{2}{3}' -f
            $ThisBorderColor,           # 0
            $Icon.Vertical,             # 1
            (' ' * $this.BoxLeftSpace), # 2
            "$([char]27)[0m"            # 3 (reset formatting)

        return $Left
    }

    hidden [string] GetRightSide() {
        $ThisBorderColor = $Script:Colour[$this.BorderTone.ToString()][$this.BorderColor.ToString()]
        $Icon            = $Script:Border[$this.BorderType.ToString()]

        $Right = '{0}{1}{2}{3}' -f
            (' ' * $this.BoxRightSpace), # 0
            $ThisBorderColor,            # 1
            $Icon.Vertical,              # 2
            "$([char]27)[0m"             # 3 (reset formatting)

        return $Right
    }

    [BoxBorder] ToBorder () {
        $out = [BoxBorder]@{
            BoxId  = $this.BoxId
            Top    = $this.GetTopBar()
            Bottom = $this.GetBottomBar()
            Left   = $this.GetLeftSide()
            Right  = $this.GetRightSide()
        }

        return $out
    }
}

class DataRate {
    static [double]$HDMI21_48    = 42.67  # <-- HDMI 2.1 48gbps
    static [double]$HDMI22_64    = 56.83  # <-- HDMI 2.2 64gbps
    static [double]$HDMI22_80    = 71.04  # <-- HDMI 2.2 80gbps
    static [double]$HDMI22_96    = 85.25  # <-- HDMI 2.2 96gbps
    static [double]$DP14_32      = 25.92  # <-- Display Port 1.4 32gbps
    static [double]$DP21_40      = 38.68  # <-- Display Port 2.1 UHBR10 40gbps
    static [double]$DP21_54      = 52.22  # <-- Display Port 2.1 UHBR13.5 54gbps
    static [double]$DP21_80      = 77.37  # <-- Display Port 2.1 UHBR20 80gbps
    static [double]$TB4_40       = 35.3   # <-- ThunderBolt 4 40gbps
    static [double]$TB5_80       = 70.6   # <-- ThunderBolt 5 80gbps
    static [double]$TB5_120      = 106    # <-- ThunderBolt 5 120gbps

    hidden DataRate () {}  # <-- hide the constructor from the end-user (though it can still be used)
}

class MonitorComparison {
    [string]$RealEstate
    [string]$MorePixels
    [string]$MoreClarity
    [string]$SmallerText
    [string]$Wider
    [string]$Taller
    [string]$WidthDiff
    [string]$HeightDiff
    [string]$PpiDiff

    MonitorComparison () {}

    [string] ToString () {
        $msg = [string]::Empty
        if ($this.MorePixels -eq 'Same number of pixels') {
            $msg = 'Both Screen A and Screen B have about the same number of pixels'
        }
        elseif ($this.MorePixels -eq 'Screen B (Difference Spec)') {
            $msg = '{0} has {1} more pixels than Screen A' -f $this.MorePixels, $this.RealEstate
        }
        elseif ($this.MorePixels -eq 'Screen A (Reference Spec)') {
            $msg = 'Screen B has {0} less pixels than {1}' -f $this.RealEstate,$this.MorePixels
        }
        return $msg
    }
}