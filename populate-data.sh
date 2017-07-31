#! /bin/bash
export JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk
export PATH=/hadoop/bin:$PATH
export HADOOP_CONF_DIR=/hadoop/etc/hadoop
mkdir -p /hadoop/etc/data
cp ${TMP_KRB_LOC} /etc/krb5.conf
cp ${TMP_CORE_LOC} /hadoop/etc/hadoop/core-site.xml 
cp ${TMP_HDFS_LOC} /hadoop/etc/hadoop/hdfs-site.xml 
until kinit -kt /var/keytabs/hdfs.keytab hdfs/nn.${NAMESPACE}.svc.cluster.local; do sleep 2; done
until (echo > /dev/tcp/nn.${NAMESPACE}.svc.cluster.local/9000) >/dev/null 2>&1; do sleep 2; done


hdfs dfsadmin -safemode wait


hdfs dfs -mkdir -p /user/ifilonenko/
hdfs dfs -copyFromLocal /wordcount.txt /user/ifilonenko

hdfs dfs -chmod -R 755 /user/ifilonenko
hdfs dfs -chown -R ifilonenko /user/ifilonenko


sleep 60