# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

target 'iChat' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for iChat
pod 'FirebaseAnalytics'
pod 'FirebaseAuth'
pod 'FirebaseFirestore' 
pod 'GoogleSignIn' , '~> 6.2.2'
pod 'FirebaseStorage'
pod 'SDWebImage'
pod 'IQKeyboardManagerSwift'
pod 'MessageKit'


end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.build_settings['WRAPPER_EXTENSION'] == 'su.andrerusso.iChat'
        config.build_settings['DEVELOPMENT_TEAM'] = 'Андрей Русин(Personal Team)'
      end
    end
  end
end


