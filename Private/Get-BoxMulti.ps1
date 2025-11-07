function Get-BoxMulti {
[OutputType('BoxMultiItem')]
[cmdletbinding()]
param (
    [BoxItem[]]$Box,

    [hashtable]$LayoutSpec = $Script:Layout
)

$MultiSpec = $LayoutSpec['Format']['BoxMulti'] | Sort-Object -Property MultiBoxLine

foreach ($Multi in $MultiSpec) {
    # get the specific boxes for this line
    $ThisBoxes = foreach ($BoxId in $Multi.Boxes) {
        $Box | where BoxId -eq $BoxId
    }

    # for each line, concatenate the text from each box
    $Boxes = [System.Collections.Generic.List[string[]]]::new() # <-- each item in the list is an array of strings
    $ThisBoxes.BoxText | foreach {$Boxes.Add($_.Split("`n"))}

    $Height   = $Boxes[0].Count -1   # <-- get the height from the 1st box
    $MultiBox = foreach ( $Line in ( 0..$Height ) ) {
        ($Boxes | foreach {$_[$Line]}) -join ''
    }

    [BoxMultiItem] @{
        MultiBoxLine = $Multi.MultiBoxLine
        MultiBoxText = $MultiBox -join "`n"
    }
}

}