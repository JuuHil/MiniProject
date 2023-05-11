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
