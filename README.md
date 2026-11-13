# Spire_Blue_mod

这是可继续开发的角色原型，基于 Alchyr 的 BasicMod character 分支。
当前角色暂名“测试角色”（英文 The Prototype），使用模板占位外观。
角色的正式名称、题材、美术和独有机制尚未确定。

## 当前行为

- 70 点生命，3 点能量。
- 初始卡组：5 张打击、4 张防御、1 张痛击。
- 初始遗物：燃烧之血。
- 暂借铁甲战士的红色卡池，保证战斗奖励、商店和事件有可用卡牌。
- 独立的角色枚举、资源目录和预留卡色，不替换原版铁甲战士。
- 提供英文和简体中文角色文本。

正式制作专属卡牌后，再将 PrototypeCharacter.getCardColor() 切换至 Meta.CARD_COLOR。
在专属卡池数量足以支持奖励和商店前，保持当前临时卡池。

## 在本机使用

在 IntelliJ IDEA 中打开本目录的 pom.xml，选择作为 Maven 项目打开。
使用现有 JDK 21 编译，编译器已经固定输出 Java 8 兼容代码。
启动游戏使用游戏自带的 Java 8。

首次克隆后，复制 local.settings.example.json 为 local.settings.json，再确认 steamApps 指向本机 Steam 库的 steamapps 目录。
local.settings.json 仅留在本机，不提交到 GitHub。更换机器或移动游戏后修改其中的 steamApps。
pom.xml 中的 steam.windows 也预设为当前本机路径，便于直接通过 IDEA 构建。

在本目录的 PowerShell 中运行：

    .\Build.ps1

构建并安装到游戏的 mods 文件夹：

    .\Build.ps1 -Install

构建、安装并只启用 BaseMod、StSLib 和本项目启动：

    .\Start-Mod.ps1

只使用已经构建的 JAR 启动：

    .\Start-Mod.ps1 -SkipBuild

如果希望显示 ModTheSpire 选择窗口：

    .\Start-Mod.ps1 -SkipBuild -Launcher

也可双击 Start-Mod.cmd。先让 Steam 保持运行。
日志保存在本项目 logs 文件夹中。
安装过程仅复制本项目 JAR 到游戏 mods 文件夹。

## 主要修改入口

- src/main/java/spireprototype/character/PrototypeCharacter.java：角色、初始卡组、遗物和卡池。
- src/main/java/spireprototype/PrototypeMod.java：角色注册、语言资源和 Mod 入口。
- src/main/resources/spireprototype/localization/zhs/CharacterStrings.json：中文名称和描述。
- src/main/resources/spireprototype/images/character：角色选择图、动画和其他占位素材。
- src/main/java/spireprototype/cards：后续添加专属卡牌。
- src/main/java/spireprototype/relics：后续添加专属遗物。

## 模板来源

https://github.com/Alchyr/BasicMod/tree/character

保留模板的 MIT LICENSE，并将其同时包含在构建的 JAR 中。

## 当前开发进度

详见 docs/PROGRESS.md。当前仅保存开发环境和角色骨架；正式角色设定与机制尚未确定。
当前代码内的 spireprototype 是临时内部标识，角色主题确定后再统一调整。
