FROM debian:jessie
RUN apt-get update \
    && apt-get install -y gcc g++ git make coreutils wget bzip2 libghc-bzlib-dev \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && apt-get autoclean -y \
    && rm -rf /var/lib/apt/lists/*
    
RUN cd /root \
     && wget https://github.com/DOCGroup/MPC/archive/ACE+TAO+CIAO-6_3_3.tar.gz \
     && wget https://github.com/objectcomputing/quickfast/archive/V1_5.tar.gz \
   && tar -xvzf ACE+TAO+CIAO-6_3_3.tar.gz  &&  tar -xvzf V1_5.tar.gz && rm -rf *.tar.gz 
   
ENV QUICKFAST_ROOT      /root/quickfast-1_5
ENV MPC_ROOT            /root/MPC-ACE-TAO-CIAO-6_3_3
ENV BOOST_ROOT          /usr/include/boost
ENV BOOST_ROOT_LIB      $BOOST_ROOT/lib
ENV XERCESCROOT         /root/xerces-c-3.1.2
ENV XERCES_ROOT         /root/xerces-c-3.1.2
ENV XERCES_LIBNAME      xerces-c-3.1
ENV XERCES_LIBPATH      $XERCES_ROOT/lib
ENV XERCES_INCLUDE      $XERCES_ROOT/include
ENV PATH                $QUICKFAST_ROOT/bin:$MPC_ROOT:$PATH
ENV LD_LIBRARY_PATH     $XERCES_LIBPATH:$QUICKFAST_ROOT/lib:$BOOST_ROOT_LIB:$LD_LIBRARY_PATH

RUN cd /root/quickfast-1_5 \
    && ./m.sh \
    && make

ENV LIQUIBOOK_ROOT      /root/liquibook
ENV CIAO_ROOT           /dev/null
ENV LD_LIBRARY_PATH     $LD_LIBRARY_PATH:$LIQUIBOOK_ROOT/lib

RUN cd /root \
    && git clone https://github.com/pkdcryptos/objectcomputing_liquibook.git \
    && cd objectcomputing_liquibook/ \
    && git submodule init \
    && git submodule update \
    && mwc.pl -type make liquibook.mwc \
    && make depend \
    && make all
