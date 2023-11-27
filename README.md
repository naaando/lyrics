# Lyrics - Sing along with your songs
Display lyrics on media players with MPRIS-2 interface

Heavily inspired by [Minilyrics](https://www.crintsoft.com/minilyrics/)

<p align=center>
    <a href='https://appcenter.elementary.io/com.github.naaando.lyrics/'>
        <img alt='Get it on AppCenter' src='https://appcenter.elementary.io/badge.svg'/>
    </a>
    <a href='https://github.com/naaando/lyrics/releases'>
        <img alt='Get the .deb' src='https://robertsanseries.github.io/ciano/img/badge.svg'/>
    </a>
    <a href='https://flathub.org/apps/details/com.github.naaando.lyrics'>
        <img alt='Get flatpak' width=150 src='https://flathub.org/assets/badges/flathub-badge-en.png'/>
    </a>
</p>

![Screenshot](data/screenshot-dark.png)
![Screenshot](data/screenshot.png)

|    ![Screenshot](data/screenshot-inactive.png)        |      ![Screenshot](data/screenshot-dark-inactive.png)      |
| -------------------------------------------- | ------------------------------------------------- |

#### Using it with youtube
If you're using Chromium based browsers you can use lyrics on Youtube with this [browser-playerctl extension](https://chrome.google.com/webstore/detail/browser-playerctl/ojjjidifjmbbckdjfiagdfdepbcmnicg).

#### Known issue
Lyrics isn't able to syncronize with Spotify App (at least for free accounts) due to null MPRIS position, so the Lyrics will always start from beginnig wherever the track position is.

### Roadmap

- [ ] random crashes
- [ ] synchronization issues
- [ ] offset
- [ ] lyrics search
- [ ] background customization

## Building and Installation

You'll need the following dependencies:

    libglib2.0-dev
    libgranite-dev
    libgtk-3-dev
    libcairo2-dev
    libsoup-dev
    xmlbird
    meson
    valac
    gettext


Ubuntu 23.10

```shell
sudo apt install libglib2.0-dev libgranite-dev libgtk-3-dev libcairo2-dev meson valac libsoup2.4-dev libsoup-gnome2.4-dev libxmlbird-dev gettext
```

Run `meson` to configure the build environment and then `ninja` to build

    meson build --prefix=/usr/local
    ninja -C build

To install, use `ninja install`

    ninja -C build install

And execute

  `com.github.naaando.lyrics`
