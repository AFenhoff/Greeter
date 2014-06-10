//
//  GreeterQueueManager.m
//  YardOps
//
//  Created by Andrew Fenhoff on 6/10/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import "GreeterQueueManager.h"
#import "GreeterQueue.h"
#import "SharedObjects.h"
#import "Common.h"

@implementation GreeterQueueManager

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
    }
    
    if(so.scannedLicense)
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
    
    //Get all existing greeter records and send them through
    NSArray *greeterRecords = [self getEntities:@"GreeterQueue" forManagedObjectContext:so.managedObjectContext];
    for(GreeterQueue *greeterRecord in greeterRecords)
    {
        [super executeAPIPost:@"greeterqueue/postgreeterqueue" forDelegate:self withObject:greeterRecord];
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
    [self.delegate didReceiveData:data];
}


@end
