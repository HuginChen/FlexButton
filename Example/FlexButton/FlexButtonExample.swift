//
//  FlexButtonExample.swift
//  app
//
//  Created by mac on 2025/07/08.
//
//  FlexButton组件示例大全：展示所有功能特性和使用场景
//

import UIKit
import FlexButton

final class FlexButtonExample: UIViewController {
    
    // MARK: - UI Components
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsVerticalScrollIndicator = true
        scroll.showsHorizontalScrollIndicator = false
        return scroll
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Constants
    private let margin: CGFloat = 16
    private let spacing: CGFloat = 20
    private let sectionSpacing: CGFloat = 40
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupExamples()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        title = "FlexButton 示例大全"
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    // MARK: - Examples Setup
    private func setupExamples() {
        var currentY: CGFloat = margin
        
        // 1. 基础功能展示
        currentY = setupBasicFeatures(startY: currentY)
        currentY += sectionSpacing
        
        // 2. 布局模式展示
        currentY = setupLayoutModes(startY: currentY)
        currentY += sectionSpacing
        
        // 3. 样式定制展示
        currentY = setupStyleCustomization(startY: currentY)
        currentY += sectionSpacing
        
        // 4. 状态管理展示
        currentY = setupStateManagement(startY: currentY)
        currentY += sectionSpacing
        
        // 5. 动画效果展示
        currentY = setupAnimationEffects(startY: currentY)
        currentY += sectionSpacing
        
        // 6. 尺寸控制展示
        currentY = setupSizeControl(startY: currentY)
        currentY += sectionSpacing
        
        // 7. 实际应用场景
        currentY = setupRealWorldScenarios(startY: currentY)
        currentY += sectionSpacing
        
        // 8. 高级功能展示
        currentY = setupAdvancedFeatures(startY: currentY)
        
        // 设置 contentView 的高度
        contentView.heightAnchor.constraint(equalToConstant: currentY + margin).isActive = true
    }
}

// MARK: - 1. 基础功能展示
extension FlexButtonExample {
    private func setupBasicFeatures(startY: CGFloat) -> CGFloat {
        var currentY = startY
        
        // 标题
        currentY = addSectionTitle("1. 基础功能", at: currentY)
        
        // 纯文字按钮
        let textOnlyButton = FlexButton()
        textOnlyButton.configure(
            title: "纯文字按钮",
            backgroundColor: .systemBlue,
            titleColor: .white
        )
        textOnlyButton.onTap = { _ in
            print("🔘 纯文字按钮被点击")
        }
        addButton(textOnlyButton, x: margin, y: currentY)
        
        // 纯图片按钮
        let imageOnlyButton = FlexButton()
        imageOnlyButton.configure(
            image: UIImage(systemName: "heart.fill"),
            backgroundColor: .systemRed,
            imageTintColor: .white
        )
        imageOnlyButton.onTap = { _ in
            print("🔘 纯图片按钮被点击")
        }
        addButton(imageOnlyButton, x: margin + 140, y: currentY, width: 50, height: 50)
        
        // 图文混合按钮
        let mixedButton = FlexButton()
        mixedButton.configure(
            image: UIImage(systemName: "star.fill"),
            title: "图文混合",
            backgroundColor: .systemGreen,
            imageTintColor: .white,
            titleColor: .white
        )
        mixedButton.onTap = { _ in
            print("🔘 图文混合按钮被点击")
        }
        addButton(mixedButton, x: margin + 210, y: currentY)
        
        return currentY + 60
    }
}

// MARK: - 2. 布局模式展示
extension FlexButtonExample {
    private func setupLayoutModes(startY: CGFloat) -> CGFloat {
        var currentY = startY
        
        // 标题
        currentY = addSectionTitle("2. 布局模式", at: currentY)
        
        let layouts: [(FlexButton.FlexButtonLayout, String)] = [
            (.imageLeft, "图片在左"),
            (.imageRight, "图片在右"),
            (.imageTop, "图片在上"),
            (.imageBottom, "图片在下")
        ]
        
        for (index, layoutInfo) in layouts.enumerated() {
            let button = FlexButton()
            button.configure(
                image: UIImage(systemName: "star.fill"),
                title: layoutInfo.1,
                layout: layoutInfo.0,
                backgroundColor: .systemOrange,
                imageTintColor: .white,
                titleColor: .white
            )
            button.onTap = { _ in
                print("🔘 \(layoutInfo.1)按钮被点击")
            }
            
            if index < 2 {
                // 前两个横排
                addButton(button, x: margin + CGFloat(index) * 180, y: currentY)
            } else {
                // 后两个竖排
                addButton(button, x: margin + CGFloat(index - 2) * 180, y: currentY + 70)
            }
        }
        
        return currentY + 170
    }
}

// MARK: - 3. 样式定制展示
extension FlexButtonExample {
    private func setupStyleCustomization(startY: CGFloat) -> CGFloat {
        var currentY = startY
        
        // 标题
        currentY = addSectionTitle("3. 样式定制", at: currentY)
        
        // 圆角按钮
        let cornerButton = FlexButton()
        cornerButton.configure(
            title: "圆角按钮",
            backgroundColor: .systemPurple,
            titleColor: .white
        )
        cornerButton.setCornerRadius(20)
        cornerButton.onTap = { _ in
            print("🔘 圆角按钮被点击")
        }
        addButton(cornerButton, x: margin, y: currentY)
        
        // 边框按钮
        let borderButton = FlexButton()
        borderButton.configure(
            title: "边框按钮",
            backgroundColor: .clear,
            titleColor: .systemBlue
        )
        borderButton.setBorder(width: 2, color: .systemBlue)
        borderButton.setCornerRadius(8)
        borderButton.onTap = { _ in
            print("🔘 边框按钮被点击")
        }
        addButton(borderButton, x: margin + 140, y: currentY)
        
        // 阴影按钮
        let shadowButton = FlexButton()
        shadowButton.configure(
            title: "阴影按钮",
            backgroundColor: .white,
            titleColor: .black
        )
        shadowButton.setShadow(color: .systemBlue, opacity: 0.3, offset: CGSize(width: 0, height: 4), radius: 8)
        shadowButton.setCornerRadius(12)
        shadowButton.onTap = { _ in
            print("🔘 阴影按钮被点击")
        }
        addButton(shadowButton, x: margin + 280, y: currentY)
        
        currentY += 60
        
        // 圆形按钮 (Frame 布局)
        let frameCircularButton = FlexButton()
        frameCircularButton.configure(
            image: UIImage(systemName: "heart.fill"),
            backgroundColor: .systemPink,
            imageTintColor: .white
        )
        frameCircularButton.setCircularMode(true)
        frameCircularButton.onTap = { sender in
            let currentSize = sender.frame.width
            let newSize: CGFloat = currentSize > 70 ? 60 : 90
            print("🔘 [Frame] 点击前: \(sender.frame.width)x\(sender.frame.height)")
            sender.setPosition(x: self.margin, y: currentY, width: newSize, height: newSize)
            print("🔘 [Frame] 设置后: \(sender.frame.width)x\(sender.frame.height)")
        }
        addButton(frameCircularButton, x: margin, y: currentY, width: 60, height: 60)
        
        // 圆形按钮 (Auto Layout)
        let autoLayoutCircularButton = FlexButton()
        autoLayoutCircularButton.configure(
            image: UIImage(systemName: "star.fill"),
            backgroundColor: .systemOrange,
            imageTintColor: .white
        )
        autoLayoutCircularButton.setCircularMode(true)
        
        // 存储约束引用以便动态修改
        var widthConstraint: NSLayoutConstraint!
        var heightConstraint: NSLayoutConstraint!
        
        autoLayoutCircularButton.onTap = { sender in
            let currentSize = widthConstraint.constant
            let newSize: CGFloat = currentSize > 70 ? 60 : 90
            UIView.animate(withDuration: 0.3) {
                widthConstraint.constant = newSize
                heightConstraint.constant = newSize
                sender.superview?.layoutIfNeeded()
            } completion: { _ in
            }
        }
        
        contentView.addSubview(autoLayoutCircularButton)
        autoLayoutCircularButton.translatesAutoresizingMaskIntoConstraints = false
        
        widthConstraint = autoLayoutCircularButton.widthAnchor.constraint(equalToConstant: 70)
        heightConstraint = autoLayoutCircularButton.heightAnchor.constraint(equalToConstant: 70)
        
        NSLayoutConstraint.activate([
            autoLayoutCircularButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin + 80),
            autoLayoutCircularButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: currentY),
            widthConstraint,
            heightConstraint
        ])
        
        return currentY + 90
    }
}

// MARK: - 4. 状态管理展示
extension FlexButtonExample {
    private func setupStateManagement(startY: CGFloat) -> CGFloat {
        var currentY = startY
        
        // 标题
        currentY = addSectionTitle("4. 状态管理", at: currentY)
        
        // 状态切换按钮
        let stateButton = FlexButton()
        stateButton.configure(
            image: UIImage(systemName: "circle"),
            title: "点击切换状态",
            backgroundColor: .systemBlue,
            imageTintColor: .white,
            titleColor: .white
        )
        
        // 配置不同状态
        stateButton.setImage(UIImage(systemName: "circle"), for: .normal)
        stateButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        stateButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .disabled)
        
        stateButton.setBackgroundColor(.systemBlue, for: .normal)
        stateButton.setBackgroundColor(.systemGreen, for: .selected)
        stateButton.setBackgroundColor(.systemGray, for: .disabled)
        
        stateButton.setTitle("点击切换状态", for: .normal)
        stateButton.setTitle("已选中状态", for: .selected)
        stateButton.setTitle("禁用状态", for: .disabled)
        
        var stateIndex = 0
        let states: [FlexButton.ButtonState] = [.normal, .selected, .disabled]
        
        stateButton.onTap = { sender in
            stateIndex = (stateIndex + 1) % states.count
            sender.setState(states[stateIndex], animated: true)
            print("🔘 状态切换到: \(states[stateIndex])")
        }
        
        addButton(stateButton, x: margin, y: currentY, width: 200)
        
        // 自定义状态配置按钮
        let customStateButton = FlexButton()
        customStateButton.configure(
            title: "自定义状态",
            backgroundColor: .systemIndigo,
            titleColor: .white
        )
        
        // 设置不同状态的字体
        customStateButton.setTitleFont(.systemFont(ofSize: 16, weight: .regular), for: .normal)
        customStateButton.setTitleFont(.systemFont(ofSize: 18, weight: .bold), for: .selected)
        customStateButton.setTitleFont(.systemFont(ofSize: 14, weight: .light), for: .disabled)
        
        // 设置不同状态的透明度
        customStateButton.setAlpha(1.0, for: .normal)
        customStateButton.setAlpha(0.8, for: .selected)
        customStateButton.setAlpha(0.5, for: .disabled)
        
        var customStateIndex = 0
        customStateButton.onTap = { sender in
            customStateIndex = (customStateIndex + 1) % states.count
            sender.setState(states[customStateIndex], animated: true)
            print("🔘 自定义状态切换到: \(states[customStateIndex])")
        }
        
        addButton(customStateButton, x: margin + 220, y: currentY, width: 150)
        
        return currentY + 60
    }
}

// MARK: - 5. 动画效果展示
extension FlexButtonExample {
    private func setupAnimationEffects(startY: CGFloat) -> CGFloat {
        var currentY = startY
        
        // 标题
        currentY = addSectionTitle("5. 动画效果", at: currentY)
        
        let animations: [(FlexButton.AnimationType, String)] = [
            (.scale, "缩放"),
            (.bounce, "弹跳"),
            (.flash, "闪烁"),
            (.shake, "震动"),
            (.pulse, "脉冲"),
            (.fadeScale, "淡入缩放")
        ]
        
        for (index, animationInfo) in animations.enumerated() {
            let button = FlexButton()
            button.configure(
                title: animationInfo.1,
                backgroundColor: .systemTeal,
                titleColor: .white
            )
            button.animationType = animationInfo.0
            button.onTap = { _ in
                print("🔘 \(animationInfo.1)动画演示")
            }
            
            let row = index / 3
            let col = index % 3
            addButton(button, x: margin + CGFloat(col) * 120, y: currentY + CGFloat(row) * 70, width: 100)
        }
        
        return currentY + 140
    }
}

// MARK: - 6. 尺寸控制展示
extension FlexButtonExample {
    private func setupSizeControl(startY: CGFloat) -> CGFloat {
        var currentY = startY
        
        // 标题
        currentY = addSectionTitle("6. 尺寸控制", at: currentY)
        
        // 自适应尺寸按钮
        let adaptiveButton = FlexButton()
        adaptiveButton.configure(
            image: UIImage(systemName: "arrow.up.and.down.and.arrow.left.and.right"),
            title: "自适应尺寸",
            backgroundColor: .systemCyan,
            imageTintColor: .white,
            titleColor: .white
        )
        adaptiveButton.onTap = { _ in
            print("🔘 自适应尺寸演示")
        }
        addButton(adaptiveButton, x: margin, y: currentY)
        
        // 固定最小尺寸按钮
        let fixedSizeButton = FlexButton()
        fixedSizeButton.configure(
            title: "最小尺寸",
            backgroundColor: .systemMint,
            titleColor: .white
        )
        fixedSizeButton.setFixedSize(width: 150, height: 50) // 设置最小尺寸
        fixedSizeButton.onTap = { sender in
            let isShort = sender.currentTitle?.count ?? 0 < 10
            let newTitle = isShort ? "这是一个很长很长的标题用来测试最小尺寸约束" : "最小尺寸"
            sender.setTitle(newTitle, for: .normal)
            print("🔘 内容变化: \(newTitle)")
        }
        addButton(fixedSizeButton, x: margin + 180, y: currentY, width: 150, height: 50)
        
        return currentY + 70
    }
}

// MARK: - 7. 实际应用场景
extension FlexButtonExample {
    private func setupRealWorldScenarios(startY: CGFloat) -> CGFloat {
        var currentY = startY
        
        // 标题
        currentY = addSectionTitle("7. 实际应用场景", at: currentY)
        
        // 导航栏按钮组
        currentY = addSubTitle("导航栏按钮", at: currentY)
        
        let backButton = FlexButton()
        backButton.configure(
            image: UIImage(systemName: "chevron.left"),
            title: "返回",
            layout: .imageLeft,
            backgroundColor: .clear,
            imageTintColor: .systemBlue,
            titleColor: .systemBlue
        )
        backButton.onTap = { _ in
            print("🔘 返回")
        }
        addButton(backButton, x: margin, y: currentY, width: 80)
        
        let moreButton = FlexButton()
        moreButton.configure(
            image: UIImage(systemName: "ellipsis"),
            backgroundColor: .clear,
            imageTintColor: .systemBlue
        )
        moreButton.onTap = { _ in
            print("🔘 更多")
        }
        addButton(moreButton, x: view.frame.width - margin - 40, y: currentY, width: 40, height: 40)
        
        currentY += 60
        
        // 工具栏按钮组
        currentY = addSubTitle("工具栏按钮", at: currentY)
        
        let toolbarButtons = [
            ("square.and.arrow.up", "分享"),
            ("heart", "收藏"),
            ("message", "评论"),
            ("bookmark", "书签")
        ]
        
        for (index, buttonInfo) in toolbarButtons.enumerated() {
            let button = FlexButton()
            button.configure(
                image: UIImage(systemName: buttonInfo.0),
                title: buttonInfo.1,
                layout: .imageTop,
                backgroundColor: .systemGray6,
                imageTintColor: .label,
                titleColor: .label,
                titleFont: .systemFont(ofSize: 12)
            )
            button.contentInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
            button.onTap = { _ in
                print("🔘 \(buttonInfo.1)")
            }
            addButton(button, x: margin + CGFloat(index) * 85, y: currentY, width: 70, height: 60)
        }
        
        currentY += 80
        
        // 表单按钮
        currentY = addSubTitle("表单按钮", at: currentY)
        
        let submitButton = FlexButton()
        submitButton.configure(
            title: "提交",
            backgroundColor: .systemBlue,
            titleColor: .white,
            titleFont: .systemFont(ofSize: 18, weight: .semibold)
        )
        submitButton.setCornerRadius(25)
        submitButton.onTap = { _ in
            print("🔘 表单提交")
        }
        addButton(submitButton, x: margin, y: currentY, width: view.frame.width - margin * 2, height: 50)
        
        currentY += 70
        
        let cancelButton = FlexButton()
        cancelButton.configure(
            title: "取消",
            backgroundColor: .clear,
            titleColor: .systemRed,
            titleFont: .systemFont(ofSize: 16)
        )
        cancelButton.setBorder(width: 1, color: .systemRed)
        cancelButton.setCornerRadius(20)
        cancelButton.onTap = { _ in
            print("🔘 取消操作")
        }
        addButton(cancelButton, x: margin, y: currentY, width: view.frame.width - margin * 2, height: 40)
        
        return currentY + 60
    }
}

// MARK: - 8. 高级功能展示
extension FlexButtonExample {
    private func setupAdvancedFeatures(startY: CGFloat) -> CGFloat {
        var currentY = startY
        
        // 标题
        currentY = addSectionTitle("8. 高级功能", at: currentY)
        
        // 背景视图按钮
        let gradientView = UIView()
        gradientView.layer.cornerRadius = 15
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.systemPurple.cgColor, UIColor.systemPink.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.cornerRadius = 15
        gradientView.layer.addSublayer(gradientLayer)
        
        let gradientButton = FlexButton()
        gradientButton.configure(
            title: "渐变背景",
            backgroundView: gradientView,
            titleColor: .white,
            titleFont: .systemFont(ofSize: 16, weight: .semibold)
        )
        
        gradientButton.onTap = { _ in
            print("🔘 渐变背景按钮被点击")
        }
        
        addButton(gradientButton, x: margin, y: currentY, width: 150, height: 50)
        
        // 更新渐变层frame
        DispatchQueue.main.async {
            gradientLayer.frame = gradientButton.bounds
        }
        
        // 内容对齐演示按钮
        let alignmentButton = FlexButton()
        alignmentButton.configure(
            image: UIImage(systemName: "align.horizontal.left"),
            title: "左对齐",
            backgroundColor: .systemIndigo,
            imageTintColor: .white,
            titleColor: .white
        )
        alignmentButton.onTap = { sender in
            let alignments: [FlexButton.ContentAlignment] = [.leading, .center, .trailing]
            let titles = ["左对齐", "居中", "右对齐"]
            let icons = ["align.horizontal.left", "align.horizontal.center", "align.horizontal.right"]
            
            let currentTitle = sender.currentTitle ?? ""
            if let currentIndex = titles.firstIndex(of: currentTitle) {
                let nextIndex = (currentIndex + 1) % alignments.count
                sender.contentAlignment = alignments[nextIndex]
                sender.setTitle(titles[nextIndex], for: .normal)
                sender.setImage(UIImage(systemName: icons[nextIndex]), for: .normal)
                print("🔘 对齐方式切换到: \(titles[nextIndex])")
            }
        }
        addButton(alignmentButton, x: margin + 170, y: currentY, width: 150)
        
        return currentY + 70
    }
}

// MARK: - Helper Methods
extension FlexButtonExample {
    
    /// 添加按钮到视图
    private func addButton(_ button: FlexButton, x: CGFloat, y: CGFloat, width: CGFloat? = nil, height: CGFloat? = nil) {
        contentView.addSubview(button)
        
        if let width = width, let height = height {
            button.setPosition(x: x, y: y, width: width, height: height)
        } else if let width = width {
            button.setPosition(x: x, y: y, width: width, height: 50)
        } else {
            button.setPosition(x: x, y: y)
        }
    }
    
    /// 添加章节标题
    private func addSectionTitle(_ title: String, at y: CGFloat) -> CGFloat {
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: y)
        ])
        
        return y + 35
    }
    
    /// 添加子标题
    private func addSubTitle(_ title: String, at y: CGFloat) -> CGFloat {
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: y)
        ])
        
        return y + 25
    }
} 
