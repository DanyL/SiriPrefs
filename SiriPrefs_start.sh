 #!/bin/bash

 echo "Starting SiriPrefs"

 echo "Starting dnsmasq"
 /etc/init.d/dnsmasq restart
 echo "Start Proxy server [y/n]?"
 read -s -n1 KEY
 if [[ "$KEY" == "y" ]]
 then
	 echo "Starting squid"
	 /etc/init.d/squid restart
	 echo "Starting dansguardian"
	 /etc/init.d/dansguardian restart
 fi
 echo "Starting lighttpd"
 /etc/init.d/lighttpd restart

 echo "SiriPrefs is up and running"
