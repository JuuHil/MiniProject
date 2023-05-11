## Johdanto

Minulle tärkeitä sovelluksia linuxille automatisoitu saltilla.

## Rauta

    Koneen rauta ja käyttöjärjestelmä
    CPU:  i7-13700K 5,4GHz
    RAM:  32GB DDR5 5200Mhz
    GPU:  RTX 3080 OC 10G
    OS:   Windows 11 Pro, Versio 22H2
    
## Versiot. 
    
    Windows 11 Pro, Versio 22H2
    Vagrant 2.3.4
    Salt 3002.6
    debian 5.10.158-2
    

# Linuxille käsin asennus

## Spotify

Asensin Spotifyn käsin spotifyn ohjeen mukaan. https://www.spotify.com/fi/download/linux/

    curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
    echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

Ja asensin Spotifyn clientin.

    sudo apt-get update && sudo apt-get install spotify-client

![image](https://user-images.githubusercontent.com/122887067/237043327-cf6fe69e-d76f-4e21-b8a6-533452009e55.png)

## Discord

Asensin Discordin `wget`in avulla

    wget "https://discord.com/api/download?platform=linux&format=deb" -O discord.deb
    
Discordin deb binäärin latauksen jälkeen asensin sen `apt`in avulla.

    sudo apt install ./discord.deb

Discordin sai avattua kirjoittamalla `discord` terminaliin

![image](https://user-images.githubusercontent.com/122887067/237050646-0e478c2d-2838-4666-bac7-25b6df45a6ed.png)

## Steam

Asensin Steamin `curl`in avulla

    curl -O https://steamcdn-a.akamaihd.net/client/installer/steam.deb

Asensin Steam-paketin komennolla

     sudo apt install ./steam.deb

Kun asennus oli valmis, käynnistin Steam kirjoittamalla `steam` terminaaliin.

Sen jälkeen steam lähti päivittämään

![image](https://user-images.githubusercontent.com/122887067/237057003-982071a9-3cdd-4be3-86f8-f3b25d1e37bc.png)

Päivityksen jälkeen valmista tuli

![image](https://user-images.githubusercontent.com/122887067/237057309-290de531-5db8-4c63-b8ec-eb407e81871e.png)

# Automatisointi

## Spotify


cat init.sls

        spotify-client:
          pkgrepo.managed:
            - humanname: Spotify Repository
            - name: deb http://repository.spotify.com stable non-free
            - file: /etc/apt/sources.list.d/spotify.list
            - key_url: https://download.spotify.com/debian/pubkey_0D811D58.gpg

        spotify:
          pkg.installed:
            - name: spotify-client
            - refresh: True

## Discord

Lataa Discordin `wget`in avulla ja tallentaa sen `/tmp` hakemistoon
ja asentaa Discordin käyttäen aptia. Lisäksi tarkistaa (`creates`) onko /usr/bin/discord jo olemassa, ennenkuin suorittaa komennon, jolloin Salt ei suorita sitä uudelleen, jos Discord on jo asennettuna.

       discord:
         cmd.run:
           - name: |
               wget "https://discord.com/api/download?platform=linux&format=deb" -O /tmp/discord.deb
               sudo apt install /tmp/discord.deb
           - creates: /usr/bin/discord

## Steam

Kokeilin aluksi käyttää Curlia (vaihtelun vuoksi) ladatakseen Steamin, mutta en saanut sitä toimimaan, joten siirryin käyttämään `wget`tiä.

### EI TOIMI

        steam:
          cmd.run:
            - name: curl -O https://steamcdn-a.akamaihd.net/client/installer/steam.deb && sudo apt install ./steam.deb
            - cwd: /tmp
            - creates: /usr/games/steam

`wget`avulla sain asennettua Steamin-paketin ja aptin avulla se asentaa sen.
creates tarkistaa onko /usr/games/steam tiedosto jo olemassa, jolloin Salt ei suorita sitä uudelleen, jos Steam on jo asennettuna.

        steam:
          cmd.run:
            - name: |
                wget "https://steamcdn-a.akamaihd.net/client/installer/steam.deb" -O /tmp/steam.deb
                sudo apt install /tmp/steam.deb
            - creates: /usr/games/steam

## Värisuora

juuhil@pug:/srv/salt/every$ cat init.sls 

    spotify-client:
      pkgrepo.managed:
        - humanname: Spotify Repository
        - name: deb http://repository.spotify.com stable non-free
        - file: /etc/apt/sources.list.d/spotify.list
        - key_url: https://download.spotify.com/debian/pubkey_0D811D58.gpg

    spotify:
      pkg.installed:
        - name: spotify-client
        - refresh: True

    discord:
      pkg.installed:
        - sources:
          - discord: https://discord.com/api/download?platform=linux&format=deb

    steam:
      cmd.run:
        - name: |
            wget "https://steamcdn-a.akamaihd.net/client/installer/steam.deb" -O /tmp/steam.deb
            sudo apt install /tmp/steam.deb
        - creates: /usr/games/steam







