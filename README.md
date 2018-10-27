# Lyrics - Download and display lyrics for musics
Display lyrics of your media player if it has support to MPRIS-2

![Screenshot](data/screenshot.png)
![Screenshot](data/screenshot-dark.png)

|    ![Screenshot](data/screenshot-inactive.png)        |      ![Screenshot](data/screenshot-dark-inactive.png)      |
| -------------------------------------------- | ------------------------------------------------- |

## Building and Installation

You'll need the following dependencies:

    libglib2.0-dev
    libgranite-dev
    libgtk-3-dev
    libcairo2-dev
    meson
    valac

Run `meson` to configure the build environment and then `ninja` to build

    meson build --prefix=/usr
    ninja -C build

To install, use `ninja install`

    sudo ninja -C build install

And execute

  `com.github.naaando.lyrics`
