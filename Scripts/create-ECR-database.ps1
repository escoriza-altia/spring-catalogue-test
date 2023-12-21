param(
    [parameter(Mandatory = $true,Position = 0)][string] $ECRName      = "",
    [parameter(Mandatory = $true,Position = 1)][string] $ECRstackName = ""
)

$ECRstackcreation = "aws cloudformation create-stack --stack-name $ECRstackName --template-body 'file://..\Templates\aws ecr repository template.json' --parameters ParameterKey=repositoryName,ParameterValue=$ECRName"
$ECRstack = Invoke-Expression -Command $ECRstackcreation | ConvertFrom-Json
$proceed = $true
while ($true) {
    $proceedString = Invoke-Expression -Command "aws cloudformation describe-stack-events --stack-name $ECRstackName" | ConvertFrom-Json
    if($proceedString.StackEvents[0].ResourceStatus -eq "CREATE_COMPLETE") {
        break;
    } elseif($proceedString.StackEvents[0].ResourceStatus -eq "DELETE_COMPLETE") {
        $proceed = $false
        break;
    } else {
        Start-Sleep -Seconds 1
    }
}
if(!$proceed) {
    Write-Output "Database system creation failed with Errorcode 3. A Stack for ECR services could not be created, please check your permissions to do so. For more please refer to the ReadMe File."
    $Errorcode = 3
    $temp = Invoke-Expression -Command "./error-script.ps1 $Errorcode '' '' $ECRstackName"
    Exit
}
$GetECRInfo = "aws ecr describe-repositories --repository-names $ECRName"
$ECRJson = Invoke-Expression -Command $GetECRInfo | ConvertFrom-Json
$imageRepository = $ECRJson.repositories[0].repositoryUri
return $imageRepository