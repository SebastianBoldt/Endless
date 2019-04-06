Pod::Spec.new do |s|
  s.name             = 'Endless'
  s.version          = '0.1.0'
  s.summary          = 'Endless is a lighweight endless page indicator.'

  s.description      = <<-DESC
    Endless is a lighweight endless page indicator.
                       DESC

  s.homepage         = 'https://github.com/self.dealloc@protonmail.com/Endless'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'self.dealloc@protonmail.com' => 'self.dealloc@googlemail.com' }
  s.source           = { :git => 'https://github.com/self.dealloc@protonmail.com/Endless.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'Endless/Classes/**/*'
end
