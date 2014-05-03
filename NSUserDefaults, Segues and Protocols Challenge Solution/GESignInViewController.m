//
//  GESignInViewController.m
//  NSUserDefaults, Segues and Protocols Challenge Solution
//
//  Created by Gary Edgcombe on 30/04/2014.
//  Copyright (c) 2014 Gary Edgcombe Code. All rights reserved.
//

#import "GESignInViewController.h"
#import "GECreateAccountViewController.h"
#import "GEViewController.h"
#import "GEUser.h"
#import "GEDefines.h"

@interface GESignInViewController ()<GECreateAccountViewControllerDelegate>

// UIControls
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *regUserCount;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;


@property (strong, nonatomic) NSMutableArray *arrayOfUserObjects;
@end

@implementation GESignInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSMutableArray *)arrayOfUserObjects{
    if (!_arrayOfUserObjects) {
        _arrayOfUserObjects = [[NSMutableArray alloc]init];
    }
    return _arrayOfUserObjects;
}


-(void)didCreateAccount
{
    NSLog(@"create account callback");
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didCancel
{
    NSLog(@"cancel callback");
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self retrieveAllData];
    self.passwordTextField.secureTextEntry = YES;
    self.loginButton.layer.cornerRadius = 25.0f;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear:");
    [self retrieveAllData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Methods

- (GEUser *)convertToUserFromPlist:(NSDictionary *)userDict
{
    // Do some work here
    GEUser *retrievedUser = [[GEUser alloc]initWithUsername: userDict[USER_NAME] andPassword:userDict[USER_PASSWORD]];
    
    return retrievedUser;
}

- (void)resetDisplay
{
    self.usernameTextField.text = @"";
    self.passwordTextField.text = @"";
    [self.usernameTextField becomeFirstResponder];
    
}

- (void)retrieveAllData
{
    [self.arrayOfUserObjects removeAllObjects];
    // get stored user details back from NSUserDefaults
    
    NSMutableArray *storedUsersAsPlists = [[[NSUserDefaults standardUserDefaults] objectForKey:STORED_DATA]mutableCopy];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // convert back to GEUser objects
    for (NSDictionary *userPlist in storedUsersAsPlists) {
        GEUser *newUser = [self convertToUserFromPlist:userPlist];
        //add to array
        
        [self.arrayOfUserObjects addObject:newUser];
    }
    
    //display number of user
    self.regUserCount.text = [NSString stringWithFormat:@"%li", [self.arrayOfUserObjects count]];

}

#pragma  mark - Action Methods

- (IBAction)createAccountButtonPressed:(id)sender
{
    NSLog(@"createAccountButtonPressed:");
    [self performSegueWithIdentifier:@"createAccountSegue" sender:self];
}

- (IBAction)loginButtonPressed:(id)sender
{
    NSLog(@"number of stored users in array = %li", self.arrayOfUserObjects.count);
    
    NSString *userName = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *storedUserName;
    NSString *storedPassword;

    //iterate through array of users for match
    for (GEUser *user in self.arrayOfUserObjects) {
        if ([user.username isEqualToString:userName]) {
            storedUserName = user.username;
            storedPassword = user.password;
        }
    }

    // Perform conditionals
    if (![userName isEqualToString:storedUserName] && ![password isEqualToString:storedPassword]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Login Details Incorrect"
                              message:@"Try Again"
                              delegate:self
                              cancelButtonTitle:@"Okay"
                              otherButtonTitles: nil];
        [alert show];

    }
    
    else [self performSegueWithIdentifier:@"toViewController" sender:self];
}


#pragma  mark - UIAlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"alertView button index pressed : %li", buttonIndex);
    [self resetDisplay];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    if ([segue.destinationViewController isKindOfClass:[GECreateAccountViewController class]]) {
        GECreateAccountViewController *createAccountVC = [segue destinationViewController];
        
        // Pass the selected object to the new view controller.
        createAccountVC.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"toViewController"]){
        GEViewController *mainVC = [segue destinationViewController];
        
        // Pass the selected object to the new view controller.
        mainVC.passedInUsername = self.usernameTextField.text;
        mainVC.passedInPassword = self.passwordTextField.text;
    }
}


@end
