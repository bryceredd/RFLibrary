#
# Be sure to run `pod spec lint RFLibrary.podspec' to ensure this is a
# valid spec.
#
# Remove all comments before submitting the spec.
#
Pod::Spec.new do |s|
  s.name     = 'RFLibrary'
  s.version  = '1.0.5'
  s.license  = 'MIT'
  s.summary  = 'A short description of RFLibrary.'
  s.homepage = 'http://bozar.dyndns.org/'
  s.author   = { 'bryce' => 'bryce@i.tv' }
  s.source   = :git => 'git@github.com:bryceredd/RFLibrary.git'
  s.description = 'An optional longer description of RFLibrary.'
  s.source_files = 'RFLibrary'
  s.resources = "RFLibrary/*.xib"
  s.frameworks = 'CoreText', 'CoreData', 'QuartzCore'

  s.dependency 'ISO8601DateFormatter', '>=0.6'
  s.dependency 'NLCoreData', '~> 0.4.5'
end
