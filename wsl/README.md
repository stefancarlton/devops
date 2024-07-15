# WSL

This is how I setup Windows 11 with WSL

### Windows Terminal
Install windows Terminal using [MS Store](https://www.microsoft.com/store/productId/9N0DX20HK701)

#### Settings
* Launch Size (`Settings → Startup → Launch size`). On a QHD monitor 220 columns by 45 rows.

### Install WSL
Using [MS guide](https://learn.microsoft.com/en-us/windows/wsl/install)

* Open powershell as an administrator
* Type `wsl --install`

### Install Ubuntu
* Install the latest version of [Ubuntu in the MS Store](https://apps.microsoft.com/store/detail/ubuntu-22042-lts/9PN20MSR04DW)
* Create a user with your name, _do not set a password_

### Ubuntu setup

* Backup your `/.bashrc` just in case something goes awry: `cp ~/.bashrc ~/.bashrc.bak`
* Passwordless sudo `echo "$USER ALL=(ALL:ALL) NOPASSWD:ALL" | sudo tee "/etc/sudoers.d/$USER.test" > /dev/null`
* Update system: `sudo apt update && sudo apt upgrade`
* Generic tooling: `sudo apt install git git-flow jq autossh zip 7zip make htop python3 python3-venv nano fontconfig`
* Ensure SSH config exists: `mkdir ~/.ssh/ && touch ~/.ssh/config`
* Git Config:
```bash
git config --global core.autocrlf false
git config --global push.default current
git config --global core.editor "nano"
git config --global rerere.enabled true
git config --global user.name "<YOUR NAME HERE>"
git config --global user.email "<YOUR EMAIL HERE>"
```
* Set MSEdge to default browser (change path if using different default browser): 
```bash
sudo ln -s /mnt/c/Program\ Files\ \(x86\)/Microsoft/Edge/Application/msedge.exe /usr/local/bin/msedge
echo 'export BROWSER=/usr/local/bin/msedge' >> ~/.bashrc
source ~/.bashrc
```

#### PHP
* Ondrej repo: `sudo apt install software-properties-common && sudo add-apt-repository ppa:ondrej/php`
* Install PHP runtimes (note no FPM - this is just for tooling such as `phpunit`, `phpcs` or `phpstan` and IDE access): 
```bash 
sudo apt install php7.3 php7.3-mysqli php7.3-xml php7.3-gd php7.3-xml php7.3-curl php7.3-mbstring php7.3-zip php7.3-xml \
		 php7.4 php7.4-mysqli php7.4-xml php7.4-gd php7.4-xml php7.4-curl php7.4-mbstring php7.4-zip php7.4-xml \
		 php8.1 php8.1-mysqli php8.1-xml php8.1-gd php8.1-xml php8.1-curl php8.1-mbstring php8.1-zip php8.1-xml \
		 php8.2 php8.2-mysqli php8.2-xml php8.2-gd php8.2-xml php8.2-curl php8.2-mbstring php8.2-zip php8.2-xml \
		 php8.3 php8.3-mysqli php8.3-xml php8.3-gd php8.3-xml php8.3-curl php8.3-mbstring php8.3-zip php8.3-xml \
```
* configure PHP to use 8.3 by default: `sudo update-alternatives --set php /usr/bin/php8.3`
* Composer: 
```bash 
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer 
```

#### MySQL
* Install the MySQL Client: `sudo apt install mysql-client`

#### Node
Install latest LTS Node version using NVM:
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.bashrc
nvm install --lts
nvm alias default 20
npm uninstall -g yarn pnpm
npm install -g corepack
corepack enable
corepack prepare yarn@stable --activate
```

#### AWS CLI
Install AWS CLI

```bash
cd /tmp
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf awscliv2.zip aws

curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"
sudo dpkg -i session-manager-plugin.deb
rm session-manager-plugin.deb
```

#### Oh My Posh
[Longer guide](https://www.hanselman.com/blog/my-ultimate-powershell-prompt-with-oh-my-posh-and-the-windows-terminal) with all [settings documented here](https://ohmyposh.dev/docs/installation/customize)

* [Download, unzip and install nerd fonts](https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/CascadiaCode.zip)
* Copy fonts to Ubuntu (assumes you have them in your downloads directory):
```bash 
mkdir ~/.fonts
cp /mnt/c/Users/<your username>/Downloads/*.tff ~/.fonts
fc-cache -fv
```
* Close & reopen terminal
* In Terminal, goto `settings → Ubuntu → Appearance` and choose Caskaydia Nerd Font
* Close & reopen terminal
* Install Oh-My-Posh:
```bash
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr
sudo chmod +x /usr/local/bin/oh-my-posh

mkdir ~/.poshthemes
wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O ~/.poshthemes/t
unzip ~/.poshthemes/themes.zip -d ~/.poshthemes
chmod u+rw ~/.poshthemes/*.omp.*
rm ~/.poshthemes/themes.zip

# export the config so you can edit it
oh-my-posh config export --output ~/.poshconfig.omp.json
```
* Add eval statement to `./bashrc`: `echo "eval \"$(oh-my-posh init bash --config ~/.poshconfig.omp.json)\" >> ~/.bashrc`

### Docker
Install [Docker Desktop](https://docs.docker.com/desktop/install/windows-install/) with WSL backend


## Additional customisations

### Directory
I like to create a directory in the home folder for code: `mkdir "$HOME/Code"`

If there is a local variable used within projects, set it into your `./bashrc`: `echo 'export LOCAL_CODE_DIR="${HOME}/Code"' >> ~/.bashrc`

### Git SSH setup:
GitHub - [generate key docs](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key)

```bash
ssh-keygen -t ed25519 -b 4096 -C "<YOUR EMAIL HERE>" -f ~/.ssh/github
echo "Host github.com
	HostName github.com
	IdentityFile ~/.ssh/github
	User git" > ~/.ssh/config
```


BitBucket - [generate key docs](https://support.atlassian.com/bitbucket-cloud/docs/set-up-personal-ssh-keys-on-linux/)
```bash
ssh-keygen -t ed25519 -b 4096 -C "<YOUR EMAIL HERE>" -f ~/.ssh/bitbucket

echo "Host bitbucket.org
	HostName bitbucket.org
	IdentityFile ~/.ssh/bitbucket
	User git" > ~/.ssh/config
```
