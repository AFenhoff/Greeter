//
//  VehicleMenuViewController.h
//  YardOps
//
//  Created by Andrew Fenhoff on 3/12/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import "BaseModalViewController.h"
#import "BarcodeViewController.h"

@interface VehicleMenuViewController : BaseModalViewController <BarcodeViewControllerDelegate,BaseModalViewControllerDelegate>

- (IBAction)newVehicle:(id)sender;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
