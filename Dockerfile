FROM python:3.9-slim

RUN apt update
RUN apt -y install ruby ruby-dev
RUN gem install gazer

RUN apt -y install git 
RUN git clone https://github.com/looker-open-source/looker_deployer.git

WORKDIR /looker_deployer

RUN pip install .

ENTRYPOINT ["ldeploy"]