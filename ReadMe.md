<h1><span style="color:#2d7eea">README - Looker Deployer Local Setup</span></h1>

<h2><span style="color:#2d7eea">Looker Deployer Local Setup</span></h2>

This file is a guide to setting up Looker Deployer Locally

Prerequisties:

- **Install Docker Desktop**: Install Docker desktop.  This will keep track of the images, containers and volumes we create.
When we run an export command files will show up in the drive we are binding to the container.
- **Necessary Folder/Files**: It will be required to have the exact file structure given in this repo.
Although ldeploy_output is empty it will be required as it is copied to the docker container and will be where the exported files are stored before import
An ini file will also be necessary in the root folder with both dev and prod credentials.  Below is an example ini.  
Be sure to include the port as this is required by deployer.

```
[dev]
base_url=https://looker-dev.company.com:19999
client_id=abc
client_secret=xyz
verify_ssl=True

[prod]
base_url=https://looker-prod.company.com:19999
client_id=abc
client_secret=xyz
verify_ssl=True
```

-**Notes**:
At the moment the entrypoint is set to run two commands in sequence.  
The folder sources and targets are all hardcoded into the dockerfile.
Will adjust this in the future to pass these as parameters instead of hardcoding.
Possibly will also adjust to run this based on a shell script instead of a hard coded entrypoint

- **Run the Dockerfile**: 
Use the following steps to run the Dockerfile
- **Build the Docker image**:
Build the image by running the following command
```
 docker build -t docker_test .
 ```

 -**Run a container to import and export**:
 Run the docker image using the following command
 ```
  docker run -v /ldeploy_output docker_test
 ```





