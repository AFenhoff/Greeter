//
//  VehicleDataAccess.h
//  YardOps
//
//  Created by Andrew Fenhoff on 6/3/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import "BaseDataAccess.h"
#import "ADFSViewController.h"

@interface VehicleDataAccess : BaseDataAccess <ADFSViewControllerDelegate>

-(void)getSupplierVehiclesBySupplier:(NSString *)supplierNo andIDNumber:(NSString *)idNumber;
-(void)getSupplierVehicleByBarcode:(NSString *)barcode;
-(void)saveSupplierVehicle;

@end
