//
//  DataSync.m
//  UPAP Inventory
//
//  Created by Andrew Fenhoff on 8/6/13.
//  Copyright (c) 2013 DJJ. All rights reserved.
//

#import "DataManager.h"
#import "BaseDataAccess.h"
#import "SupplierDataAccess.h"

@implementation DataManager

@synthesize managedObjectContext;

-(DataManager *)initWithObjectContext:(NSManagedObjectContext *)objectContext
{
    managedObjectContext = objectContext;
    return self;
}

-(void)syncBaseData
{
    //Sync InventorySummary
    //InventorySummaries *ivs = [[InventorySummaries alloc] init];
    //[ivs getInventorySummaryWithContext:managedObjectContext];
 }

-(void) syncData;
{
   
    //Sync Inventory Activity
    /*
    NSArray *inventoryVehicles = [self getEntities:@"InventoryVehicle"];
    for (int i = 0; i < inventoryVehicles.count; i++)
    {
        //Must re-instantiate to ensure a new thread is spawned
        InventoryVehicles *iv = [[InventoryVehicles alloc] init];
        iv.delegate = self;
        //not sure the managed object is needed in uploadVehicle
        [iv uploadInventoryVehicle:inventoryVehicles[i] withManagedObject:managedObjectContext];
    }
    */
    
}

-(NSArray *)getEntities:(NSString *)entityName
{
    NSArray *entities;
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                              inManagedObjectContext:managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setIncludesPropertyValues:NO];
    [fetchRequest setIncludesSubentities:NO];
    NSError *error = nil;
    entities = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if(error != nil){
        entities = nil;
    }
    return entities;
}

-(NSArray *)getEntities:(NSString *)entityName ByStockID:(NSNumber *)stockID
{
    NSArray *entities;
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                              inManagedObjectContext:managedObjectContext];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"(stockID == %@)", stockID];
    
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setIncludesPropertyValues:NO];
    [fetchRequest setIncludesSubentities:NO];
    NSError *error = nil;
    entities = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if(error != nil){
        entities = nil;
    }
    return entities;
}

-(void)getSuppliersByLastName:(NSString *)name forDelegate:(id)delegate;
{
    SupplierDataAccess *s = [[SupplierDataAccess alloc] init];
    s.delegate = self;
    [s getSuppliersByLastName:name];
}

-(void)didReceiveData:(NSMutableArray *)data
{
    NSLog(@"DataManager didReceiveData");
    [self.delegate dataDidSync:self];
}


@end
