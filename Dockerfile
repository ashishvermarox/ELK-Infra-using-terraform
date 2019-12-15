FROM python
RUN apt-get update && apt-get install -y unzip wget && \
useradd -s /bin/bash -u 501 -U -d /build -m build && groupmod -g 501 build
RUN curl https://releases.hashicorp.com/terraform/0.12.18/terraform_0.12.18_linux_amd64.zip -o terraform.zip && \
unzip terraform.zip -d /usr/local/bin

COPY ["TerraformTemplate","/tmp/TerraformTemplate"]

WORKDIR /tmp/TerraformTemplate