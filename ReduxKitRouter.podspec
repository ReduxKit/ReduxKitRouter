Pod::Spec.new do |spec|
  spec.name              = 'ReduxKitRouter'
  spec.version           = '0.1.1'
  spec.summary           = 'Router middleware for ReduxKit'
  spec.homepage          = 'https://github.com/ReduxKit/ReduxKitRouter'
  spec.license           = { :type => 'MIT', :file => 'LICENSE' }
  spec.authors           = { 'Aleksander Herforth Rendtslev' => 'kontakt@karemedia.dk', 'Karl Bowden' => 'karl@karlbowden.com' }
  spec.source            = { :git => 'https://github.com/ReduxKit/ReduxKitRouter.git', :tag => spec.version.to_s }
  spec.source_files      = 'ReduxKitRouter'
  spec.dependency          'ReduxKit', '~> 0.1'
  spec.ios.deployment_target = '8.0'
end
