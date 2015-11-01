//
//  ViewController.h
//  RandomContactsViewer
//
//  Created by Varun Goyal on 2015-10-29.
//  Copyright © 2015 Varun Goyal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactDetailsViewController.h"

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, retain) NSMutableArray *randomUserContactsData;
@property (nonatomic, retain) NSMutableArray *displayedContactsData;
@property (nonatomic, retain) IBOutlet UITableView *contactListTableViewController;

@property (nonatomic, retain) ContactDetailsViewController *contactDetailsViewController;

@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;

@property (nonatomic, retain) IBOutlet UIButton *reloadData;


- (void) setup;
- (IBAction)refresh:(id)sender;
@end

