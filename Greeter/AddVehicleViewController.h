//
//  AddVehicleViewController.h
//  YardOps
//
//  Created by Andrew Fenhoff on 6/11/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseModalViewController.h"

@interface AddVehicleViewController : BaseViewController  <BaseModalViewControllerDelegate>

@property (nonatomic, retain) IBOutlet UIButton *makeButton;
@property (nonatomic, retain) IBOutlet UIButton *modelButton;
@property (nonatomic, retain) IBOutlet UIButton *colorButton;
@property (nonatomic, retain) IBOutlet UITextField *yearTextField;
@property (nonatomic, retain) IBOutlet UITextField *plateTextField;
@property (nonatomic, retain) IBOutlet UITextField *plateStateTextField;
@property (nonatomic, retain) IBOutlet UITextField *trailerTextField;
@property (nonatomic, retain) IBOutlet UITextField *trailerStateTextField;
@property (nonatomic, retain) IBOutlet UITextField *barcodeTextField;
@property (nonatomic) BOOL processLineaCommands;

@end
