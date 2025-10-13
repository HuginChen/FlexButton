//
//  FlexButton.swift
//  app
//
//  Created by mac on 2025/07/08.
//
//  灵活按钮组件：支持图文混排、纯图片、纯文字、状态管理、动画效果等多种布局模式
//

import UIKit 

public extension FlexButton {
    /// 内容排列方式
    enum FlexButtonLayout {
        case imageLeft    // 图片在左，文字在右
        case imageRight   // 图片在右，文字在左
        case imageTop     // 图片在上，文字在下
        case imageBottom  // 图片在下，文字在上
    }

    /// 内容对齐方式
    enum ContentAlignment {
        case center       // 居中
        case leading      // 左对齐
        case trailing     // 右对齐
        case top          // 顶部对齐
        case bottom       // 底部对齐
        case leadingTop   // 左对齐+上对齐
        case leadingBottom // 左对齐+下对齐
        case trailingTop  // 右对齐+上对齐
        case trailingBottom // 右对齐+下对齐
    }

    /// 按钮状态
    enum ButtonState {
        case normal
        case selected
        case disabled
    }

    /// 点击动画类型
    enum AnimationType {
        case none           // 无动画
        case scale          // 缩放动画
        case bounce         // 弹跳动画
        case flash          // 闪烁动画
        case shake          // 震动动画
        case pulse          // 脉冲动画
        case fadeScale      // 淡入淡出缩放
    }
} 

public final class FlexButton: UIView {
    
    // MARK: - Public Properties
    
    /// 内容排列方式
    public var layout: FlexButtonLayout = .imageLeft {
        didSet {
            invalidateSizeCache()
            updateLayout()
            updateSizeIfNeeded()
        }
    }
    
    /// 图片和文字之间的间距
    public var spacing: CGFloat = 8 {
        didSet {
            invalidateSizeCache()
            stackView.spacing = spacing
            updateLayout()
            updateSizeIfNeeded()
        }
    }
    
    /// 按钮内边距
    public var contentInsets: UIEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16) {
        didSet {
            invalidateSizeCache()
            updateLayout()
            updateSizeIfNeeded()
        }
    }
    
    /// 图片大小
    public var imageSize: CGSize = CGSize(width: 20, height: 20) {
        didSet {
            invalidateSizeCache()
            updateImageSizeConstraints()
        }
    }
    
    /// 内容对齐方式
    public var contentAlignment: ContentAlignment = .center {
        didSet {
            updateLayout()
        }
    }
    
    /// 自定义图片大小（如果设置，将覆盖图片原始大小）
    /// 注意：此属性由状态管理，请使用 setImageSize(_:for:) 方法设置
    private(set) var customImageSize: CGSize? = nil
    
    /// 文字字体
    /// 注意：此属性由状态管理，请使用 setTitleFont(_:for:) 方法设置
    private(set) var titleFont: UIFont = .systemFont(ofSize: 16)
    
    /// 背景视图（可以是图片、渐变、自定义控件等）
    /// 注意：此属性由状态管理，请使用 setBackgroundView(_:for:) 方法设置
    private(set) var backgroundView: UIView?
    
    /// 是否启用点击动画效果
    public var isAnimationEnabled: Bool = true
    
    /// 点击动画类型
    public var animationType: AnimationType = .scale
    
    /// 是否禁用最小触摸目标尺寸限制
    /// 当设置为true时，按钮尺寸将完全基于内容计算，不受44pt最小尺寸限制
    public var isMinimumTouchTargetDisabled: Bool = false {
        didSet {
            invalidateSizeCache()
            updateSizeIfNeeded()
        }
    }
    
    /// 图片视图
    public let imageView = UIImageView()
    
    /// 文字标签
    public let titleLabel = UILabel()
    
    /// 当前图片（只读，通过状态管理设置）
    public var currentImage: UIImage? {
        return imageView.image
    }
    
    /// 当前文字（只读，通过状态管理设置）
    public var currentTitle: String? {
        return titleLabel.text
    }
    
    /// 点击回调
    public var onTap: ((_ sender: FlexButton) -> Void)?
    
    /// 当前状态
    public private(set) var currentState: ButtonState = .normal
    
    /// 状态配置
    private var stateConfigs: [ButtonState: StateConfig] = [:]
    
    /// 状态配置结构
    public struct StateConfig {
        public var backgroundColor: UIColor?
        public var imageTintColor: UIColor?
        public var titleColor: UIColor?
        public var titleFont: UIFont?
        public var backgroundView: UIView?
        public var image: UIImage?
        public var title: String?
        public var customImageSize: CGSize?
        public var alpha: CGFloat = 1.0
        
        public init() {}
    }
    
    // MARK: - Private Properties
    private let stackView = UIStackView()
    private var currentConstraints: [NSLayoutConstraint] = []
    private var backgroundViewConstraints: [NSLayoutConstraint] = []
    private var cachedMinimumSize: CGSize?
    private var fixedSize: CGSize?
    private var isCircular: Bool = false
    
    // MARK: - Layout Override for Auto Updates
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        // 在布局完成后更新圆形圆角（如果启用）
        if isCircular {
            updateCircularCornerIfNeeded()
        }
    }
    
    // MARK: - Constants
    private static let backgroundViewTag = 999
    private static let defaultAnimationDuration: TimeInterval = 0.2
    private static let minimumTouchTarget: CGFloat = 44
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    /// 便捷初始化方法
    public convenience init(
        image: UIImage? = nil,
        title: String? = nil,
        layout: FlexButtonLayout = .imageLeft,
        backgroundColor: UIColor = .blue,
        backgroundView: UIView? = nil,
        imageTintColor: UIColor? = nil,
        titleColor: UIColor = .white,
        titleFont: UIFont = .systemFont(ofSize: 16),
        contentAlignment: ContentAlignment = .center,
        customImageSize: CGSize? = nil,
        isAnimationEnabled: Bool = true,
        animationType: AnimationType = .scale,
        isMinimumTouchTargetDisabled: Bool = false,
        onTap: ((_ sender: FlexButton) -> Void)? = nil
    ) {
        self.init(frame: .zero)
        configure(
            image: image,
            title: title,
            layout: layout,
            backgroundColor: backgroundColor,
            backgroundView: backgroundView,
            imageTintColor: imageTintColor,
            titleColor: titleColor,
            titleFont: titleFont,
            contentAlignment: contentAlignment,
            customImageSize: customImageSize,
            isAnimationEnabled: isAnimationEnabled,
            animationType: animationType,
            isMinimumTouchTargetDisabled: isMinimumTouchTargetDisabled,
            onTap: onTap
        )
    }
    
    // MARK: - Public Methods
    
    /// 配置按钮内容
    public func configure(
        image: UIImage? = nil,
        title: String? = nil,
        layout: FlexButtonLayout = .imageLeft,
        backgroundColor: UIColor? = nil,
        backgroundView: UIView? = nil,
        imageTintColor: UIColor? = nil,
        titleColor: UIColor? = nil,
        titleFont: UIFont? = nil,
        contentAlignment: ContentAlignment = .center,
        customImageSize: CGSize? = nil,
        isAnimationEnabled: Bool? = nil,
        animationType: AnimationType? = nil,
        isMinimumTouchTargetDisabled: Bool? = nil,
        onTap: ((_ sender: FlexButton) -> Void)? = nil
    ) {
        // 设置全局属性（不参与状态管理）
        self.layout = layout
        self.contentAlignment = contentAlignment
        self.onTap = onTap
        
        // 状态管理的属性通过 setupInitialState 设置，不在这里直接设置
        if let isAnimationEnabled = isAnimationEnabled {
            self.isAnimationEnabled = isAnimationEnabled
        }
        if let animationType = animationType {
            self.animationType = animationType
        }
        if let isMinimumTouchTargetDisabled = isMinimumTouchTargetDisabled {
            self.isMinimumTouchTargetDisabled = isMinimumTouchTargetDisabled
        }
        
        updateLayout()
        
        // 设置初始状态配置
        setupInitialState(
            image: image,
            title: title,
            backgroundColor: backgroundColor,
            backgroundView: backgroundView,
            imageTintColor: imageTintColor,
            titleColor: titleColor,
            titleFont: titleFont,
            customImageSize: customImageSize
        )
    }
    
    /// 设置初始状态配置
    private func setupInitialState(
        image: UIImage?,
        title: String?,
        backgroundColor: UIColor?,
        backgroundView: UIView?,
        imageTintColor: UIColor?,
        titleColor: UIColor?,
        titleFont: UIFont?,
        customImageSize: CGSize?
    ) {
        // 设置正常状态的配置
        var normalConfig = StateConfig()
        normalConfig.image = image
        normalConfig.title = title
        normalConfig.backgroundColor = backgroundColor
        normalConfig.backgroundView = backgroundView
        normalConfig.imageTintColor = imageTintColor
        normalConfig.titleColor = titleColor
        normalConfig.titleFont = titleFont
        normalConfig.customImageSize = customImageSize
        normalConfig.alpha = 1.0
        stateConfigs[.normal] = normalConfig
        
        // 设置选中状态的配置（稍微暗一点）
        var selectedConfig = StateConfig()
        selectedConfig.backgroundColor = backgroundColor?.withAlphaComponent(0.9)
        selectedConfig.imageTintColor = imageTintColor?.withAlphaComponent(0.9)
        selectedConfig.titleColor = titleColor?.withAlphaComponent(0.9)
        selectedConfig.titleFont = titleFont
        selectedConfig.alpha = 0.9
        stateConfigs[.selected] = selectedConfig
        
        // 设置禁用状态的配置（半透明）
        var disabledConfig = StateConfig()
        disabledConfig.backgroundColor = backgroundColor?.withAlphaComponent(0.5)
        disabledConfig.imageTintColor = imageTintColor?.withAlphaComponent(0.5)
        disabledConfig.titleColor = titleColor?.withAlphaComponent(0.5)
        disabledConfig.titleFont = titleFont
        disabledConfig.alpha = 0.5
        stateConfigs[.disabled] = disabledConfig
        
        // 更新当前外观
        updateAppearance(animated: false)
    }
    
    /// 设置内容对齐方式
    public func setContentAlignment(_ alignment: ContentAlignment) {
        contentAlignment = alignment
    }
    
    /// 设置动画开关
    public func setAnimationEnabled(_ enabled: Bool) {
        isAnimationEnabled = enabled
    }
    
    /// 设置动画类型
    public func setAnimationType(_ type: AnimationType) {
        animationType = type
    }
    
    /// 设置是否禁用最小触摸目标尺寸限制
    public func setMinimumTouchTargetDisabled(_ disabled: Bool) {
        isMinimumTouchTargetDisabled = disabled
    }
    
    /// 重置固定尺寸标记，恢复完全自适应行为
    public func resetFixedSize() {
        fixedSize = nil
        updateSizeIfNeeded()
    }
    
    // MARK: - Convenience Methods
    
    /// 设置圆角
    public func setCornerRadius(_ radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = radius > 0
    }
    
    /// 设置边框
    public func setBorder(width: CGFloat, color: UIColor) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
    
    /// 设置阴影
    public func setShadow(color: UIColor = .black, opacity: Float = 0.3, offset: CGSize = CGSize(width: 0, height: 2), radius: CGFloat = 4) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.masksToBounds = false
    }
    
    /// 设置为自适应圆形按钮（会根据尺寸变化自动调整）
    public func setCircularMode(_ enabled: Bool) {
        isCircular = enabled
        if enabled {
            updateCircularCornerIfNeeded()
        } else {
            // 禁用圆形模式时，恢复原始圆角
            layer.cornerRadius = 0
            layer.masksToBounds = false
        }
    }
    
    /// 当前是否处于圆形模式
    public var isCircularMode: Bool {
        return isCircular
    }
      
    /// 更新圆形圆角（如果启用）
    private func updateCircularCornerIfNeeded() {
        guard isCircular else { return }
        let size = min(frame.width, frame.height)
        layer.cornerRadius = size / 2.0
        layer.masksToBounds = true
    }
    
    /// 重置动画状态，修复可能卡住的transform
    /// 
    /// 在某些情况下，点击动画（特别是scale类型）的transform可能不会完全重置，
    /// 导致视图显示尺寸与实际frame不符。此方法确保在布局更新前清理动画状态。
    private func resetAnimationState() {
        transform = .identity
        layer.removeAllAnimations()
    }
    
    /// 设置最小尺寸基准：确保按钮不小于指定尺寸，内容超出时自动扩展
    /// - 与Auto Layout约束不同：约束是强制固定，此方法是智能最小尺寸
    /// - 支持Frame和Auto Layout两种布局模式
    /// - 计算规则：实际尺寸 = max(最小尺寸, 内容实际尺寸)
    public func setFixedSize(width: CGFloat, height: CGFloat) {
        // 🔧 自动修复：重置可能卡住的动画transform
        resetAnimationState()
        
        fixedSize = CGSize(width: width, height: height)
        
        if !translatesAutoresizingMaskIntoConstraints {
            // Auto Layout 模式下，需要通知系统重新计算intrinsicContentSize
            invalidateIntrinsicContentSize()
        } else {
            // Frame 模式下，直接更新尺寸
            updateSizeIfNeeded()
        }
    }
    
    /// 便捷方法：设置位置和尺寸
    public func setPosition(x: CGFloat, y: CGFloat, width: CGFloat? = nil, height: CGFloat? = nil) {
        // 确保使用 frame 布局
        translatesAutoresizingMaskIntoConstraints = true
        
        // 🔧 自动修复：重置可能卡住的动画transform
        resetAnimationState()
        
        var newFrame = frame
        newFrame.origin.x = x
        newFrame.origin.y = y
        
        // 计算最小尺寸
        let minimumSize = calculateMinimumSize()
        
        if let width = width, let height = height {
            // 使用指定的尺寸，但不小于最小尺寸
            newFrame.size.width = max(width, minimumSize.width)
            newFrame.size.height = max(height, minimumSize.height)
            // 记录固定尺寸，作为最小尺寸基准
            fixedSize = CGSize(width: width, height: height)
        } else {
            // 使用最小尺寸
            newFrame.size.width = width ?? minimumSize.width
            newFrame.size.height = height ?? minimumSize.height
            // 清除固定尺寸，恢复完全自适应
            fixedSize = nil
        }
        
        frame = newFrame
    }
    
    /// Auto Layout 约束设置方法
    public func setupConstraints(
        to view: UIView,
        top: NSLayoutYAxisAnchor? = nil,
        leading: NSLayoutXAxisAnchor? = nil,
        bottom: NSLayoutYAxisAnchor? = nil,
        trailing: NSLayoutXAxisAnchor? = nil,
        centerX: NSLayoutXAxisAnchor? = nil,
        centerY: NSLayoutYAxisAnchor? = nil,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        topConstant: CGFloat = 0,
        leadingConstant: CGFloat = 0,
        bottomConstant: CGFloat = 0,
        trailingConstant: CGFloat = 0
    ) {
        translatesAutoresizingMaskIntoConstraints = false
        
        var constraints: [NSLayoutConstraint] = []
        
        if let top = top {
            constraints.append(topAnchor.constraint(equalTo: top, constant: topConstant))
        }
        if let leading = leading {
            constraints.append(leadingAnchor.constraint(equalTo: leading, constant: leadingConstant))
        }
        if let bottom = bottom {
            constraints.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
        }
        if let trailing = trailing {
            constraints.append(trailingAnchor.constraint(equalTo: trailing, constant: -trailingConstant))
        }
        if let centerX = centerX {
            constraints.append(centerXAnchor.constraint(equalTo: centerX))
        }
        if let centerY = centerY {
            constraints.append(centerYAnchor.constraint(equalTo: centerY))
        }
        if let width = width {
            constraints.append(widthAnchor.constraint(equalToConstant: width))
        }
        if let height = height {
            constraints.append(heightAnchor.constraint(equalToConstant: height))
        }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: - Accessibility
    
    /// 设置无障碍性
    private func setupAccessibility() {
        isAccessibilityElement = true
        accessibilityTraits = .button
        updateAccessibilityLabel()
    }
    
    /// 更新无障碍标签
    private func updateAccessibilityLabel() {
        let title = currentTitle ?? ""
        let hasImage = currentImage != nil
        
        if !title.isEmpty && hasImage {
            accessibilityLabel = title
            accessibilityHint = "图片按钮"
        } else if !title.isEmpty {
            accessibilityLabel = title
            accessibilityHint = nil
        } else if hasImage {
            accessibilityLabel = "图片按钮"
            accessibilityHint = nil
        } else {
            accessibilityLabel = "按钮"
            accessibilityHint = nil
        }
        
        // 根据当前状态设置无障碍状态
        switch currentState {
        case .normal:
            accessibilityValue = nil
        case .selected:
            accessibilityValue = "已选中"
        case .disabled:
            accessibilityTraits = [.button, .notEnabled]
        }
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        // 设置基本属性
        isUserInteractionEnabled = true
        
        // 默认使用 frame 布局
        translatesAutoresizingMaskIntoConstraints = true
        
        // 无障碍性设置
        setupAccessibility()
        
        // 设置 StackView
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = spacing
        stackView.alignment = .center
        stackView.distribution = .fill
        
        // 设置图片视图
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemBlue
        
        // 设置文字标签
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = titleFont
        titleLabel.textColor = .systemBlue
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 1
        titleLabel.adjustsFontForContentSizeCategory = false
        
        // 添加到 StackView
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        
        // 添加 StackView 到主视图
        addSubview(stackView)
        
        // 基本约束现在在布局方法中设置
        
        // 设置图片大小约束
        updateImageSizeConstraints()
        
        updateLayout()
        
        // 设置初始尺寸
        let minimumSize = calculateMinimumSize()
        frame.size = minimumSize
    }
    
    // MARK: - Touch Handling
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        // 检查是否在按钮范围内
        if let touch = touches.first {
            let location = touch.location(in: self)
            if bounds.contains(location) {
                // 执行点击动画
                if isAnimationEnabled {
                    performTapAnimation()
                } 
                
                onTap?(self)
            }
        }
    }
    
    /// 执行点击动画
    private func performTapAnimation() {
        switch animationType {
        case .none:
            break
            
        case .scale:
            UIView.animate(withDuration: 0.1, animations: {
                self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }) { _ in
                UIView.animate(withDuration: 0.1) {
                    self.transform = .identity
                }
            }
            
        case .bounce:
            UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: [], animations: {
                self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }) { _ in
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.8, options: [], animations: {
                    self.transform = .identity
                })
            }
            
        case .flash:
            UIView.animate(withDuration: 0.1, animations: {
                self.alpha = 0.5
            }) { _ in
                UIView.animate(withDuration: 0.1) {
                    self.alpha = 1.0
                }
            }
            
        case .shake:
            let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
            animation.timingFunction = CAMediaTimingFunction(name: .linear)
            animation.duration = 0.6
            animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0]
            layer.add(animation, forKey: "shake")
            
        case .pulse:
            UIView.animate(withDuration: 0.2, animations: {
                self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                self.alpha = 0.8
            }) { _ in
                UIView.animate(withDuration: 0.2) {
                    self.transform = .identity
                    self.alpha = 1.0
                }
            }
            
        case .fadeScale:
            UIView.animate(withDuration: 0.15, animations: {
                self.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
                self.alpha = 0.6
            }) { _ in
                UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [], animations: {
                    self.transform = .identity
                    self.alpha = 1.0
                })
            }
        }
    }
    
    // MARK: - Intrinsic Content Size
    public override var intrinsicContentSize: CGSize {
        // 如果使用 frame 布局，不提供 intrinsic size
        if translatesAutoresizingMaskIntoConstraints {
            return CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
        }
        
        // Auto Layout 模式下，考虑固定尺寸
        let minimumSize = calculateMinimumSize()
        
        if let fixed = fixedSize {
            // 有固定尺寸：使用固定尺寸和最小尺寸的最大值
            return CGSize(
                width: max(fixed.width, minimumSize.width),
                height: max(fixed.height, minimumSize.height)
            )
        } else {
            // 完全自适应：直接返回计算出的最小尺寸
            return minimumSize
        }
    }
    
    /// 清除尺寸缓存
    private func invalidateSizeCache() {
        cachedMinimumSize = nil
    }
    
    /// 计算最小尺寸
    private func calculateMinimumSize() -> CGSize {
        // 使用缓存避免重复计算
        if let cached = cachedMinimumSize {
            return cached
        }
        let hasImage = imageView.image != nil
        let hasTitle = !(titleLabel.text?.isEmpty ?? true)
        
        let currentImageSize: CGSize
        if let customSize = customImageSize {
            currentImageSize = customSize
        } else if let image = imageView.image {
            currentImageSize = image.size
        } else {
            currentImageSize = imageSize
        }
        
        // 确保图片尺寸不为 0（如果有图片），向上取整增给文字尺寸增加缓冲空间，避免被省略
        let safeImageSize = hasImage ? CGSize(
            width: max(ceil(currentImageSize.width), 1),
            height: max(ceil(currentImageSize.height), 1)
        ) : .zero
        
        // 获取当前应该使用的字体（状态管理字体 -> 默认字体）
        let currentConfig = stateConfigs[currentState]
        let normalConfig = stateConfigs[.normal]
        let currentFont = currentConfig?.titleFont ?? normalConfig?.titleFont ?? titleFont
        
        // 使用正确的字体计算文字大小，增加缓冲空间
        let titleSize: CGSize
        if hasTitle {
            let text = titleLabel.text ?? ""
            let attributes = [NSAttributedString.Key.font: currentFont]
            let boundingRect = text.boundingRect(
                with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude),
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                attributes: attributes,
                context: nil
            )
            // 向上取整并增加缓冲空间，避免被省略
            titleSize = CGSize(
                width: ceil(boundingRect.width),
                height: ceil(boundingRect.height)
            )
        } else {
            titleSize = .zero
        }
        
        let totalWidth: CGFloat
        let totalHeight: CGFloat
        
        // 根据是否有图片和文字计算尺寸
        if hasImage && hasTitle {
            // 有图片和文字，需要考虑间距
            switch layout {
            case .imageLeft, .imageRight:
                totalWidth = safeImageSize.width + spacing + titleSize.width + contentInsets.left + contentInsets.right
                totalHeight = max(safeImageSize.height, titleSize.height) + contentInsets.top + contentInsets.bottom
            case .imageTop, .imageBottom:
                totalWidth = max(safeImageSize.width, titleSize.width) + contentInsets.left + contentInsets.right
                totalHeight = safeImageSize.height + spacing + titleSize.height + contentInsets.top + contentInsets.bottom
            }
        } else if hasImage {
            // 只有图片
            totalWidth = safeImageSize.width + contentInsets.left + contentInsets.right
            totalHeight = safeImageSize.height + contentInsets.top + contentInsets.bottom
        } else if hasTitle {
            // 只有文字
            totalWidth = titleSize.width + contentInsets.left + contentInsets.right
            totalHeight = titleSize.height + contentInsets.top + contentInsets.bottom
        } else {
            // 没有内容，返回最小尺寸
            totalWidth = contentInsets.left + contentInsets.right
            totalHeight = contentInsets.top + contentInsets.bottom
        }
        
        // 确保符合苹果推荐的最小触摸目标尺寸（除非被禁用）
        let finalWidth: CGFloat
        let finalHeight: CGFloat
        
        if isMinimumTouchTargetDisabled {
            // 禁用最小触摸目标限制，完全基于内容计算
            finalWidth = ceil(totalWidth)
            finalHeight = ceil(totalHeight)
        } else {
            // 应用最小触摸目标限制
            finalWidth = max(ceil(totalWidth), Self.minimumTouchTarget)
            finalHeight = max(ceil(totalHeight), Self.minimumTouchTarget)
        }
        
        let result = CGSize(width: finalWidth, height: finalHeight)
        
        // 缓存计算结果
        cachedMinimumSize = result
        return result
    }
    
    // MARK: - State Management
    
    /// 设置状态
    public func setState(_ state: ButtonState, animated: Bool = true) {
        guard state != currentState else { return }
        currentState = state
        updateAppearance(animated: animated)
    }
    
    /// 设置指定状态的背景色
    public func setBackgroundColor(_ color: UIColor?, for state: ButtonState) {
        ensureStateConfig(for: state)
        stateConfigs[state]?.backgroundColor = color
        if currentState == state {
            updateAppearance()
        }
    }
    
    /// 设置指定状态的图片颜色
    public func setImageTintColor(_ color: UIColor?, for state: ButtonState) {
        ensureStateConfig(for: state)
        stateConfigs[state]?.imageTintColor = color
        if currentState == state {
            updateAppearance()
        }
    }
    
    /// 设置指定状态的文字颜色
    public func setTitleColor(_ color: UIColor?, for state: ButtonState) {
        ensureStateConfig(for: state)
        stateConfigs[state]?.titleColor = color
        if currentState == state {
            updateAppearance()
        }
    }
    
    /// 设置指定状态的透明度
    public func setAlpha(_ alpha: CGFloat, for state: ButtonState) {
        ensureStateConfig(for: state)
        stateConfigs[state]?.alpha = alpha
        if currentState == state {
            updateAppearance()
        }
    }
    
    /// 设置指定状态的字体
    public func setTitleFont(_ font: UIFont?, for state: ButtonState) {
        ensureStateConfig(for: state)
        stateConfigs[state]?.titleFont = font
        if currentState == state {
            updateAppearance()
        }
    }
    
    /// 设置指定状态的背景视图
    public func setBackgroundView(_ view: UIView?, for state: ButtonState) {
        ensureStateConfig(for: state)
        stateConfigs[state]?.backgroundView = view
        if currentState == state {
            updateAppearance()
        }
    }
    
    /// 设置指定状态的图片
    public func setImage(_ image: UIImage?, for state: ButtonState) {
        ensureStateConfig(for: state)
        stateConfigs[state]?.image = image
        if currentState == state {
            updateAppearance()
        }
    }
    
    /// 设置指定状态的文字
    public func setTitle(_ title: String?, for state: ButtonState) {
        ensureStateConfig(for: state)
        stateConfigs[state]?.title = title
        if currentState == state {
            updateAppearance()
        }
    }
    
    /// 设置指定状态的图片大小
    public func setImageSize(_ size: CGSize?, for state: ButtonState) {
        ensureStateConfig(for: state)
        stateConfigs[state]?.customImageSize = size
        if currentState == state {
            updateAppearance()
        }
    }
    
    /// 确保状态配置存在
    private func ensureStateConfig(for state: ButtonState) {
        if stateConfigs[state] == nil {
            stateConfigs[state] = StateConfig()
        }
    }
    
    private func updateAppearance(animated: Bool = true) {
        let currentConfig = stateConfigs[currentState]
        let normalConfig = stateConfigs[.normal]
        
        let updateBlock = {
            // 清除尺寸缓存，因为状态变化可能影响内容尺寸
            self.invalidateSizeCache()
            
            // 背景色：当前状态 -> normal状态 -> 保持当前值
            if let backgroundColor = currentConfig?.backgroundColor ?? normalConfig?.backgroundColor {
                self.backgroundColor = backgroundColor
            }
            
            // 图片着色：当前状态 -> normal状态 -> 保持当前值
            if let imageTintColor = currentConfig?.imageTintColor ?? normalConfig?.imageTintColor {
                self.imageView.tintColor = imageTintColor
            }
            
            // 文字颜色：当前状态 -> normal状态 -> 保持当前值
            if let titleColor = currentConfig?.titleColor ?? normalConfig?.titleColor {
                self.titleLabel.textColor = titleColor
            }
            
            // 字体：当前状态 -> normal状态 -> 保持当前值
            if let titleFont = currentConfig?.titleFont ?? normalConfig?.titleFont {
                self.titleLabel.font = titleFont
            }
            
            // 背景视图：当前状态 -> normal状态 -> 保持当前值
            if let backgroundView = currentConfig?.backgroundView ?? normalConfig?.backgroundView {
                self.backgroundView = backgroundView
                self.updateBackgroundView()
            }
            
            // 图片：当前状态 -> normal状态 -> 保持当前值
            if let image = currentConfig?.image ?? normalConfig?.image {
                self.imageView.image = image
                self.updateImageSizeConstraints()
            }
            
            // 文字：当前状态 -> normal状态 -> 保持当前值
            if let title = currentConfig?.title ?? normalConfig?.title {
                self.titleLabel.text = title
            }
            
            // 图片大小：当前状态 -> normal状态 -> 保持当前值
            if let customImageSize = currentConfig?.customImageSize ?? normalConfig?.customImageSize {
                self.updateImageSizeDirectly(customImageSize)
            }
            
            // 透明度：当前状态 -> normal状态 -> 1.0
            let alpha = currentConfig?.alpha ?? normalConfig?.alpha ?? 1.0
            self.alpha = alpha
            
            // 重要：状态改变后需要重新布局和尺寸，因为图片/文字内容可能发生变化
            self.updateLayout()
            self.updateSizeIfNeeded()
            
            // 更新无障碍标签
            self.updateAccessibilityLabel()
        }
        
        if animated {
            UIView.animate(withDuration: Self.defaultAnimationDuration) {
                updateBlock()
            }
        } else {
            updateBlock()
        }
    }
    
    /// 直接更新图片大小，避免循环调用
    private func updateImageSizeDirectly(_ size: CGSize) {
        // 直接设置内部属性，不触发 didSet
        customImageSize = size
        updateImageSizeConstraints()
    }
    
    // 存储图片大小约束的引用
    private var imageWidthConstraint: NSLayoutConstraint?
    private var imageHeightConstraint: NSLayoutConstraint?
    
    private func updateImageSizeConstraints() {
        // 移除现有的大小约束
        imageWidthConstraint?.isActive = false
        imageHeightConstraint?.isActive = false
        
        let currentImageSize: CGSize
        if let customSize = customImageSize {
            currentImageSize = customSize
        } else if let image = imageView.image {
            currentImageSize = image.size
        } else {
            currentImageSize = imageSize
        }
        
        // 设置图片视图的大小约束
        imageWidthConstraint = imageView.widthAnchor.constraint(equalToConstant: currentImageSize.width)
        imageHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: currentImageSize.height)
        
        imageWidthConstraint?.isActive = true
        imageHeightConstraint?.isActive = true
        
        // 如果使用 frame 布局，需要设置 imageView 的 frame
        if translatesAutoresizingMaskIntoConstraints {
            // 在 frame 布局下，直接设置 imageView 的 frame
            imageView.frame.size = currentImageSize
            // 注意：不在这里调用 updateLayout 和 calculateMinimumSize
            // 让调用方统一处理，避免重复计算
        }
    }
    
    /// 根据布局模式更新尺寸
    private func updateSizeIfNeeded() {
        if translatesAutoresizingMaskIntoConstraints {
            // 使用 frame 布局
            let minimumSize = calculateMinimumSize()
            var newFrame = frame
            
            if let fixed = fixedSize {
                // 有固定尺寸：使用固定尺寸和最小尺寸的最大值，确保内容不被截断
                newFrame.size.width = max(fixed.width, minimumSize.width)
                newFrame.size.height = max(fixed.height, minimumSize.height)
            } else {
                // 完全自适应：直接使用计算出的最小尺寸
                newFrame.size = minimumSize
            }
            
            frame = newFrame
        } else {
            // 使用 Auto Layout
            invalidateIntrinsicContentSize()
        }
    }
    
    /// 更新背景视图
    private func updateBackgroundView() {
        // 移除现有的背景视图约束
        NSLayoutConstraint.deactivate(backgroundViewConstraints)
        backgroundViewConstraints.removeAll()
        
        // 移除现有的背景视图
        subviews.filter { $0.tag == Self.backgroundViewTag }.forEach { $0.removeFromSuperview() }
        
        // 添加新的背景视图
        if let bgView = backgroundView {
            bgView.tag = Self.backgroundViewTag // 标记为背景视图
            bgView.translatesAutoresizingMaskIntoConstraints = false
            insertSubview(bgView, at: 0) // 插入到最底层
            
            // 设置约束，让背景视图填满整个按钮
            backgroundViewConstraints = [
                bgView.topAnchor.constraint(equalTo: topAnchor),
                bgView.leadingAnchor.constraint(equalTo: leadingAnchor),
                bgView.trailingAnchor.constraint(equalTo: trailingAnchor),
                bgView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ]
            
            NSLayoutConstraint.activate(backgroundViewConstraints)
            
            // 如果设置了背景视图，将按钮自身的背景色设为透明
            backgroundColor = .clear
        }
    }
    
    private func updateLayout() {
        // 移除现有约束
        NSLayoutConstraint.deactivate(currentConstraints)
        currentConstraints.removeAll()
        
        // 根据布局方式设置约束
        switch layout {
        case .imageLeft:
            currentConstraints = setupImageLeftLayout()
        case .imageRight:
            currentConstraints = setupImageRightLayout()
        case .imageTop:
            currentConstraints = setupImageTopLayout()
        case .imageBottom:
            currentConstraints = setupImageBottomLayout()
        }
        
        // 激活新约束
        NSLayoutConstraint.activate(currentConstraints)
    }
    
    private func setupImageLeftLayout() -> [NSLayoutConstraint] {
        // 配置 StackView
        stackView.axis = .horizontal
        stackView.alignment = .center
        
        // 根据内容设置间距和子视图
        let hasImage = imageView.image != nil
        let hasTitle = !(titleLabel.text?.isEmpty ?? true)
        stackView.spacing = (hasImage && hasTitle) ? spacing : 0
        
        // 确保图片和文字的顺序正确
        stackView.arrangedSubviews.forEach { stackView.removeArrangedSubview($0) }
        if hasImage {
            stackView.addArrangedSubview(imageView)
            imageView.isHidden = false
        } else {
            imageView.isHidden = true
        }
        if hasTitle {
            stackView.addArrangedSubview(titleLabel)
            titleLabel.isHidden = false
        } else {
            titleLabel.isHidden = true
        }
        
        return setupStackViewConstraints()
    }
    
    /// 通用的 StackView 约束设置
    private func setupStackViewConstraints() -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        
        // StackView 在主视图中的位置约束
        switch contentAlignment {
        case .center:
            constraints.append(stackView.centerXAnchor.constraint(equalTo: centerXAnchor))
            constraints.append(stackView.centerYAnchor.constraint(equalTo: centerYAnchor))
        case .leading, .leadingTop:
            constraints.append(stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: contentInsets.left))
            constraints.append(stackView.topAnchor.constraint(equalTo: topAnchor, constant: contentInsets.top))
        case .leadingBottom:
            constraints.append(stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: contentInsets.left))
            constraints.append(stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -contentInsets.bottom))
        case .trailing, .trailingTop:
            constraints.append(stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -contentInsets.right))
            constraints.append(stackView.topAnchor.constraint(equalTo: topAnchor, constant: contentInsets.top))
        case .trailingBottom:
            constraints.append(stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -contentInsets.right))
            constraints.append(stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -contentInsets.bottom))
        case .top:
            constraints.append(stackView.centerXAnchor.constraint(equalTo: centerXAnchor))
            constraints.append(stackView.topAnchor.constraint(equalTo: topAnchor, constant: contentInsets.top))
        case .bottom:
            constraints.append(stackView.centerXAnchor.constraint(equalTo: centerXAnchor))
            constraints.append(stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -contentInsets.bottom))
        }
        
        // 确保 StackView 不超出边界
        constraints.append(stackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: contentInsets.left))
        constraints.append(stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -contentInsets.right))
        constraints.append(stackView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: contentInsets.top))
        constraints.append(stackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -contentInsets.bottom))
        
        return constraints
    }
    
    private func setupImageRightLayout() -> [NSLayoutConstraint] {
        // 配置 StackView
        stackView.axis = .horizontal
        stackView.alignment = .center
        
        // 根据内容设置间距和子视图
        let hasImage = imageView.image != nil
        let hasTitle = !(titleLabel.text?.isEmpty ?? true)
        stackView.spacing = (hasImage && hasTitle) ? spacing : 0
        
        // 确保图片和文字的顺序正确（文字在左，图片在右）
        stackView.arrangedSubviews.forEach { stackView.removeArrangedSubview($0) }
        if hasTitle {
            stackView.addArrangedSubview(titleLabel)
            titleLabel.isHidden = false
        } else {
            titleLabel.isHidden = true
        }
        if hasImage {
            stackView.addArrangedSubview(imageView)
            imageView.isHidden = false
        } else {
            imageView.isHidden = true
        }
        
        return setupStackViewConstraints()
    }
    
    private func setupImageTopLayout() -> [NSLayoutConstraint] {
        // 配置 StackView
        stackView.axis = .vertical
        stackView.alignment = .center
        
        // 根据内容设置间距和子视图
        let hasImage = imageView.image != nil
        let hasTitle = !(titleLabel.text?.isEmpty ?? true)
        stackView.spacing = (hasImage && hasTitle) ? spacing : 0
        
        // 确保图片和文字的顺序正确（图片在上，文字在下）
        stackView.arrangedSubviews.forEach { stackView.removeArrangedSubview($0) }
        if hasImage {
            stackView.addArrangedSubview(imageView)
            imageView.isHidden = false
        } else {
            imageView.isHidden = true
        }
        if hasTitle {
            stackView.addArrangedSubview(titleLabel)
            titleLabel.isHidden = false
        } else {
            titleLabel.isHidden = true
        }
        
        return setupStackViewConstraints()
    }
    
    private func setupImageBottomLayout() -> [NSLayoutConstraint] {
        // 配置 StackView
        stackView.axis = .vertical
        stackView.alignment = .center
        
        // 根据内容设置间距和子视图
        let hasImage = imageView.image != nil
        let hasTitle = !(titleLabel.text?.isEmpty ?? true)
        stackView.spacing = (hasImage && hasTitle) ? spacing : 0
        
        // 确保图片和文字的顺序正确（文字在上，图片在下）
        stackView.arrangedSubviews.forEach { stackView.removeArrangedSubview($0) }
        if hasTitle {
            stackView.addArrangedSubview(titleLabel)
            titleLabel.isHidden = false
        } else {
            titleLabel.isHidden = true
        }
        if hasImage {
            stackView.addArrangedSubview(imageView)
            imageView.isHidden = false
        } else {
            imageView.isHidden = true
        }
        
        return setupStackViewConstraints()
    }
} 
