function ConvertTo-Cell {
[OutputType('CellItem')]  # <-- an array of CellItems
[cmdletbinding()]
param (
    [Parameter(Mandatory)]
    [hashtable]$Values,   # <-- ex. ConvertTo-LayoutValues (Get-ScreenSpec)

    [hashtable]$LayoutSpec = $Script:Layout
)

$Format = $LayoutSpec['Format']

$List = $Values.Keys | where {$_ -like 'B?R?C?'}
foreach ($Key in $List) {
    
    $Position = [Cell]$Key
    $CellPos  = $Key
        
    if ($Values[$Key]['Link']) {
        $Name = $Values[$Key]['Name']
        $Link = $Values[$Key]['Link']
    }
    else {
        $Name = $Values[$Key]
        $Link = $null
    }

    # get the formatting
    if ($Format[$CellPos] -and $Format[$CellPos]['IsHighlighted']) {
        $Color = $Format['Default']['Highlight']['ColorName']
        $Tone  = $Format['Default']['Highlight']['ColorTone']
        $Style = $Format[$CellPos]['FontStyle']
    }
    elseif ($Format[$CellPos]) {
        $Color = $Format[$CellPos]['ColorName']
        $Tone  = $Format[$CellPos]['ColorTone']
        $Style = $Format[$CellPos]['FontStyle']
    }
    else {  # <-- there is no special formatting for this cell, so apply the default format
        $ColumnId = 'Col{0}' -f $Position.Col
        $Color = $Format['Default'][$ColumnId]['ColorName']
        $Tone  = $Format['Default'][$ColumnId]['ColorTone']
        $Style = $Format['Default'][$ColumnId]['FontStyle']
    }

    $BoxCol = 'B{0}C{1}' -f $Position.Box,$Position.Col
    $Length = $Format['ColumnLength'][$BoxCol]

    if ($Name.Length -gt $Length) {
        $Name = $Name.Substring(0,$Length-1) + '…'
    }

    [CellItem] @{
        Position = $Position
        Name     = $Name
        Color    = $Color
        Tone     = $Tone
        Style    = $Style
        Link     = $Link
        Length   = $Length
    }
}

}