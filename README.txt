SiriPrefs 0.2b by Dany Lisiansky (DanyL).

SiriPrefs it's a set of web tools which combined to work together and allow you to launch apps using Siri/Bing voice/Google voice.

dnsmasq = DNS Server
squid & dansguardianpath = Transperant Proxy Server
lighttpd = Web Server

Installation:
1) Run Debian or Debian-based distro.
2) Run terminal as root.
* I recommand you to update your system before the installation by typing 'apt-get update' at the terminal.
3) Type 'git clone git://github.com/DanyL/SiriPrefs.git'
4) Enter SiriPrefs directory by typing 'cd SiriPrefs'.
5) Type './SiriPrefs.sh' to run the script.
6) The script will ask you "What would you like to do?", press 'in'.
7) The script will ask you if you want to install proxy server, it's your choice.
    Pros:
		Allow to keep using the search engines as search engines.
		Allow Google voice search application to work with SiriPrefs.
	Cons:
		There is a caching issues and applications like YouTube will have problems.
8) The script will ask you what search engine you want SiriPrefs to use, it's your choice:
	Press [g] for Google
	Press [y] for Yahoo
	Press [b] for Bing
	Press [a] for all"
9) Now you'll see the next line:
	"In your iPhone's WiFi Settings, select the blue arrow icon next to your active WiFi connection, tap on the DNS section, and type [Your_IP] (explanation taken from 'idownloadblog.com')"
	but instead of [your_IP] you'll see your own IP, write it in the DNS section in your iPhone's Wifi settings, and set Airplane mode on and off to make your changes effect.
	* I also recommend you to turn off locations for Safari and Google Search to prevent google from redirecting .com to a local extension. (rockbox-psgroove.com/siriprefs/location-off.png)
10) Back to the computer, press any key to start SiriPrefs.
11) The script will ask you if you want to start Proxy server, it depends on your answer in section 7.
12) Start Siri/Google search/Bing and say 'Test'.
	* If you are using Siri you should say the search engine's name before the command.
	** you can also type it in safari/google/bing/yahoo applications.
13) If everything installed correctly you'll see a web page saying "SiriPrefs is up and running".
14) Well done!

Starting SiriPrefs:
1) Type './SiriPrefs.sh' to run the script.
2) The script will ask you "What would you like to do?", press 'st'.
3) The script will ask you if you want to start Proxy server, Press [y] for yes, or [n] for no.

Updating:
I added an option to update the siriprefs.conf file alone, so I'll be able to add more commands.
1) Run SiriPrefs.sh in terminal and press [up].
2) SiriPrefs will restart all the neccesery proccess and you'll be able to test new commands.
	* I recommend you to clear cache in safari/google/bing/yahoo applications to prevent problems.

Adding commands:
1) The syntax for adding new commands is:
	"Command|command" => "url_scheme",
	while you can use (.*) as a space.
2) This line goes to the right section (apps/settings/sites) in the file "siriprefs.conf".
3) For local updating SiriPrefs, run SiriPrefs.sh script again, and press [lo] for a local update.
4) SiriPrefs will restart all the neccesery proccess and you'll be able to test your new command.

Uninstallation:
1) Run SiriPrefs.sh in terminal and press [un].

FAQ:
Q: Google Voice search app doesn't work.
A: Install and start Proxy Server.

Q: I installed Proxy Server but I can't access to the internet.
A:  1. Start the Proxy server by pressing [y] when starting SiriPrefs.
	2. Cheack if you are connected to the internet at the machine running SiriPrefs.

Q: After running SiriPrefs, I can't access youtube app.
A: This is a caching problem with the Proxy server, you can use youtube.com instead.

Q: My static IP changed and now SiriPrefs doesn't work, what should I do?
A: Reinstall SiriPrefs, it'll update your old IP with your current one.

Contact:
Name: Dany Lisiansky
Email: siriprefs@gmail.com

Donations:
I'm trying to buy a Mac Mini for development, and I'll be happy if you'll help me to buy one.
PayPal: marinalisyansky@gmail.com