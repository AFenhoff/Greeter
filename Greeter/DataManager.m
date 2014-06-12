//
//  DataSync.m
//  UPAP Inventory
//
//  Created by Andrew Fenhoff on 8/6/13.
//  Copyright (c) 2013 DJJ. All rights reserved.
//

#import "DataManager.h"
#import "MaterialDataAccess.h"
#import "SupplierDataAccess.h"
#import "VehicleDataAccess.h"
#import "UserDataAccess.h"
#import "GreeterQueueManager.h"
#import "MakeAndModelDataAccess.h"

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
    self.callType = LastNameSearch;
    SupplierDataAccess *s = [[SupplierDataAccess alloc] init];
    s.delegate = self;
    [s getSuppliersByLastName:name];
}

-(void)getSupplierByIDNumber:(NSString *)idNumber andState:(NSString *)state forDelegate:(id)delegate;
{
    self.callType = SupplierIDSearch;
    SupplierDataAccess *s = [[SupplierDataAccess alloc] init];
    s.delegate = self;
    [s getSupplierByIDNumber:idNumber andState:state];
}

-(void)getSuppliersBySupplierName:(NSString *)supplierName forDelegate:(id)delegate
{
    self.callType = SupplierNameSearch;
    SupplierDataAccess *s = [[SupplierDataAccess alloc] init];
    s.delegate = self;
    [s getSuppliersBySupplierName:supplierName];
}

-(void)getSupplierByFirstName:(NSString *)firstName andLastName:(NSString *)lastName andAddress:(NSString *)address
{
    self.callType = SupplierNameSearch;
    SupplierDataAccess *s = [[SupplierDataAccess alloc] init];
    s.delegate = self;
    [s getSupplierByFirstName:firstName andLastName:lastName andAddress:address];
 
}

-(void)getSupplierVehiclesBySupplierNo:(NSString *)supplierNo andIDNumber:(NSString *)idNumber forDelegate:(id)delegate
{
    self.callType = SupplierVehicles;
    VehicleDataAccess *v = [[VehicleDataAccess alloc] init];
    v.delegate = self;
    [v getSupplierVehiclesBySupplier:supplierNo andIDNumber:idNumber];
}

-(void)getSupplierVehicleByBarcode:(NSString *)barcode forDelegate:(id)delegate
{
    self.callType = VehicleBarcode;
    VehicleDataAccess *v = [[VehicleDataAccess alloc] init];
    v.delegate = self;
    [v getSupplierVehicleByBarcode:barcode];
}

-(void)getUserByEmployeeID:(NSNumber *)employeeID forDelegate:(id)delegate
{
    //Check to see if this user has authenticated (has a user record in NSUserDefaults)
    //Need to change this to inspect NSUserDefaults
    self.callType = Users;
    if(![UserDataAccess getUserCookiesForEmployeeID:employeeID])
    {
        UserDataAccess *userDataAccess = [[UserDataAccess alloc] init];
        userDataAccess.delegate = self;
        [userDataAccess authenticateUser];
    }else{
        [self.delegate dataDidSync:self];
    }
    
}

-(void)getMaterialsForBranch:(NSString *)branchCode forDelegate:(id)delegate
{
    self.callType = Materials;
    MaterialDataAccess* materialDataAccess = [[MaterialDataAccess alloc] init];
    [materialDataAccess getMaterialsForBranch:branchCode forDelegate:delegate];
}

-(void)getMakesAndModels:(id)delegate
{
    self.callType = MakesAndModels;
    MakeAndModelDataAccess* makeAndModelDataAccess = [[MakeAndModelDataAccess alloc] init];
    [makeAndModelDataAccess getMakesAndModels:self];
}

-(void)saveGreeterQueue
{
    self.callType = PostGreeterQueue;
    GreeterQueueManager *greeterQueueManager = [[GreeterQueueManager alloc] init];
    greeterQueueManager.delegate = self;
    [greeterQueueManager saveGreeterQueueRecord];
}

-(void)saveSupplierVehicle
{
    self.callType = PostSupplierVehicle;
    VehicleDataAccess* vehicleAccess = [[VehicleDataAccess alloc] init];
    vehicleAccess.delegate = self;
    [vehicleAccess saveSupplierVehicle];
}

-(void)didReceiveData:(NSMutableArray *)data
{
    NSLog(@"DataManager didReceiveData");
    SharedObjects *sharedObjects = [SharedObjects getSharedObjects];
    switch (self.callType) {
        case VehicleBarcode:
            if(sharedObjects.selectedVehicle)
            {
                [self getSupplierByIDNumber:sharedObjects.selectedVehicle.idNumber andState:@"" forDelegate:self.delegate];
            }
            break;
        case PostSupplierVehicle:
            //do nothing
            break;
        default:
            [self.delegate dataDidSync:self];
            break;
    }
}

-(void)objectCreatedSuccessfully:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(recordCreatedSuccessfully:)]) {
        [self.delegate	recordCreatedSuccessfully:self];
    }
}

@end
