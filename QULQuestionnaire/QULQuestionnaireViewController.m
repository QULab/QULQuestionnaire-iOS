//
//  QULQuestionnaireViewController.m
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


#import "QULQuestionnaireViewController.h"

#import "QULQuestionnaireSliderViewController.h"
#import "QULQuestionnaireSmileyViewController.h"
#import "QULQuestionnaireTextViewController.h"
#import "QULQuestionnaireSingleSelectViewController.h"
#import "QULQuestionnaireMultiSelectViewController.h"
#import "QULQuestionnaireSortableViewController.h"
#import "QULQuestionnaireInstructionViewController.h"

@interface QULQuestionnaireViewController ()

@property (strong, nonatomic) NSMutableArray *stepViewControllers;

@end

@implementation QULQuestionnaireViewController

- (instancetype)initWithQuestionnaireData:(NSArray *)questionnaireData {
    self = [super init];
    if (self) {
        [self prepareViewControllers:questionnaireData];
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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.results[@"data"] = [@[] mutableCopy];
    self.results[@"user"] = @"userId";
    self.results[@"startTime"] = [NSDate date];
}

- (void)prepareViewControllers:(NSArray *)questionnaireData {
    self.stepViewControllers = [@[] mutableCopy];
    
    [questionnaireData enumerateObjectsUsingBlock:^(NSDictionary *question, NSUInteger idx, BOOL *stop) {
        UIViewController *viewController;
        if ([question[@"type"] isEqualToString:@"radio"]) {
            viewController = [[QULQuestionnaireSingleSelectViewController alloc] init];
            ((QULQuestionnaireSingleSelectViewController*)viewController).questionnaireData = question;
        } else if ([question[@"type"] isEqualToString:@"checkbox"]) {
            viewController = [[QULQuestionnaireMultiSelectViewController alloc] init];
            ((QULQuestionnaireMultiSelectViewController*)viewController).questionnaireData = question;
        } else if ([question[@"type"] isEqualToString:@"text"]) {
            viewController = [[QULQuestionnaireTextViewController alloc] init];
            ((QULQuestionnaireTextViewController*)viewController).questionnaireData = question;
        } else if ([question[@"type"] isEqualToString:@"smiley"]) {
            viewController = [[QULQuestionnaireSmileyViewController alloc] init];
            ((QULQuestionnaireSmileyViewController*)viewController).questionnaireData = question;
        } else if ([question[@"type"] isEqualToString:@"slider"]) {
            viewController = [[QULQuestionnaireSliderViewController alloc] init];
            ((QULQuestionnaireSliderViewController*)viewController).questionnaireData = question;
        } else if ([question[@"type"] isEqualToString:@"sortable"]) {
            viewController = [[QULQuestionnaireSortableViewController alloc] init];
            ((QULQuestionnaireSortableViewController*)viewController).questionnaireData = question;
        } else if ([question[@"type"] isEqualToString:@"instruction"]) {
            viewController = [[QULQuestionnaireInstructionViewController alloc] init];
            ((QULQuestionnaireInstructionViewController*)viewController).questionnaireData = question;
        } else {
            NSLog(@"Skipping item with unknown questionnaire type (%@): %@",question[@"type"],question);
        }
        
        if (viewController) {
            viewController.step.title = (question[@"title"]) ? question[@"title"] : [NSString stringWithFormat:@"%u",idx+1];
            
            [self.stepViewControllers addObject:viewController];
        }
    }];
}

- (void)finishedAllSteps {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    self.results[@"endTime"] = [NSDate date];
}

- (void)canceled {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
