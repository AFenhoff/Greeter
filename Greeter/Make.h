//
//  Make.h
//  YardOps
//
//  Created by Andrew Fenhoff on 4/9/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Make : NSManagedObject

@property (nonatomic, retain) NSString * make;
@property (nonatomic, retain) NSString * makeCode;

@end
