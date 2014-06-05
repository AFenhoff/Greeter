//
//  SupplierDataAccess.h
//  YardOps
//
//  Created by Andrew Fenhoff on 6/2/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import "BaseDataAccess.h"
#import "ADFSViewController.h"

@interface SupplierDataAccess : BaseDataAccess <ADFSViewControllerDelegate>

-(void)getSuppliersByLastName:(NSString *)name;
-(void)getSuppliersBySupplierName:(NSString *)supplierName;
-(void)getSupplierByIDNumber:(NSString *)idNumber andState:(NSString *)state;

@end
