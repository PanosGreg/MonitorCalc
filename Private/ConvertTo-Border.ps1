function ConvertTo-Border {
[OutputType('BorderSpec')]  # <-- an array of BorderSpecs
param (
    [Parameter(Mandatory)]
    [hashtable]$Values,   # <-- ex. ConvertTo-LayoutValues (Get-ScreenSpec)

    [hashtable]$LayoutSpec = $Script:Layout
)

$Format = $LayoutSpec['Format']

$List = $Values.Keys | where {$_ -like 'B?Title'}
$BorderList = foreach ($Key in $List) {  # <-- Keys are B1Title, B2Title, etc
    
    $BoxNumber = $Key.Replace('Title',$null)[1]
    $BoxId     = "Box$BoxNumber"        # ex. Box1, Box2, etc
    $BorderId  = "B${BoxNumber}Border"  # ex. B1Border, B2Border

    [BorderSpec]@{
        BoxId         = $BoxId.Replace('Box',$null) -as [int]
        TitleName     = $Values[$Key]
        TitleColor    = $Format[$Key]['ColorName']
        TitleTone     = $Format[$Key]['ColorTone']
        TitleStyle    = $Format[$Key]['FontStyle']

        BoxLength     = $Format['BoxProperties'][$BoxId]['Length']
        BoxLeftSpace  = $Format['BoxProperties'][$BoxId]['LeftSpace']
        BoxRightSpace = $Format['BoxProperties'][$BoxId]['RightSpace']

        BorderColor   = $Format[$BorderId]['ColorName']
        BorderTone    = $Format[$BorderId]['ColorTone']
        BorderType    = $Format[$BorderId]['LineType']
    }
}

# make sure each box has a unique id (by using a hashset)
$set = [System.Collections.Generic.Hashset[int]]::new()
$BorderList | foreach {
    if (-not $set.Add($_.BoxId)) {
        throw "Duplicate box id for 'Box$_', please amend the input values or input layout"
    }
}
$set.Clear()

Write-Output $BorderList
}