Pod::Spec.new do |s|
  s.name             = 'flutter_image_gallery_saver'
  s.version          = '2.0.0'
  s.summary          = 'Flutter Image Gallery Saver'
  s.description      = 'Flutter Image Gallery Saver is a plugin that lets you save images and videos to the device gallery on Android and iOS, streamlining media storage for your apps.'
  s.homepage         = 'http://knottx.dev'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Visarut Tippun' => 'knotto.vt@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'flutter_image_gallery_saver/Sources/flutter_image_gallery_saver/**/*.swift'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  s.resource_bundles = {'flutter_image_gallery_saver_privacy' => ['flutter_image_gallery_saver/Sources/flutter_image_gallery_saverResources/PrivacyInfo.xcprivacy']}
end
