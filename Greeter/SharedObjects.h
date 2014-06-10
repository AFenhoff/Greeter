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
#import "Material.h"

@interface SharedObjects : NSObject <DataManagerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) DataManager *dataManager;
@property (nonatomic, retain) ADFSViewController *authScreen;
@property (nonatomic, retain) Supplier *selectedSupplier;
@property (nonatomic, retain) Vehicle *selectedVehicle;
@property (nonatomic, retain) User *currentUser;
@property (nonatomic, retain) Material* selectedMaterial;

+ (id)getSharedObjects;

- (void)popAuthenticationForDelegate:(id)delegate withRequestURL:(NSURLRequest *)requestedURL;

@end
