#!/bin/bash

# Apply environment variables
echo "${TZ}" > /etc/timezone  && dpkg-reconfigure tzdata
sed -ri -e 's/(^\s+email\s+)\S+(.*)/\1'${NAGIOSADMIN_EMAIL}'\2/' ${NAGIOS_HOME}/etc/objects/contacts.cfg
sed -i -e 's/nagiosadmin/'${NAGIOSADMIN_USER}'/' ${NAGIOS_HOME}/etc/objects/contacts.cfg
sed -i -e 's/=nagiosadmin$/='${NAGIOSADMIN_USER}'/' ${NAGIOS_HOME}/etc/cgi.cfg

if [ ! -f ${NAGIOS_HOME}/etc/htpasswd.users ] ; then
  htpasswd -bc ${NAGIOS_HOME}/etc/htpasswd.users ${NAGIOSADMIN_USER} "${NAGIOSADMIN_PASS}"
  chown -R ${NAGIOS_USER}:${NAGIOS_USER} ${NAGIOS_HOME}/etc/htpasswd.users
fi
# Added by Johan Mogollon
sed -i 's/Listen 80[[:space:]]*$/Listen 8080/' /etc/apache2/ports.conf
sed -i 's/Listen 443[[:space:]]*$/Listen 8443/' /etc/apache2/ports.conf
sed -i 's/Listen 80[[:space:]]*$/Listen 8080/' /etc/apache2/sites-enabled/000-default.conf
sed -i 's/Listen 443[[:space:]]*$/Listen 8443/' /etc/apache2/sites-enabled/000-default.conf
#########################

# Start supporting services
/etc/init.d/apache2 start

exec ${NAGIOS_HOME}/bin/nagios ${NAGIOS_HOME}/etc/nagios.cfg