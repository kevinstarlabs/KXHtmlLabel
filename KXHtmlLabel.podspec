Pod::Spec.new do |s|
  s.name = "KXHtmlLabel"
  s.version = "0.8.1"

  s.homepage = "https://github.com/kxzen/KXHtmlLabel"
  s.summary = "powerful UILabel extension, display HTML on UILabel"

  s.author = { 'kxzen' => 'kevinapp38@gmail.com' }
  s.license = { :type => "MIT", :file => "LICENSE.md" }
  
  s.platform = :ios, '8.0'
  s.ios.deployment_target = '8.0'

  s.source = { :git => "https://github.com/kxzen/KXHtmlLabel.git", :tag => s.version }

  s.requires_arc = true

  s.resource  = 'KXHtmlLabel/FontAwesome.otf'
  s.source_files = 'KXHtmlLabel/**/*.{h,m}'
  s.public_header_files = 'KXHtmlLabel/**/*.h'
  s.private_header_files = 'KXHtmlLabel/PrivateHeaders/**/*.h'
  s.frameworks = 'UIKit', 'CoreText'
  s.requires_arc = true
end
