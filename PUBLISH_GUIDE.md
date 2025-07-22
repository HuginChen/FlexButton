# FlexButton 发布指南

## 📦 项目状态

✅ **已完成**:
- FlexButton 核心组件代码
- 完整的示例项目 (FlexButtonExample.swift)
- 详细的 API 文档 (README.md)
- CocoaPods 配置文件 (FlexButton.podspec)
- Git 仓库初始化和首次提交
- 版本标签 v1.0.0

## 🚀 发布到 GitHub

### 1. 在 GitHub 创建仓库
1. 登录 GitHub.com
2. 点击 "New repository"
3. 仓库名称：`FlexButton`
4. 描述：`灵活的iOS按钮组件，支持图文混排、状态管理、动画效果和自适应尺寸`
5. 选择 "Public"
6. 不要初始化 README（我们已经有了）

### 2. 推送到 GitHub
```bash
cd ~/FlexButton
git remote add origin https://github.com/你的用户名/FlexButton.git
git branch -M main
git push -u origin main
git push origin --tags
```

### 3. 创建 Release
1. 在 GitHub 仓库页面点击 "Releases"
2. 点击 "Create a new release"
3. Tag version: `1.0.0`
4. Release title: `FlexButton v1.0.0`
5. 描述：复制 commit message 的内容
6. 点击 "Publish release"

## 📚 发布到 CocoaPods (可选)

### 准备工作
1. 注册 CocoaPods Trunk 账户：
```bash
pod trunk register 你的邮箱 "你的名字" --description="FlexButton"
```

2. 验证 podspec：
```bash
pod lib lint FlexButton.podspec --verbose
```

3. 发布到 CocoaPods：
```bash
pod trunk push FlexButton.podspec --verbose
```

## 🎯 使用方式

### CocoaPods 安装
在 Podfile 中添加：
```ruby
pod 'FlexButton'
```

然后运行：
```bash
pod install
```

### 基础使用
```swift
import FlexButton

let button = FlexButton(
    image: UIImage(systemName: "heart"),
    title: "收藏",
    backgroundColor: .systemBlue,
    titleColor: .white
) { sender in
    print("按钮被点击了")
}

view.addSubview(button)
button.setPosition(x: 20, y: 100)
```

## 📋 项目结构说明

```
FlexButton/
├── FlexButton/
│   └── Classes/
│       ├── FlexButton.swift          # 核心组件代码
│       └── FlexButton_README.md      # API 详细文档
├── Example/
│   └── FlexButton/
│       ├── ViewController.swift      # 示例主控制器
│       └── FlexButtonExample.swift  # 完整示例代码
├── FlexButton.podspec               # CocoaPods 配置
├── README.md                        # 项目说明文档
└── LICENSE                          # MIT 许可证
```

## 🔧 维护说明

### 版本更新流程
1. 修改代码
2. 更新 `FlexButton.podspec` 中的版本号
3. 更新 `README.md` 中的版本信息
4. 提交代码：`git commit -am "版本更新信息"`
5. 创建标签：`git tag 新版本号`
6. 推送：`git push origin main --tags`
7. 如果已发布到 CocoaPods：`pod trunk push FlexButton.podspec`

### 开发测试
运行示例项目：
```bash
cd Example
pod install
open FlexButton.xcworkspace
```

## ✨ 特性亮点

- 🎨 **多样化布局**：支持图片和文字的4种排列方式
- 📐 **智能尺寸**：自适应内容尺寸，支持最小尺寸约束  
- 🎭 **状态管理**：支持3种状态，每种状态独立配置外观
- ✨ **动画效果**：内置6种点击动画类型
- 🎯 **便捷功能**：圆角、边框、阴影、圆形模式一键设置
- ♿️ **无障碍**：完整的 VoiceOver 支持
- 📱 **兼容性**：iOS 15.0+，Swift 5.0+

## 📞 支持

如有问题或建议，请在 GitHub 上创建 Issue。

---

🎉 **祝你发布成功！** 