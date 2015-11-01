//
//  ViewController.m
//  RandomContactsViewer
//
//  Created by Varun Goyal on 2015-10-29.
//  Copyright © 2015 Varun Goyal. All rights reserved.
//

#import "ViewController.h"
#import "Constants.h"
#import "UserModel.h"
#import "ContactDetailsViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize randomUserContactsData = _randomUserContactsData, contactListTableViewController = _contactListTableViewController,contactDetailsViewController = _contactDetailsViewController;

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Setups up the main view of the application. Makes a request to random user api to return X users.
- (void) setup {    
    self.randomUserContactsData = [NSMutableArray array];
    self.contactListTableViewController.cellLayoutMarginsFollowReadableWidth = NO;
    int numberOfContacts = rand()%110+1;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:RANDOM_USER_API_URL, numberOfContacts]]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          if (error) {
                                              [NSException raise:@"Exception : Error While Retrieving contacts"
                                                          format:@"%@", error.localizedDescription];
                                              
                                          }
                                          
                                          NSError *jsonError;
                                          
                                          // Parse the JSON response
                                          NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data
                                                                                               options:kNilOptions
                                                                                                 error:&jsonError];
                                          if (jsonError) {
                                              [NSException raise:@"Json Parse Exception"
                                                          format:@"%@", jsonError.localizedDescription];
                                          }
//                                          
                                          NSArray *resultsArray = [responseDict objectForKey:@"results"];
                                          
                                          for(NSDictionary *currentDictionary in resultsArray){
                                              UserModel *currentContact = [[UserModel alloc] initWithDictionary:[currentDictionary objectForKey:@"user"]];
                                              [self.randomUserContactsData addObject:currentContact];
                                          }
                                          
                                          NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES]];
                                          self.randomUserContactsData = [[self.randomUserContactsData sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
                                          
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                [self.contactListTableViewController reloadData];
                                          });
                                      }];
    [dataTask resume];
}

// TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.randomUserContactsData.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];

    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:MyIdentifier];
    }
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    UserModel *currentUser = [self.randomUserContactsData objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", currentUser.firstName, currentUser.lastName];
//    [cell setSeparatorInset:UIEdgeInsetsZero];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 80;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.contactDetailsViewController == NULL){
        self.contactDetailsViewController = [[ContactDetailsViewController alloc] initWithUser:[self.randomUserContactsData objectAtIndex:indexPath.row]];
        [self.contactDetailsViewController.view setFrame:self.view.frame];
    }else{
        [self.contactDetailsViewController reloadUser:[self.randomUserContactsData objectAtIndex:indexPath.row]];
    }
    
    [self presentViewController:self.contactDetailsViewController animated:YES completion:nil];
}

@end
