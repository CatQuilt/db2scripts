<#
.Synopsis
   This module will split the DDL output of a db2look command.
.DESCRIPTION
   This cmdlet will split the DDL ouput of a db2look command into 3 output files, a table file, a stored procedure file and other (for DB2 objects which are neither tables or stored procedures).
.EXAMPLE
   SplitDb2look -dbname dbxxx -delimiter '@'  
.EXAMPLE
   SplitDb2look -parm1 xxx -parm2 yyy  
.INPUTS
   The db2look file
.OUTPUTS
   The ddl files, dependent on which objects are in the database. Could be up to 14 files.
.NOTES
   General notes
.COMPONENT
   The component this cmdlet belongs to
.ROLE
   The role this cmdlet belongs to
.FUNCTIONALITY
   The functionality that best describes this cmdlet
#>
#
# LFlatley 12/17/2018

[CmdletBinding(DefaultParameterSetName='Parameter Set 1', 
                  SupportsShouldProcess=$true, 
                  PositionalBinding=$false,
                  HelpUri = 'http://www.microsoft.com/',
                  ConfirmImpact='Medium')]
    [Alias()]
    [OutputType([String])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=0,
                   ParameterSetName='Parameter Set 1')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
#       [ValidateCount(0,5)]
#       [ValidateSet("sun", "moon", "earth")] 
        $DBname,

        # Param2 help description
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=1,
				   ParameterSetName='Parameter Set 1')]
		[ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
#       [AllowNull()]
#       [AllowEmptyCollection()]
#       [AllowEmptyString()]
#       [ValidateScript({$true})]
#       [String]
        $Delimiter,

        # Param3 help description
        [Parameter(ParameterSetName='Another Parameter Set')]
        [ValidatePattern("[a-z]*")]
        [ValidateLength(0,15)]
        [String]
        $Param3
        )

$InputPath = "C:\DB2_ADMIN\"
$InputFile = $InputPath + "db2look_staging_output3.txt"

$OutputPath = "C:\TEMP\"
#$OutputFile = $OutputPath + "db2look_staging_output3.txt"

$Content = Get-Content -Path $InputFile -raw

#$SPContent = $Content -replace "END P1;", "END P1@"
#$SPContent | Set-Content "c:\temp\test_db2look_data1.txt"

$SPContent = ($Content -replace "-- DDL Statements for ", "JUNK -- DDL Statements for ") -replace "-- Authorization Statements ", "JUNK -- Authorization Statements "
#$SPContent | Set-Content "c:\temp\test_db2look_data2.txt"

$arr = $SPContent -split 'JUNK '

$TableOutput = $OutputPath + $dbname  + "_db2look_table_data.sql"
$StprocOutput = $OutputPath + $dbname  + "_db2look_stproc_data.sql"
$AuthOutput = $OutputPath + $dbname  + "_db2look_auth_data.sql"
$OtherOutput = $OutputPath + $dbname  + "_db2look_other_data.sql"
$BuffOutput = $OutputPath + $dbname  + "_db2look_buff_data.sql"
$TblspOutput = $OutputPath + $dbname  + "_db2look_tblsp_data.sql"
$SchemaOutput = $OutputPath + $dbname  + "_db2look_schema_data.sql"
$SequenceOutput = $OutputPath + $dbname  + "_db2look_sequence_data.sql"
$ConstraintOutput = $OutputPath + $dbname  + "_db2look_constraint_data.sql"
$IndexOutput = $OutputPath + $dbname  + "_db2look_index_data.sql"
$NicknameOutput = $OutputPath + $dbname  + "_db2look_nickname_data.sql"
$UdfOutput = $OutputPath + $dbname  + "_db2look_udf_data.sql"
$ViewOutput = $OutputPath + $dbname  + "_db2look_view_data.sql"
$TriggerOutput = $OutputPath + $dbname  + "_db2look_trigger_data.sql"

Set-Content -Path $TableOutput -Value "-- tables" -Force
Set-Content -Path $StprocOutput -Value "-- stored procs" -Force
Set-Content -Path $AuthOutput -Value "-- authorizations" -Force
Set-Content -Path $OtherOutput -Value "-- other" -Force
Set-Content -Path $BuffOutput -Value "-- bufferpool" -Force
Set-Content -Path $TblspOutput -Value "-- tablespace" -Force
Set-Content -Path $SchemaOutput -Value "-- schema" -Force
Set-Content -Path $SequenceOutput -Value "-- sequence" -Force
Set-Content -Path $ConstraintOutput -Value "-- constraint" -Force
Set-Content -Path $IndexOutput -Value "-- index" -Force
Set-Content -Path $NicknameOutput -Value "-- nickname" -Force
Set-Content -Path $UdfOutput -Value "-- udf" -Force
Set-Content -Path $ViewOutput -Value "-- view" -Force
Set-Content -Path $TriggerOutput -Value "-- trigger" -Force

Write-Host "Number of ddl objects " $arr.Count #print count of items in the array
$i = 0

foreach ($element in $arr) {
  
  if ($element -Like '*DDL Statements for Table *')
  {
#    Write-Host "found DDL Statements for Table "
     $element | Add-Content -Path $TableOutput
  }

  elseif ($element -Like '*DDL Statements for Stored Procedures*')
  {
#    Write-Host "found DDL Statements for Stored Procedures "
     $element | Add-Content -Path $StprocOutput
  }

    elseif ($element -Like '*-- Authorization Statements*')
  {
#    Write-Host "found DDL Statements for Authorizations "
     $element | Add-Content -Path $AuthOutput
  }

    elseif ($element -Like '*-- DDL Statements for Indexes*')
  {
#    Write-Host "found DDL Statements for Indexes "
     $element | Add-Content -Path $IndexOutput
  }

    else 
  {
#    Write-Host "found other "
     $element | Add-Content -Path $OtherOutput
  }
  $i += 1 
}

$EndSP = 'END P1' + $Delimiter

((Get-Content -path $StprocOutput -Raw) -replace 'END P1;',$EndSP) | Set-Content -Path $StprocOutput
