//
//  DataSync.h
//  UPAP Inventory
//
//  Created by Andrew Fenhoff on 8/6/13.
//  Copyright (c) 2013 DJJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDataAccess.h"

typedef enum DataManagerCallType : NSInteger DataManagerCallType;
enum DataManagerCallType : NSInteger {
    LastNameSearch,
    SupplierNameSearch,
    SupplierIDSearch,
    SupplierVehicles,
    VehicleBarcode,
    Users,
    Materials,
    PostGreeterQueue,
    MakesAndModels,
    PostSupplierVehicle
};

@protocol DataManagerDelegate<NSObject>
@optional

-(void)recordCreatedSuccessfully:(id)sender;
-(void)dataDidSync:(id)sender;

@end

@interface DataManager : NSObject<BaseDataAccessDelegate>

@property (nonatomic, assign) id<DataManagerDelegate> delegate;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) DataManagerCallType callType;

-(DataManager *)initWithObjectContext:(NSManagedObjectContext *)objectContext;
-(void) syncBaseData;
-(void) syncData;
-(NSArray *)getEntities:(NSString *)entityName;

-(void)getSuppliersByLastName:(NSString *)name forDelegate:(id)delegate;
-(void)getSupplierVehiclesBySupplierNo:(NSString *)supplierNo andIDNumber:(NSString *)idNumber forDelegate:(id)delegate;
-(void)getSuppliersBySupplierName:(NSString *)supplierName forDelegate:(id)delegate;
-(void)getSupplierByIDNumber:(NSString *)idNumber andState:(NSString *)state forDelegate:(id)delegate;
-(void)getSupplierByFirstName:(NSString *)firstName andLastName:(NSString *)lastName andAddress:(NSString *)address;
-(void)getSupplierVehicleByBarcode:(NSString *)barcode forDelegate:(id)delegate;
-(void)getUserByEmployeeID:(NSNumber *)employeeID forDelegate:(id)delegate;
-(void)getMaterialsForBranch:(NSString *)branchCode forDelegate:(id)delegate;
-(void)getMakesAndModels:(id)delegate;

/*****Save Section********************************************************************************************************/
-(void)saveGreeterQueue;
-(void)saveSupplierVehicle;

@end
