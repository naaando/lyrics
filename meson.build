project ('com.github.naaando.lyrics', 'vala', 'c',
    license: 'GPL3'
)

gnome = import ('gnome')
i18n = import('i18n')
add_project_arguments('-DGETTEXT_PACKAGE="lyrics"', language:'c')

asresources = gnome.compile_resources(
    'as-resources', 'data/' + meson.project_name() + '.gresource.xml',
    source_dir: 'data',
    c_name: 'as'
)

c = run_command('meson_helper.sh', check: true)
sources = c.stdout().strip().split('\n')
executable(
    meson.project_name(),
    asresources,
    sources,
    dependencies: [
        dependency ('glib-2.0'),
        dependency ('gtk+-3.0'),
        dependency ('gee-0.8'),
        dependency ('libsoup-2.4'),
        dependency ('xmlbird'),
    ],
    install: true
)

subdir ('data')
subdir('po')

meson.add_install_script('meson/post_install.py')
