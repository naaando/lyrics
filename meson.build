project ('com.github.naaando.lyrics', 'vala', 'c',
    version: '0.9.1',
    license: 'GPL3'
)

gnome = import ('gnome')
i18n = import('i18n')
add_project_arguments('-DGETTEXT_PACKAGE="lyrics"', language:'c')

add_project_arguments(['-g', '-X', '-rdynamic'], language: 'vala')

asresources = gnome.compile_resources(
    'as-resources', 'data/' + meson.project_name() + '.gresource.xml',
    source_dir: 'data',
    c_name: 'as'
)

sources = run_command('meson/find_sources.sh', check: true).stdout().strip().split('\n')

deps = [
    dependency ('glib-2.0'),
    dependency ('gtk+-3.0'),
    dependency ('gee-0.8'),
    dependency ('libsoup-2.4'),
    dependency ('xmlbird'),
]

executable(
    meson.project_name(),
    asresources,
    sources,
    dependencies: deps,
    c_args: ['-fprofile-arcs', '-ftest-coverage', '-fprofile-abs-path'],
    link_args: ['-fprofile-arcs', '-ftest-coverage', '-fprofile-abs-path'],
    install: true
)

subdir ('data')
subdir('po')

meson.add_install_script('meson/post_install.py')

unit_test_sources = run_command('meson/find_unit_test_sources.sh', check: true).stdout().strip().split('\n')

test(
  'unit',
  executable(
    'unit',
    unit_test_sources,
    dependencies: deps,
    c_args: ['-fprofile-arcs', '-ftest-coverage', '-fprofile-abs-path'],
    link_args: ['-fprofile-arcs', '-ftest-coverage', '-fprofile-abs-path'],
  ),
  args: ['--tap'],
  env: [
    'G_TEST_SRCDIR=@0@'.format(meson.current_source_dir()),
    'G_TEST_BUILDDIR=@0@'.format(meson.current_build_dir()),
    'G_DISABLE_ASSERT=1',
  ],
  protocol: 'tap',
)
