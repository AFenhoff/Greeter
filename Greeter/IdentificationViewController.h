//
//  IdentificationViewController.h
//  YardOps
//
//  Created by Andrew Fenhoff on 3/10/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import "BaseViewController.h"
#import "SupplierDataAccess.h"

@interface IdentificationViewController : BaseViewController <DataManagerDelegate>

@property (nonatomic, retain) IBOutlet UITextField *lastNameTextField;
@property (nonatomic, retain) IBOutlet UITextField *supplierNameTextField;

@property (nonatomic, retain) IBOutlet UIButton *lastNameSearchButton;
@property (nonatomic, retain) IBOutlet UIButton *supplierNameSearchButton;

-(IBAction)lastNameSearch:(id)sender;
-(IBAction)supplierNameSearch:(id)sender;


@end
