#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

#Comment in /etc/apt/source/list

sed -i -e 's/^/##/' /etc/apt/sources.list

mkdir /tmp/fonts

#Added new apt sources

cat <<EOT >> /etc/apt/sources.list
#--------------------------------------------------#
#Sources added by live cd customization
deb http://archive.ubuntu.com/ubuntu/ bionic main restricted
deb http://archive.ubuntu.com/ubuntu/ bionic-updates main restricted
deb http://archive.ubuntu.com/ubuntu/ bionic universe
deb http://archive.ubuntu.com/ubuntu/ bionic-updates universe
deb http://archive.ubuntu.com/ubuntu/ bionic multiverse
deb http://archive.ubuntu.com/ubuntu/ bionic-updates multiverse
deb http://archive.ubuntu.com/ubuntu/ bionic-backports main restricted universe multiverse
deb http://security.ubuntu.com/ubuntu bionic-security main restricted
deb http://security.ubuntu.com/ubuntu bionic-security universe
deb http://security.ubuntu.com/ubuntu bionic-security multiverse

EOT

# Do we have wget?
W="/usr/bin/wget"

# Do we have unzip?
Z="/usr/bin/unzip"

# Stuff
cp -a /custom/. /

printf "${GREEN}Updating system${NC}\n"
apt update
apt install ibus{,-m17n,,-gtk} im-config -y

# This not work on ubuntu18
# apt install ttf-devanagari-fonts
# Acording this https://ubuntu.pkgs.org/18.04/ubuntu-main-amd64/fonts-lohit-deva_2.95.4-2_all.deb.html
# ttf-devanagari-fonts was replaced by fonts-deva

printf "${GREEN}Installing fonts-deva vlc audacity default-jre libreoffice-java-common and gimp${NC}\n"
apt install fonts-deva vlc audacity default-jre libreoffice-java-common gimp -y
#apt install vlc -y
#apt install audacity -y
#apt install default-jre libreoffice-java-common -y
#apt install gimp -y

./$W &>/dev/null
if [ $? = "1" ]; then
	printf "${GREEN}We have wget, getting new fonts${NC}\n"
	wget http://aksharyogini.sudhanwa.com/download/Aksharyogini2Normal.ttf -O /usr/share/fonts/truetype/Aksharyogini2Normal.ttf
	wget https://www.wfonts.com/download/data/2015/09/15/akshar-unicode/akshar-unicode.zip -O /tmp/akshar.zip; unzip -p /tmp/akshar.zip akshar.ttf > /usr/share/fonts/truetype/akshar.ttf ; rm /tmp/aks*   
	wget https://s3.amazonaws.com/gamabhana/fonts_add.zip -O /tmp/fonts_add.zip ; unzip /tmp/fonts_add.zip -d /tmp/ ; mv  /tmp/fonts_add/*ttf /usr/share/fonts/truetype/
	wget https://s3.amazonaws.com/gamabhana/fonts_add2.zip -O /tmp/fonts_add2.zip ; unzip  /tmp/fonts_add2.zip -d /tmp/ ; mv  /tmp/fonts_add2/*ttf /usr/share/fonts/truetype/ 
	fc-cache --system-only
else
	printf "${REDD}We don't have wget, installing it${NC}\n"
	apt install wget -y
	printf "${GREEN}getting new fonts${NC}\n"
	wget http://aksharyogini.sudhanwa.com/download/Aksharyogini2Normal.ttf -O /usr/share/fonts/truetype/Aksharyogini2Normal.ttf
	wget https://www.wfonts.com/download/data/2015/09/15/akshar-unicode/akshar-unicode.zip -O /tmp/akshar.zip; unzip -p /tmp/akshar.zip akshar.ttf > /usr/share/fonts/truetype/akshar.ttf ; rm /tmp/aks*   
	wget https://s3.amazonaws.com/gamabhana/fonts_add.zip -O /tmp/fonts_add.zip ; unzip /tmp/fonts_add.zip -d /tmp/ ; mv  /tmp/fonts_add/*ttf /usr/share/fonts/truetype/
	wget https://s3.amazonaws.com/gamabhana/fonts_add2.zip -O /tmp/fonts_add2.zip ; unzip  /tmp/fonts_add2.zip -d /tmp/ ; mv  /tmp/fonts_add2/*ttf /usr/share/fonts/truetype/ 
	fc-cache --system-only
fi;


./$Z &>/dev/null
if [ $? = "1" ]; then
	printf "${GREEN}We have unzip, getting mozilla profile${NC}\n";
	wget https://s3.amazonaws.com/gamabhana/firefoxset.tar.gz -O /tmp/firefoxset.tar.gz ; mkdir /tmp/firefox/ ; tar xvzf /tmp/firefoxset.tar.gz --directory /tmp/firefox/ ; cp -R /tmp/firefox/firefox/* /etc/skel/.mozilla/firefox/
	printf "${GREEN}Copy to /etc/.mozilla: done${NC}\n"
else
	printf "${RED}We dont have unzip, we need install it${NC}\n";
	apt install unzip;
	printf "${GREEN}Getting mozilla profile${NC}\n"
	wget https://s3.amazonaws.com/gamabhana/firefoxset.tar.gz -O /tmp/firefoxset.tar.gz ; mkdir /tmp/firefox/ ; tar xvzf /tmp/firefoxset.tar.gz --directory /tmp/firefox/ ; cp -R /tmp/firefox/firefox/* /etc/skel/.mozilla/firefox/
	printf "${GREEN}Copy to /etc/.mozilla: done${NC}\n"
fi;

# wget the new version from http://extensions.libreoffice.org/extension-center/marathi-spellchecker/releases/1.3/libre_office_4_autotext.oxt

printf "${GREEN}Getting libreoffice marathi-spellchecker${NC}\n"
wget https://extensions.libreoffice.org/extensions/marathi-spellchecker/1.6/@@download/file/lib_with_syn_suffix_v1.oxt -O /tmp/lib_with_syn_suffix_v1.oxt

# unopkg add --shared /custom/libre_office_4.oxt
printf "${GREEN}Installing libreoffice marathi-spellchecker${NC}\n"
unopkg add --shared /tmp/lib_with_syn_suffix_v1.oxt

glib-compile-schemas /usr/share/glib-2.0/schemas/

printf "${GREEN}Installing libreoffice marathi-spellchecker:done${NC}\n"
#gsettings set org.gnome.desktop.session idle-delay 0

# Anaconda
# 32-bit: http://09c8d0b2229f813c1b93-c95ac804525aac4b6dba79b00b39d1d3.r79.cf1.rackcdn.com/Anaconda-2.1.0-Linux-x86.sh
# 64-bit: http://09c8d0b2229f813c1b93-c95ac804525aac4b6dba79b00b39d1d3.r79.cf1.rackcdn.com/Anaconda-2.1.0-Linux-x86_64.sh

