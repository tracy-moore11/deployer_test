<h1><span style="color:#2d7eea">README - Looker Deployer Local Setup</span></h1>

<h2><span style="color:#2d7eea">Looker Deployer Local Setup</span></h2>

This file is a guide to setting up Looker Deployer Locally

Prerequisties:

- **Install Docker Desktop**: Install Docker desktop.  This will keep track of the images, containers and mounted volumes we create.

- **Necessary Folder/Files**: It will be required to have the exact file structure given in this repo.
* The ldeploy_output folder will be used as a mounted volume which will hold the exported files.  This directory will also be targeted for importing content.
* An ini file will be necessary (not provided in this example).  For this example we place the ini file in the ldeploy_settings folder, which will be referenced in the deployer call. 
    Below is an example ini.  

```
[dev]
base_url=https://looker-dev.cloud.google.com:443
client_id=abc
client_secret=xyz
verify_ssl=True

[prod]
base_url=https://looker-prod.cloud.google.com:443
client_id=abc
client_secret=xyz
verify_ssl=True
```
*Be sure to include the port as this is required by deployer.*
*This is based on your Looker API settings, 443 is the default port, or 1999 for older versions of Looker.*


# Run the Dockerfile: 
Use the following steps to run deployer
## Build the Docker image:
Build the Docker image by running the following command
```
 docker build -t ldeploy .
```

 ## Run a container to export to ldeploy_output from target looker instance:
 Run the docker image in terminal
 
 Example command:
 ```
    docker run \
    -v /Users/tracy/Documents/Dev/Docker/deployer_test/ldeploy_settings:/ldeploy_settings \
    -v /Users/tracy/Documents/Dev/Docker/deployer_test/ldeploy_output:/ldeploy_output \
    ldeploy content export \
    --ini /ldeploy_settings/looker.ini \
    --local-target /ldeploy_output \
    --env dev \
    --folders 1
 ```

### ldeploy content export options**
```
usage: ldeploy content export [-h] --env ENV [--ini INI] [--debug] --folders
                              FOLDERS [FOLDERS ...] --local-target
                              LOCAL_TARGET

optional arguments:
  -h, --help            show this help message and exit
  --env ENV             What environment to deploy from
  --ini INI             ini file to parse for credentials
  --debug               set logger to debug for more verbosity
  --folders FOLDERS [FOLDERS ...]
                        What folders to export content from
  --local-target LOCAL_TARGET
                        Local directory to store content
```

**After running this command, all dashboards from the source should be visibile in the deployer_output folder on your local machine**

## Run a container to import to looker instance:
 Run the docker image in terminal
 
Example command:
 ```
    docker run \
    -v /Users/tracy/Documents/Dev/Docker/deployer_test/ldeploy_settings:/ldeploy_settings \
    -v /Users/tracy/Documents/Dev/Docker/deployer_test/ldeploy_output:/ldeploy_output \
    ldeploy content import --ini /ldeploy_settings/looker.ini \
    --folders /ldeploy_output/Shared \
    --env prod \
    --recursive \
    --target-folder Shared
 ```

### ldeploy content import options
```
usage: ldeploy content import [-h] --env ENV [--ini INI] [--debug]
                              [--recursive] [--target-folder TARGET_FOLDER]
                              (--folders FOLDERS [FOLDERS ...] | --dashboards DASHBOARDS [DASHBOARDS ...] | --looks LOOKS [LOOKS ...])

optional arguments:
  -h, --help            show this help message and exit
  --env ENV             What environment to deploy to
  --ini INI             ini file to parse for credentials
  --debug               set logger to debug for more verbosity
  --recursive           Should folders deploy recursively
  --target-folder TARGET_FOLDER
                        override the default target folder with a custom path
  --folders FOLDERS [FOLDERS ...]
                        Folders to fully deploy
  --dashboards DASHBOARDS [DASHBOARDS ...]
                        Dashboards to deploy
  --looks LOOKS [LOOKS ...]
                        Looks to deploy
```

**After running this command, all dashboards from the source folder should be visibile in your target Looker instance**

### Example commands
- ldeploy content export --env dev --folders 1 --local-target ./foo/bar/ <- exports the Shared folder (id 1) and all sub-folders to the directory location ./foo/bar/
- ldeploy content export --env dev --folders 5 8 --local-target ./foo/bar/ <- exports folders 5 and 8 (and all of their sub-folders) to the directory location ./foo/bar/
- ldeploy content import --env prod --folders ./foo/bar/Shared/Public <- deploys every piece of content in Shared/Public to the prod instance
- ldeploy content import --env prod --folders ./foo/bar/Shared/Public --recursive --target-folder Shared/FromDev/Public <- deploys every piece of content in Shared/Public and all sub-folders to the prod instance in the Shared/FromDev/Public folder.
- ldeploy content import --env prod --dashboards ./foo/bar/Shared/Public/Dashboard_1.json ./foo/bar/Shared/Restricted/Dashboard_2.json <- deploys Dashboard1 and Dashboard2 to their respective folders in the prod instance
- ldeploy content import --env prod --folders ./dev/Users --recursive --target-folder Users <- deploys every piece of content in dev/Users and all sub-folders to the prod instance in the Users folder
- ldeploy content import --env prod --folders "./dev/Embed Users" --recursive --target-folder "Embed Users" <- deploys every piece of content in dev/Embed Users and all sub-folders to the prod instance in the Embed Groups folder
- ldeploy content import --env prod --folders "./dev/Embed Groups" --recursive --target-folder "Embed Groups" <- deploys every piece of content in dev/Embed Groups and all sub-folders to the prod instance in the Embed Groups folder
