function Get-Box {
[OutputType('BoxItem')]
[CmdletBinding()]
param (
    [BoxLine[]]$Line,
    [BoxBorder[]]$Border
)

foreach ($BoxId in $Border.BoxId) {
    # get the lines for the current box
    $LineItems = $Line | where Box -eq $BoxId

    # get the border for the current box
    $BorderItem = $Border | where BoxId -eq $BoxId

    # get the middle lines of the box (as-in all lines except top & bottom)
    $LineList = foreach ($ThisLine in $LineItems) {
        '{0}{1}{2}' -f $BorderItem.Left,$ThisLine.Txt,$BorderItem.Right
    }
    $MiddleLines = $LineList -join "`n"

    # output the full box
    $Box = "{0}`n{1}`n{2}" -f 
        $BorderItem.Top,    # 0
        $MiddleLines,       # 1
        $BorderItem.Bottom  # 2

    [BoxItem] @{
        BoxId   = $BoxId
        BoxText = $Box
    }
}

}