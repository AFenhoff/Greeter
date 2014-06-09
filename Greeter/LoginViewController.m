//
//  LoginViewController.m
//  UPAP Inventory
//
//  Created by Andrew Fenhoff on 9/16/13.
//  Copyright (c) 2013 DJJ. All rights reserved.
//

#import "LoginViewController.h"
#import "GreeterMenuViewController.h"
#import "UserDataAccess.h"
#import "NSString+ToDate.h"
#import "Common.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize managedObjectContext, employeeIDTextField, loginButton;//, user;

//ben test

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
    [employeeIDTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//Turn this into a button press event
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //((GreeterMenuViewController *)segue.destinationViewController).managedObjectContext = managedObjectContext;

}

-(IBAction)loginButtonPress:(id)sender;
{
    self.title = @"Logout";
    
    SharedObjects *sharedObjects = [SharedObjects getSharedObjects];
    sharedObjects.dataManager.delegate = self;
    [sharedObjects.dataManager getUserByEmployeeID:[NSNumber numberWithInt:[employeeIDTextField.text intValue]] forDelegate:self];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
  /*
    UITextField *passwordTextField = [alertView textFieldAtIndex:0];
    user.password = passwordTextField.text;
    UserDataAccess *uda = [[UserDataAccess alloc] init];
    uda.delegate = self;
    [uda loginUser:user withManagedObject:managedObjectContext];
    */
    
}

/*
-(void)userValidated:(User *)user
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.currentUser = user;
    employeeIDTextField.text = @"";
    //perform segue
    [self performSegueWithIdentifier:@"loggedIn" sender:self];
}

-(void)userLoggedIn:(User *)user
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.currentUser = user;
    employeeIDTextField.text = @"";
}

-(void)userNotValid
{
    
}
*/

-(void)dataDidSync:(id)sender
{
    switch ([Common getIntSetting:kApplicationModeSettingName]) {
        case 0: //Greeter and Inspector
            [self performSegueWithIdentifier:@"greeterAndInspector" sender:self];
            break;
        case 1: //Greeter
            [self performSegueWithIdentifier:@"greeter" sender:self];
            break;
        case 2: //Inspector
            [self performSegueWithIdentifier:@"inspector" sender:self];
            break;
        default:
            [self performSegueWithIdentifier:@"greeterAndInspector" sender:self];
            break;
    }

}

@end
