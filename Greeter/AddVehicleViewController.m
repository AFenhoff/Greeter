//
//  AddVehicleViewController.m
//  YardOps
//
//  Created by Andrew Fenhoff on 6/11/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import "AddVehicleViewController.h"
#import "ColorTableViewController.h"
#import "DTDevices.h"

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
    SharedObjects* object = [SharedObjects getSharedObjects];
    object.selectedVehicle = [[Vehicle alloc] init];
}

- (void) viewDidAppear:(BOOL)animated
{
    ((DTDevices *)[DTDevices sharedDevice]).delegate = self;
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
}
*/

-(void)barcodeData:(NSString *)barcode type:(int)type
{
    if(!processLineaCommands) { return; }
    barcodeTextField.text = barcode;
}


-(void)modalComplete:(id)sender
{
}

-(IBAction)savePressed:(id)sender
{
    if ([self isValid]) {
        SharedObjects* object = [SharedObjects getSharedObjects];
        object.selectedVehicle.year = [NSNumber numberWithInt:[self.yearTextField.text intValue]];
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
    
    if (object.selectedVehicle.make && [object.selectedVehicle.make isEqualToString:@""]) {
        result = NO;
        errorMessage = [errorMessage stringByAppendingString:@"Make is Required!\n"];
    }
    
    if (object.selectedVehicle.model && [object.selectedVehicle.model isEqualToString:@""]) {
        result = NO;
        errorMessage = [errorMessage stringByAppendingString:@"Model is Required!\n"];
    }
    
    if (object.selectedVehicle.color && [object.selectedVehicle.color isEqualToString:@""]) {
        result = NO;
        errorMessage = [errorMessage stringByAppendingString:@"Color is Required!\n"];
    }
    
    return result;
}

@end
