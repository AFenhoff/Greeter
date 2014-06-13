//
//  GreeterQueue.h
//  YardOps
//
//  Created by Andrew Fenhoff on 6/12/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface GreeterQueue : NSManagedObject

@property (nonatomic, retain) NSString * address1;
@property (nonatomic, retain) NSString * address2;
@property (nonatomic, retain) NSNumber * bodyCount;
@property (nonatomic, retain) NSString * branch;
@property (nonatomic, retain) NSNumber * cfcTaken;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * dateOfBirth;
@property (nonatomic, retain) NSString * eyeColor;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * hairColor;
@property (nonatomic, retain) NSString * height;
@property (nonatomic, retain) NSString * idExpireDate;
@property (nonatomic, retain) NSString * idIssueDate;
@property (nonatomic, retain) NSString * idIssuer;
@property (nonatomic, retain) NSString * idNumber;
@property (nonatomic, retain) NSString * idType;
@property (nonatomic, retain) NSString * inYardID;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * materialCode;
@property (nonatomic, retain) NSString * middleName;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * postCode;
@property (nonatomic, retain) NSNumber * queueType;
@property (nonatomic, retain) NSString * race;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSNumber * supplierIDRowID;
@property (nonatomic, retain) NSString * supplierNo;
@property (nonatomic, retain) NSNumber * titlesTaken;
@property (nonatomic, retain) NSString * trailerTagNo;
@property (nonatomic, retain) NSString * trailerTagState;
@property (nonatomic, retain) NSString * user;
@property (nonatomic, retain) NSString * vehicleColor;
@property (nonatomic, retain) NSString * vehicleDesc;
@property (nonatomic, retain) NSString * vehicleTagNo;
@property (nonatomic, retain) NSString * vehicleTagState;
@property (nonatomic, retain) NSString * weight;
@property (nonatomic, retain) NSString * color;

@end
