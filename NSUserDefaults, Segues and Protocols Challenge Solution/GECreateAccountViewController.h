//
//  GECreateAccountViewController.h
//  NSUserDefaults, Segues and Protocols Challenge Solution
//
//  Created by Gary Edgcombe on 30/04/2014.
//  Copyright (c) 2014 Gary Edgcombe Code. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GECreateAccountViewControllerDelegate <NSObject>

@required
- (void)didCancel;
- (void)didCreateAccount;

@end

@interface GECreateAccountViewController : UIViewController

@property (weak, nonatomic) id<GECreateAccountViewControllerDelegate> delegate;

@end
