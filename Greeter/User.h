//
//  User.h
//  YardOps
//
//  Created by Andrew Fenhoff on 6/7/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSNumber * employeeID;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) id cookieStore;

@end
