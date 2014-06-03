//
//  ModelGenerator.m
//  YardOps
//
//  Created by Andrew Fenhoff on 4/9/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import "ModelGenerator.h"
#import "Make.h"
#import "Model.h"

@implementation ModelGenerator
@synthesize managedObjectContext;

-(void)createMakes
{
    [BaseDataAccess clearAllObjectsForEntity:@"Make"];
    
    for (int i = 0; i < 5; i++)
    {
        Make *vs = (Make *)[NSEntityDescription insertNewObjectForEntityForName:@"Make" inManagedObjectContext:managedObjectContext];
        
        vs.make = [NSString stringWithFormat:@"Make %d", i];
        vs.makeCode = [NSString stringWithFormat:@"makeCode%d", i];
        
        NSError *error = nil;
        if (![managedObjectContext save:&error]) {
            // Handle the error.
        }
        
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}

-(void)createModels
{
    [BaseDataAccess clearAllObjectsForEntity:@"Model"];
    
    for (int i = 0; i < 5; i++)
    {
        Model *vs = (Model *)[NSEntityDescription insertNewObjectForEntityForName:@"Model" inManagedObjectContext:managedObjectContext];
        
        vs.model = [NSString stringWithFormat:@"Model %d", i];
        vs.modelCode = [NSString stringWithFormat:@"modelCode%d", i];
        
        NSError *error = nil;
        if (![managedObjectContext save:&error]) {
            // Handle the error.
        }
        
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}

@end
