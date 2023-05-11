spotify-client:
  pkgrepo.managed:
    - name: deb http://repository.spotify.com stable non-free
    - file: /etc/apt/sources.list.d/spotify.list
    - key_url: https://download.spotify.com/debian/pubkey_0D811D58.gpg
    - key_server: hkp://keyserver.ubuntu.com:80
    
spotify:
  pkg.installed:
    - name: spotify-client
    - refresh: True

