//
//  Helpers.m
//  RandomContactsViewer
//
//  Created by Varun Goyal on 2015-10-29.
//  Copyright © 2015 Varun Goyal. All rights reserved.
//

#import "Helpers.h"
#import "Reachability.h"

@interface Helpers ()

@end

@implementation Helpers

// Checks if we have an internet connection or not
+ (BOOL) testInternetConnection;
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

@end
