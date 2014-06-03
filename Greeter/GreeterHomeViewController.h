//
//  GreeterHomeViewController.h
//  YardOps
//
//  Created by Andrew Fenhoff on 10/9/13.
//  Copyright (c) 2013 DJJ. All rights reserved.
//

#import "BaseViewController.h"

@interface GreeterHomeViewController : BaseViewController


@property (nonatomic, retain) IBOutlet UITextField *inYardIDTextField;
@property (nonatomic, retain) IBOutlet UITextField *bodyCountTextField;
@property (nonatomic, retain) IBOutlet UIButton *nfButton;
@property (nonatomic, retain) IBOutlet UIButton *feButton;


-(IBAction)nfButtonPressed:(id)sender;
-(IBAction)feButtonPressed:(id)sender;

@end
