$ECRName = "dockerrepository"
$clusterName = "TestingSpringAQuarkus"
$RDSstackName = "PostgreSQLdb"
$ECSstackName = "ECSinstance"
$ECRstackName = "ECRinstance"

$GetECRInfo = "aws ecr describe-repositories --repository-names $ECRName"
$ECRJson = Invoke-Expression -Command $GetECRInfo | ConvertFrom-Json
$repoName = $ECRJson.repositories[0].repositoryName
$delImage = Invoke-Expression -Command "aws ecr batch-delete-image --repository-name $repoName --image-ids imageTag=latest"

$allService = Invoke-Expression -Command "aws ecs list-services --cluster $clusterName" | ConvertFrom-Json
$serviceArn = $allService.serviceArns[0]
$delService = Invoke-Expression -Command "aws ecs delete-service --cluster $clusterName --service $serviceArn --force"

Start-Sleep -Seconds 10
$delECS = Invoke-Expression -Command "aws cloudformation delete-stack --stack-name $ECSstackName"
$delECR = Invoke-Expression -Command "aws cloudformation delete-stack --stack-name $ECRstackName"
$delRDS = Invoke-Expression -Command "aws cloudformation delete-stack --stack-name $RDSstackName"