//
//  UserDataAccess.h
//  YardOps
//
//  Created by Andrew Fenhoff on 6/8/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import "BaseDataAccess.h"
#import "User.h"
#import "ADFSViewController.h"

@interface UserDataAccess : BaseDataAccess<ADFSViewControllerDelegate>

+(void)clearUser:(NSNumber *)employeeID;
+(NSArray *)getUserCookiesForEmployeeID:(NSNumber *)employeeID;

-(void)authenticateUser;
-(User *)getUserByEmployeeID:(NSNumber *)employeeID;

@end
