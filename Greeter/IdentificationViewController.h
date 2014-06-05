//
//  IdentificationViewController.h
//  YardOps
//
//  Created by Andrew Fenhoff on 3/10/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import "BaseViewController.h"
#import "SupplierDataAccess.h"
#import "DTDevices.h"

@interface IdentificationViewController : BaseViewController <DataManagerDelegate, DTDeviceDelegate>

{
    NSMutableString *status;
	NSMutableString *debug;

}

@property (nonatomic, retain) IBOutlet UILabel *lineaLabel;
@property (nonatomic, retain) IBOutlet UITextField *lastNameTextField;
@property (nonatomic, retain) IBOutlet UITextField *supplierNameTextField;

@property (nonatomic, retain) IBOutlet UIButton *lastNameSearchButton;
@property (nonatomic, retain) IBOutlet UIButton *supplierNameSearchButton;

@property (nonatomic, retain) DTDevices *dtDevices;


-(IBAction)lastNameSearch:(id)sender;
-(IBAction)supplierNameSearch:(id)sender;


@end
