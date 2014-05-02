//
//  GEViewController.m
//  NSUserDefaults, Segues and Protocols Challenge Solution
//
//  Created by Gary Edgcombe on 30/04/2014.
//  Copyright (c) 2014 Gary Edgcombe Code. All rights reserved.
//

#import "GEViewController.h"
#import "GEDefines.h"

@interface GEViewController ()
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;

@end

@implementation GEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.usernameLabel.text = self.passedInUsername;
    self.passwordLabel.text = self.passedInPassword;
}
    
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
