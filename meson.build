project ('com.github.naaando.lyrics', 'vala', 'c')

gnome = import ('gnome')

add_global_arguments ('-DGETTEXT_PACKAGE="' + meson.project_name () + '"', language:'c')

asresources = gnome.compile_resources(
    'as-resources', 'data/' + meson.project_name() + '.gresource.xml',
    source_dir: 'data',
    c_name: 'as'
)

executable(
    meson.project_name (),
    asresources,
    'src/Core/Factory/MetasongFactory.vala',
    'src/Core/Lyric.vala',
    'src/Core/Metasong.vala',
    'src/Core/Player.vala',
    'src/Core/Players.vala',
    'src/Repository/Interfaces/IRepository.vala',
    'src/Repository/Local/LocalFile.vala',
    'src/Repository/Local/LocalRepository.vala',
    'src/Repository/LyricSources/LyricSourcesDownloader.vala',
    'src/Repository/LyricSources/LyricSourcesRemoteFile.vala',
    'src/Repository/LyricSources/LyricSourcesRepository.vala',
    'src/Repository/ILyricFile.vala',
    'src/Repository/Repository.vala',
    'src/Mpris/MprisClient.vala',
    'src/Mpris/MprisPlayer.vala',
    'src/Mpris/MprisService.vala',
    'src/Parser/LRC-Parser.vala',
    'src/Widgets/Display.vala',
    'src/Widgets/Download.vala',
    'src/Widgets/ModeSwitch.vala',
    'src/Application.vala',
    'src/MainWindow.vala',
    'src/SimplePlayer.vala',
    'src/StackController.vala',
    dependencies: [
        dependency ('glib-2.0'),
        dependency ('gtk+-3.0'),
        dependency ('gee-0.8'),
        dependency ('cairo')
    ],
    install: true
)

subdir ('data')

meson.add_install_script('meson/post_install.py')
