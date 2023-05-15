discord:
  cmd.run:
    - name: |
        wget "https://discord.com/api/download?platform=linux&format=deb" -O /tmp/discord.deb
        sudo dpkg -i /tmp/discord.deb
    - creates: /usr/bin/discord

