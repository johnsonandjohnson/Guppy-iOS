Pod::Spec.new do |s|
  s.name          = 'Guppy'
  s.version       = '0.6.1'
  s.summary       = 'Guppy is a friendly fish that sniffs out all network requests.'
  s.homepage      = 'https://github.com/johnsonandjohnson/Guppy-iOS'
  s.license       = { :type => 'Apache v2.0' }

  s.authors = { 
    'Diego Urquiza' => 'dspaces1@gmail.com',
    'Stephen Hayes' => 'shayes20@its.jnj.com',
    'Brandon Walton' => 'bwalton5@its.jnj.com'
  }

  s.ios.deployment_target = '10.0'
  s.swift_version = '5.0'
  s.source        = { :git => 'https://github.com/johnsonandjohnson/Guppy-iOS.git', :tag => s.version }
  s.source_files  = 'Sources/**/*.swift'
  s.resources     = 'Sources/**/*.xcassets'
  s.ios.resources = 'Sources/**/*.{storyboard,xib}'

end
