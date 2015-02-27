sourcify() {
  source ~/.bash_profile
  source ~/.profile
  source ~/.bashrc
}

sudo apt-get update && sudo apt-get install --only-upgrade bash # anti-shellshock
sudo apt-get -y install git vim curl wget htop

PROJECT_ROOT="/vagrant"

# get ready for the special ubuntu rvm install
# thanks to http://blog.coolaj86.com/articles/installing-ruby-on-ubuntu-12-04.html
sudo apt-get -y remove --purge ruby-rvm ruby
sudo rm -rf /usr/share/ruby-rvm /etc/rmvrc /etc/profile.d/rvm.sh
sudo rm -rf ~/.rvm* ~/.gem/ ~/.bundle*
echo "gem: --no-rdoc --no-ri" >> ~/.gemrc # who needs documentation?

# needed to trust rvm key signature
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -L https://get.rvm.io | bash -s stable --autolibs=enabled --auto-dotfiles

sourcify
rvm requirements
sourcify
rvm install 2.2.0
sourcify
rvm rubygems current
sourcify
gem install pry

# sudo apt-get -y install nginx

# whoa. thanks to http://www.thisprogrammingthing.com/2013/getting-started-with-vagrant/
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password rootpass'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password rootpass'
sudo apt-get -y install mysql-server --fix-missing --fix-broken                                       
sudo apt-get -y install mysql-client libmysqlclient-dev # seriously, the mysql gem won't work without these so save yourself grief and just do it

# load timezone info into mysql
mysql_tzinfo_to_sql /usr/share/zoneinfo/

# thanks to http://rshestakov.wordpress.com/2014/01/26/how-to-make-vagrant-and-puppet-to-clone-private-github-repo 
# add github to the list of known_hosts
#sudo touch ~/.ssh/known_hosts
#sudo ssh-keyscan -H "github.com" >> ~/.ssh/known_hosts
#sudo chmod 600 ~/.ssh/known_hosts

# doesn't work right now, will fail spectacularly
#echo 'cloning dotfiles from github'
#git clone git@github.com:beane/dotfiles.git
#chmod +x ~/dotfiles/setup.sh
#./setup.sh

