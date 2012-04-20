Pod::Spec.new do

  #############################################################################
  # Required attributes
  #############################################################################

  # This pod’s name.
  name 'RFLibrary'

  # This pod’s version.
  #
  # The version string can contain numbers and periods, such as 1.0.0. A pod is
  # a ‘prerelease’ pod if the version has a letter in it, such as 1.0.0.pre.
  version '1.0.0'

  # A short summary of this pod’s description. Displayed in `pod list -d`.
  summary 'A library of useful categories and views'

  # The list of authors and their email addresses.
  #
  # This attribute is aliased as `author`, which can be used if there’s only
  # one author.
  authors 'Bryce Redd' => 'mr.redd@gmail.com'

  # The download strategy and the URL of the location of this pod’s source.
  #
  # Options are:
  # * :git => 'git://example.org/ice-pop.git'
  # * :svn => 'http://example.org/ice-pop/trunk'
  # * :tar => 'http://example.org/ice-pop-1.0.0.tar.gz'
  # * :zip => 'http://example.org/ice-pop-1.0.0.zip'

  source :git => 'git@github.com:bryceredd/RFLibrary.git'


end
