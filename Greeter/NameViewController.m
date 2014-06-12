//
//  NameViewController.m
//  YardOps
//
//  Created by Andrew Fenhoff on 6/12/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import "NameViewController.h"

@interface NameViewController ()

@end

@implementation NameViewController

@synthesize firstNameTextField, lastNameTextField, saveButton;

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
    saveButton.enabled = YES;
    [firstNameTextField becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveButtonPressed:(id)sender
{
    SharedObjects *sharedObjects = [SharedObjects getSharedObjects];
    sharedObjects.selectedSupplier.firstName = [firstNameTextField.text uppercaseString];
    sharedObjects.selectedSupplier.lastName = [lastNameTextField.text uppercaseString];
    
    [self.delegate modalComplete:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)cancelButtonPressed:(id)sender
{
    [self.delegate modalCanceled:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
