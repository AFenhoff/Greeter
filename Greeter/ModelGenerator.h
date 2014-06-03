//
//  ModelGenerator.h
//  YardOps
//
//  Created by Andrew Fenhoff on 4/9/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDataAccess.h"

@interface ModelGenerator : BaseDataAccess

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(void)createMakes;
-(void)createModels;

@end
