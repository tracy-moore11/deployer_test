FROM python:3.9-slim

RUN apt update
RUN apt -y install ruby ruby-dev
RUN gem install gazer

RUN apt -y install git 
RUN git clone https://github.com/looker-open-source/looker_deployer.git

WORKDIR /looker_deployer

COPY looker.ini  .
RUN pip install .

ENTRYPOINT ["ldeploy"]

##for export
# docker run \
# -v /Users/tracy/Documents/Dev/Docker/deployer_test/ldeploy_settings:/ldeploy_settings \
# -v /Users/tracy/Documents/Dev/Docker/deployer_test/ldeploy_output:/ldeploy_output \
# ldeploy content export --ini /ldeploy_settings/looker.ini --local-target /ldeploy_output --env dev --folders 1

##for import
#docker run \
#-v /Users/tracy/Documents/Dev/Docker/deployer_test/ldeploy_settings:/ldeploy_settings \
#-v /Users/tracy/Documents/Dev/Docker/deployer_test/ldeploy_output:/ldeploy_output \
#ldeploy content import --ini /ldeploy_settings/looker.ini --folders /ldeploy_output/Shared --env prod --recursive --target-folder Shared
