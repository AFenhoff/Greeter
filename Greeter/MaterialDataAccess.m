//
//  MaterialDataAccess.m
//  YardOps
//
//  Created by loaner on 6/9/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import "MaterialDataAccess.h"

@implementation MaterialDataAccess

-(void)getMaterialsForBranch:(NSString *)branchCode forDelegate:(id)delegate
{
    self.lastRequestURL = [NSString stringWithFormat:@"%@", @"materials/getallmaterials"];
    [super executeAPIMethod:self.lastRequestURL forDelegate:self];
}

-(void)authenticationComplete:(id)sender
{
    [super executeAPIMethod:self.lastRequestURL forDelegate:self];
}

-(void)didReceiveData:(NSMutableArray *)data
{
    [BaseDataAccess clearAllObjectsForEntity:@"Material"];
    SharedObjects *sharedObjects = [SharedObjects getSharedObjects];
    
    //for (id string in data)
    for(int i = 0; i < data.count; i++)
    {
        NSDictionary *string = data[i];
        
        Material *mat = (Material *)[NSEntityDescription insertNewObjectForEntityForName:@"Material" inManagedObjectContext:sharedObjects.managedObjectContext];
        
        mat.materialCode   = [string objectForKey:@"MaterialCode"];
        mat.materialDescription     = [string objectForKey:@"MaterialDesc"];
        mat.yardCode   = [string objectForKey:@"YardCode"];
        mat.inventoryCode = [string objectForKey:@"InventoryCode"];
        mat.branch = [string objectForKey:@"Branch"];
        
        NSError *error = nil;
        if (![sharedObjects.managedObjectContext save:&error]) {
            // Handle the error.
        }
        
        if(data.count == 0) { sharedObjects.selectedSupplier = mat; }
        
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [self.delegate didReceiveData:data];
}
@end
