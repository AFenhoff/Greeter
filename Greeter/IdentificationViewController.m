//
//  IdentificationViewController.m
//  YardOps
//
//  Created by Andrew Fenhoff on 3/10/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import "IdentificationViewController.h"
#import "Common.h"

@interface IdentificationViewController ()

@end

@implementation IdentificationViewController

@synthesize lastNameTextField, supplierNameTextField;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)lastNameSearch:(id)sender
{
    if([lastNameTextField.text length] == 0)
    {
        [Common showAlert:@"Please enter Last Name" forDelegate:self];
        [lastNameTextField becomeFirstResponder];
        return;
    }
    
    SharedObjects *sharedObjects = [SharedObjects getSharedObjects];
    sharedObjects.dataManager.delegate = self;
    [sharedObjects.dataManager getSuppliersByLastName:lastNameTextField.text forDelegate:self];
    //
}

-(void)dataDidSync:(id)sender
{
    [self performSegueWithIdentifier:@"NameSearch" sender:self];
}

-(IBAction)supplierNameSearch:(id)sender
{
    [self performSegueWithIdentifier:@"SuppleirSearch" sender:self];
}


@end
