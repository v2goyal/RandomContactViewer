//
//  RandomContactsViewerTests.m
//  RandomContactsViewerTests
//
//  Created by Varun Goyal on 2015-10-29.
//  Copyright © 2015 Varun Goyal. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UserModel.h"
#import "ViewController_Private.h"

@interface RandomContactsViewerTests : XCTestCase

@property (nonatomic, strong) ViewController *vc;

@end

@implementation RandomContactsViewerTests

- (void)setUp {
    [self tearDown];
    [super setUp];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.vc = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    [self.vc performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.vc = nil;
    [super tearDown];
}

-(void)testThatViewLoads
{
    XCTAssertNotNil(self.vc.view, @"View not initiated properly");
}

- (void)testParentViewHasTableViewSubview
{
    NSArray *subviews = self.vc.view.subviews;
    XCTAssertTrue([subviews containsObject:self.vc.contactListTableViewController], @"View does not have a table subview");
}

-(void)testThatTableViewLoads
{
    XCTAssertNotNil(self.vc.contactListTableViewController, @"TableView not initiated");
}

#pragma mark - UITableView tests
- (void)testThatViewConformsToUITableViewDataSource
{
    XCTAssertTrue([self.vc conformsToProtocol:@protocol(UITableViewDataSource) ], @"View does not conform to UITableView datasource protocol");
}

- (void)testThatTableViewHasDataSource
{
    XCTAssertNotNil(self.vc.contactListTableViewController.dataSource, @"Table datasource cannot be nil");
}

- (void)testThatViewConformsToUITableViewDelegate
{
    XCTAssertTrue([self.vc conformsToProtocol:@protocol(UITableViewDelegate) ], @"View does not conform to UITableView delegate protocol");
}

//Check if table view delegate is initialized
- (void)testTableViewIsConnectedToDelegate
{
    XCTAssertNotNil(self.vc.contactListTableViewController.delegate, @"Table delegate cannot be nil");
}

// Test if number of rows are consistent in tableview
- (void)testTableViewNumberOfRowsInSection
{
    while (self.vc.displayedContactsData == NULL || self.vc.displayedContactsData.count <=0);
    NSInteger expectedRows = self.vc.displayedContactsData.count;
    XCTAssertTrue([self.vc tableView:self.vc.contactListTableViewController numberOfRowsInSection:0]==expectedRows, @"Table has %ld rows but it should have %ld", (long)[self.vc tableView:self.vc.contactListTableViewController numberOfRowsInSection:0], (long)expectedRows);
}

// Test table view row selection
- (void)testTableViewDidSelectRowAtIndex
{
    while (self.vc.displayedContactsData == NULL || self.vc.displayedContactsData.count <=0);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.vc.contactListTableViewController selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
    XCTAssertEqual([self.vc.contactListTableViewController indexPathForSelectedRow], indexPath, @"Table View row was not selected");
}

// Test if contact details view is initialized
- (void) testContactDetailsViewDidInitialize{
    while (self.vc.displayedContactsData == NULL || self.vc.displayedContactsData.count <=0);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.vc tableView:self.vc.contactListTableViewController didSelectRowAtIndexPath:indexPath];
    XCTAssertNotNil(self.vc.contactDetailsViewController, @"Contact Details View did not initialize");
}

//Test reloading user to an already initialized contact details view works
- (void) testContactViewReloadUser{
    while (self.vc.displayedContactsData == NULL || self.vc.displayedContactsData.count <=0);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.vc tableView:self.vc.contactListTableViewController didSelectRowAtIndexPath:indexPath];
    NSString *initialUserFullName = self.vc.contactDetailsViewController.fullName.text;
    indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [self.vc tableView:self.vc.contactListTableViewController didSelectRowAtIndexPath:indexPath];
    XCTAssertNotEqual(initialUserFullName, self.vc.contactDetailsViewController.fullName.text, @"Reloading user not working");
}

//Test if refresh reloads contact data
- (void) testDataRefresh{
    while (self.vc.displayedContactsData == NULL || self.vc.displayedContactsData.count <=0);
    NSInteger count = self.vc.randomUserContactsData.count;
    UserModel *firstUser = [self.vc.randomUserContactsData objectAtIndex:0];
    [self.vc refresh:self.vc.reloadData];
    while (self.vc.displayedContactsData == NULL || self.vc.displayedContactsData.count <=0);
    NSInteger refreshedCount = self.vc.randomUserContactsData.count;
    UserModel *refreshsedFirstUser = [self.vc.randomUserContactsData objectAtIndex:0];
    BOOL *didRefresh = (count != refreshedCount) || firstUser != refreshsedFirstUser;
    XCTAssertTrue(didRefresh, @"Refreshing data does not work");
}

// Search Bar Test Methods

//Test if first name searching works
- (void) testSearchBarQueryFirstName{
    while (self.vc.displayedContactsData == NULL || self.vc.displayedContactsData.count <=0);
    int count = self.vc.displayedContactsData.count;
    [self.vc.searchBar setText:((UserModel*)[self.vc.displayedContactsData objectAtIndex:0]).firstName];
    [self.vc searchBarSearchButtonClicked:self.vc.searchBar];
    XCTAssertNotEqual(count, self.vc.displayedContactsData.count, @"First name search did not work");
}

//Test if last name searching works
- (void) testSearchBarQueryLastName{
    while (self.vc.displayedContactsData == NULL || self.vc.displayedContactsData.count <=0);
    int count = self.vc.displayedContactsData.count;
    [self.vc.searchBar setText:((UserModel*)[self.vc.displayedContactsData objectAtIndex:0]).lastName];
    [self.vc searchBarSearchButtonClicked:self.vc.searchBar];
    XCTAssertNotEqual(count, self.vc.displayedContactsData.count, @"Last name search did not work");
}

//Test if full name searching works
- (void) testSearchBarQueryFullName{
    while (self.vc.displayedContactsData == NULL || self.vc.displayedContactsData.count <=0);
    int count = self.vc.displayedContactsData.count;
    UserModel *user = [self.vc.displayedContactsData objectAtIndex:0];
    [self.vc.searchBar setText:[NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName]];
    [self.vc searchBarSearchButtonClicked:self.vc.searchBar];
    XCTAssertNotEqual(count, self.vc.displayedContactsData.count, @"Full Name search Did Not work");
}

//Test if clearing search reloads all contacts
- (void) testSearchBarClear{
    while (self.vc.displayedContactsData == NULL || self.vc.displayedContactsData.count <=0);
    [self.vc.searchBar setText:((UserModel*)[self.vc.displayedContactsData objectAtIndex:0]).firstName];
    [self.vc searchBarSearchButtonClicked:self.vc.searchBar];
    int count = self.vc.displayedContactsData.count;
    [self.vc searchBar:self.vc.searchBar textDidChange:@""];
    XCTAssertNotEqual(count, self.vc.displayedContactsData.count, @"Search clear does not reload data");
}


@end
