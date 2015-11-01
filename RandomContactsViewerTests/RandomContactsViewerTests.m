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
    while (self.vc.randomUserContactsData.count <=0);
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

- (void)testTableViewIsConnectedToDelegate
{
    XCTAssertNotNil(self.vc.contactListTableViewController.delegate, @"Table delegate cannot be nil");
}

- (void)testTableViewNumberOfRowsInSection
{
    NSInteger expectedRows = self.vc.randomUserContactsData.count;
    XCTAssertTrue([self.vc tableView:self.vc.contactListTableViewController numberOfRowsInSection:0]==expectedRows, @"Table has %ld rows but it should have %ld", (long)[self.vc tableView:self.vc.contactListTableViewController numberOfRowsInSection:0], (long)expectedRows);
}

- (void)testTableViewDidSelectRowAtIndex
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.vc.contactListTableViewController selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
    XCTAssertEqual([self.vc.contactListTableViewController indexPathForSelectedRow], indexPath, @"Table View row was not selected");
}

- (void) testContactDetailsViewDidInitialize{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.vc tableView:self.vc.contactListTableViewController didSelectRowAtIndexPath:indexPath];
    XCTAssertNotNil(self.vc.contactDetailsViewController, @"Contact Details View did not initialize");
}
@end
