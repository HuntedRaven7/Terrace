kind: manual

sources:
- kind: git_repo
  url: https://github.com/quickshell-mirror/quickshell.git
  track: v0.3.1
  ref: v0.3.1

depends:
- freedesktop-sdk.bst:qt6-qtbase
- freedesktop-sdk.bst:qt6-qtdeclarative
- freedesktop-sdk.bst:qt6-qtwayland
- freedesktop-sdk.bst:qt6-qtsvg
- freedesktop-sdk.bst:qt6-qttools
- freedesktop-sdk.bst:wayland
- freedesktop-sdk.bst:wayland-protocols
- freedesktop-sdk.bst:wlroots
- freedesktop-sdk.bst:mesa
- freedesktop-sdk.bst:libinput
- freedesktop-sdk.bst:libxkbcommon
- freedesktop-sdk.bst:pipewire
- freedesktop-sdk.bst:libpipewire
- freedesktop-sdk.bst:glib
- freedesktop-sdk.bst:fmt
- freedesktop-sdk.bst:spdlog
- freedesktop-sdk.bst:nlohmann-json
- freedesktop-sdk.bst:tomlplusplus
- freedesktop-sdk.bst:cmake
- freedesktop-sdk.bst:ninja

config:
  build-commands:
  - cmake -B build -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTS=OFF
  - cmake --build build --parallel
  install-commands:
  - DESTDIR="${DESTDIR}" cmake --install build