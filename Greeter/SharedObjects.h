//
//  SharedObjects.h
//  YardOps
//
//  Created by Andrew Fenhoff on 6/3/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADFSViewController.h"
#import "DataManager.h"
#import "Supplier.h"
#import "Vehicle.h"
#import "User.h"
#import "LicenseDecoder.h"
#import "Material.h"

typedef enum GreeterType : NSInteger GreeterType;
enum GreeterType : NSInteger {
    BOTH = 1,
    NF = 1,
    FE = 2
};

@interface SharedObjects : NSObject <DataManagerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) DataManager *dataManager;
@property (nonatomic, retain) ADFSViewController *authScreen;
@property (nonatomic, retain) Supplier *selectedSupplier;
@property (nonatomic, retain) Vehicle *selectedVehicle;
@property (nonatomic, retain) User *currentUser;
@property (nonatomic, retain) LicenseDecoder *scannedLicense;
@property (nonatomic, retain) NSString *inYardID;
@property (nonatomic, retain) Material *selectedMaterial;
@property (nonatomic, retain) NSNumber *bodyCount;
@property (nonatomic, retain) NSNumber *cfcTaken;
@property (nonatomic, retain) NSNumber *titlesTaken;
@property (nonatomic) int foundSupplierCount;
@property (nonatomic) GreeterType greeterType;
@property (nonatomic, retain) NSString *scannedBarcode;
@property (nonatomic, retain) NSString *scannedTrack1;
@property (nonatomic, retain) NSString *scannedTrack2;
@property (nonatomic, retain) NSString *scannedTrack3;

+ (id)getSharedObjects;

- (void)popAuthenticationForDelegate:(id)delegate withRequestURL:(NSURLRequest *)requestedURL;
- (void)clearData;
-(void)clearDataLeaveInYard;

@end
