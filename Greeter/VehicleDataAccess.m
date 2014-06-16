//
//  VehicleDataAccess.m
//  YardOps
//
//  Created by Andrew Fenhoff on 6/3/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import "VehicleDataAccess.h"
#import "SharedObjects.h"
#import "Vehicle.h"

@implementation VehicleDataAccess

-(void)getSupplierVehiclesBySupplier:(NSString *)supplierNo andIDNumber:(NSString *)idNumber
{
    // ****** (SAI Branch Peddler) is caught by IIS as a potentially harmful request
    if([supplierNo isEqualToString:@"******"])
    {
        supplierNo = @"BRANCHPEDDLER";
    }
    self.lastRequestURL = [NSString stringWithFormat:@"suppliers/vehicles/getbysuppliernoidnumber/%@/%@", supplierNo,idNumber.length == 0 ? @"notsupplied" : idNumber ];
    
    [super executeAPIMethod:self.lastRequestURL forDelegate:self];
}

-(void)getSupplierVehicleByBarcode:(NSString *)barcode
{
    self.lastRequestURL = [NSString stringWithFormat:@"suppliers/vehicles/getbybarcode/%@", barcode];
    [super executeAPIMethod:self.lastRequestURL forDelegate:self];
}

-(void)saveSupplierVehicle
{
    SharedObjects *so = [SharedObjects getSharedObjects];
    //Get all existing greeter records and send them through
    [super executeAPIPost:@"suppliers/vehicles/postsuppliervehicle" forDelegate:self withObject:so.selectedVehicle];
    
}
-(void)authenticationComplete:(id)sender
{
    //NEED TO FIGURE OUT HOW TO RESUME WHERE WE LEFT OFF SINCE WE GET BACK HERE AFTER ADFS AUTHENTICATION
    [super executeAPIMethod:self.lastRequestURL forDelegate:self];
}

-(void)didReceiveData:(NSMutableArray *)data
{
    NSLog(@"Supplier Vehicles Data Received");
    [BaseDataAccess clearAllObjectsForEntity:@"Vehicle"];
    SharedObjects *sharedObjects = [SharedObjects getSharedObjects];
    
    for(int i = 0; i < data.count; i++)
    {
        NSDictionary *string = data[i];
        Vehicle *veh = (Vehicle *)[NSEntityDescription insertNewObjectForEntityForName:@"Vehicle" inManagedObjectContext:sharedObjects.managedObjectContext];
        
        veh.supplierNo      = [string objectForKey:@"SupplierNo"];
        veh.idNumber        = [string objectForKey:@"IDNumber"];
        veh.rowid           = [string objectForKey:@"rowid"];
        veh.make            = [string objectForKey:@"Make"];
        veh.model           = [string objectForKey:@"Model"];
        veh.year            = [string objectForKey:@"Year"];
        veh.color           = [string objectForKey:@"Color"];
        veh.licensePlate    = [string objectForKey:@"LicensePlate"];
        veh.state           = [string objectForKey:@"State"];
        veh.trailerNumber   = [string objectForKey:@"TrailerNumber"];
        
        NSError *error = nil;
        if (![sharedObjects.managedObjectContext save:&error]) {
            // Handle the error.
        }
        if(data.count == 1) { sharedObjects.selectedVehicle = veh; }
        
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [self.delegate didReceiveData:data];
}


@end
