//
//  AdjustmentsViewController.m
//  YardOps
//
//  Created by Andrew Fenhoff on 5/15/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import "AdjustmentsViewController.h"
#import "Common.h"

@interface AdjustmentsViewController ()

@end

@implementation AdjustmentsViewController

@synthesize adjustmentLbs,
            adjustmentPercent,
            originalWeight,
            lblOriginalWeight,
            lblAdjWeight,
            lblAdjPercent,
            txtInput,
            weightOrPercent;


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
    [txtInput becomeFirstResponder];
    txtInput.text = @"0";
    lblOriginalWeight.text = [NSString stringWithFormat:@"%d", originalWeight];
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
-(IBAction)btnCompletePressed:(id)sender
{
    [self.delegate modalComplete:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(IBAction)adjustmentTextChanged:(id)sender
{
    switch (weightOrPercent.selectedSegmentIndex) {
        case 0: //LBS
            if ([txtInput.text integerValue] > originalWeight) {[Common showAlert:@"Cannot deduct more than original weight." forDelegate:self];}
            
            adjustmentLbs = [txtInput.text integerValue];
            adjustmentPercent = (1 - ((double)(originalWeight - adjustmentLbs)/originalWeight)) * 100;

            break;
        case 1: //PCT
            if ([txtInput.text integerValue] > 100) {[Common showAlert:@"Cannot deduct more than 100%." forDelegate:self];}
            adjustmentPercent = [txtInput.text integerValue];
             adjustmentLbs = originalWeight - ( originalWeight * (1 - (adjustmentPercent / 100.0)));
             break;
        default:
            break;
    }
    lblAdjWeight.text = [NSString stringWithFormat:@"%d", originalWeight - adjustmentLbs];
    lblAdjPercent.text = [NSString stringWithFormat:@"%.0f%% of original", ((double)(originalWeight - adjustmentLbs) / originalWeight) * 100];
}


@end
