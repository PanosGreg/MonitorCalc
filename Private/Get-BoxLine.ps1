function Get-BoxLine {
<#
.EXAMPLE
#>
[OutputType('BoxLine')]
param (
    [CellItem[]]$Cell  # <-- the assumption here is that you'll feed cells into this function
)                      #     that are for the same box

# group the cells per row and then sort them per column
foreach ($BoxGroup in ($Cell | Group-Object {$_.Position.Box})) {
    foreach ($RowGroup in ($BoxGroup.Group | Group-Object {$_.Position.Row})) {
        $SingleRow = $RowGroup.Group | Sort-Object {$_.Position.Col} | foreach {$_.ToString()}
        [BoxLine] @{
            Box = $BoxGroup.Name -as [int]
            Row = $RowGroup.Name -as [int]
            Txt = $SingleRow -join ''
        } #the entire line of a single row (all the columns joined of a single row)
    } #foreach row in a box
} #foreach box

}