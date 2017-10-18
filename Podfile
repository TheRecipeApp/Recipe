# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'RecipeApp' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for RecipeApp
  pod 'AFNetworking'
  pod 'MBProgressHUD'
  pod 'Parse'
  pod 'ParseUI'
  pod 'CryptoSwift'
  pod 'ParseFacebookUtilsV4'
  pod 'FacebookCore'
  pod 'FacebookLogin'
  pod 'iCarousel'

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '3.2'
      end
    end
  end
end
