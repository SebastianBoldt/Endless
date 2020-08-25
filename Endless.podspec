Pod::Spec.new do |s|
  s.name             = 'Endless'
  s.version          = '0.0.2'
  s.summary          = 'Endless is a lighweight endless page indicator.'

  s.description      = <<-DESC
    Endless is a lighweight endless page indicator.
                       DESC

  s.homepage         = 'https://www.sebastianboldt.com'
  s.author           = { 'Sebastian Boldt' => 'self.dealloc@icloud.com' }
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.source           = { :git => 'https://github.com/SebastianBoldt/Endless.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.swift_version    = '4.2'
  s.source_files = 'Endless/Classes/**/*'
end
