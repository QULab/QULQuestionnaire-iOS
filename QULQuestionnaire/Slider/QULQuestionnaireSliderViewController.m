//
//  QULQuestionnaireSliderViewController.m
//  QULQuestionnaire
//
/*
 Copyright 2014 Quality and Usability Lab, Telekom Innvation Laboratories, TU Berlin.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */


#import "QULQuestionnaireSliderViewController.h"
#import "RMStepsController.h"

@interface QULQuestionnaireSliderViewController ()

@property (strong, nonatomic) UIButton *nextButton;
@property (strong, nonatomic) UISlider *slider;
@property (strong, nonatomic) UILabel *selectedValueLabel;

@end

@implementation QULQuestionnaireSliderViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *questionLabel = [[UILabel alloc] init];
    questionLabel.preferredMaxLayoutWidth = 280;
    questionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    questionLabel.numberOfLines = 0;
    questionLabel.font = [UIFont boldSystemFontOfSize:21.0];
    questionLabel.text = self.questionnaireData[@"question"];
    [self.view addSubview:questionLabel];
    
    UILabel *instructionLabel = [[UILabel alloc] init];
    instructionLabel.preferredMaxLayoutWidth = 280;
    instructionLabel.numberOfLines = 0;
    instructionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    instructionLabel.text = self.questionnaireData[@"instruction"];
    [self.view addSubview:instructionLabel];
    
    UISlider *slider = [[UISlider alloc] init];
    slider.translatesAutoresizingMaskIntoConstraints = NO;
    slider.minimumValue = [self.questionnaireData[@"minValue"] floatValue];
    slider.maximumValue = [self.questionnaireData[@"maxValue"] floatValue];
    [slider addTarget:self
               action:@selector(sliderDidChangeValue:)
     forControlEvents:UIControlEventValueChanged];
    self.slider = slider;
    [self.view addSubview:slider];
    
    UILabel *minLabel = [[UILabel alloc] init];
    minLabel.translatesAutoresizingMaskIntoConstraints = NO;
    minLabel.text = self.questionnaireData[@"minLabel"];
    [self.view addSubview:minLabel];
    
    UILabel *maxLabel = [[UILabel alloc] init];
    maxLabel.translatesAutoresizingMaskIntoConstraints = NO;
    maxLabel.text = self.questionnaireData[@"maxLabel"];
    [self.view addSubview:maxLabel];
    
    UILabel *selectedValueLabel = [[UILabel alloc] init];
    selectedValueLabel.translatesAutoresizingMaskIntoConstraints = NO;
    selectedValueLabel.text = @"";
    selectedValueLabel.hidden = ![self.questionnaireData[@"showSelectedValue"] boolValue];
    self.selectedValueLabel = selectedValueLabel;
    [self.view addSubview:self.selectedValueLabel];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [nextButton setTitle:@"Next" forState:UIControlStateNormal];
    nextButton.translatesAutoresizingMaskIntoConstraints = NO;
    nextButton.enabled = ![self.questionnaireData[@"required"] boolValue];
    [nextButton addTarget:self
                   action:@selector(proceed)
         forControlEvents:UIControlEventTouchUpInside];
    self.nextButton = nextButton;
    [self.view addSubview:self.nextButton];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(questionLabel,
                                                         instructionLabel,
                                                         slider,
                                                         minLabel,
                                                         maxLabel,
                                                         selectedValueLabel,
                                                         nextButton);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[questionLabel]-[instructionLabel]-(45)-[slider]-[minLabel]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[nextButton]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[questionLabel]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[instructionLabel]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[slider]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[minLabel]-(>=8)-[selectedValueLabel]-(>=8)-[maxLabel]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[nextButton]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:minLabel
                                                          attribute:NSLayoutAttributeBaseline
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:selectedValueLabel
                                                          attribute:NSLayoutAttributeBaseline
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:selectedValueLabel
                                                          attribute:NSLayoutAttributeBaseline
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:maxLabel
                                                          attribute:NSLayoutAttributeBaseline
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:selectedValueLabel
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.0]];
}

- (void)proceed {
    NSDictionary *result = @{@"question": self.questionnaireData[@"key"],
                             @"answer": @(self.slider.value)};    
    [self.stepsController.results[@"data"] addObject:result];
    
    [self.stepsController showNextStep];
}

- (void)sliderDidChangeValue:(UISlider *)slider {
    
    if (self.questionnaireData[@"stepValue"]) {
        float stepValue = [self.questionnaireData[@"stepValue"] floatValue];
        float newStep = roundf((slider.value) / stepValue);
        slider.value = newStep * stepValue;
    }
    
    self.selectedValueLabel.text = [NSString stringWithFormat:@"%.1f",slider.value];
    
    if (!self.nextButton.enabled) {
        self.nextButton.enabled = YES;
    }
}

@end
