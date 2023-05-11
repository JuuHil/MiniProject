spotify-client:
  pkgrepo.managed:
    - name: deb http://repository.spotify.com stable non-free
    - file: /etc/apt/sources.list.d/spotify.list
    - key_url: https://download.spotify.com/debian/pubkey_0D811D58.gpg

spotify:
  pkg.installed:
    - name: spotify-client
    - refresh: True

