Write-Output ""
Write-Output "Migrating impulse-spring to codecommit..."
$startRepo = Invoke-Expression -Command "aws cloudformation create-stack --stack-name ccSpring --template-body 'file://..\Templates\CodeCommit Template.json'"

<# Wait till Repository reached a stable runtime and check every second #>
<# In case of an unexpected Delete set proceeding to false #>
$proceed = $true
while ($true) {
    $proceedString = Invoke-Expression -Command "aws cloudformation describe-stack-events --stack-name $RDSstackName" | ConvertFrom-Json
    if($proceedString.StackEvents[0].ResourceStatus -eq "CREATE_COMPLETE") {
        break;
    } else {
        Start-Sleep -Seconds 1
    }
}

Write-Output ""
Write-Output "Repository Stack created"

Invoke-Expression -Command "git clone --mirror https://github.com/Impulse-Team/impulse-spring-template.git ./../aws-codecommit-spring-temp"
Invoke-Expression -Command "cd ./../aws-codecommit-spring-temp"
Invoke-Expression -Command "git push https://git-codecommit.eu-west-1.amazonaws.com/ccRepositorySpring --all"

Invoke-Expression -Command "rm -rf aws-codecommit-spring-temp.git"
Invoke-Expression -Command "cd ./.."
Invoke-Expression -Command "Remove-Item -path aws-codecommit-spring-temp"

Write-Output "Repository is in Code Commit..."
