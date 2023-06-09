install_wget:
  pkg.installed:
    - name: wget
   
install_libc++1:
  pkg.installed:
    - name: libc++1
    
fix_dependencies:
  cmd.run:
    - name: sudo apt --fix-broken install

spotify_key:
  cmd.run:
    - name: sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 7A3A762FAFD4A51F
    - unless: sudo apt-key list | grep 7A3A762FAFD4A51F

spotify-client:
  pkgrepo.managed:
    - name: deb http://repository.spotify.com stable non-free  
    - file: /etc/apt/sources.list.d/spotify.list
    - key_url: https://download.spotify.com/debian/pubkey_0D811D58.gpg

spotify:
  pkg.installed:
    - name: spotify-client
    - refresh: True

steam:
  cmd.run:
    - name: |
        wget "https://steamcdn-a.akamaihd.net/client/installer/steam.deb" -O /tmp/steam.deb
        sudo apt install /tmp/steam.deb
    - creates: /usr/games/steam

discord:
  cmd.run:
    - name: |
        wget "https://discord.com/api/download?platform=linux&format=deb" -O /tmp/discord.deb
        sudo dpkg -i /tmp/discord.deb
    - creates: /usr/bin/discord

