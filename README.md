# QULQuestionnaire-iOS

[![CI Status](http://img.shields.io/travis/QULab/QULQuestionnaire.svg?style=flat)](https://travis-ci.org/QULab/QULQuestionnaire)
[![Version](https://img.shields.io/cocoapods/v/QULQuestionnaire.svg?style=flat)](http://cocoapods.org/pods/QULQuestionnaire)
[![License](https://img.shields.io/cocoapods/l/QULQuestionnaire.svg?style=flat)](http://cocoapods.org/pods/QULQuestionnaire)
[![Platform](https://img.shields.io/cocoapods/p/QULQuestionnaire.svg?style=flat)](http://cocoapods.org/pods/QULQuestionnaire)

QULQuestionnaire provides a drop-in solution for presenting an in-app questionnaire to the user.

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

##Questionaire items & JSON format


###Single selection (radio)
```json
{
  "key": STRING,
  "type": "radio",
  "orientation": STRING ("horizontal" | "vertical") 
  "question": STRING,        
  "instruction": STRING,
  "required": BOOL,
  "randomized": BOOL,
  "other": BOOL // optional; only available in vertical orientation
  "minLabel": STRING, // optional; only available in horizontal orientation
  "maxLabel": STRING, // optional; only available in horizontal orientation
  "decreaseIncreaseAccessory": BOOL, // optional; only available in horizontal orientation
  "options": [
    {
      "key": STRING,
      "value": STRING,
      "default": BOOL // optional
    }
  ]
}
```
<img src="Screenshots/SingleSelectionVertical.png" width="200" alt="Single selection vertical">
<img src="Screenshots/SingleSelectionHorizontal.png" width="200" alt="Single selection horizontal">

###Overall rating (smiley scale)
```json
{
  "key": STRING,
  "type": "smiley",
  "question": STRING,
  "instruction": STRING, 
  "required": BOOL
}
```
<img src="Screenshots/Smiley.png" width="200" alt="Smiley">

###Multiple selection (checkbox)
```json
{
  "key": STRING,
  "type": "checkbox",
  "question": STRING,
  "instruction": STRING,    
  "required": BOOL,
  "randomized": BOOL,
   "maxSelectable": INT, // optional
   "options": [
     {
       "key": STRING,
       "value": STRING,
       "selected": BOOL // optional
      }
    ]
}
```
<img src="Screenshots/MultipleSelection.png" width="200" alt="Multiple selection">

###Value from range (slider)
```json
{
  "key": STRING,
  "type": "slider",
  "question": STRING,
  "instruction": STRING,
  "required": BOOL,
  "minValue": FLOAT,
  "maxValue": FLOAT,
  "minLabel": STRING,
  "maxLabel": STRING,
  "showSelectedValue": BOOL, // optional
  "stepValue": INT // optional
}
```
<img src="Screenshots/Slider.png" width="200" alt="Slider">

###Text
```json
{
  "key": STRING,
  "type": "text",
  "question": STRING,
  "input": STRING ("text" | "number" | "email") , // optional, defaults to text
  "instruction": STRING,
  "placeholder": STRING,
  "required": BOOL
}
```
<img src="Screenshots/Text.png" width="200" alt="Text">

###Ranking
```json
{
  "key": STRING,
  "type": "sortable",
  "question": STRING,    
  "instruction": STRING,
  "required": BOOL,
  "randomized": BOOL,
  "options": [
    {
      "key": STRING,
      "value": STRING
    }
  ]
}
```
<img src="Screenshots/Ranking.png" width="200" alt="Ranking">

#Installation

##Manual

Copy all files from the QULQuestionnare folder to your project.

## CocoaPods

```ruby
platform :ios, '7.0'
pod "QULQuestionnaire", "~> 0.1"
```

#Requirements
* iOS7 (will work on iOS6 without RMStepsController)
* ARC

#Dependencies
* https://github.com/CooperRS/RMStepsController

#License

QULQuestionnaire-iOS is licensed under the terms of the [Apache License, version 2.0](http://www.apache.org/licenses/LICENSE-2.0.html). Please see the [LICENSE](LICENSE) file for full details.
