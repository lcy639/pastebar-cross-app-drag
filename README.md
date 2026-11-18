# PasteBar 跨应用拖放补丁

由 [@lcy639](https://github.com/lcy639) 独立维护的 Windows 改动，适用于 [PasteBar v0.7.0](https://github.com/PasteBar/PasteBarApp/tree/v0.7.0)。

在历史卡片上按住鼠标约 100ms，用同一个动作拖到不同位置。

- 放到 PasteBar 内的有效区域，继续使用固定、归类等原有操作。
- 把文字拖到支持文本拖放的应用输入框，在落点插入文字。
- 把图片拖到支持文件拖放的窗口，例如 [CrossDrop](https://github.com/lcy639/crossdrop) 的文件框，以 PNG 文件交给接收方。CrossDrop 按自己的上传流程处理。

复制和三点菜单保留点击操作。跨应用拖放使用 Windows 自带的拖放机制。

## 在 Windows 上构建

需要 Git、Node.js 22、通过 rustup 安装的 Rust 1.87.0 MSVC 工具链、Visual Studio 2022 的 C++ 桌面开发组件和 Windows SDK。运行时需要 Microsoft Edge WebView2。

进入本仓库，在 Visual Studio 的 x64 开发者 PowerShell 中运行下面的命令。

```powershell
.\build.ps1
```

脚本会在仓库下的 `.build` 目录获取指定版本的上游源码、应用补丁并编译，最后输出 `.build\portable\PasteBar.exe`。双击即可试用。如果已有另一个 PasteBar 实例，请先从托盘退出。

本地已验证 Windows x64 构建、应用启动、历史数据库完整性，以及 Windows 读取 Unicode 文本与 PNG 文件路径。目标应用的鼠标放置和上传流程需在实际环境中验证。

## 来源和许可

原软件由 PasteBar / AnotherVision LLC 及其贡献者开发，本补丁是独立修改，未经原作者背书。此仓库提供 [修改补丁](./pastebar-v0.7.0.patch) 和构建脚本。

上游源码和构建结果仍适用原项目的许可条款。参见 [项目许可](https://github.com/PasteBar/PasteBarApp/blob/v0.7.0/CC-LICENSE) 和 [前端许可](https://github.com/PasteBar/PasteBarApp/blob/v0.7.0/packages/pastebar-app-ui/LICENSE)。
