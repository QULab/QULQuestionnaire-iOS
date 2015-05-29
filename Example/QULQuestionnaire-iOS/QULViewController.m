//
//  QULViewController.m
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


#import "QULViewController.h"
#import "QULQuestionnaireViewController.h"

@interface QULViewController ()

@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;

@end

@implementation QULViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showRemoteQuestionnaire:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://example.com/questionnaire.json"];
    [self loadQuestionnaireDataFromURL:url];
}

- (IBAction)showLocalQuestionnaire:(id)sender {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"questionnaire" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    NSError *error;
    NSArray *questionnaireData = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:0
                                                                   error:&error];
    
    if (error) {
        NSLog(@"Error parsing JSON: %@", error.description);
    } else {
        [self showQuestionnaireWithData:questionnaireData];
    }
}

- (void)loadQuestionnaireDataFromURL:(NSURL *)url {
    self.loadingLabel.hidden = NO;
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                               if (error) {
                                   NSLog(@"Error fetching data: %@", error.description);
                               } else {
                                   NSArray *questionnaireData = [NSJSONSerialization JSONObjectWithData:data
                                                                                                options:0
                                                                                                  error:&error];
                                   
                                   if (error) {
                                       NSLog(@"Error parsing JSON: %@", error.description);
                                   } else {
                                       [self showQuestionnaireWithData:questionnaireData];
                                       self.loadingLabel.hidden = YES;
                                   }
                               }
                           }];
}

- (void)showQuestionnaireWithData:(NSArray *)questionnaireData {
    QULQuestionnaireViewController *controller = [[QULQuestionnaireViewController alloc] initWithQuestionnaireData:questionnaireData];
    
    [self presentViewController:controller animated:YES completion:NULL];
}


@end
