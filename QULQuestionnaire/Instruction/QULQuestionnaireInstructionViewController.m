//
//  QULQuestionnaireInstructionViewController.m
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

#import "QULQuestionnaireInstructionViewController.h"
#import "RMStepsController.h"

@interface QULQuestionnaireInstructionViewController ()

@end

@implementation QULQuestionnaireInstructionViewController

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
    
    UITextView *instructionTextView = [[UITextView alloc] init];
    instructionTextView.translatesAutoresizingMaskIntoConstraints = NO;
    instructionTextView.text = self.questionnaireData[@"instruction"];
    instructionTextView.editable = NO;
    instructionTextView.font = [UIFont systemFontOfSize:15.0];
    [self.view addSubview:instructionTextView];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [nextButton setTitle:NSLocalizedString(@"Next", nil) forState:UIControlStateNormal];
    nextButton.translatesAutoresizingMaskIntoConstraints = NO;
    [nextButton addTarget:self
                   action:@selector(proceed)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(questionLabel,
                                                         instructionTextView,
                                                         nextButton);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[questionLabel]-[instructionTextView]-[nextButton]-(20)-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[questionLabel]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[instructionTextView]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[nextButton]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
}

- (void)proceed {
    [self.stepsController showNextStep];
}

@end
