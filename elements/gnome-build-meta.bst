kind: junction

sources:
- kind: git_repo
  url: gitlab:gnome/gnome-build-meta.git
  track: gnome-51
  ref: 51.0-1-g66496574a8103a5106d79e2759287ac3835a1757

config:
  options:
    arch: '%{arch}'
  (?):
    - x86_64_v3:
      x86_64_v3: true

overrides:
  freedesktop-sdk.bst: freedesktop-sdk.bst
  core/meta-gnome-core-apps.bst: core/meta-gnome-core-apps.bst
  plugins/buildstream-plugins.bst: plugins/buildstream-plugins.bst
  plugins/buildstream-plugins-community.bst: plugins/buildstream-plugins-community.bst