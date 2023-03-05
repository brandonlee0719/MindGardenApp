# Uncomment the next line to define a global platform for your project
 platform :ios, '15.0'

target 'MindGarden' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MindGarden
#   pod 'FirebaseFirestore'
   pod 'Amplitude-iOS', '~> 4.9.3'
   pod 'lottie-ios', '~> 3.5.0'
   pod 'AppsFlyerFramework'
   pod 'Purchases'
#   pod 'Firebase/DynamicLinks'
   pod 'Amplitude', '~> 8.5.0'
#   pod 'Firebase/Crashlytics'
   # pod 'EnvoySDK'
   
   target 'MindGardenWidgetExtension' do
#     pod 'FirebaseFirestore'
#     pod 'Firebase'
#     pod 'FirebaseAuth'
   end

  target 'MindGardenTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'MindGardenUITests' do
    # Pods for testing
  end

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['APPLICATION_EXTENSION_API_ONLY'] = 'No'
      end
    end
  end
  
end
