# FClash

<p align="center"><img src="assets/images/app_tray.png" style="border-radius: 50%" width="150px"/></p>


<p align="center" style="font-size: 20px">A Clash Proxy Fronted based on Clash</p>
<p align="center" style="font-size: 16px">Windows / macOS / Linux(amd64/arm64) / Android(Beta) Supported!</p>
<p align="center" style="font-size: 16px">This app mainly focused on all Linux distros, which brings a better experience for linux users/developers.</p>

<p align="center" style="font-size: 8px;">The purpose of the app is to give a learning case how to build an app with Flutter and Golang for full-stack developers. It's STRICTLY Prohibited for any illegal usages, and it's only built for the learning purpose! </p>

 
> 项目初衷很纯粹：为了学习Golang语言、FFI框架+Flutter进行跨平台开发，通过FFI而不是RestFul的形式提高跨语言开发效率。同时解决广大科研工作者在Linux环境搞科研的网络缓慢且工具链匮乏的问题。
>
> 目前个人有其他的安排，没有太多的精力投入到这个项目中，故停止维护。

[![flutter awesome](https://img.shields.io/badge/Flutter-Awesome-orange)](https://flutterawesome.com/clash-fronted-client-by-flutter-linux-supported/)
[![fclash](https://snapcraft.io/fclash/badge.svg)](https://snapcraft.io/fclash)
[![release](https://img.shields.io/github/v/release/kingtous/fclash)](https://github.com/Kingtous/Fclash/releases)
[![aur](https://img.shields.io/aur/version/fclash)](https://aur.archlinux.org/packages/fclash)
![downloads](https://img.shields.io/github/downloads/kingtous/fclash/total)
![](https://img.shields.io/github/workflow/status/kingtous/fclash/Build%20Debian%20Package)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/1d9c16d3c94f45fc9b4ee95d9c2e6f8c)](https://www.codacy.com/gh/Kingtous/Fclash/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=Kingtous/Fclash&amp;utm_campaign=Badge_Grade)
![commit](https://img.shields.io/github/commit-activity/y/kingtous/fclash)
[![stars](https://img.shields.io/github/stars/kingtous/fclash?style=social)]()
[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2FKingtous%2FFclash.svg?type=shield)](https://app.fossa.com/projects/git%2Bgithub.com%2FKingtous%2FFclash?ref=badge_shield)

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=kingtous/fclash&type=Date)](https://star-history.com/#kingtous/fclash&Date)

## Install

### Linux

- For Arch/Manjaro users, using AUR
  - `yay -S fclash`
- For Ubuntu/Debian users, download deb files directly
  - [https://github.com/Kingtous/Fclash/releases](https://github.com/Kingtous/Fclash/releases)
- For Redhat/Fedora/OpenSuse users, download rpm files directly.
  - [https://github.com/Kingtous/Fclash/releases](https://github.com/Kingtous/Fclash/releases)
- For other distro users, please to use the snap app.
  - [![Get it from the Snap Store](https://snapcraft.io/static/images/badges/en/snap-store-black.svg)](https://snapcraft.io/fclash)

Note: If you are using in `Wayland`, please use `export WAYLAND_DISPLAY=wayland-x11` or `WAYLAND_DISPLAY=wayland-x11 ./fclash`. Check https://github.com/Fclash/Fclash/issues/52 for details.

### Windows

Please download .exe setup directly. [https://github.com/Kingtous/Fclash/releases](https://github.com/Kingtous/Fclash/releases)

### MacOS

Please download .dmg setup directly. [https://github.com/Kingtous/Fclash/releases](https://github.com/Kingtous/Fclash/releases)

Note that macOS will treat the `FClash` as an untrusted app, so please go to settings and trust it manually.

### Android

<a href='https://play.google.com/store/apps/details?id=com.fclash.fclash&pcampaignid=pcampaignidMKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1'><img alt='Get it on Google Play' src='https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png' style="width:250px"/></a>

or download .apk directly. [https://github.com/Kingtous/Fclash/releases](https://github.com/Kingtous/Fclash/releases)

Note: the Android version is looking for contributors.

## Feature

- More features: FClash is based on the full open source [Clash.Meta](https://github.com/MetaCubeX/Clash.Meta).
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
 ![image](https://github.com/Fclash/Fclash/assets/39793325/b569cb61-e7f0-43c3-b4f7-6b35ab9abd51)


- Profile Page
 ![image](https://github.com/Fclash/Fclash/assets/39793325/abfe9f01-b3dc-4d1b-978f-ff2f5b92134a)


- Setting Page
 ![image](https://github.com/Fclash/Fclash/assets/39793325/36a908e0-d5b4-428e-835d-abf4a7c9727a)


- Logs Page

 ![image](https://github.com/Fclash/Fclash/assets/39793325/4f7d646e-1420-4905-bbe1-20d83135f98a)


- Add a subscription page
  ![](docs/images/深度截图_选择区域_20220414110622.png)
  
- support `RULE-SET` convert (a feature of Clash Premium).
  
  ![image](https://user-images.githubusercontent.com/39793325/215257349-2e55d8ec-3d73-4244-8ea1-f652a0627086.png)


- About Page

 ![image](https://github.com/Fclash/Fclash/assets/39793325/166f4b85-f95f-4e6f-bea1-6e4721b0e481)


- App system menu bar

  ![](docs/images/Screenshot_20220414_112025.png)

![截屏2023-09-07 09 20 29](https://github.com/Fclash/Fclash/assets/39793325/558755eb-f887-4910-a537-52c67445df8b)

## Install

- Snap Store(comming soon)
  - `sudo snap install fclash --classic`

- Download DEB files, go to [Github Action page](https://github.com/Kingtous/Fclash/actions).

## Build from source

FClash depends `libappindicator3-dev` when compiling.

## License
[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2FKingtous%2FFclash.svg?type=large)](https://app.fossa.com/projects/git%2Bgithub.com%2FKingtous%2FFclash?ref=badge_large)

