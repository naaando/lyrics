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

    meson setup build --prefix=/usr/local
    meson compile -C build

To install, use `ninja install`

    ninja -C build install

And execute

  `com.github.naaando.lyrics`

## Unit testing

The unit tests can be run on the build directory with the following command:

    meson -Db_coverage=true build

    meson test -C build --print-errorlogs

    ninja -C build coverage-text

    ninja -C build coverage-html

## Coverage

Coverage is currently broken on meson setup
A workaround is to run coverage.sh

    ./coverage.sh
