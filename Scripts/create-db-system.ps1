<# Set all parameters for Cloudformations create-stack #>
param(
[parameter(Mandatory = $true,Position = 0)][string] $dbName           = "",
[parameter(Mandatory = $true,Position = 1)][string] $masterUser       = "",
[parameter(Mandatory = $true,Position = 2)][string] $masterPassword   = "",
[parameter(Mandatory = $false,Position = 3)][string] $imageRepository = "",
[parameter(Mandatory = $false,Position = 4)][string] $containerName   = "SpringContainer",
[parameter(Mandatory = $false,Position = 5)][string] $clusterName     = "TestingSpringAQuarkus",
[parameter(Mandatory = $false,Position = 6)][string] $ECRName         = "dockerrepository"


)

$RDSstackName = "PostgreSQLdb"
$ECSstackName = "ECSinstance"
$ECRstackName = "ECRinstance"
$containerPortBinding  = 8080

Write-Output "========================================="
Write-Output "Executing script can take up to 20 Minutes..."
Write-Output " ____   ____    ___  _  _  ___  ____  ____  __  __ "
Write-Output "(  _ \ (  _ \  / __)( \/ )/ __)(_  _)( ___)(  \/  )"
Write-Output " )(_) ) ) _ <  \__ \ \  / \__ \  )(   )__)  )    ( "
Write-Output "(____/ (____/  (___/ (__) (___/ (__) (____)(_/\/\_)"
Write-Output " _____  _  _       ____   ____  __  __    __    _  _  ____  "
Write-Output "(  _  )( \( ) ___ (  _ \ ( ___)(  \/  )  /__\  ( \( )(  _ \ "
Write-Output " )(_)(  )  ( (___) )(_) ) )__)  )    (  /(__)\  )  (  )(_) )"
Write-Output "(_____)(_)\_)     (____/ (____)(_/\/\_)(__)(__)(_)\_)(____/ "
Write-Output ""
Write-Output "v.13.2.1"
Write-Output "========================================="
Write-Output "Starting Database System creation"

<# Establish Private-Links#>
Write-Output "Create PrivateLinks"
$pl = Invoke-Expression -Command "./create-VPC-PrivateLinks.ps1"
Write-Output "Creating PrivateLinks successful"

<# ECR Repository creation #>
if($imageRepository -eq "") {
    Write-Output "Create ECR-Repository"
    $imageRepository = Invoke-Expression -Command "./create-ECR-database.ps1 $ECRName $ECRstackName"
    Write-Output "Creating ECR-Repository successful"
}

<# Create Database Stack with given Values#>
Write-Output "Create Database: $dbName"
$RDSstackcreation = "aws cloudformation create-stack --stack-name $RDSstackName --template-body file://..\Templates\PostgreSQLTemplateCF.json --parameters ParameterKey=DBNameP,ParameterValue=$dbName ParameterKey=MUser,ParameterValue=$masterUser ParameterKey=MPass,ParameterValue=$masterPassword"
$result = Invoke-Expression -Command $RDSstackcreation

<# Wait till Database reached a stable runtime and check every second #>
<# In case of an unexpected Delete set proceeding to false #>
$proceed = $true
while ($true) {
    $proceedString = Invoke-Expression -Command "aws cloudformation describe-stack-events --stack-name $RDSstackName" | ConvertFrom-Json
    if($proceedString.StackEvents[0].ResourceStatus -eq "CREATE_COMPLETE") {
        break;
    } elseif($proceedString.StackEvents[0].ResourceStatus -eq "DELETE_COMPLETE") {
        $proceed = $false
        break;
    } else {
        Start-Sleep -Seconds 1
    }
}

<# Stack creation failed and an error script will solve all dependencies up until this point #>
if(!$proceed) {
    Write-Output "Database system creation failed with Errorcode 1. A Stack for RDS services could not be created, please check your permissions to do so. Also check if a mandatory DB name, master user and master password have been set. For more please refer to the ReadMe File."
    $Errorcode = 1
    $temp = Invoke-Expression -Command "./error-script.ps1 $Errorcode $RDSstackName $ECSstackName $ECRstackName"
    Exit
}
Write-Output "Database Stack created"

<# After creation get IP-Address of database for later purposes and to print to Console #>
$RDSstack = "aws rds describe-db-instances --db-instance-identifier MyDBInstance-eu-west-1"
$RDSinstance = Invoke-Expression -Command $RDSstack
$RDSinstance = $RDSinstance | ConvertFrom-Json
$DBAddress = $RDSinstance.DBInstances[0].Endpoint.Address
$DBPort = $RDSinstance.DBInstances[0].Endpoint.Port
$DBAddress2 = "$DBAddress" +  ":$DBPort"
$DBAddress3 = "jdbc:postgresql://mydbinstance-eu-west-1.czghri173swc.eu-west-1.rds.amazonaws.com" + ":5432/$dbName"

<# Change Connection data in spring #>
$replacePath = "..\containerizeSpring\src\main\resources\application.properties"
$newFile = Get-Content ..\containerizeSpring\src\main\resources\application.properties | ForEach-Object{
    $_ -replace 'DB',$DBAddress3
}
$newFile | Set-Content ..\containerizeSpring\src\main\resources\application.properties
$newFile = Get-Content ..\containerizeSpring\src\main\resources\application.properties | ForEach-Object{
    $_ -replace 'UNAME',$masterUser
}
$newFile | Set-Content ..\containerizeSpring\src\main\resources\application.properties
$newFile = Get-Content ..\containerizeSpring\src\main\resources\application.properties | ForEach-Object{
    $_ -replace 'PWORD',$masterPassword
}
$newFile | Set-Content ..\containerizeSpring\src\main\resources\application.properties

<# Image Handling #>
cd ..\containerizeSpring\
$login = Invoke-Expression -Command "aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin $imageRepository"
Write-Output $login
$build = Invoke-Expression -Command "./mvnw package"
$docker = Invoke-Expression -Command "docker build -f Dockerfile -t $ECRName ."
$tagCommand = "docker tag $ECRName" + ":latest $imageRepository"
Invoke-Expression -Command $tagCommand

<# Reset Connection data to placeholder #>
$replacePath = "src\main\resources\application.properties"
$newFile = Get-Content src\main\resources\application.properties | ForEach-Object{
    $_ -replace "spring.datasource.url=$DBAddress3",'spring.datasource.url=DB'
}
$newFile | Set-Content src\main\resources\application.properties
$newFile = Get-Content src\main\resources\application.properties | ForEach-Object{
    $_ -replace "spring.datasource.username=$masterUser",'spring.datasource.username=UNAME'
}
$newFile | Set-Content src\main\resources\application.properties
$newFile = Get-Content src\main\resources\application.properties | ForEach-Object{
    $_ -replace "spring.datasource.password=$masterPassword",'spring.datasource.password=PWORD'
}
$newFile | Set-Content src\main\resources\application.properties

$pushECRCommand = "docker push $imageRepository"
Invoke-Expression -Command $pushECRCommand
cd ..\Scripts\

<# Create ECS cluster and TaskDefinition with given or default values #>
Write-Output "Create ECS: -Cluster $clusterName -TaskDefinition with container $containerName"
$ECSstackcreation = "aws cloudformation create-stack --stack-name $ECSstackName --template-body 'file://..\Templates\AWS ECS Cluster and Taskdefinition Template.json' --parameters ParameterKey=containerName,ParameterValue=$containerName ParameterKey=imageRepository,ParameterValue=$imageRepository ParameterKey=clusterName,ParameterValue=$clusterName"
$result = Invoke-Expression -Command $ECSstackcreation

<# Wait till ECS reached a stable runtime and check every second #>
<# In case of an unexpected Delete set proceeding to false #>
$proceed = $true
while ($true) {
    $proceedString = Invoke-Expression -Command "aws cloudformation describe-stack-events --stack-name $ECSstackName" | ConvertFrom-Json
    if($proceedString.StackEvents[0].ResourceStatus -eq "CREATE_COMPLETE") {
        break;
    } elseif($proceedString.StackEvents[0].ResourceStatus -eq "DELETE_COMPLETE") {
        $proceed = $false
        break;
    } else {
        Start-Sleep -Seconds 1
    }
}

<# Stack creation failed and an error script will solve all dependencies up until this point #>
if(!$proceed) {
    Write-Output "Database system creation failed with Errorcode 2. For more please refer to the ReadMe File."
    $Errorcode = 2
    $temp = Invoke-Expression -Command "./error-script.ps1 $Errorcode $RDSstackName $ECSstackName $ECRstackName"
    Exit
}
Write-Output "ECS Stack created"

<# Get TaskDefinition name of Springtask #>
$Alltasks = "aws ecs list-task-definitions"
$taskNames = Invoke-Expression -Command $Alltasks | ConvertFrom-Json
$taskNames = $taskNames.taskDefinitionArns
$TaskDefName = ""
for ($i = 0; $i -lt $taskNames.Count; $i++) {
    if($taskNames[$i].Contains("Springtask")) {
        $TaskDefName = $taskNames[$i]
        break
    }
}

<# Get Cluster name #>
$Allclusters = "aws ecs describe-clusters --cluster $clusterName"
$clusterNames = Invoke-Expression -Command $Allclusters | ConvertFrom-Json
$clusterNames = $clusterNames.clusters
$Cluster = ""
for ($i = 0; $i -lt $clusterNames.Count; $i++) {
    if($clusterNames[$i].clusterArn.Contains($clusterName)) {
        $Cluster = $clusterNames[$i].clusterArn
        break
    }
}

<# Create new Service running Task of TaskDefininition #>
Write-Output "Create Service springMicroservice running Tasks"
$serviceName = "springMicroservice"
$serviceCall = "aws ecs create-service --cluster $Cluster --service-name $serviceName --launch-type FARGATE --task-definition $TaskDefName --desired-count 1 --network-configuration 'awsvpcConfiguration={subnets=[subnet-04a0bce6c85944231],securityGroups=[sg-025c880d7fa486270],assignPublicIp=ENABLED}'"
$newService = Invoke-Expression -Command $serviceCall | ConvertFrom-Json
$waitCommand = "aws ecs wait services-stable --cluster $Cluster --services $serviceName"
$wait = Invoke-Expression -Comman $waitCommand
Write-Output "Service created and waiting for Task to be running"

<# Get Task ID #>
Start-Sleep -Seconds 5
$getTask = Invoke-Expression -Command "aws ecs describe-services --services $serviceName --cluster $Cluster" | ConvertFrom-Json
$taskID = $getTask.services.events[$getTask.services.events.Count-1].message -split " "
$taskID = $taskID[7].substring(0, $taskID[7].Length - 2)
$waitCommand = "aws ecs wait tasks-running --cluster $Cluster --tasks $taskID"
$wait = Invoke-Expression -Comman $waitCommand
Write-Output "Task in Service springMicroservice running"

<# Get Task Connection Data #>
$getConnectionCommand = "aws ecs describe-tasks --tasks $taskID --cluster $Cluster"
$getConnection = Invoke-Expression -Command $getConnectionCommand | ConvertFrom-Json
$connectionSearch = $getConnection.tasks[0].attachments[0].details
$IP = ""
for ($i = 0; $i -lt $connectionSearch.Count; $i++) {
    if($connectionSearch[$i].name -eq "privateIPv4Address") {
        $IP = $connectionSearch[$i].value
        break;
    }
}
$connection = "$IP" + ":$containerPortBinding"
Write-Output "DBsystem created..."
Start-Sleep -Seconds 3
Write-Output "Database running at $DBAddress2"
Start-Sleep -Seconds 1
Write-Output "Microservice waiting for requests at $connection"
Write-Output "========================================="