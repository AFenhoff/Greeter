//
//  AdjustmentsViewController.h
//  YardOps
//
//  Created by Andrew Fenhoff on 5/15/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import "BaseModalViewController.h"

@interface AdjustmentsViewController : BaseModalViewController <UITextFieldDelegate>

@property (nonatomic) NSInteger adjustmentLbs;
@property (nonatomic) NSInteger adjustmentPercent;
@property (nonatomic) NSInteger originalWeight;

@property (nonatomic, retain) IBOutlet UILabel *lblOriginalWeight;
@property (nonatomic, retain) IBOutlet UILabel *lblAdjWeight;
@property (nonatomic, retain) IBOutlet UILabel *lblAdjPercent;
@property (nonatomic, retain) IBOutlet UITextField *txtInput;
@property (nonatomic, retain) IBOutlet UIButton *btnComplete;

@property (nonatomic, retain) IBOutlet UISegmentedControl *weightOrPercent;

-(IBAction)btnCompletePressed:(id)sender;

-(IBAction)adjustmentTextChanged:(id)sender;

@end
