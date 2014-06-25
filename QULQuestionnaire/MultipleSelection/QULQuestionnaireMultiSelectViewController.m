//
//  QULQuestionnaireMultiSelectViewController.m
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


#import "QULQuestionnaireMultiSelectViewController.h"
#import "RMStepsController.h"
#import "NSMutableArray+Shuffle.h"

@interface QULQuestionnaireMultiSelectViewController ()

@property (strong, nonatomic) UIButton *nextButton;

@property (strong, nonatomic) NSMutableArray *selectedOptions;

@end

@implementation QULQuestionnaireMultiSelectViewController

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

    self.selectedOptions = [@[] mutableCopy];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:scrollView];
    
    UILabel *questionLabel = [[UILabel alloc] init];
    questionLabel.preferredMaxLayoutWidth = 280;
    questionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    questionLabel.numberOfLines = 0;
    questionLabel.font = [UIFont boldSystemFontOfSize:21.0];
    questionLabel.text = self.questionnaireData[@"question"];
    [scrollView addSubview:questionLabel];
    
    UILabel *instructionLabel = [[UILabel alloc] init];
    instructionLabel.preferredMaxLayoutWidth = 280;
    instructionLabel.numberOfLines = 0;
    instructionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    instructionLabel.text = self.questionnaireData[@"instruction"];
    [scrollView addSubview:instructionLabel];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [nextButton setTitle:NSLocalizedString(@"Next", nil)
                forState:UIControlStateNormal];
    nextButton.translatesAutoresizingMaskIntoConstraints = NO;
    nextButton.enabled = ![self.questionnaireData[@"required"] boolValue];
    [nextButton addTarget:self
                   action:@selector(proceed)
         forControlEvents:UIControlEventTouchUpInside];
    self.nextButton = nextButton;
    [self.view addSubview:self.nextButton];
    
    if ([self.questionnaireData[@"randomized"] boolValue]) {
        NSMutableArray *shuffledOptions = [self.questionnaireData[@"options"] mutableCopy];
        [shuffledOptions shuffle];
        
        NSMutableDictionary *dataCopy = [self.questionnaireData mutableCopy];
        dataCopy[@"options"] = shuffledOptions;
        self.questionnaireData = dataCopy;
    }
    
    NSDictionary *views = NSDictionaryOfVariableBindings(scrollView,
                                                         questionLabel,
                                                         instructionLabel,
                                                         nextButton);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]-[nextButton]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[questionLabel]-[instructionLabel]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[questionLabel]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[instructionLabel]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[nextButton]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:scrollView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:questionLabel
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0]];
    
    
    UIImage *radioOff = [UIImage imageNamed:@"QULQuestionnaireRadioOff"];
    UIImage *radioOn = [UIImage imageNamed:@"QULQuestionnaireRadioOn"];
    
    int i=0;
    id previousElement = instructionLabel;
    for (NSDictionary *option in self.questionnaireData[@"options"]) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [button setImage:radioOff forState:UIControlStateNormal];
        [button setImage:radioOn forState:UIControlStateSelected];
        button.tag = i;
        [button addTarget:self
                   action:@selector(checkboxToggle:)
         forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:button];
        
        [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:33.0]];
        [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:33.0]];
        
        UILabel *label = [[UILabel alloc] init];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.text = option[@"value"];
        [scrollView addSubview:label];
        
        NSString *format;
        if (i == 0) {
            format = @"V:[previousElement]-(45)-[button]";
        } else if (i == [self.questionnaireData[@"options"] count]-1) {
            format = @"V:[previousElement]-[button]|";
        } else {
            format = @"V:[previousElement]-[button]";
        }
        
        [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format
                                                                          options:NSLayoutFormatAlignAllLeading
                                                                          metrics:nil
                                                                            views:NSDictionaryOfVariableBindings(previousElement,button)]];
        [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[button]-[label]-|"
                                                                          options:NSLayoutFormatAlignAllCenterY
                                                                          metrics:nil
                                                                            views:NSDictionaryOfVariableBindings(button,label)]];
        
        previousElement = button;
        i++;
    }
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:scrollView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:questionLabel
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    UIScrollView *scrollView = [[self.view subviews] firstObject];
    [scrollView flashScrollIndicators];
}

- (void)proceed {
    NSMutableDictionary *result = [@{} mutableCopy];
    result[@"question"] = self.questionnaireData[@"key"];
    result[@"answer"] = [@[] mutableCopy];
    
    [self.selectedOptions enumerateObjectsUsingBlock:^(NSNumber *buttonTag, NSUInteger idx, BOOL *stop) {
        NSDictionary *option = self.questionnaireData[@"options"][[buttonTag integerValue]];
        result[@"answer"][idx] = option[@"key"];
    }];
    [self.stepsController.results[@"data"] addObject:result];
    
    [self.stepsController showNextStep];
}


- (void)checkboxToggle:(UIButton *)button {
    
    if (!self.nextButton.enabled) {
        self.nextButton.enabled = YES;
    }
    
    if (button.selected) {
        [self.selectedOptions removeObject:@(button.tag)];
        button.selected = !button.selected;
    } else {
        if (self.questionnaireData[@"maxSelectable"]) {
            if ([self.selectedOptions count] < [self.questionnaireData[@"maxSelectable"] intValue]) {
                [self.selectedOptions addObject:@(button.tag)];
                button.selected = !button.selected;
            }
        } else {
            [self.selectedOptions addObject:@(button.tag)];
            button.selected = !button.selected;
        }
    }
}

@end
