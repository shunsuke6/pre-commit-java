FROM --platform=linux/amd64 openjdk:17-alpine

RUN apk add --update --no-cache wget unzip curl bash jq
RUN mkdir -p /opt

RUN cd /opt \
      && export PMD_URL=$(curl --silent https://api.github.com/repos/pmd/pmd/releases/latest | jq -r '.assets[] | select(.name | test("pmd.*bin.*zip")) | .browser_download_url')  \
      && wget -nc -O pmd.zip ${PMD_URL} \
      && unzip pmd.zip \
      && rm pmd.zip \
      && mv pmd-bin* pmd

RUN cd /opt \
      && export CS_URL=$(curl --silent https://api.github.com/repos/checkstyle/checkstyle/releases/latest | jq '.assets[] | select(.name | test("checkstyle-.*jar")) | .browser_download_url' | sed -e 's/^"//' -e 's/"$//') \
      && wget -nc -O checkstyle.jar ${CS_URL}

COPY run_pmd.sh /opt
COPY run_cpd.sh /opt
COPY ruleset.xml /opt
COPY run_checkstyle.sh /opt
