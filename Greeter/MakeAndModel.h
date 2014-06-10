//
//  MakeAndModel.h
//  YardOps
//
//  Created by loaner on 6/10/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MakeAndModel : NSManagedObject

@property (nonatomic, retain) NSString * make;
@property (nonatomic, retain) NSString * model;

@end
