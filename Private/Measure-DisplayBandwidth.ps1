function Measure-DisplayBandwidth {
[OutputType([string])]
[cmdletbinding()]
param (
    [Parameter(Mandatory)]
    [double]$Bandwidth
)

$DataRates = $Script:Cables['DataRates']
$CommonDisplayInterfaces = $DataRates.Keys | where {$_ -ne 'GPMI'} | Sort-Object

foreach ($DisplayInterface in $CommonDisplayInterfaces) {
    $SortedDataRates = $DataRates[$DisplayInterface].GetEnumerator() | Sort-Object Value
    foreach ($ThisDataRate in $SortedDataRates) {
        if ($Bandwidth -le $ThisDataRate.Value) {
            $ThisDataRate.Key
            break
        }
    }
}

}