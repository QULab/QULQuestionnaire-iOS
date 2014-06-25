//
//  QULQuestionnaireSortableViewController.m
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


#import "QULQuestionnaireSortableViewController.h"
#import "RMStepsController.h"
#import "NSMutableArray+Shuffle.h"

@interface QULQuestionnaireSortableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIButton *nextButton;
@property (strong, nonatomic) NSMutableArray *orderedOptions;

@end

@implementation QULQuestionnaireSortableViewController

- (instancetype)init {
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

- (void)viewDidLoad {
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
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.editing = YES;
    [scrollView addSubview:tableView];
    
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
        
        self.orderedOptions = shuffledOptions;
    } else {
        self.orderedOptions = [self.questionnaireData[@"options"] mutableCopy];
    }
    
    NSDictionary *views = NSDictionaryOfVariableBindings(scrollView,
                                                         questionLabel,
                                                         instructionLabel,
                                                         tableView,
                                                         nextButton);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]-[nextButton]-|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:views]];
    CGFloat tableHeight = [self.orderedOptions count] * 44;
    NSString *format = [NSString stringWithFormat:@"V:|-[questionLabel]-[instructionLabel]-(45)-[tableView(%f)]|",tableHeight];
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format
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
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[tableView]-|"
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
    
    [self.orderedOptions enumerateObjectsUsingBlock:^(NSDictionary *option, NSUInteger idx, BOOL *stop) {
        result[@"answer"][idx] = option[@"key"];
    }];
    [self.stepsController.results[@"data"] addObject:result];

    [self.stepsController showNextStep];
}

#pragma mark - UITableView delegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSDictionary *dictToMove = [self.orderedOptions objectAtIndex:sourceIndexPath.row];
    [self.orderedOptions removeObjectAtIndex:sourceIndexPath.row];
    [self.orderedOptions insertObject:dictToMove atIndex:destinationIndexPath.row];
    
    if (!self.nextButton.enabled) {
        self.nextButton.enabled = YES;
    }
}

#pragma mark - UITableView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.orderedOptions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SortableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"SortableCell"];
    }
    
    NSDictionary *option = self.questionnaireData[@"options"][indexPath.row];
    cell.textLabel.text = option[@"value"];
    
    return cell;
}

@end
