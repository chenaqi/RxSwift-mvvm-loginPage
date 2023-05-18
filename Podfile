# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'
inhibit_all_warnings! #忽略警告
source 'https://github.com/CocoaPods/Specs.git'

target 'LoginDemo' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for LoginDemo
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'SnapKit'
  pod 'MBProgressHUD'
  pod 'UILabelImageText'
  pod 'Toast-Swift'

  target 'LoginDemoTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'LoginDemoUITests' do
    # Pods for testing
  end

  post_install do |installer|
    installer.generated_projects.each do |project|
      project.targets.each do |target|
        target.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
        end
      end
    end
  end
end

