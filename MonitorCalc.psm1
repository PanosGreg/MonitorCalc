
#region Get all the files we need to load

# helper function for use within the .psm1 file
function script:Get-ModuleName {
    $MyInvocation.MyCommand.Module.Name
}

$ModName = Get-ModuleName
$ModFile = $MyInvocation.MyCommand.Path
$ManFile = [System.IO.Path]::ChangeExtension($ModFile,'.psd1')

# get all the file names listed in the manifest
# this also checks that the .psd1 file exists
$FileList = (Import-PowerShellDataFile -Path $ManFile -EA Stop).FileList

# make sure there's at least one file to load
if (([array]$FileList).Count -eq 0) {
    Write-Warning 'Could NOT find any file names in the "FileList" property of the .psd1 manifest'
    Write-Warning 'Please edit the .psd1 manifest to explicitly include all the files of this module in the "FileList" property'
    Write-Warning "The module $ModName was NOT loaded properly"    
    return
}

# now get the module files (this also checks that the files exist)
$ModuleFiles = $FileList | foreach {
    Get-Item -Path (Join-Path $PSScriptRoot $_) -EA Stop
}

# filter all the PowerShell and CSharp files
$PSFunctions = $ModuleFiles | where {$_.Extension -eq '.ps1'  -and $_.Directory.Name -match 'Public|Private'}
$CSharpLibs  = $ModuleFiles | where {$_.Extension -eq '.cs'   -and $_.Directory.Name -eq 'Class'}
$PSModules   = $ModuleFiles | where {$_.Extension -eq '.psm1' -and $_.Directory.Name -eq 'Class'}
$PSClasses   = $ModuleFiles | where {$_.Extension -eq '.ps1'  -and $_.Directory.Name -eq 'Class'}
$PSDataList  = $ModuleFiles | where {$_.Extension -eq '.psd1' -and $_.Directory.Name -eq 'Data'}
if (Test-Path "$PSScriptRoot\Data\ClassReferences.psd1") {
    $CSLibRefs = (Import-PowerShellDataFile -Path "$PSScriptRoot\Data\ClassReferences.psd1")['AddType']
}

#endregion


# Load PowerShell classes
if (([array]$PSModules).Count -ge 1) {
    $UsingText = ($PSModules.FullName | foreach {"using module '$_'"}) -join "`n"
    . ([scriptblock]::Create($UsingText))
    # load any classes via the using statement in order to be able to use them within the module
}
foreach ($PSClass in $PSClasses) {
    Try {
        . $PSClass.FullName
    }
    Catch {
        $msg = "Failed to import PowerShell class $($PSClass.FullName)"
        Write-Error -Message $msg
        Write-Error $_ -ErrorAction Stop
    }
}

# Load the C# Classes & Enumerations
# Note: this needs to be done before loading the functions
Foreach ($File in $CSharpLibs) {
    Try {
        $RefsList = ($CSLibRefs | where File -eq (Split-Path $File.FullName -Leaf)).Refs
        
        if ($RefsList) {
            $Refs = $RefsList | foreach {Invoke-Expression -Command $_}        
            Add-Type -Path $File.FullName -ReferencedAssemblies $Refs -ErrorAction Stop
        }
        else {Add-Type -Path $File.FullName -ErrorAction Stop}
    }
    Catch {
        $msg = "Failed to import types from $($File.FullName)"
        Write-Error -Message $msg
        Write-Error $_ -ErrorAction Stop
    }
}

# Load the functions
Foreach($Import in $PSFunctions) {
    Try {
        . $Import.FullName
    }
    Catch {
        $msg = "Failed to import function $($Import.FullName)"
        Write-Error -Message $msg
        Write-Error $_ -ErrorAction Stop
    }
}

# set some defaults
#$PSDefaultParameterValues = @{
#}

# internal module variables
$Script:Style  = Import-PowerShellDataFile "$PSScriptRoot\Data\FontStyles.psd1"
$Script:Border = Import-PowerShellDataFile "$PSScriptRoot\Data\BorderLines.psd1"
$Script:Layout = Import-PowerShellDataFile "$PSScriptRoot\Data\OutputLayout.psd1"
$Script:Cables = Import-PowerShellDataFile "$PSScriptRoot\Data\DisplayInterfaces.psd1"
$Script:Names  = Import-PowerShellDataFile "$PSScriptRoot\Data\ResolutionNames.psd1"
$Script:Colour = @{}  # <-- colors
$Data = Import-PowerShellDataFile "$PSScriptRoot\Data\ColorPalettes.psd1"
foreach ($ThisTone in $Data.Keys) {
    $Script:Colour.Add($ThisTone,@{})
    foreach ($ThisColor in $Data[$ThisTone].Keys) {
        $C = $Data[$ThisTone][$ThisColor]
        $Script:Colour[$ThisTone].Add($ThisColor,("$([char]27)[38;2;{0};{1};{2}m" -f $C['R'],$C['G'],$C['B']))
    }
}

# cache where we store the results of the last command
[System.Collections.Generic.List[object]]$Script:Cache = [System.Collections.Generic.List[object]]::new()
  # Note: I mainly do this in case the user forgot to save the results into a variable

# Static Data
foreach ($DataFile in $PSDataList) {
    $Value = (Import-PowerShellDataFile -Path $DataFile.FullName)[$DataFile.BaseName]
    New-Variable -Scope Script -Name $DataFile.BaseName -Value $Value
}

# Module manifest & folder
[hashtable]$Script:ModuleManifest = Import-PowerShellDataFile -Path $ManFile
[string]$Script:ModulePath        = (Resolve-Path (Split-Path $ManFile)).Path

# small function to get the internal cache
function Get-LatestFetch() {

if ($Script:Cache.Count -eq 0) {
    Write-Warning 'The cache is empty.'
}
else {$Script:Cache.ToArray()}
}
