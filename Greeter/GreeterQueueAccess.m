//
//  GreeterQueueManager.m
//  YardOps
//
//  Created by Andrew Fenhoff on 6/10/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import "GreeterQueueAccess.h"
#import "GreeterQueue.h"
#import "SharedObjects.h"
#import "Common.h"

@implementation GreeterQueueAccess

-(void)saveGreeterQueueRecord
{
    SharedObjects *so = [SharedObjects getSharedObjects];
    
    //Commit this to CoreData in case the save fails
    GreeterQueue *gq = (GreeterQueue *)[NSEntityDescription insertNewObjectForEntityForName:@"GreeterQueue" inManagedObjectContext:so.managedObjectContext];
    gq.name = so.selectedSupplier.supplierName;
    gq.idNumber = so.selectedSupplier.idNumber;
    gq.supplierNo = so.selectedSupplier.supplierNo;
    gq.supplierIDRowID = so.selectedSupplier.rowid;
    gq.branch = [Common getStringSetting:kBranchSettingName];
    gq.queueType = [NSNumber numberWithInt:1];
    gq.user = [NSString stringWithFormat:@"%@",so.currentUser.employeeID];
    gq.inYardID = so.inYardID;
    gq.materialCode = so.selectedMaterial.materialCode;
    gq.bodyCount = so.bodyCount;
    gq.cfcTaken = so.cfcTaken;
    gq.titlesTaken = so.titlesTaken;
    
    if(so.selectedVehicle)
    {
        gq.vehicleTagState = so.selectedVehicle.state;
        gq.vehicleTagNo = so.selectedVehicle.licensePlate;
        gq.vehicleDesc = [NSString stringWithFormat:@"%@ %@ %@", [so.selectedVehicle.color uppercaseString],
                          [so.selectedVehicle.make uppercaseString], [so.selectedVehicle.model uppercaseString]];
        gq.trailerTagNo = so.selectedVehicle.trailerNumber;
        gq.trailerTagState = so.selectedVehicle.state;
        gq.color = so.selectedVehicle.color;
        
    }
    
    if(so.scannedLicense.ID)
    {
        gq.idNumber = so.scannedLicense.ID;
        gq.idExpireDate = so.scannedLicense.ExpirationDate;
        gq.idIssuer = so.scannedLicense.State;
        gq.idType = @"DL";
        gq.address1 = so.scannedLicense.Address1;
        gq.address2 = so.scannedLicense.Address2;
        gq.city = so.scannedLicense.City;
        gq.state = so.scannedLicense.State;
        gq.postCode = so.scannedLicense.Zip;
        gq.firstName = so.scannedLicense.FirstName;
        gq.lastName = so.scannedLicense.LastName;
        gq.gender = so.scannedLicense.Gender;
        gq.hairColor = so.scannedLicense.HairColor;
        gq.height = so.scannedLicense.Height;
        gq.weight = so.scannedLicense.Weight;
        gq.eyeColor = so.scannedLicense.EyeColor;
        gq.race = so.scannedLicense.Race;
        gq.name = [NSString stringWithFormat:@"%@ %@", so.scannedLicense.FirstName, so.scannedLicense.LastName];
    }
    NSError *error = nil;
    if (![so.managedObjectContext save:&error]) {
        // Handle the error.
    }
    [self postGreeterNextRecord];
}

-(void)postGreeterNextRecord
{
    //Get all existing greeter records and send them through
    SharedObjects *so = [SharedObjects getSharedObjects];
    NSArray *greeterRecords = [self getEntities:@"GreeterQueue" forManagedObjectContext:so.managedObjectContext];
    if (greeterRecords.count > 0)
    {
        [super executeAPIPost:@"greeterqueue/postgreeterqueue" forDelegate:self withObject:greeterRecords[0]];
    }else{
        if([self.delegate respondsToSelector:@selector(objectCreatedSuccessfully:)])
        {
            [self.delegate objectCreatedSuccessfully:self];
        }
    }
}

-(NSArray *)getEntities:(NSString *)entityName forManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
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


-(void)authenticationComplete:(id)sender
{

}

-(void)didReceiveData:(NSMutableArray *)data
{
    //Remove first object from Core Data
    [self clearFirstGreeterQueue];
    //Process any other greeter records in core data
    [self postGreeterNextRecord];
}

-(void)clearFirstGreeterQueue
{
    SharedObjects *sharedObjects = [SharedObjects getSharedObjects];
    //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSFetchRequest * allObjects = [[NSFetchRequest alloc] init];
    [allObjects setEntity:[NSEntityDescription entityForName:@"GreeterQueue" inManagedObjectContext:sharedObjects.managedObjectContext]];
    [allObjects setIncludesPropertyValues:NO]; //only fetch the managedObjectID

    NSError * error = nil;
    NSArray * objects = [sharedObjects.managedObjectContext executeFetchRequest:allObjects error:&error];

    //error handling goes here
    if(objects.count > 0 ) {
        [sharedObjects.managedObjectContext deleteObject:objects[0]];
    }
    NSError *saveError = nil;
    [sharedObjects.managedObjectContext save:&saveError];
}



@end
