Pod::Spec.new do |s|
  s.name         = "QULQuestionnaire"
  s.version      = "0.1"
  s.summary      = "Drop-in in-app questionnaire for iOS"
  s.homepage     = "https://github.com/QULab/QULQuestionnaire-iOS"
  s.license      = "Apache License, Version 2.0"
  s.author             = { "Tilo Westermann" => "tilo.westermann@tu-berlin.de" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/QULab/QULQuestionnaire-iOS.git", :tag => "0.1" }
  s.source_files  = "QULQuestionnaire/**/*.{h,m}"
  s.resources = "QULQuestionnaire/QULQuestionnaireImages.xcassets"
  s.requires_arc = true
  s.dependency "RMStepsController", "~> 1.0.1"
end