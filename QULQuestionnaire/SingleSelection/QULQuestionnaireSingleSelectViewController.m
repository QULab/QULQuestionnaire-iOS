//
//  QULQuestionnaireSingleSelectViewController.m
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


#import "QULQuestionnaireSingleSelectViewController.h"
#import "RMStepsController.h"
#import "NSMutableArray+Shuffle.h"

@interface QULQuestionnaireSingleSelectViewController ()

@property (strong, nonatomic) UIButton *nextButton;
@property (strong, nonatomic) NSMutableArray *buttons;

@end

@implementation QULQuestionnaireSingleSelectViewController

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
    
    if(([self.questionnaireData[@"orientation"] integerValue] == QULQuestionnaireSingleSelectOrientationHorizontal) &&
       (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)) {
        NSAssert1([self.questionnaireData[@"options"] count] <= 7,
                  @"Due to layout constraints in portrait mode, the maximum number of options is 7 (%d provided).",
                  [self.questionnaireData[@"options"] count]);
    }
    
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
                                                                      metrics:0
                                                                        views:views]];
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[questionLabel]-|"
                                                                      options:0
                                                                      metrics:0
                                                                        views:views]];
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[instructionLabel]-|"
                                                                      options:0
                                                                      metrics:0
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[nextButton]-|"
                                                                      options:0
                                                                      metrics:0
                                                                        views:views]];
    
    UIImage *radioOff = [UIImage imageNamed:@"QULQuestionnaireRadioOff"];
    UIImage *radioOn = [UIImage imageNamed:@"QULQuestionnaireRadioOn"];
    
    int i=0;
    id previousElement = instructionLabel;
    self.buttons = [@[] mutableCopy];
    for (NSDictionary *option in self.questionnaireData[@"options"]) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [button setImage:radioOff forState:UIControlStateNormal];
        [button setImage:radioOn forState:UIControlStateSelected];
        button.tag = i;
        [button addTarget:self
                   action:@selector(didSelectButton:)
         forControlEvents:UIControlEventTouchUpInside];
        [self.buttons addObject:button];
        [scrollView addSubview:button];
        
        UILabel *label = [[UILabel alloc] init];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.text = option[@"value"];
        [scrollView addSubview:label];
        
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
        
        if ([self.questionnaireData[@"orientation"] integerValue] == QULQuestionnaireSingleSelectOrientationHorizontal) {
            
            NSLayoutAttribute attr;
            if ([option[@"value"] length] > 3) {
                label.layer.anchorPoint = CGPointMake(0.0f, 0.0f);
                label.transform = CGAffineTransformRotate(label.transform, (M_PI * 30 / 180.0));
                attr = NSLayoutAttributeCenterY;
            } else {
                attr = NSLayoutAttributeTop;
            }
            
            
            if (i == 0) {
                [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[instructionLabel]-(45)-[button]"
                                                                                  options:0
                                                                                  metrics:nil
                                                                                    views:NSDictionaryOfVariableBindings(instructionLabel,button)]];
            } else if (i == [self.questionnaireData[@"options"] count] - 1) {
                [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[label]-|"
                                                                                   options:0
                                                                                   metrics:nil
                                                                                     views:NSDictionaryOfVariableBindings(label)]];
            }
            
            NSString *format = (i == 0) ? @"H:|-[button]" : @"H:[previousElement]-[button]";
            
            [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format
                                                                              options:NSLayoutFormatAlignAllCenterY
                                                                              metrics:nil
                                                                                views:NSDictionaryOfVariableBindings(previousElement,button)]];
            [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                  attribute:NSLayoutAttributeBottom
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:label
                                                                  attribute:attr
                                                                 multiplier:1.0
                                                                   constant:0]];
            [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                  attribute:NSLayoutAttributeCenterX
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:label
                                                                  attribute:NSLayoutAttributeCenterX
                                                                 multiplier:1.0
                                                                   constant:0]];
        } else {
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
        }
        
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

- (void)proceed {
    NSMutableDictionary *result = [@{} mutableCopy];
    result[@"question"] = self.questionnaireData[@"key"];
    
    [self.buttons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        if (button.selected) {
            NSDictionary *option = self.questionnaireData[@"options"][button.tag];
            result[@"answer"] = option[@"key"];
            
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
    }
}

@end
