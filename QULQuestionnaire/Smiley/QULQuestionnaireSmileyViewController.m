//
//  QULQuestionnaireSmileyViewController.m
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


#import "QULQuestionnaireSmileyViewController.h"
#import "RMStepsController.h"

@interface QULQuestionnaireSmileyViewController ()

@property (strong, nonatomic) UIButton *nextButton;
@property (strong, nonatomic) NSMutableArray *buttons;

@end

@implementation QULQuestionnaireSmileyViewController

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
    [nextButton setTitle:@"Next" forState:UIControlStateNormal];
    nextButton.translatesAutoresizingMaskIntoConstraints = NO;
    nextButton.enabled = ![self.questionnaireData[@"required"] boolValue];
    [nextButton addTarget:self
                   action:@selector(proceed)
         forControlEvents:UIControlEventTouchUpInside];
    self.nextButton = nextButton;
    [self.view addSubview:self.nextButton];
    
    
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
    
    NSArray *smileys = @[@"QULQuestionnaireSmileyVerySad",
                         @"QULQuestionnaireSmileySad",
                         @"QULQuestionnaireSmileyOK",
                         @"QULQuestionnaireSmileyHappy",
                         @"QULQuestionnaireSmileyVeryHappy"];
    
    int i = 0;
    id previousElement = instructionLabel;
    self.buttons = [@[] mutableCopy];
    for (NSString *smileyName in smileys) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        button.tag = i;
        [button setImage:[UIImage imageNamed:smileyName]
                forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@Selected",smileyName]]
                forState:UIControlStateSelected];
        [button addTarget:self
                   action:@selector(didSelectButton:)
         forControlEvents:UIControlEventTouchUpInside];
        [self.buttons addObject:button];
        [scrollView addSubview:button];
        
        if (i == 0) {
            [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[instructionLabel]-(45)-[button]"
                                                                              options:0
                                                                              metrics:nil
                                                                                views:NSDictionaryOfVariableBindings(instructionLabel,
                                                                                                                     button)]];
        } else {
            if (i == [smileys count] - 1) {
                [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[button]-|"
                                                                                   options:0
                                                                                   metrics:nil
                                                                                     views:NSDictionaryOfVariableBindings(button)]];
            }
            
            [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                   attribute:NSLayoutAttributeCenterY
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:previousElement
                                                                   attribute:NSLayoutAttributeCenterY
                                                                  multiplier:1.0f
                                                                    constant:0.0f]];
        }
        
        CGFloat multiplier = (2*i + 2) / (CGFloat)([smileys count] + 1);
        [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                               attribute:NSLayoutAttributeCenterX
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:scrollView
                                                               attribute:NSLayoutAttributeCenterX
                                                              multiplier:multiplier
                                                                constant:0]];
        
        previousElement = button;
        i++;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    UIScrollView *scrollView = [[self.view subviews] firstObject];
    [scrollView flashScrollIndicators];
}

- (void)proceed {
    NSMutableDictionary *result = [@{} mutableCopy];
    result[@"question"] = self.questionnaireData[@"key"];
    
    [self.buttons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        if (button.selected) {
            result[@"answer"] = @(button.tag);
            
            *stop = YES;
        }
    }];
    [self.stepsController.results[@"data"] addObject:result];
    
    [self.stepsController showNextStep];
}

- (void)didSelectButton:(UIButton *)selected {
    
    if (!self.nextButton.enabled) {
        self.nextButton.enabled = YES;
    }
    
    for (UIButton *button in self.buttons) {
        button.selected = (button == selected);
//        button.backgroundColor = (button == selected) ? [UIColor blueColor] : [UIColor clearColor];
    }
}

@end
