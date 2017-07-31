FROM centos:7

RUN yum -y install krb5-server krb5-workstation
RUN yum -y install java-1.8.0-openjdk-headless
RUN yum -y install apache-commons-daemon-jsvc
RUN yum install net-tools -y
RUN yum install telnet telnet-server -y
RUN yum -y install which

RUN sed -i -e 's/#//' -e 's/default_ccache_name/# default_ccache_name/' /etc/krb5.conf
RUN useradd -u 1098 hdfs

ADD hadoop-2.6.5.tar.gz /
RUN ln -s hadoop-2.6.5 hadoop
RUN chown -R -L hdfs /hadoop

COPY ssl-server.xml /hadoop/etc/hadoop/
COPY yarn-site.xml /hadoop/etc/hadoop/

COPY start-namenode.sh /
COPY start-datanode.sh /
COPY populate-data.sh /
COPY start-kdc.sh /

COPY wordcount.txt /
