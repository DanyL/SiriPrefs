 #!/bin/bash
 echo "    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>"
	
 echo "SiriPrefs 0.2b by DanyL (Dany Lisiansky)"

 SCRIPT=$(readlink -f "$0")
 SCRIPTPATH=`dirname "$SCRIPT"`
 proxy='false'
 dnsmasqpath='/etc/dnsmasq.conf'
 lighttpdpath='/etc/lighttpd/lighttpd.conf'
 squidpath='/etc/squid/squid.conf'
 dansguardianpath='/etc/dansguardian/dansguardian.conf'

 echo "What would you like to do?"
 echo "Press [in] for install / reinstall
      [up] for internet 'siriprefs.conf' update
      [lo] for local update (from $SCRIPTPATH/siriprefs.conf)
      [st] for start / restart
      [un] for uninstall
      [ex] for exit"

 read -s -n2 KEY
 if [[ "$KEY" == "in" ]]
 then
	echo "install / reinstall"
	echo "Installing dnsmasq, lighttpd"
	apt-get install dnsmasq lighttpd

	echo ""
	echo "Install proxy server (there is currently caching issues with applications like YouTube.) [y/n]?"
	read -s -n1 KEY
	if [[ "$KEY" == "y" ]]
		then
		proxy='true'
		echo "Installing iptables dansguardian squid"
		apt-get install iptables dansguardian squid
		wget -O /"$SCRIPTPATH/siriprefs.conf" "http://rockbox-psgroove.com/siriprefs/configureation/siriprefs-proxy.conf"
	else
		wget -O /"$SCRIPTPATH/siriprefs.conf" "http://rockbox-psgroove.com/siriprefs/configureation/siriprefs.conf"
	fi

	echo "creating SiriPrefs's working directory"
	mkdir /etc/siriprefs
	cp -f "$SCRIPTPATH/siriprefs.conf" /etc/siriprefs/siriprefs.conf
	cp -f "$SCRIPTPATH/SiriPrefs_start.sh" /etc/siriprefs/SiriPrefs.sh
 
	echo "getting your current IP"
	IP=`ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}'`

	echo "$dnsmasqpath"
	if [ -f "$dnsmasqpath.bak" ];
	then
		echo "Restoring configuration files"
		cp -f "$dnsmasqpath.bak" "$dnsmasqpath"
	else
		echo "Backing-up configuration files"
		cp -f "$dnsmasqpath" "$dnsmasqpath.bak"
	fi 

	echo "$lighttpdpath"
	if [ -f "$lighttpdpath.bak" ];
	then
		cp -f "$lighttpdpath.bak" "$lighttpdpath"
	else
		cp -f "$lighttpdpath" "$lighttpdpath.bak"
	fi 
	
	if [[ "$proxy" == "true" ]]
	then
		echo "$squidpath"
		if [ -f "$squidpath.bak" ];
		then
			cp -f "$squidpath.bak" "$squidpath"
		else
			cp -f "$squidpath" "$squidpath.bak"
		fi 

		echo "$dansguardianpath"
		if [ -f "$dansguardianpath.bak" ];
		then
			cp -f "$dansguardianpath.bak" "$dansguardianpath"
		else
			cp -f "$dansguardianpath" "$dansguardianpath.bak"
		fi 
	fi

	echo "Fixing permissions"
	chmod 777 "/etc/siriprefs/SiriPrefs.sh"
	chmod 777 "$dnsmasqpath"
	chmod 777 "$lighttpdpath"
	if [[ "$proxy" == "true" ]]
	then
		chmod 777 "$squidpath"
		chmod 777 "$dansguardianpath"
	fi

	echo "adding address to $dnsmasqpath"
	echo "select a search engine:"
	echo "Press [g] for Google
		    [y] for Yahoo
		    [b] for Bing
		    [a] for all"
	read -s -n1 KEY
	if [[ "$KEY" == "g" ]]
	then
		addr="address=/google.com/$IP"
	fi
	if [[ "$KEY" == "b" ]]
	then
		addr="address=/m.bing.com/$IP"
	fi

	if [[ "$KEY" == "y" ]]
	then
		addr="address=/m.yahoo.com/$IP"
	fi

	if [[ "$KEY" == "a" ]]
	then
		addr="address=/m.bing.com/$IP address=/m.yahoo.com/$IP address=/google.com/$IP"
	fi
	(cat "$dnsmasqpath" ; echo $addr) > "$dnsmasqpath.tmp"
	mv "$dnsmasqpath.tmp" "$dnsmasqpath"
 
	if [[ "$proxy" == "true" ]]
	then
		echo "Configuring squid and dansguardian"
		sed 's/http_port 3128/http_port 3128 transparent/g' $squidpath > "$squidpath.tmp"
		mv "$squidpath.tmp" "$squidpath"
		sed 's/UNCONFIGURED/#UNCONFIGURED/g' $dansguardianpath > "$dansguardianpath.tmp"
		mv "$dansguardianpath.tmp" "$dansguardianpath"
	fi

	echo "including SiriPrefs confg file to $lighttpdpath"
	if [[ "$proxy" == "true" ]]
	then
		dnsmasq='$HTTP["host"] =~ "" {include "/etc/siriprefs/siriprefs.conf" proxy.server  = ( "" => (( "host" => "127.0.0.1", "port" => "8080" )))}'
	else
		dnsmasq='$HTTP["host"] =~ "" {include "/etc/siriprefs/siriprefs.conf"}'
	fi
	(cat "$lighttpdpath" ; echo $dnsmasq) > "$lighttpdpath.tmp"
	mv "$lighttpdpath.tmp" "$lighttpdpath"
	cp -f /etc/lighttpd/conf-available/10-proxy.conf /etc/lighttpd/conf-enabled/10-proxy.conf

	echo ""
	echo "In your iPhone's WiFi Settings, select the blue arrow icon next to your active WiFi connection, tap on the DNS section, and type $IP (explanation taken from 'idownloadblog.com')"

	echo "SiriPrefs Installed!"
	echo "Press any key to start SiriPrefs..."
	read -s -n 1 any_key
	/etc/siriprefs/SiriPrefs.sh
 fi

 if [[ "$KEY" == "up" ]]
 then
	echo "update"
	echo "Did you install Proxy server? [y/n]"
	read -s -n1 KEY
	if [[ "$KEY" == "y" ]]
	then
		wget -O /"$SCRIPTPATH/siriprefs.conf" "http://rockbox-psgroove.com/siriprefs/configureation/siriprefs-proxy.conf"
	else
		wget -O /etc/siriprefs/siriprefs.conf "http://rockbox-psgroove.com/siriprefs/configureation/siriprefs.conf"
	fi
	/etc/siriprefs/SiriPrefs.sh
	echo "Done"
 fi

 if [[ "$KEY" == "lo" ]]
 then
	echo "local update (from $SCRIPTPATH/siriprefs.conf"
	cp -f "$SCRIPTPATH/siriprefs.conf" /etc/siriprefs/siriprefs.conf
	/etc/siriprefs/SiriPrefs.sh
	echo "Done"
 fi

 if [[ "$KEY" == "st" ]]
 then
	/etc/siriprefs/SiriPrefs.sh
 fi

 if [[ "$KEY" == "un" ]]
 then
	echo "uninstall"
	echo "Restoring configuration files"
	echo "$dnsmasqpath"
	if [ -f "$dnsmasqpath.bak" ];
	then
		mv -f "$dnsmasqpath.bak" "$dnsmasqpath"
	fi 

	echo "$lighttpdpath"
	if [ -f "$lighttpdpath.bak" ];
	then
		mv -f "$lighttpdpath.bak" "$lighttpdpath"
	fi 
	
	echo "$squidpath"
	if [ -f "$squidpath.bak" ];
	then
		mv -f "$squidpath.bak" "$squidpath"
	fi 

	echo "$dansguardianpath"
	if [ -f "$dansguardianpath.bak" ];
	then
		mv -f "$dansguardianpath.bak" "$dansguardianpath"
	fi

	echo "Uninstalling dnsmasq lighttpd iptables dansguardian squid"
	apt-get remove dnsmasq lighttpd iptables dansguardian squid
	echo "Done!"
fi

 if [[ "$KEY" == "ex" ]]
 then
	echo "exit"
 fi
