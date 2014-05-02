//
//  GEUser.h
//  NSUserDefaults, Segues and Protocols Challenge Solution
//
//  Created by Gary Edgcombe on 30/04/2014.
//  Copyright (c) 2014 Gary Edgcombe Code. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GEUser : NSObject

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;

- (id)initWithUsername:(NSString *)newUsername
           andPassword:(NSString *)newPassword;
@end
