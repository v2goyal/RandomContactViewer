//
//  ContactDetailsViewController.m
//  RandomContactsViewer
//
//  Created by Varun Goyal on 2015-10-30.
//  Copyright © 2015 Varun Goyal. All rights reserved.
//

#import "ContactDetailsViewController.h"

@interface ContactDetailsViewController ()

@end

@implementation ContactDetailsViewController

@synthesize currentUser = _currentUser, profileImage = _profileImage, fullName = _fullName, cellNumber = _cellNumber, phoneNumber = _phoneNumber, email = _email;

- (instancetype)initWithUser:(UserModel*) user
{
    self = [super init];
    if (self) {
        self.currentUser = user;
        [self setup];
    }
    return self;
}

- (void) setup{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIView *navBarBackround = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 54)];
    [navBarBackround setBackgroundColor:[UIColor blackColor]];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backButton setFrame:CGRectMake(10, 5, 80, 44)];
    [backButton setTitle:@"Contacts" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(hideViewController) forControlEvents:UIControlEventTouchUpInside];
    [navBarBackround addSubview:backButton];
    [self.view addSubview:navBarBackround];

    self.profileImage = [[UIImageView alloc] initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.currentUser.imageUrl]]]];
    
    float height = 300;
    float width = ((300*1.0)/self.profileImage.image.size.height) * self.profileImage.image.size.width;
    
    [self.profileImage setFrame:CGRectMake((self.view.frame.size.width - width)/2.0, 98, width, height)];
    [self.view addSubview:self.profileImage];
    
    self.fullName = [[UILabel alloc] initWithFrame:CGRectMake(0, 408, self.view.frame.size.width, 60)];
    [self.fullName setText:[NSString stringWithFormat:@"%@ %@", self.currentUser.firstName, self.currentUser.lastName]];
    [self.fullName setTextAlignment:NSTextAlignmentCenter];
    [self.fullName setFont:[UIFont fontWithName:@"Helvetica Neue" size:35]];
    [self.view addSubview:self.fullName];
    
    self.phoneNumber = [[UILabel alloc] initWithFrame:CGRectMake(20, 488, self.view.frame.size.width - 40, 44)];
    [self.phoneNumber setText:[NSString stringWithFormat:@"Phone : \t%@" , self.currentUser.phoneNumber]];
    [self.phoneNumber setTextAlignment:NSTextAlignmentLeft];
    [self.phoneNumber setFont:[UIFont fontWithName:@"Helvetica Neue" size:20]];
    [self.view addSubview:self.phoneNumber];
    
    self.cellNumber = [[UILabel alloc] initWithFrame:CGRectMake(20, 532, self.view.frame.size.width - 40, 44)];
    [self.cellNumber setText:[NSString stringWithFormat:@"Cell : \t\t%@" , self.currentUser.cellNumber]];
    [self.cellNumber setTextAlignment:NSTextAlignmentLeft];
    [self.cellNumber setFont:[UIFont fontWithName:@"Helvetica Neue" size:20]];
    [self.view addSubview:self.cellNumber];
    
    self.email = [[UILabel alloc] initWithFrame:CGRectMake(20, 576, self.view.frame.size.width - 40, 44)];
    [self.email setText:[NSString stringWithFormat:@"Email : \t%@" , self.currentUser.email]];
    [self.email setTextAlignment:NSTextAlignmentLeft];
    [self.email setFont:[UIFont fontWithName:@"Helvetica Neue" size:20]];
    [self.view addSubview:self.email];
}

- (void) reloadUser:(UserModel*) user {
    self.currentUser = user;
    [self.profileImage setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.currentUser.imageUrl]]]];
    float height = 300;
    float width = ((300*1.0)/self.profileImage.image.size.height) * self.profileImage.image.size.width;
    
    [self.profileImage setFrame:CGRectMake((self.view.frame.size.width - width)/2.0, 98, width, height)];
    
    [self.fullName setText:[NSString stringWithFormat:@"%@ %@", self.currentUser.firstName, self.currentUser.lastName]];
    [self.phoneNumber setText:[NSString stringWithFormat:@"Phone : \t%@" , self.currentUser.phoneNumber]];
    [self.cellNumber setText:[NSString stringWithFormat:@"Cell : \t\t%@" , self.currentUser.cellNumber]];
    [self.email setText:[NSString stringWithFormat:@"Email : \t%@" , self.currentUser.email]];
}

- (void) hideViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
