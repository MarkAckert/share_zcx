FROM ubuntu:18.04

RUN echo '#!/bin/sh \n\
     uname -om' > /os-info.sh 

RUN chmod +x /os-info.sh

ENTRYPOINT ["/os-info.sh"]