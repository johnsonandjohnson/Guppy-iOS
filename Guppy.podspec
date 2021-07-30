Pod::Spec.new do |s|
  s.name          = 'Guppy'
  s.version       = '0.9.0'
  s.summary       = 'Guppy is a friendly fish that sniffs out all network requests.'
  s.homepage      = 'https://github.com/johnsonandjohnson/Guppy-iOS'
  s.license       = { :type => 'Apache v2.0' }
  s.author = 'Johnson & Johnson'
  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'
  s.source        = { :git => 'https://github.com/johnsonandjohnson/Guppy-iOS.git', :tag => s.version }
  s.source_files  = 'Sources/**/*.swift'
  s.resource_bundles = {
    'Guppy' => ['Sources/**/*.{storyboard,xib,xcassets}']
  }
end
