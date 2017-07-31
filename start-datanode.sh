#! /bin/bash
export JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk
export PATH=/hadoop/bin:$PATH
export HADOOP_CONF_DIR=/hadoop/etc/hadoop
mkdir -p /hadoop/etc/data
cp ${TMP_KRB_LOC} /etc/krb5.conf
cp ${TMP_CORE_LOC} /hadoop/etc/hadoop/core-site.xml 
cp ${TMP_HDFS_LOC} /hadoop/etc/hadoop/hdfs-site.xml 
until kinit -kt /var/keytabs/hdfs.keytab hdfs/nn.${NAMESPACE}.svc.cluster.local; do sleep 15; done
echo "KDC is up and ready to go... starting up"

kdestroy

hdfs datanode