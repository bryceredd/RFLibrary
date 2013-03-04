#
# Be sure to run `pod spec lint ITVCoreJSON.podspec' to ensure this is a
# valid spec.
#
# Remove all comments before submitting the spec. Optional attributes are commented.
#
# For details see: https://github.com/CocoaPods/CocoaPods/wiki/The-podspec-format
#
Pod::Spec.new do |s|
  s.name         = "ITVCoreJSON"
  s.version      = "0.0.1"
  s.summary      = "A tool which automatically converts incoming JSON to CoreData objects."
  s.description  = 'A tool which automatically converts incoming JSON to CoreData objects.  Handles nested objects, updating objects, removal of objects, custom properties, and relationships. Solution based on this blog post: http://bryceredd.posterous.com/automated-json-to-coredata-parsing'
  s.homepage     = "https://github.com/idottv/ITVCoreJSON"

  # Specify the license type. CocoaPods detects automatically the license file if it is named
  # `LICENSE*', however if the name is different, specify it.
  # Only if no dedicated file is available include the full text of the license.
  #
  s.license      = 'MIT'
  # s.license      = { :type => 'MIT', :file => 'LICENSE', :text => 'Permission is hereby granted ...' }

  # Specify the authors of the library, with email addresses. You can often find
  # the email addresses of the authors by using the SCM log. E.g. $ git log
  #
  s.authors       = { "bryce redd" => "bryce@i.tv", "layne moseley" => "layne@i.tv" }
  # s.authors      = { "bryce redd" => "bryce@i.tv", "other author" => "and email address" }
  #
  # If absolutely no email addresses are available, then you can use this form instead.
  #
  # s.author       = 'bryce redd', 'other author'

  # Specify the location from where the source should be retreived.
  #
  s.source       = { :git => "https://github.com/idottv/ITVCoreJSON.git", :tag => "0.0.1" }

  # If this Pod runs only on iOS or OS X, then specify the platform and
  # the deployment target.
  #
  # s.platform     = :ios, '5.0'
  s.platform     = :ios

  # ――― MULTI-PLATFORM VALUES ――――――――――――――――――――――――――――――――――――――――――――――――― #

  # If this Pod runs on both platforms, then specify the deployment
  # targets.
  #
  s.ios.deployment_target = '5.0'
  # s.osx.deployment_target = '10.7'

  # A list of file patterns which select the source files that should be
  # added to the Pods project. If the pattern is a directory then the
  # path will automatically have '*.{h,m,mm,c,cpp}' appended.
  #
  # Alternatively, you can use the FileList class for even more control
  # over the selected files.
  # (See http://rake.rubyforge.org/classes/Rake/FileList.html.)
  #
  s.source_files = './*.{h,m}'

  # A list of resources included with the Pod. These are copied into the
  # target bundle with a build phase script.
  #
  # Also allows the use of the FileList class like `source_files does.
  #
  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # A list of paths to preserve after installing the Pod.
  # CocoaPods cleans by default any file that is not used.
  # Also allows the use of the FileList class like `source_files does.
  #
  # s.preserve_paths = "examples", "doc"

  # Specify a list of frameworks that the application needs to link
  # against for this Pod to work.
  #
  s.framework  = 'CoreData'
  # s.frameworks = 'SomeFramework', 'AnotherFramework'

  # Specify a list of libraries that the application needs to link
  # against for this Pod to work.
  #
  # s.library   = 'iconv'
  # s.libraries = 'iconv', 'xml2'

  # If this Pod uses ARC, specify it like so.
  #
  s.requires_arc = true

  # If you need to specify any other build settings, add them to the
  # xcconfig hash.
  #
  # s.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2' }

  # Finally, specify any Pods that this Pod depends on.
  #
  s.dependency 'RFLibrary', :git => 'git@github.com:bryceredd/RFLibrary.git'
  s.dependency 'NLCoreData', '>=0.2.0'
end
