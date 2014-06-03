//
//  BarcodeViewController.h
//  YardOps
//
//  Created by Andrew Fenhoff on 3/19/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol BarcodeViewControllerDelegate
@required
-(void)barcodeCaptured:(NSString *)barcode CallingViewController:(UIViewController *)callingViewController;
@end

@interface BarcodeViewController : UIViewController

@property (nonatomic, assign) id<BarcodeViewControllerDelegate> delegate;
@property (nonatomic, assign) IBOutlet UIButton *closeButton;
@property (nonatomic, retain) IBOutlet UIImageView *tempDrawImage;


-  (IBAction)closeButtonClick:(id)sender;

@end
