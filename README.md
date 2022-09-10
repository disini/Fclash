# FClash

<p align="center"><img src="assets/images/app_tray.png" style="border-radius: 50%;"/></p>


<p align="center" style="font-size: 20px">A Clash Proxy Fronted based on Clash</p>
<p align="center" style="font-size: 16px">Windows / Linux Supported, macOS comming soon!</p>

[![flutter awesome](https://img.shields.io/badge/Flutter-Awesome-orange)](https://flutterawesome.com/clash-fronted-client-by-flutter-linux-supported/)
[![fclash](https://snapcraft.io/fclash/badge.svg)](https://snapcraft.io/fclash)
[![release](https://img.shields.io/github/v/release/kingtous/fclash)](https://github.com/Kingtous/Fclash/releases)
[![aur](https://img.shields.io/aur/version/fclash)](https://aur.archlinux.org/packages/fclash)
![downloads](https://img.shields.io/github/downloads/kingtous/fclash/total)
![](https://img.shields.io/github/workflow/status/kingtous/fclash/Build%20Debian%20Package)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/1d9c16d3c94f45fc9b4ee95d9c2e6f8c)](https://www.codacy.com/gh/Kingtous/Fclash/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=Kingtous/Fclash&amp;utm_campaign=Badge_Grade)
![commit](https://img.shields.io/github/commit-activity/y/kingtous/fclash)
[![stars](https://img.shields.io/github/stars/kingtous/fclash?style=social)]()


## Install

- For Arch/Manjaro users, using AUR
  - `yay -S fclash`
- For Ubuntu/Debian users, download deb files directly
  - [https://github.com/Kingtous/Fclash/releases](https://github.com/Kingtous/Fclash/releases)
- For other distro users, using snap app.
  - [![Get it from the Snap Store](https://snapcraft.io/static/images/badges/en/snap-store-black.svg)](https://snapcraft.io/fclash)

## Feature

- Stable: Restart and restore clash status when clash kernel crashs automatically.
- Stable: Monitor Realtime runtime status.
- UI: Beautiful UI built by Flutter.
- UI: Chinese/English localizations supported.
- UI: Light/Dark mode supported.
- Functions: Easy to set/unset as system proxy.
- Functions: Full customized setting, proxy mode, ports, LAN connection, ipv6, etc.
- Functions: Switch yaml configs in realtime.
- Functions: Test delay with each proxy.
- Functions: prebuilt clash kernel and country mmdb.
- Info: Show status on status menu bar.
- Info: Show logs on About page.
- Info: Show download/upload rates on both system app menu bar and in-app menu bar.

## Preview

- Proxy Page
  ![](docs/images/%E6%B7%B1%E5%BA%A6%E6%88%AA%E5%9B%BE_%E9%80%89%E6%8B%A9%E5%8C%BA%E5%9F%9F_20220414110524.png)

- Profile Page
  ![](docs/images/深度截图_选择区域_20220414110533.png)

- Setting Page
  ![](docs/images/深度截图_选择区域_20220414110541.png)

- Logs Page
  ![](docs/images/深度截图_选择区域_20220414110604.png)

- Add a subscription page
  ![](docs/images/深度截图_选择区域_20220414110622.png)

- About Page
  ![](docs/images/深度截图_选择区域_20220414114331.png)

- App system menu bar
  ![](docs/images/Screenshot_20220414_112025.png)

## Install

- Snap Store(comming soon)
  - `sudo snap install fclash --classic`

- Download DEB files, go to [Github Action page](https://github.com/Kingtous/Fclash/actions).

## Build from source

FClash depends `libappindicatior3-dev` when compiling.
