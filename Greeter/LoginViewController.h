//
//  LoginViewController.h
//  UPAP Inventory
//
//  Created by Andrew Fenhoff on 9/16/13.
//  Copyright (c) 2013 DJJ. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewController : BaseViewController <UIAlertViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet UITextField *employeeIDTextField;
@property (nonatomic, retain) IBOutlet UIButton *loginButton;
//@property (nonatomic, retain) User *user;

-(IBAction)loginButtonPress:(id)sender;

@end
