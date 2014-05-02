//
//  GEUser.m
//  NSUserDefaults, Segues and Protocols Challenge Solution
//
//  Created by Gary Edgcombe on 30/04/2014.
//  Copyright (c) 2014 Gary Edgcombe Code. All rights reserved.
//

#import "GEUser.h"

@implementation GEUser

- (id)init{
    self = [self initWithUsername:nil andPassword:nil];
    return  self;
}

-(id)initWithUsername:(NSString *)newUsername andPassword:(NSString *)newPassword
{
    self = [super init];
    _username = newUsername;
    _password = newPassword;
    
    return self;
}

@end
