//
//  Vehicle.h
//  YardOps
//
//  Created by Andrew Fenhoff on 6/3/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Vehicle : NSManagedObject

@property (nonatomic, retain) NSNumber * rowid;
@property (nonatomic, retain) NSString * supplierNo;
@property (nonatomic, retain) NSString * idNumber;
@property (nonatomic, retain) NSString * make;
@property (nonatomic, retain) NSString * model;
@property (nonatomic, retain) NSNumber * year;
@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSString * licensePlate;
@property (nonatomic, retain) NSString * trailerNumber;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * createdBy;

@end
