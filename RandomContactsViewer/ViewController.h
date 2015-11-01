//
//  ViewController.h
//  RandomContactsViewer
//
//  Created by Varun Goyal on 2015-10-29.
//  Copyright © 2015 Varun Goyal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactDetailsViewController.h"

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray *randomUserContactsData;
@property (nonatomic, retain) IBOutlet UITableView *contactListTableViewController;

@property (nonatomic, retain) ContactDetailsViewController *contactDetailsViewController;

- (void) setup;

@end

