//
//  LoginViewController.m
//  UPAP Inventory
//
//  Created by Andrew Fenhoff on 9/16/13.
//  Copyright (c) 2013 DJJ. All rights reserved.
//

#import "LoginViewController.h"
#import "GreeterMenuViewController.h"
//#import "UserDataAccess.h"
#import "NSString+ToDate.h"
#import "Common.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize managedObjectContext, employeeIDTextField, loginButton;//, user;

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
/*
     Find User by EmployeeID

    user = [Common getUserByEmployeeID:[NSNumber numberWithInt:[employeeIDTextField.text intValue]] inObjectContext:managedObjectContext];
    if(!user)
    {
*/        /*
        If EmployeeID not found
        prompt for password
            validate
        //user.password = ;
        user = (User *)[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:managedObjectContext];
        user.employeeID = [NSNumber numberWithInt:[employeeIDTextField.text intValue]];
        [Common showAlert:@"Enter Password" forDelegate:self withAlertViewStyle:UIAlertViewStyleSecureTextInput];
    }else{
           */
    /*
        If lastPasswordChangeDate + 90 days < today
        prompt for password
            validate
     
        UserDataAccess *uda = [[UserDataAccess alloc] init];
        uda.delegate = self;
        [uda validateUser:user withManagedObject:managedObjectContext];
     */
    
       /*
        if([[user.lastPasswordChangeDate toDate] dateByAddingTimeInterval:90 * 24 * 60 * 60] < [NSDate date])
            //Not quite right
            //           || [user.lastUpdated toDate] > [NSDate date])
        {
            [Common showAlert:@"Enter Password" forDelegate:self withAlertViewStyle:UIAlertViewStyleSecureTextInput];
        }else{
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.currentUser = user;
            employeeIDTextField.text = @"";
            //perform segue
            [self performSegueWithIdentifier:@"loggedIn" sender:self];

        }
    
        
        //self.title = @"Logout";
        
    }
            */
    
    //[self performSegueWithIdentifier:@"greeter" sender:self];
    //[self performSegueWithIdentifier:@"inspector" sender:self];
    /**************************************************/
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
    ;
    /****************************************************/
    self.title = @"Logout";
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


@end
