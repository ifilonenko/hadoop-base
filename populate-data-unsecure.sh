#! /bin/bash
export JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk
export PATH=/hadoop/bin:$PATH
export HADOOP_CONF_DIR=/hadoop/etc/hadoop
export HADOOP_OPTS="-Djava.net.preferIPv4Stack=true -Dsun.security.krb5.debug=false ${HADOOP_OPTS}"
mkdir -p /hadoop/etc/data
cp ${TMP_CORE_LOC} /hadoop/etc/hadoop/core-site.xml 
cp ${TMP_HDFS_LOC} /hadoop/etc/hadoop/hdfs-site.xml 
hdfs dfsadmin -safemode wait
hdfs dfs -mkdir -p /user/if
ilonenko/
hdfs dfs -copyFromLocal /wordcount.txt /user/ifilonenko

hdfs dfs -chmod -R 755 /user/ifilonenko
hdfs dfs -chown -R ifilonenko /user/ifilonenko


sleep 60