Pod::Spec.new do |s|
  s.name     = 'RFLibrary'
  s.version  = '1.0.5'
  s.license  = 'MIT'
  s.platform = :ios, 5.0
  s.summary  = 'A short description of RFLibrary.'
  s.description = 'An optional longer description of RFLibrary.'
  s.homepage = 'http://bozar.dyndns.org/'
  s.author   = { 'bryce' => 'bryce@i.tv' }
  s.source   = { :git => 'git@github.com:bryceredd/RFLibrary.git' }
  s.source_files = 'RFLibrary'
  s.resources = "RFLibrary/*.xib"
  s.frameworks = 'CoreText', 'CoreData', 'QuartzCore'
  s.dependency 'ISO8601DateFormatter', '>=0.6'
  s.dependency 'NLCoreData', '~> 0.4.5'
end
