//
//  ContactDetailsViewController.h
//  RandomContactsViewer
//
//  Created by Varun Goyal on 2015-10-30.
//  Copyright © 2015 Varun Goyal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface ContactDetailsViewController : UIViewController

@property (nonatomic, retain) UserModel *currentUser;

@property (nonatomic, retain) UIImageView *profileImage;

@property (nonatomic, retain) UILabel *fullName;

@property (nonatomic, retain) UILabel *phoneNumber;

@property (nonatomic, retain) UILabel *cellNumber;

@property (nonatomic, retain) UILabel *email;

- (instancetype)initWithUser:(UserModel*) user;

- (void) reloadUser:(UserModel*) user;

@end
