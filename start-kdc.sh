#! /bin/bash
export JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk
export PATH=/hadoop/bin:$PATH
export HADOOP_CONF_DIR=/hadoop/etc/hadoop
mkdir -p /hadoop/etc/data
cp ${TMP_KRB_LOC} /etc/krb5.conf
cp ${TMP_CORE_LOC} /hadoop/etc/hadoop/core-site.xml 
cp ${TMP_HDFS_LOC} /hadoop/etc/hadoop/hdfs-site.xml 
/usr/sbin/kdb5_util -P changeme create -s


## password only user
/usr/sbin/kadmin.local -q "addprinc  -randkey ifilonenko"
/usr/sbin/kadmin.local -q "ktadd -k /var/keytabs/ifilonenko.keytab ifilonenko"

/usr/sbin/kadmin.local -q "addprinc -randkey HTTP/server.${NAMESPACE}.svc.cluster.local"
/usr/sbin/kadmin.local -q "ktadd -k /var/keytabs/server.keytab HTTP/server.${NAMESPACE}.svc.cluster.local"

/usr/sbin/kadmin.local -q "addprinc -randkey hdfs/nn.${NAMESPACE}.svc.cluster.local"
/usr/sbin/kadmin.local -q "addprinc -randkey HTTP/nn.${NAMESPACE}.svc.cluster.local"
/usr/sbin/kadmin.local -q "addprinc -randkey hdfs/dn1.${NAMESPACE}.svc.cluster.local"
/usr/sbin/kadmin.local -q "addprinc -randkey HTTP/dn1.${NAMESPACE}.svc.cluster.local"

/usr/sbin/kadmin.local -q "ktadd -k /var/keytabs/hdfs.keytab hdfs/nn.${NAMESPACE}.svc.cluster.local"
/usr/sbin/kadmin.local -q "ktadd -k /var/keytabs/hdfs.keytab HTTP/nn.${NAMESPACE}.svc.cluster.local"
/usr/sbin/kadmin.local -q "ktadd -k /var/keytabs/hdfs.keytab hdfs/dn1.${NAMESPACE}.svc.cluster.local"
/usr/sbin/kadmin.local -q "ktadd -k /var/keytabs/hdfs.keytab HTTP/dn1.${NAMESPACE}.svc.cluster.local"

chown hdfs /var/keytabs/hdfs.keytab

keytool -genkey -alias nn.${NAMESPACE}.svc.cluster.local -keyalg rsa -keysize 1024 -dname "CN=nn.${NAMESPACE}.svc.cluster.local" -keypass changeme -keystore /var/keytabs/hdfs.jks -storepass changeme
keytool -genkey -alias dn1.${NAMESPACE}.svc.cluster.local -keyalg rsa -keysize 1024 -dname "CN=dn1.${NAMESPACE}.svc.cluster.local" -keypass changeme -keystore /var/keytabs/hdfs.jks -storepass changeme

chmod 700 /var/keytabs/hdfs.jks
chown hdfs /var/keytabs/hdfs.jks


krb5kdc -n