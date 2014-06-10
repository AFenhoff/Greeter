//
//  MakeAndModelDataAccess.m
//  YardOps
//
//  Created by loaner on 6/10/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import "MakeAndModelDataAccess.h"

@implementation MakeAndModelDataAccess

-(void)getMakesAndModels:(id)delegate
{
    self.lastRequestURL = [NSString stringWithFormat:@"%@", @"vehicle/getallmakesandmodels"];
    [super executeAPIMethod:self.lastRequestURL forDelegate:self];
}

-(void)authenticationComplete:(id)sender
{
    [super executeAPIMethod:self.lastRequestURL forDelegate:self];
}

-(void)didReceiveData:(NSMutableArray *)data
{
    [BaseDataAccess clearAllObjectsForEntity:@"MakeAndModel"];
    SharedObjects *sharedObjects = [SharedObjects getSharedObjects];
    
    //for (id string in data)
    for(int i = 0; i < data.count; i++)
    {
        NSDictionary *string = data[i];
        
        MakeAndModel *mm = (MakeAndModel *)[NSEntityDescription insertNewObjectForEntityForName:@"MakeAndModel" inManagedObjectContext:sharedObjects.managedObjectContext];
        
        mm.make     = [string objectForKey:@"Make"];
        mm.model    = [string objectForKey:@"Model"];
        
        NSError *error = nil;
        if (![sharedObjects.managedObjectContext save:&error]) {
            // Handle the error.
        }
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [self.delegate didReceiveData:data];
}

@end
