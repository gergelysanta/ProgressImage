#
# Be sure to run `pod lib lint ProgressImage.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ProgressImage'
  s.version          = '0.1.1'
  s.summary          = 'A small customizable ProgressImage usable in menu extras or context menus.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
This is an NSImage enhancement displaying a small progressbar.
Why NSImage? The main point was to create a progressbar usable in menu extras (menubar)
or in context menus and those items can contain only NSImages. ProgressImage is a small
configurable image displaying graphical progress so you can visualize any progress up
in the menu extras bar for example.
                       DESC

  s.homepage         = 'https://github.com/gergelysanta/ProgressImage'
  # s.screenshots     = 'https://github.com/gergelysanta/ProgressImage/blob/master/Screenshots/ProgressImageStatusItem.png', 'https://github.com/gergelysanta/ProgressImage/blob/master/Screenshots/ProgressImageStatusItem.gif', 'https://github.com/gergelysanta/ProgressImage/blob/master/Screenshots/ProgressImageContextMenu.png'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Gergely Sánta' => 'gergely.santa@trikatz.com' }
  s.source           = { :git => 'https://github.com/gergelysanta/ProgressImage.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/gergelysanta'

  s.platform = :osx
  s.osx.deployment_target = "10.10"
  s.osx.frameworks = 'Cocoa'

  s.swift_version = "4.0"

  s.source_files = 'Source/**/*'

  # s.resource_bundles = {
  #   'ProgressImage' => ['Source/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/**/*.h'
end
