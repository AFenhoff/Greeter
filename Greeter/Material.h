//
//  Material.h
//  YardOps
//
//  Created by loaner on 6/9/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Material : NSManagedObject

@property (nonatomic, retain) NSString * materialDescription;
@property (nonatomic, retain) NSString * materialCode;
@property (nonatomic, retain) NSString * yardCode;
@property (nonatomic, retain) NSString * branch;
@property (nonatomic, retain) NSString * inventoryCode;

@end
