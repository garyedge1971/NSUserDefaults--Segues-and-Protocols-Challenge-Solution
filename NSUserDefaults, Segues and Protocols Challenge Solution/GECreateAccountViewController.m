//
//  GECreateAccountViewController.m
//  NSUserDefaults, Segues and Protocols Challenge Solution
//
//  Created by Gary Edgcombe on 30/04/2014.
//  Copyright (c) 2014 Gary Edgcombe Code. All rights reserved.
//

#import "GECreateAccountViewController.h"
#import "GEDefines.h"
#import "GEUser.h"

@interface GECreateAccountViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *repeatPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *redButton;
@property (weak, nonatomic) IBOutlet UIButton *greenButton;

@property (strong, nonatomic) NSMutableArray *arrayOfUsersAsPlists;

@end

@implementation GECreateAccountViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.passwordTextField.secureTextEntry = YES;
    self.repeatPasswordTextField.secureTextEntry = YES;
    self.redButton.layer.cornerRadius = 25.0f;
    self.greenButton.layer.cornerRadius = 25.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Lazy Instantiation
-(NSMutableArray *)arrayOfUsersAsPlists
{
    _arrayOfUsersAsPlists = [[[NSUserDefaults standardUserDefaults] arrayForKey:STORED_DATA]mutableCopy];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    return _arrayOfUsersAsPlists;
}

#pragma mark - helper methods
- (NSDictionary *)convertUserToPList:(GEUser *)newUser
{
    // convert the user to an a NSDictionary object
    NSDictionary *newUserAsPropertyList = @{USER_NAME : newUser.username,
                                            USER_PASSWORD : newUser.password};
    return newUserAsPropertyList;
}

- (void)createNewUser:(NSString *)username andPassword:(NSString *)password
{
    GEUser *newUser = [[GEUser alloc]initWithUsername:username andPassword:password];
    
    NSDictionary *newUserAsPropertyList;
    newUserAsPropertyList = [self convertUserToPList:newUser];
    NSLog(@"newUserAsPropertyList = %@", [newUserAsPropertyList description]);
    
    NSMutableArray *arrayOfUsersAsDictionaryObjects = [[[NSUserDefaults standardUserDefaults] arrayForKey:STORED_DATA]mutableCopy];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (!arrayOfUsersAsDictionaryObjects) {
        arrayOfUsersAsDictionaryObjects = [[NSMutableArray alloc]init];
    }
    
    [arrayOfUsersAsDictionaryObjects addObject:newUserAsPropertyList];
    
    NSLog(@"Count of arrayOfUsersAsPlists objects %lu ", (unsigned long)[arrayOfUsersAsDictionaryObjects count]);
    
    // Save to NSUserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:arrayOfUsersAsDictionaryObjects forKey:STORED_DATA];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}

- (void)resetDisplay
{
    self.usernameTextField.text = @"";
    self.passwordTextField.text = @"";
    self.repeatPasswordTextField.text = @"";
    
    [self.usernameTextField becomeFirstResponder];
}

#pragma mark - actions
- (IBAction)cancelButtonPressed:(id)sender
{
    //just call delegate to dismissViewController
    [self.delegate didCancel];
    
}

- (IBAction)createButtonPressed:(id)sender
{
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *confirmPassword = self.repeatPasswordTextField.text;
    
    
    // *** Validation ***
    
    // Check if username already exists
    for (NSDictionary *userInfo in self.arrayOfUsersAsPlists) {
        NSString *existingUserName = userInfo[USER_NAME];
        NSLog(@"Existing userName from array = %@", existingUserName);
        if ([existingUserName isEqualToString:username]) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Username already exists"
                                  message:@"Try Again"
                                  delegate:self
                                  cancelButtonTitle:@"Okay"
                                  otherButtonTitles: nil];
            [alert show];
            return;
        }
    }
    
    // Check username is not blank and passwords match
    if ([username isEqualToString:@""] && ![password isEqualToString:confirmPassword]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Username Empty"
                              message:@"And Passwords do not match"
                              delegate:self
                              cancelButtonTitle:@"Dismiss"
                              otherButtonTitles: nil];
        [alert show];
        return;
    }
    else if ([username isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Username Empty"
                              message:@"Cannot be left blank"
                              delegate:self
                              cancelButtonTitle:@"Dismiss"
                              otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    else if (![password isEqualToString:confirmPassword]) {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Passwords do not match"
                              message:@"Enter again"
                              delegate:self
                              cancelButtonTitle:@"Dismiss"
                              otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    
    [self createNewUser:username andPassword:password];
 
    [self.delegate didCreateAccount];
}

#pragma mark - UIAlertView Delegate Methods
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"alertView button index pressed : %li", buttonIndex);
    [self resetDisplay];
    
}

@end
