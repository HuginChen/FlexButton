# FlexButton

[![CI Status](https://img.shields.io/travis/mac/FlexButton.svg?style=flat)](https://travis-ci.org/mac/FlexButton)
[![Version](https://img.shields.io/cocoapods/v/FlexButton.svg?style=flat)](https://cocoapods.org/pods/FlexButton)
[![License](https://img.shields.io/cocoapods/l/FlexButton.svg?style=flat)](https://cocoapods.org/pods/FlexButton)
[![Platform](https://img.shields.io/cocoapods/p/FlexButton.svg?style=flat)](https://cocoapods.org/pods/FlexButton)

## 概述

`FlexButton` 是一个高度灵活的iOS按钮组件，基于UIView构建，提供丰富的布局选项、状态管理、动画效果和智能尺寸控制。

## 核心特性

### 🎨 多样化布局支持
- 支持图片和文字的多种排列方式（左右上下）
- 灵活的内容对齐选项
- 可自定义间距和内边距

### 📐 智能尺寸管理
- 自适应内容尺寸计算
- 支持最小尺寸约束
- 完美兼容AutoLayout和Frame布局

### 🎭 状态管理系统
- 支持normal、selected、disabled等多种状态
- 每种状态可独立配置外观属性
- 平滑的状态切换动画

### ✨ 丰富的动画效果
- 内置多种点击动画（缩放、弹跳、闪烁等）
- 支持自定义动画类型
- 可配置动画开关

### 🎯 实用便捷功能
- 圆角、边框、阴影快速设置
- 自适应圆形按钮模式
- 渐变背景视图支持
- 完整的无障碍支持

## 安装

FlexButton 可通过 [CocoaPods](https://cocoapods.org) 安装。添加以下行到你的 Podfile:

```ruby
pod 'FlexButton'
```

然后运行:

```bash
pod install
```

## 快速开始

### 基础使用

```swift
import FlexButton

// 创建一个基础的图文按钮
let button = FlexButton(
    image: UIImage(systemName: "heart"),
    title: "收藏",
    backgroundColor: .systemBlue,
    titleColor: .white
) { sender in
    print("按钮被点击了")
}

// 添加到视图
view.addSubview(button)
button.setPosition(x: 20, y: 100)
```

### 配置不同状态

```swift
let stateButton = FlexButton(
    image: UIImage(systemName: "heart"),
    title: "收藏"
)

// 设置不同状态的外观
stateButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
stateButton.setTitle("已收藏", for: .selected)
stateButton.setBackgroundColor(.systemRed, for: .selected)

// 切换状态
stateButton.setState(.selected, animated: true)
```

### 使用Auto Layout

```swift
let autoButton = FlexButton(
    image: UIImage(systemName: "star"),
    title: "评分"
)

view.addSubview(autoButton)
autoButton.translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint.activate([
    autoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    autoButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
])
```

### 智能尺寸控制

```swift
// Frame 布局 + 最小尺寸
button.setPosition(x: 20, y: 100, width: 120, height: 40)

// Auto Layout + 最小尺寸（智能扩展，不是强制固定）
button.setFixedSize(width: 120, height: 40)

// 恢复完全自适应
button.resetFixedSize()
```

### 快速样式设置

```swift
button.setCornerRadius(8)
button.setBorder(width: 1, color: .gray)
button.setShadow(opacity: 0.2)

// 自适应圆形模式
button.setCircularMode(true)
```

## 布局选项

```swift
// 图片位置选项
.imageLeft    // 图片在左，文字在右（默认）
.imageRight   // 图片在右，文字在左  
.imageTop     // 图片在上，文字在下
.imageBottom  // 图片在下，文字在上

// 内容对齐选项
.center       // 居中（默认）
.leading      // 左对齐
.trailing     // 右对齐
.top         // 顶部对齐
.bottom      // 底部对齐
```

## 动画类型

```swift
.none         // 无动画
.scale        // 缩放动画（默认）
.bounce       // 弹跳动画
.flash        // 闪烁动画
.shake        // 震动动画
.pulse        // 脉冲动画
.fadeScale    // 淡入淡出缩放
```

## 适用场景

- 导航栏按钮
- 工具栏按钮组
- 表单提交按钮
- 社交分享按钮
- 状态切换按钮
- 自定义样式按钮

## 系统要求

- iOS 15.0+
- Swift 5.0+

## 示例项目

要运行示例项目，克隆本仓库后，在 Example 目录下运行 `pod install`。

## 作者

mac, developer@example.com

## License

FlexButton 在 MIT 许可下提供。详见 LICENSE 文件。
