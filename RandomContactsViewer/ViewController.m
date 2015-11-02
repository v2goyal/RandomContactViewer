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
#import "Helpers.h"

@interface ViewController ()
@end

@implementation ViewController

@synthesize randomUserContactsData = _randomUserContactsData, contactListTableViewController = _contactListTableViewController,contactDetailsViewController = _contactDetailsViewController, searchBar = _searchBar, displayedContactsData = _displayedContactsData, reloadData = _reloadData;

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

- (void)viewDidAppear:(BOOL)animated{
    BOOL hasInternet = [Helpers testInternetConnection];
    
    if(hasInternet == false && self.randomUserContactsData.count == 0){        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No internet connection!" message:@"Please connect to an internet connection and try again later." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           NSLog(@"Cancel action");
                                       }];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"OK action");
                                   }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        
        [alertController setModalPresentationStyle:UIModalPresentationPopover];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Setups up the main view of the application. Makes a request to random user api to return X users.
- (void) setup {
    self.randomUserContactsData = [NSMutableArray array];
    self.displayedContactsData = [NSMutableArray array];
    self.contactListTableViewController.cellLayoutMarginsFollowReadableWidth = NO;
    [self connectAndLoadData];
}

// TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.displayedContactsData.count;
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
    
    UserModel *currentUser = [self.displayedContactsData objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", currentUser.firstName, currentUser.lastName];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 80;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.contactDetailsViewController == NULL){
        self.contactDetailsViewController = [[ContactDetailsViewController alloc] initWithUser:[self.displayedContactsData objectAtIndex:indexPath.row]];
        [self.contactDetailsViewController.view setFrame:self.view.frame];
    }else{
        [self.contactDetailsViewController reloadUser:[self.displayedContactsData objectAtIndex:indexPath.row]];
    }
    
    [self presentViewController:self.contactDetailsViewController animated:YES completion:nil];
}

// Search Bar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if ([searchText length] == 0) {
        self.displayedContactsData = [self.randomUserContactsData mutableCopy];
        [self.contactListTableViewController reloadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString* filter = @"%K CONTAINS[cd] %@";
    NSArray *searchText = [searchBar.text componentsSeparatedByString:@" "];
    
    //No query
    if(searchText.count == 0 || searchText.count > 2){
        return;
    }else if(searchText.count == 1){
    //Search if query exists in user's first or last name
        NSPredicate* predicate = [NSPredicate predicateWithFormat:filter, @"firstName", [searchText objectAtIndex:0]];
        NSPredicate* predicateLastName = [NSPredicate predicateWithFormat:filter, @"lastName", [searchText objectAtIndex:0]];
        self.displayedContactsData = [[self.randomUserContactsData filteredArrayUsingPredicate:predicate] mutableCopy];
        [self.displayedContactsData addObjectsFromArray:[[self.randomUserContactsData filteredArrayUsingPredicate:predicateLastName] mutableCopy]];
        
        //Remove duplicates
        self.displayedContactsData = [[[NSOrderedSet orderedSetWithArray:self.displayedContactsData] array] mutableCopy];
        
        //Sort by first name
        NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES]];
        self.displayedContactsData = [[self.displayedContactsData sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
        
    }else if(searchText.count == 2){
    //Query user full name to filter contacts
        NSPredicate* predicate = [NSPredicate predicateWithFormat:filter, @"firstName", [searchText objectAtIndex:0]];
        NSPredicate* predicateLastName = [NSPredicate predicateWithFormat:filter, @"lastName", [searchText objectAtIndex:1]];
        self.displayedContactsData = [[self.randomUserContactsData filteredArrayUsingPredicate:predicate] mutableCopy];
        self.displayedContactsData = [[self.displayedContactsData filteredArrayUsingPredicate:predicateLastName] mutableCopy];
    }

    [self.contactListTableViewController reloadData];
    [searchBar resignFirstResponder];
}

//Hides shown keyboard if any when table view is scrolled
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.contactListTableViewController){
        [self.searchBar resignFirstResponder];
    }
}

- (IBAction)refresh:(id)sender {
    BOOL hasInternet = [Helpers testInternetConnection];

    if(hasInternet == false){
        return;
    }

    [self connectAndLoadData];
}

- (void) connectAndLoadData{
    BOOL hasInternet = [Helpers testInternetConnection];
    
    if(hasInternet == false){
        return;
    }
    
    [self.randomUserContactsData removeAllObjects];
    [self.displayedContactsData removeAllObjects];
    
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
                                          self.displayedContactsData = [self.randomUserContactsData mutableCopy];
                                          
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              [self.contactListTableViewController reloadData];
                                          });
                                      }];
    [dataTask resume];
}
@end
