# FlexButton API 文档

## 概述
`FlexButton` 是一个基于 UIView 实现的灵活按钮组件，支持图文混排、纯图片、纯文字、状态管理、动画效果和自适应尺寸等多种模式。

---

## 枚举定义

### FlexButton.FlexButtonLayout - 内容排列方式
```swift
extension FlexButton {
    enum FlexButtonLayout {
        case imageLeft    // 图片在左，文字在右
        case imageRight   // 图片在右，文字在左
        case imageTop     // 图片在上，文字在下
        case imageBottom  // 图片在下，文字在上
    }
}
```

### FlexButton.ContentAlignment - 内容对齐方式
```swift
extension FlexButton {
    enum ContentAlignment {
        case center         // 居中
        case leading        // 左对齐
        case trailing       // 右对齐
        case top           // 顶部对齐
        case bottom        // 底部对齐
        case leadingTop    // 左对齐+上对齐
        case leadingBottom // 左对齐+下对齐
        case trailingTop   // 右对齐+上对齐
        case trailingBottom // 右对齐+下对齐
    }
}
```

### FlexButton.ButtonState - 按钮状态
```swift
extension FlexButton {
    enum ButtonState {
        case normal     // 正常状态
        case selected   // 选中状态
        case disabled   // 禁用状态
    }
}
```

### FlexButton.AnimationType - 点击动画类型
```swift
extension FlexButton {
    enum AnimationType {
        case none       // 无动画
        case scale      // 缩放动画
        case bounce     // 弹跳动画
        case flash      // 闪烁动画
        case shake      // 震动动画
        case pulse      // 脉冲动画
        case fadeScale  // 淡入淡出缩放
    }
}
```

---

## 初始化方法

### 基本初始化
```swift
// 标准初始化
init(frame: CGRect)
init?(coder: NSCoder)

// 便捷初始化
convenience init(
    image: UIImage? = nil,
    title: String? = nil,
    layout: FlexButton.FlexButtonLayout = .imageLeft,
    backgroundColor: UIColor = .systemBlue,
    backgroundView: UIView? = nil,
    imageTintColor: UIColor? = nil,
    titleColor: UIColor = .white,
    titleFont: UIFont = .systemFont(ofSize: 16),
    contentAlignment: FlexButton.ContentAlignment = .center,
    customImageSize: CGSize? = nil,
    isAnimationEnabled: Bool = true,
    animationType: FlexButton.AnimationType = .scale,
    onTap: ((_ sender: FlexButton) -> Void)? = nil
)
```

---

## 基础属性

### 布局相关
```swift
var layout: FlexButton.FlexButtonLayout       // 内容排列方式
var spacing: CGFloat                          // 图片和文字之间的间距 (默认: 8)
var contentInsets: UIEdgeInsets               // 按钮内边距 (默认: top:12, left:16, bottom:12, right:16)
var imageSize: CGSize                         // 图片大小 (默认: 20x20)
var contentAlignment: FlexButton.ContentAlignment  // 内容对齐方式
```

### 动画相关
```swift
var isAnimationEnabled: Bool                  // 是否启用点击动画效果
var animationType: FlexButton.AnimationType   // 点击动画类型
```

### 视图组件
```swift
let imageView: UIImageView                    // 图片视图 (只读)
let titleLabel: UILabel                       // 文字标签 (只读)
```

### 内容访问
```swift
var currentImage: UIImage?                    // 当前图片 (只读)
var currentTitle: String?                     // 当前文字 (只读)
var currentState: FlexButton.ButtonState      // 当前状态 (只读)
```

### 事件回调
```swift
var onTap: ((_ sender: FlexButton) -> Void)?  // 点击回调
```

---

## 配置方法

### 基础配置
```swift
func configure(
    image: UIImage? = nil,
    title: String? = nil,
    layout: FlexButton.FlexButtonLayout = .imageLeft,
    backgroundColor: UIColor? = nil,
    backgroundView: UIView? = nil,
    imageTintColor: UIColor? = nil,
    titleColor: UIColor? = nil,
    titleFont: UIFont? = nil,
    contentAlignment: FlexButton.ContentAlignment = .center,
    customImageSize: CGSize? = nil,
    isAnimationEnabled: Bool? = nil,
    animationType: FlexButton.AnimationType? = nil,
    onTap: ((_ sender: FlexButton) -> Void)? = nil
)
```

### 快速设置
```swift
func setContentAlignment(_ alignment: FlexButton.ContentAlignment)
func setAnimationEnabled(_ enabled: Bool)
func setAnimationType(_ type: FlexButton.AnimationType)
```

### 便捷样式方法
```swift
// 圆角设置
func setCornerRadius(_ radius: CGFloat)

// 边框设置  
func setBorder(width: CGFloat, color: UIColor)

// 阴影设置
func setShadow(color: UIColor = .black, opacity: Float = 0.3, offset: CGSize = CGSize(width: 0, height: 2), radius: CGFloat = 4)

// 自适应圆形模式（尺寸变化时自动调整）
func setCircularMode(_ enabled: Bool)
var isCircularMode: Bool  // 只读属性，检查当前是否处于圆形模式
```

---

## 状态管理

### 状态控制
```swift
func setState(_ state: FlexButton.ButtonState, animated: Bool = true)
```

### 分状态属性设置
```swift
func setBackgroundColor(_ color: UIColor?, for state: FlexButton.ButtonState)
func setImageTintColor(_ color: UIColor?, for state: FlexButton.ButtonState)
func setTitleColor(_ color: UIColor?, for state: FlexButton.ButtonState)
func setTitleFont(_ font: UIFont?, for state: FlexButton.ButtonState)
func setBackgroundView(_ view: UIView?, for state: FlexButton.ButtonState)
func setImage(_ image: UIImage?, for state: FlexButton.ButtonState)
func setTitle(_ title: String?, for state: FlexButton.ButtonState)
func setImageSize(_ size: CGSize?, for state: FlexButton.ButtonState)
func setAlpha(_ alpha: CGFloat, for state: FlexButton.ButtonState)
```

---

## 布局方法

### Frame 布局
```swift
// 设置位置和尺寸 (强制使用 frame 布局)
func setPosition(x: CGFloat, y: CGFloat, width: CGFloat? = nil, height: CGFloat? = nil)
```

### 智能尺寸控制
```swift
// 设置最小尺寸基准：确保按钮不小于指定尺寸，内容超出时自动扩展
// 支持Frame和Auto Layout两种布局模式  
func setFixedSize(width: CGFloat, height: CGFloat)

// 重置最小尺寸，恢复完全自适应
func resetFixedSize()
```

---

## 使用示例

### 1. 基础使用
```swift
let button = FlexButton(
    image: UIImage(systemName: "heart"),
    title: "收藏",
    backgroundColor: .systemBlue,
    titleColor: .white
) { sender in
    print("按钮被点击")
}

// Frame 布局
button.setPosition(x: 20, y: 100)
view.addSubview(button)
```

### 2. Auto Layout
```swift
let button = FlexButton(
    image: UIImage(systemName: "star"),
    title: "评分"
)

view.addSubview(button)
button.translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint.activate([
    button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
])
```

### 3. 状态管理
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

### 4. 智能尺寸控制
```swift
// Frame 布局 + 最小尺寸（宽高至少120×40，内容大时自动扩展）
button.setPosition(x: 20, y: 100, width: 120, height: 40)

// Auto Layout + 最小尺寸（智能扩展，不是强制固定）
button.setFixedSize(width: 120, height: 40)

// 恢复完全自适应
button.resetFixedSize()
```

### 5. 自定义动画和布局
```swift
let customButton = FlexButton(
    image: UIImage(systemName: "gear"),
    title: "设置",
    layout: .imageTop,
    contentAlignment: .center,
    animationType: .bounce
)

customButton.spacing = 12
customButton.contentInsets = UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20)
```

### 6. 便捷样式设置
```swift
let styledButton = FlexButton(
    image: UIImage(systemName: "star"),
    title: "评分"
)

// 快速样式设置
styledButton.setCornerRadius(8)
styledButton.setBorder(width: 1, color: .gray)
styledButton.setShadow(opacity: 0.2)
styledButton.setCircularMode(true)  // 自适应圆形，尺寸变化时自动调整

// 检查当前模式
if styledButton.isCircularMode {
    print("当前是圆形模式")
}

// 圆形模式下，任何frame变化都会自动重新计算圆角
styledButton.frame = CGRect(x: 0, y: 0, width: 80, height: 80)  // 自动变为40pt圆角
styledButton.setPosition(x: 0, y: 0, width: 100, height: 100)   // 自动变为50pt圆角

// 动态改变大小的圆形按钮（完全自动化）
let dynamicButton = FlexButton(image: UIImage(systemName: "heart.fill"))
dynamicButton.setCircularMode(true)
dynamicButton.setPosition(x: 50, y: 100, width: 60, height: 60)  // 初始尺寸

// 用户点击时动态调整大小，无需处理任何transform细节
dynamicButton.onTap = { sender in
    let currentSize = sender.frame.width
    let newSize: CGFloat = currentSize > 70 ? 60 : 90
    // ✅ 自动处理：transform重置、圆角更新
    sender.setPosition(x: 50, y: 100, width: newSize, height: newSize)
}
```

---

## 特性说明

### 智能自适应尺寸
- 按钮会根据内容自动计算最小尺寸  
- 支持最小尺寸基准与内容尺寸的智能组合
- 内容超出时自动扩展，内容减少时保持最小尺寸
- 与Auto Layout约束的区别：约束是强制固定，setFixedSize是智能最小尺寸

### 性能优化
- 内置尺寸计算缓存机制
- 只在必要时重新计算布局
- 支持 intrinsicContentSize 优化

### 灵活布局
- 支持 Frame 和 Auto Layout 两种布局模式
- 9种内容对齐方式
- 4种图文排列方式

### 智能圆形模式
- **自动触发机制**: 布局完成时自动重新计算圆角，无需手动调用
- **零维护成本**: 一次设置，永久生效  
- **完美适配**: 支持Frame和Auto Layout两种模式，始终保持完美圆形

### 动画状态管理
- **自动重置**: `setPosition`等布局方法会自动重置卡住的动画transform
- **无需手动**: 用户无需处理`transform = .identity`等技术细节
- **状态清洁**: 确保每次布局更新都是干净的初始状态

### 丰富状态
- 支持多状态外观配置
- 平滑状态切换动画
- 6种内置点击动画效果
