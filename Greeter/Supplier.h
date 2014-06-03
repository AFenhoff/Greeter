//
//  Supplier.h
//  YardOps
//
//  Created by Andrew Fenhoff on 6/3/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Supplier : NSManagedObject

@property (nonatomic, retain) NSNumber * rowid;
@property (nonatomic, retain) NSNumber * fingerPrint;
@property (nonatomic, retain) NSNumber * idPhoto;
@property (nonatomic, retain) NSNumber * idRequired;
@property (nonatomic, retain) NSString * supplierNo;
@property (nonatomic, retain) NSString * supplierName;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * idNumber;
@property (nonatomic, retain) NSString * supplierType;
@property (nonatomic, retain) NSString * cfcExpDate;

@end
