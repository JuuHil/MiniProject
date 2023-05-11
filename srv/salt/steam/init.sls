steam:
  cmd.run:
    - name: |
        wget "https://steamcdn-a.akamaihd.net/client/installer/steam.deb" -O /tmp/steam.deb
        sudo apt install /tmp/steam.deb
    - creates: /usr/games/steam

