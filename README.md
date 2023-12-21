## impulse-spring-template
The Template is for creating a Database system service in AWS environment using PostgreSQL as DBMS.
Required are an installed Docker environment, the execution of Powershell as admin as well as all rights in AWS to perform ECR, ECS, CF and RDS operations.
Following Resources are part of the repository:
        - Templates:         Templates creating Instances in AWS cloudforamtion
        - Testing:           All results from Testing the Microservice
        - containerizeSpring: The Microservice to communicate with the Database
        - Scripts:           Executing Powershell scripts to kick off Database creation

## Templates
All Templates are used by cloudformatio to create described Instances.
Changing values should only be executed after assuring that no probles will occur, because some values were intended not to be changed.
Changing a Property name in a Template for example could hinder creation scripts to function.
For further readings about Template creation refer to:
    https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-guide.html
For more informations about used Template Instances refer to:
    - ECS:        https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/AWS_ECS.html
    - ECR:        https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/AWS_ECR.html
    - RDS:        https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/AWS_RDS.html
    - CodeCommit: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/AWS_CodeCommit.html (Before using this Template, create a S3 Bucket)

##containerizeSpring
In this folder the Microservice is saved.
Before executing a creation script, the database should be configured to prefered tasks.
Otherwise the default tables (company, complex, fruit, vegetable, vehicle) will be used.
In .\containerizeSpring\src\main\java\com\example\containerizeSpring all tables, as this is a relational database service, are described in a Entity and Ressource class.
For a short tutorial about creating all needed Resources:
    https://spring.io/guides/gs/accessing-data-mysql/

##Scripts
Scripts are the final Step in providing the database system service on-demand.
The Scripts should be executed after any changes have been made.
1. Change any desired database-stucture info in the Microservice, which creates configured tables on startup
2. (Optional) Execute ./create-ECR-database.ps1 to create Repository for newly created Docker image
3. (Optional) Change Templates (Warning: Changes can destroy Script execution)
4. Execute ./create-db-system.ps1 with mandatory parameters:
        Database name,
        Master User,
        Master Password
   and parameters with default value: (Only important to set ECR and image values when step three has been executed)
        Image Repository Link,
        ContainerName,
        ClusterName,
        ECRrepository name

! Docker and Powershell need to be executed with an Admin-account
! ./error-script.ps1 should not executed by any user. Errors will be handled by ./create-db-system.ps1
! Before execution the Docker engine (Docker Daemon) should be restarted to avoid push deadlocks during the docker part of the script
! The recommended way of execution is only step 1. and 4. with "./create-db-system [DB Name] [Username] [Password]"
! In this version Spring as well as Quarkus Microservices can cooexist, but with completely different AWS CF Stacks. Otherwise database information will be deleted when starting the other Framework.
! Two or more Services from the same Framework are not useful and therefore not supported

Consider all important notes and share Microservice IP-Addresses if necessary with collegues so costs are reduced to a minimum.