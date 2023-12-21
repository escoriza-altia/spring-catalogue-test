param(
[parameter(Mandatory = $true,Position = 0)][number] $errorC = 0,
[parameter(Mandatory = $true,Position = 1)][string] $rds   = "",
[parameter(Mandatory = $true,Position = 2)][string] $ecs   = "",
[parameter(Mandatory = $true,Position = 3)][string] $ecr   = ""
)

if ($errorC == 1) {
    $deleteCommand = "aws cloudformation delete-stack --stack-name $ecr"
    $delete = Invoke-Expression -Command $deleteCommand
    $deleteCommand = "aws cloudformation delete-stack --stack-name $rds"
    $delete = Invoke-Expression -Command $deleteCommand
    Write-Output = "Database Stack was deleted due to an Error"
} elseif ($errorC == 2) {
    $deleteCommand = "aws cloudformation delete-stack --stack-name $ecr"
    $delete = Invoke-Expression -Command $deleteCommand
    $deleteCommand = "aws cloudformation delete-stack --stack-name $rds"
    $delete = Invoke-Expression -Command $deleteCommand
    $deleteCommand = "aws cloudformation delete-stack --stack-name $ecs"
    $delete = Invoke-Expression -Command $deleteCommand
    Write-Output = "ECS Stack was deleted due to an Error"
} elseif($errorC == 3) {
    $deleteCommand = "aws cloudformation delete-stack --stack-name $ecr"
    $delete = Invoke-Expression -Command $deleteCommand
    Write-Output = "Database Stack was deleted due to an Error"
}
Write-Output "Delete Operation complete, please try again after fixing possible mistakes"