//
//  UserModel.m
//  RandomContactsViewer
//
//  Created by Varun Goyal on 2015-10-29.
//  Copyright © 2015 Varun Goyal. All rights reserved.
//

#import "UserModel.h"

@interface UserModel ()

@end

@implementation UserModel

@synthesize  firstName = _firstName, lastName = _lastName, userName = _userName, phoneNumber = _phoneNumber, cellNumber = _cellNumber, city = _city, imageUrl = _imageUrl, thumbnailUrl = _thumbnailUrl;

- (instancetype)initWithDictionary:(NSDictionary*) dictionary
{
    self = [super init];
    if (self) {
        self.firstName = [[[dictionary objectForKey:@"name"] objectForKey:@"first"] capitalizedString];
        self.lastName = [[[dictionary objectForKey:@"name"] objectForKey:@"last"] capitalizedString];
        self.userName = [dictionary objectForKey:@"username"];
        self.email = [dictionary objectForKey:@"email"];
        self.phoneNumber = [dictionary objectForKey:@"phone"];
        self.cellNumber = [dictionary objectForKey:@"cell"];
        self.city = [[dictionary objectForKey:@"location"] objectForKey:@"city"];
        self.imageUrl = [[dictionary objectForKey:@"picture"] objectForKey:@"medium"];
        self.thumbnailUrl = [[dictionary objectForKey:@"picture"] objectForKey:@"thumbnail"];
    }
    return self;
}

@end
