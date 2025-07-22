#
# Be sure to run `pod lib lint FlexButton.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FlexButton'
  s.version          = '1.0.0'
  s.summary          = '灵活的iOS按钮组件，支持图文混排、状态管理、动画效果和自适应尺寸'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
FlexButton 是一个高度灵活的iOS按钮组件，基于UIView构建，提供以下核心功能：

🎨 多样化布局支持
• 支持图片和文字的多种排列方式（左右上下）
• 灵活的内容对齐选项
• 可自定义间距和内边距

📐 智能尺寸管理
• 自适应内容尺寸计算
• 支持最小尺寸约束
• 完美兼容AutoLayout和Frame布局

🎭 状态管理系统
• 支持normal、selected、disabled等多种状态
• 每种状态可独立配置外观属性
• 平滑的状态切换动画

✨ 丰富的动画效果
• 内置多种点击动画（缩放、弹跳、闪烁等）
• 支持自定义动画类型
• 可配置动画开关

🎯 实用便捷功能
• 圆角、边框、阴影快速设置
• 自适应圆形按钮模式
• 渐变背景视图支持
• 完整的无障碍支持

适用于各种场景：导航按钮、工具栏、表单提交、社交分享等。
                       DESC

  s.homepage         = 'https://github.com/HuginChen/FlexButton'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'HuginChen' => 'huginn.chen@gmail.com' }
  s.source           = { :git => 'https://github.com/HuginChen/FlexButton.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '14.0'
  s.swift_versions = '5.0'

  s.source_files = 'FlexButton/Classes/**/*'
  
  # s.resource_bundles = {
  #   'FlexButton' => ['FlexButton/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
