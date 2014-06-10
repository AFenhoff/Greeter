//
//  MaterialDataAccess.h
//  YardOps
//
//  Created by loaner on 6/9/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import "BaseDataAccess.h"
#import "ADFSViewController.h"
#import "SharedObjects.h"


@interface MaterialDataAccess : BaseDataAccess<ADFSViewControllerDelegate>

-(void)getMaterialsForBranch:(NSString *)branchCode forDelegate:(id)delegate;

@end
