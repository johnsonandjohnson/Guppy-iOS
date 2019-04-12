Pod::Spec.new do |s|
  s.name          = 'Guppy'
  s.version       = '0.5.0'
  s.summary       = 'Guppy is a friendly fish that sniffs out all network request.'
  s.homepage      = 'https://github.com/johnsonandjohnson/Guppy'
  s.license       = { :type => 'Apache v2.0' }

  s.authors = { 
    'Diego Urquiza' => 'dspaces1@gmail.com',
  }

  s.swift_version = '5.0'
  s.source        = { :git => 'https://github.com/johnsonandjohnson/guppy.git', :tag => s.version }
  s.source_files  = 'Guppy/Sources/**/*.swift'
  s.resources     = 'Guppy/Sources/**/*.xcassets'
  s.ios.resources = 'Guppy/Sources/**/*.{storyboard,xib}'

end
