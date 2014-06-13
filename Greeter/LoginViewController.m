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

//ben test ahhhhhhhhh

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
    if ([[Common getStringSetting:kBranchSettingName] isEqualToString:@""] || [Common getStringSetting:kBranchSettingName].length != 2) {
        [Common showAlert:@"Invalid Branch Code!\nPlease put a valid branch code in branch setting" forDelegate:self];
    }
	// Do any additional setup after loading the view.
    [employeeIDTextField becomeFirstResponder];
}

-(void)viewDidAppear:(BOOL)animated
{
    //SharedObjects *sharedObjects = [SharedObjects getSharedObjects];
    //[sharedObjects clearData];
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
    exit(0);
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
    SharedObjects* currentObject = [SharedObjects getSharedObjects];
    [currentObject.dataManager getMaterialsForBranch:[Common getStringSetting:kBranchSettingName] forDelegate:nil];
    [currentObject.dataManager getMakesAndModels:self];
    
    switch ([Common getIntSetting:kApplicationModeSettingName]) {
        case 0: //Greeter and Inspector
            [self performSegueWithIdentifier:@"greeterAndInspector" sender:self];
            break;
        case 1: //Greeter
            switch ([Common getIntSetting:kGreeterMode]) {
                case 1:
                    //fe
                    [self performSegueWithIdentifier:@"LoginGreeterAndFESelected" sender:self];
                    break;
                case 2:
                    //nf
                    [self performSegueWithIdentifier:@"LoginGreeterAndNFSelected" sender:self];
                    break;
                default:
                    [self performSegueWithIdentifier:@"greeter" sender:self];
                    break;
            }
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
