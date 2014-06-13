//
//  AddVehicleViewController.m
//  YardOps
//
//  Created by Andrew Fenhoff on 6/11/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import "AddVehicleViewController.h"
#import "ColorTableViewController.h"
#import "SearchViewController.h"
#import "DTDevices.h"
#import "SelectModelViewController.h"
#import "SelectMakeViewController.h"
#import "IdentityDetailViewController.h"

@interface AddVehicleViewController ()

@end

@implementation AddVehicleViewController

@synthesize makeButton, modelButton, colorButton, yearTextField, plateTextField, plateStateTextField,
trailerTextField, trailerStateTextField, barcodeTextField, processLineaCommands;

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
    makeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    modelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    colorButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    SharedObjects* object = [SharedObjects getSharedObjects];
    object.selectedVehicle = (Vehicle *)[NSEntityDescription insertNewObjectForEntityForName:@"Vehicle" inManagedObjectContext:object.managedObjectContext];
    object.selectedVehicle.make = @"";
    object.selectedVehicle.model = @"";
    object.selectedVehicle.color = @"";
    object.selectedVehicle.idNumber = object.selectedSupplier.idNumber;
    object.selectedVehicle.supplierNo = object.selectedSupplier.supplierNo;
    processLineaCommands = YES;
}

- (void) viewDidAppear:(BOOL)animated
{
    ((DTDevices *)[DTDevices sharedDevice]).delegate = self;
}

-(IBAction)backButtonPressed:(id)sender
{
    SharedObjects* object = [SharedObjects getSharedObjects];
    object.selectedVehicle = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    if([self isMovingFromParentViewController])
    {
        
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[SelectModelViewController class]])
    {
        SharedObjects *sharedObjects = [SharedObjects getSharedObjects];
        SelectModelViewController *modelSelector = segue.destinationViewController;
        modelSelector.make = sharedObjects.selectedVehicle.make;
        ((SelectModelViewController *)segue.destinationViewController).delegate = self;
        
    }
    
    if([segue.destinationViewController isKindOfClass:[SelectMakeViewController class]])
    {
        ((SelectMakeViewController *)segue.destinationViewController).delegate = self;
    }
    
    if([segue.destinationViewController isKindOfClass:[ColorTableViewController class]])
    {
        ((ColorTableViewController *)segue.destinationViewController).delegate = self;
    }
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if([identifier isEqualToString:@"modelSegue"])
    {
        SharedObjects *sharedObjects = [SharedObjects getSharedObjects];
        if(sharedObjects.selectedVehicle.make.length == 0)
        {
            [Common showAlert:@"No Make selected.\nCannot display models." forDelegate:self];
            return NO;
        }
    }
    return YES;
}


-(void)barcodeData:(NSString *)barcode type:(int)type
{
    if(!processLineaCommands) { return; }
    barcodeTextField.text = barcode;
}


-(void)modalComplete:(id)sender
{
    if([sender isKindOfClass:[SelectMakeViewController class]])
    {
        SharedObjects* object = [SharedObjects getSharedObjects];
        makeButton.titleLabel.text = object.selectedVehicle.make;
        [self performSelector:@selector(modelPressed:) withObject:self afterDelay:0.75 ];
    }
    if([sender isKindOfClass:[SelectModelViewController class]])
    {
        SharedObjects* object = [SharedObjects getSharedObjects];
        modelButton.titleLabel.text = object.selectedVehicle.model;
        [self performSelector:@selector(colorPressed:) withObject:self afterDelay:0.75 ];
    }

    if([sender isKindOfClass:[ColorTableViewController class]])
    {
        SharedObjects* object = [SharedObjects getSharedObjects];
        colorButton.titleLabel.text = object.selectedVehicle.color;

        NSArray *params = [NSArray arrayWithObjects:plateTextField, @"YES", nil];

        [self performSelector:@selector(animateTextField:)
                   withObject:params
                   afterDelay:0.75];
        
        [plateTextField becomeFirstResponder];
        [self animateTextField:plateTextField up:YES];
    }
}

-(IBAction)savePressed:(id)sender
{
    if ([self isValid]) {
        SharedObjects* object = [SharedObjects getSharedObjects];
        object.selectedVehicle.year = [NSNumber numberWithInt:[self.yearTextField.text intValue]];
        object.selectedVehicle.licensePlate = [self.plateTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        object.selectedVehicle.trailerNumber = [self.trailerTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        object.selectedVehicle.state = [self.plateStateTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        object.selectedVehicle.barcode = [self.barcodeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        object.dataManager.delegate = self;
        [object.dataManager saveSupplierVehicle];
    }
}

-(BOOL)isValid
{
    BOOL result = YES;
    NSString* errorMessage = @"";
    SharedObjects* object = [SharedObjects getSharedObjects];
    
    self.plateTextField.text = [self.plateTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([self.plateTextField.text isEqualToString:@""]) {
        result = NO;
        errorMessage = [errorMessage stringByAppendingString:@"License Plate is Required!\n"];
    }
    
    /*
    if ([object.selectedVehicle.make isEqualToString:@""]) {
        result = NO;
        errorMessage = [errorMessage stringByAppendingString:@"Make is Required!\n"];
    }
    
    if ([object.selectedVehicle.model isEqualToString:@""]) {
        result = NO;
        errorMessage = [errorMessage stringByAppendingString:@"Model is Required!\n"];
    }
    */
    if ([object.selectedVehicle.color isEqualToString:@""]) {
        result = NO;
        errorMessage = [errorMessage stringByAppendingString:@"Color is Required!\n"];
    }
    
    if (!result) {
        [Common showAlert:errorMessage forDelegate:self];
    }
    
    return result;
}

-(void)recordCreatedSuccessfully:(id)sender
{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[IdentityDetailViewController class]]) {
            [self.navigationController popToViewController:controller
                                                  animated:YES];
            break;
        }
    }
}

bool isMake;

-(void)makePressed:(id)sender
{
    isMake = true;
    [self performSegueWithIdentifier:@"makeSegue" sender:self];
}

-(void)modelPressed:(id)sender
{
    isMake = false;
    [self performSegueWithIdentifier:@"modelSegue" sender:self];
}

-(void)colorPressed:(id)sender
{
    isMake = false;
    [self performSegueWithIdentifier:@"colorSegue" sender:self];
}



#pragma mark - UITextView
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 80; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    if (textField == self.plateTextField || textField == self.plateStateTextField) {
        movement = up ? movement - 50 : movement + 50;
    }
    
    if (textField == self.trailerTextField || textField == yearTextField) {
        movement = up ? movement - 75 : movement + 75;
    }
    
    if (textField == self.barcodeTextField) {
        movement = up ? movement - 100 : movement + 100;
    }
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (void) animateTextField:(NSArray *)parameters
{
    [self animateTextField:parameters[0] up:(BOOL)parameters[1]];
}

@end
