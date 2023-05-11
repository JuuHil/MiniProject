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

Spotifyn kanssa oli eniten ongelmia, joten se ensimmäisenä. Spotifyn asentamisessa manuaalisesti piti määrittää Spotifyn Debian-varasto jonka jälkeen pystyi vasta asentamaan Spotifyn.

spotify_key: 
name: lisää spotify-palvelimen julkisen avaimen APT-palvelimen avainten joukkoon
unless: tarkistaa, onko avain jo asennettu, jos ei ole ajetaan ylempi komento.

spotify-client:
name: lähde mistä paketit ladataan (URL-osoite)
file: tiedoston sijainti
key_url: osoite jossa julkinen avain. (URL-osoite)
key_server: määrittää käyttämään Ubuntu-avainpalvelinta ladatakseen julkisen avaimen.

spotify:
name: nimi paketille, joka asennetaan.
refresh: päivittää pakettivaraston ennen paketin asentamista.



`init.sls` tiedoston sisältö

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

![image](https://github.com/JuuHil/MiniProject/assets/122887067/9a66a10f-9233-41db-b4b5-7192b1cda934)

## Discord

Lataa Discordin `wget`in avulla ja tallentaa sen `/tmp` hakemistoon
ja asentaa Discordin käyttäen aptia. Lisäksi tarkistaa (`creates`) onko /usr/bin/discord jo olemassa, ennenkuin suorittaa komennon, jolloin Salt ei suorita sitä uudelleen, jos Discord on jo asennettuna.

`init.sls` tiedoston sisältö

       discord:
         cmd.run:
           - name: |
               wget "https://discord.com/api/download?platform=linux&format=deb" -O /tmp/discord.deb
               sudo apt install /tmp/discord.deb
           - creates: /usr/bin/discord

## Steam

Kokeilin aluksi käyttää Curlia (vaihtelun vuoksi) ladatakseen Steamin, mutta en saanut sitä toimimaan, joten siirryin käyttämään `wget`tiä.

### EI TOIMI

`init.sls` tiedoston sisältö

        steam:
          cmd.run:
            - name: curl -O https://steamcdn-a.akamaihd.net/client/installer/steam.deb && sudo apt install ./steam.deb
            - cwd: /tmp
            - creates: /usr/games/steam

`wget`avulla sain asennettua Steamin-paketin ja aptin avulla se asentaa sen.
creates tarkistaa onko /usr/games/steam tiedosto jo olemassa, jolloin Salt ei suorita sitä uudelleen, jos Steam on jo asennettuna.

### TOIMII

`init.sls` tiedoston sisältö

        steam:
          cmd.run:
            - name: |
                wget "https://steamcdn-a.akamaihd.net/client/installer/steam.deb" -O /tmp/steam.deb
                sudo apt install /tmp/steam.deb
            - creates: /usr/games/steam

## Värisuora

Kaikki komennot yhdistettynä yhdeksi. 

`init.sls` tiedoston sisältö

    install_wget:
      pkg.installed:
        - name: wget
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

![image](https://github.com/JuuHil/MiniProject/assets/122887067/7ba4b05c-559b-4894-9dbe-8550723b5a81)

## Käyttöönotto

Aloitus tyhjällä koneella Step-by-step

Pakettien päivitys

    sudo apt-get update
    sudo apt-get -y dist-upgrade
    
Palomuuri

    sudo apt-get -y install ufw
    sudo ufw enable

Micron asennus
    
    sudo apt-get install micro
    
Saltin asennus

    sudo apt-get install salt-minion
 
Oikeaan paikkaan

    cd srv/

    sudo mkdir salt/

    cd salt/
    
![image](https://github.com/JuuHil/MiniProject/assets/122887067/112ba51c-3077-4d05-be3f-f56c3d48a07a)

Kansioiden tekeminen

    sudo mkdir discord
    sudo mkdir steam
    sudo mkdir spotify
    sudo mkdir every

Ensimmäisenä steam

    cd srv/salt/steam

Ja init tiedosto

    micro init.sls

        steam:
          cmd.run:
            - name: |
                wget "https://steamcdn-a.akamaihd.net/client/installer/steam.deb" -O /tmp/steam.deb
                sudo apt install /tmp/steam.deb
            - creates: /usr/games/steam

Ja ajo. 

    sudo salt-call state.apply steam --local
    
Steam toimii, mutta tarvitsee superuserin salasanan, jotta asennus onnistuu

![image](https://github.com/JuuHil/MiniProject/assets/122887067/30c37eba-b9f8-4d10-a001-05e7ca1d7d89)

Seuraavaksi discord.

    cd /srv/salt/discord
    
Ja init tiedosto

    discord:
      cmd.run:
        - name: |
            wget "https://discord.com/api/download?platform=linux&format=deb" -O /tmp/discord.deb
            sudo apt install /tmp/discord.deb
        - creates: /usr/bin/discord

Ja ajo.

    sudo salt-call state.apply discord --local
    
![image](https://github.com/JuuHil/MiniProject/assets/122887067/eb7fbbf7-e3dd-4a0b-b146-3cdc43433f31)

Seuraavana Spotify

    cd /srv/salt/spotify

Ja init tiedosto

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
        
Ja ajo. 

    sudo salt-call state.apply spotify --local

![image](https://github.com/JuuHil/MiniProject/assets/122887067/537f4bae-dd79-47d3-9f9e-4aa9608ba81e)

## Lopullinen testi

Täysin tyhjä kone.

## Lähteet 
https://github.com/JuuHil/infra/tree/main/Laksu

https://terokarvinen.com/2023/palvelinten-hallinta-2023-kevat/

https://www.spotify.com/fi/download/linux/

https://github.com/mirok99/h7demo

https://itsfoss.com/install-discord-linux/




