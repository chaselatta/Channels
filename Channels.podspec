Pod::Spec.new do |s|
  s.name             = "Channels"
  s.version          = "0.1.0"
  s.summary          = "An experiment in using Channels."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description      = <<-DESC
An experiment in using Channels.
                       DESC

  s.homepage         = "https://github.com/chaselatta/Channels"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.authors          = { "Chase Latta" => "chaselatta@twitter.com" }
  s.source           = { :git => "https://github.com/chaselatta/channels.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/???'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Channels/**/*'

  # s.frameworks = 'UIKit'
end
