spotify-client:
  pkgrepo.managed:
    - name: deb http://repository.spotify.com stable non-free
    - file: /etc/apt/sources.list.d/spotify.list
    - key_url: https://download.spotify.com/debian/pubkey_0D811D58.gpg

spotify:
  pkg.installed:
    - name: spotify-client
    - refresh: True

discord:
  cmd.run:
    - name: |
        wget "https://discord.com/api/download?platform=linux&format=deb" -O /tmp/discord.deb
        sudo apt install /tmp/discord.deb
    - creates: /usr/bin/discord

steam:
  cmd.run:
    - name: |
        wget "https://steamcdn-a.akamaihd.net/client/installer/steam.deb" -O /tmp/steam.deb
        sudo apt install /tmp/steam.deb
    - creates: /usr/games/steam
