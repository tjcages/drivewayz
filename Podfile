# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'DriveWayz' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  #post_install do |installer|
#  installer.pods_project.targets.each do |target|
#    target.build_configurations.each do |config|
#      config.build_settings['SWIFT_VERSION'] = '4.2'
#    end
#  end
#end

post_install do |installer|
    installer.aggregate_targets.each do |aggregate_target|
        if aggregate_target.name == 'Pods-SampleApp'
            aggregate_target.xcconfigs.each do |config_name, config_file|
                aggregate_target.pod_targets.each do |pod_target|
                    pod_target.specs.each do |spec|
                        if spec.attributes_hash['vendored_frameworks'] != nil or (spec.attributes_hash['ios'] != nil and spec.attributes_hash['ios']['vendored_frameworks'] != nil)
                            puts "Removing #{spec.name}"
                            config_file.frameworks.delete(spec.name)
                        end
                    end
                end
                xcconfig_path = aggregate_target.xcconfig_path(config_name)
                config_file.save_as(xcconfig_path)
            end
        end
    end
end

  # Pods for DriveWayz
	pod ‘Firebase/Auth'
	pod 'Firebase/Core'
	pod 'Firebase/Messaging'
	pod 'Firebase/Database'
	pod 'Firebase/Storage'
    	pod 'Firebase/Analytics'
	pod 'Firebase/DynamicLinks'
	pod 'Firebase/RemoteConfig'
	pod 'Firebase/Firestore'

	pod 'GoogleSignIn'
	pod 'PushNotifications'
	pod 'GooglePlaces'
	pod 'GooglePlacePicker'
	pod 'GoogleMaps'
    	pod 'GeoFire', :git => 'https://github.com/firebase/geofire-objc.git'
	pod 'Cyborg'

	pod 'Stripe'
	pod 'Alamofire', '~> 4.7.3'
	pod 'SwiftyJSON'

	pod 'FBSDKCoreKit', '~> 4.38.0'
	pod 'FBSDKLoginKit', '~> 4.38.0'
	pod 'FacebookCore'
	pod 'FacebookLogin'

	pod 'MapboxStatic.swift', '~> 0.9'
	pod 'Mapbox-iOS-SDK'
	pod 'MapboxCoreNavigation'
	pod 'MapboxNavigation'

	pod 'Cosmos'
	pod 'NVActivityIndicatorView'
	pod 'AFNetworking'
	pod 'UIImageColors'
	pod 'Solar'
	pod 'CHIPageControl', '~> 0.1.3'
	pod 'JTAppleCalendar'

	pod 'PayCardsRecognizer'
	pod 'ViewAnimator'
	pod 'MultiSlider'
	pod 'AnyFormatKit'

end
