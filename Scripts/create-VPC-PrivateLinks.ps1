$isecr = $true
$isecs = $true
$iss3 = $true
$checkLinks = Invoke-Expression -Command "aws ec2 describe-vpc-endpoints" | ConvertFrom-Json
for ($i = 0; $i -lt $checkLinks.VpcEndpoints.Count; $i++) {
    if($checkLinks.VpcEndpoints.VpcId -eq "vpc-0e961d486b54ef5e0") {
        if($checkLinks.VpcEndpoints.ServiceName -eq "com.amazonaws.eu-west-1.ecr.dkr") {
            $isecr = $false
        }
        if($checkLinks.VpcEndpoints.ServiceName -eq "com.amazonaws.eu-west-1.s3") {
            $iss3 = $false
        }
        if($checkLinks.VpcEndpoints.ServiceName -eq "com.amazonaws.eu-west-1.ecr.api") {
            $isecs = $false
        }
    }
}

if($isecr) {
    $ecrdkr = "aws ec2 create-vpc-endpoint --service-name com.amazonaws.eu-west-1.ecr.dkr --vpc-id vpc-0e961d486b54ef5e0 --vpc-endpoint-type Interface"
    $exec = Invoke-Expression -Command $ecrdkr
}
if($iss3) {
    $s3 = "aws ec2 create-vpc-endpoint --service-name com.amazonaws.eu-west-1.s3 --vpc-id vpc-0e961d486b54ef5e0 --vpc-endpoint-type Interface"
    $exec = Invoke-Expression -Command $s3
}
if($isecs) {
    $ecrapi = "aws ec2 create-vpc-endpoint --service-name com.amazonaws.eu-west-1.ecr.api --vpc-id vpc-0e961d486b54ef5e0 --vpc-endpoint-type Interface"
    $exec = Invoke-Expression -Command $ecrapi
}