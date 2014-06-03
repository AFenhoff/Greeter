//
//  SupplierDataAccess.m
//  YardOps
//
//  Created by Andrew Fenhoff on 6/2/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import "SupplierDataAccess.h"
#import "Supplier.h"
#import "SharedObjects.h"

@implementation SupplierDataAccess

-(void)getSuppliersByLastName:(NSString *)name
{
    self.lastRequestURL = [NSString stringWithFormat:@"suppliers/get/%@", name];
    [super executeAPIMethod:self.lastRequestURL forDelegate:self];
}


-(void)authenticationComplete:(id)sender
{
    //NEED TO FIGURE OUT HOW TO RESUME WHERE WE LEFT OFF SINCE WE GET BACK HERE AFTER ADFS AUTHENTICATION
    [super executeAPIMethod:self.lastRequestURL forDelegate:self];

}

-(void)didReceiveData:(NSMutableArray *)data
{
    NSLog(@"Supplier Data Received");
    [BaseDataAccess clearAllObjectsForEntity:@"Supplier"];
    SharedObjects *sharedObjects = [SharedObjects getSharedObjects];
    
    for (id string in data)
    {
        Supplier *supp = (Supplier *)[NSEntityDescription insertNewObjectForEntityForName:@"Supplier" inManagedObjectContext:sharedObjects.managedObjectContext];
        
        supp.supplierName   = [string objectForKey:@"SupplierName"];
        supp.supplierNo     = [string objectForKey:@"SupplierNo"];
        supp.supplierType   = [string objectForKey:@"SupplierType"];
        supp.cfcExpDate     = [string objectForKey:@"CFCExpDate"];
        supp.idNumber       = [string objectForKey:@"IDNumber"];
        supp.idPhoto        = [string objectForKey:@"IDPhoto"];
        supp.idRequired     = [string objectForKey:@"IDRequired"];
        supp.fingerPrint    = [string objectForKey:@"Fingerprint"];
        supp.firstName      = [string objectForKey:@"FirstName"];
        supp.lastName       = [string objectForKey:@"LastName"];
        supp.rowid          = [string objectForKey:@"rowid"];
        
        NSError *error = nil;
        if (![sharedObjects.managedObjectContext save:&error]) {
            // Handle the error.
        }
        
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [self.delegate didReceiveData:data];
}

@end
