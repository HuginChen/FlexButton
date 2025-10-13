# FlexButton 最小触摸目标尺寸控制功能

## 功能概述

FlexButton 新增了 `isMinimumTouchTargetDisabled` 属性，允许开发者禁用苹果推荐的 44pt 最小触摸目标尺寸限制。当启用此功能时，按钮的尺寸将完全基于内容计算，不受最小尺寸约束。

## 使用方法

### 1. 属性设置

```swift
// 创建按钮时设置
let button = FlexButton()
button.isMinimumTouchTargetDisabled = true

// 或使用便捷方法
button.setMinimumTouchTargetDisabled(true)
```

### 2. 初始化时设置

```swift
let button = FlexButton(
    title: "小按钮",
    backgroundColor: .systemRed,
    titleColor: .white,
    isMinimumTouchTargetDisabled: true  // 禁用最小触摸目标限制
)
```

### 3. 配置时设置

```swift
button.configure(
    title: "小按钮",
    backgroundColor: .systemRed,
    titleColor: .white,
    isMinimumTouchTargetDisabled: true  // 禁用最小触摸目标限制
)
```

## 功能对比

| 设置 | 行为 | 适用场景 |
|------|------|----------|
| `isMinimumTouchTargetDisabled = false` (默认) | 按钮尺寸至少为 44x44pt，符合苹果人机界面指南 | 标准按钮、主要操作按钮 |
| `isMinimumTouchTargetDisabled = true` | 按钮尺寸完全基于内容计算，可能小于 44x44pt | 紧凑布局、图标按钮、次要操作按钮 |

## 注意事项

1. **可访问性考虑**：禁用最小触摸目标限制可能会影响用户体验，特别是对于手指较大的用户
2. **苹果建议**：苹果官方建议触摸目标至少为 44x44pt，除非有特殊设计需求
3. **动态调整**：属性变更会自动触发尺寸重新计算和布局更新

## 示例代码

```swift
// 创建一个小尺寸按钮（不受44pt限制）
let smallButton = FlexButton()
smallButton.configure(
    title: "小",
    backgroundColor: .systemBlue,
    titleColor: .white,
    isMinimumTouchTargetDisabled: true
)
smallButton.setPosition(x: 20, y: 100, width: 30, height: 20)

// 创建标准按钮（受44pt限制）
let normalButton = FlexButton()
normalButton.configure(
    title: "标准",
    backgroundColor: .systemGreen,
    titleColor: .white,
    isMinimumTouchTargetDisabled: false  // 默认值
)
normalButton.setPosition(x: 70, y: 100, width: 30, height: 20)
// 实际尺寸会被调整为 44x44pt
```

## 技术实现

- 属性变更会触发 `invalidateSizeCache()` 和 `updateSizeIfNeeded()`
- 在 `calculateMinimumSize()` 方法中根据此属性决定是否应用最小尺寸限制
- 支持 Frame 和 Auto Layout 两种布局模式
