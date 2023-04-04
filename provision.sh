#!/bin/bash
set -eu -o pipefail

# load environment variables from .env
set -a
if [ -e /vagrant/.env ]; then
  # shellcheck disable=SC1091
  . /vagrant/.env
else
  echo 'Environment file .env not found. Therefore, dotenv.sample will be used.'
  # shellcheck disable=SC1091
  . /vagrant/dotenv.sample
fi
set +a

readonly FILE=/vagrant/oracle-database-free-23c-1.0-1.el8.x86_64.rpm
readonly CHECKSUM=63b6c0ec9464682cfd9814e7e2a5d533139e5c6aeb9d3e7997a5f976d6677ca6

# Verify SHA256 checksum
echo "$CHECKSUM $FILE" | sha256sum -c

# Install Oracle Linux Developer yum repository configuration
dnf -y install oraclelinux-developer-release-el8

# Install Oracle Database 23c Free
dnf -y localinstall "$FILE"

# Creating and configuring an Oracle Database
echo -e "${ORACLE_PASSWORD}\n${ORACLE_PASSWORD}" | /etc/init.d/oracle-free-23c configure

# Set environment variables
cat <<EOT >>/home/vagrant/.bash_profile
export ORACLE_BASE=/opt/oracle/product/23c/dbhomeFree
export ORACLE_HOME=/opt/oracle/product/23c/dbhomeFree
export ORACLE_SID=FREE
export PATH=\$PATH:\$ORACLE_HOME/bin
EOT

# Install rlwrap and set alias
dnf -y install oracle-epel-release-el8
dnf -y --enablerepo=ol8_developer_EPEL install rlwrap
cat <<EOT >>/home/vagrant/.bashrc
alias sqlplus='rlwrap sqlplus'
EOT

# Configure automating shutdown and startup
systemctl daemon-reload
systemctl enable oracle-free-23c

# Install sample schemas
if [[ ${ORACLE_SAMPLESCHEMA^^} == TRUE ]]; then
  SAMPLE_DIR=$(mktemp -d)
  readonly SAMPLE_DIR
  chmod 777 "$SAMPLE_DIR"
  cp /vagrant/install_sample.sh "$SAMPLE_DIR"/install_sample.sh
  su - vagrant -c "$SAMPLE_DIR/install_sample.sh $ORACLE_PASSWORD localhost/FREEPDB1"
  su - vagrant -c "rm -rf $SAMPLE_DIR/*"
  rmdir "$SAMPLE_DIR"
fi
