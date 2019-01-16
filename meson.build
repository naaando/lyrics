project ('com.github.naaando.lyrics', 'vala', 'c',
    version: '0.4.3',
    license: 'GPL3'
)

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
    'src/Core/LyricsService.vala',
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
    'src/Parser/LyricFormatter.vala',
    'src/Parser/ParserChain/AChainOfResponsibility.vala',
    'src/Parser/ParserChain/CompressedLyricContentParser.vala',
    'src/Parser/ParserChain/LyricEmptyStringParser.vala',
    'src/Parser/ParserChain/LyricMetadataParser.vala',
    'src/Parser/ParserChain/LyricContentParser.vala',
    'src/View/Factory/ViewFactory.vala',
    'src/View/HeaderBar.vala',
    'src/View/MainStack.vala',
    'src/View/MainWindow.vala',
    'src/View/SettingsPopover.vala',
    'src/View/Widgets/Displays/IDisplay.vala',
    'src/View/Widgets/Displays/SimpleDisplay.vala',
    'src/View/Widgets/Displays/ScrolledDisplay.vala',
    'src/View/Widgets/DownloadView.vala',
    'src/View/Widgets/FileChooserButton.vala',
    'src/View/Widgets/ModeSwitch.vala',
    'src/View/Widgets/SearchLyric.vala',
    'src/Application.vala',
    'src/SimplePlayer.vala',
    dependencies: [
        dependency ('glib-2.0'),
        dependency ('gtk+-3.0'),
        dependency ('granite'),
        dependency ('gee-0.8'),
        dependency ('cairo')
    ],
    install: true
)

subdir ('data')

meson.add_install_script('meson/post_install.py')
