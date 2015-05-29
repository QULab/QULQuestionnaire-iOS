Pod::Spec.new do |s|
  s.name             = "QULQuestionnaire"
  s.version          = "0.4"
  s.summary          = "Drop-in in-app questionnaire for iOS"
  s.homepage         = "https://github.com/QULab/QULQuestionnaire-iOS"
  s.license          = "Apache License, Version 2.0"
  s.author           = { "Tilo Westermann" => "tilo.westermann@tu-berlin.de" }
  s.source           = { :git => "https://github.com/QULab/QULQuestionnaire-iOS.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.ios.resource_bundle = { 'QULQuestionnaire' => 'Pod/Assets/**/*.png' }

  s.dependency "RMStepsController", "~> 1.0.2"
end
