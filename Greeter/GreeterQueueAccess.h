//
//  GreeterQueueAccess.h
//  YardOps
//
//  Created by Andrew Fenhoff on 6/10/14.
//  Copyright (c) 2014 DJJ. All rights reserved.
//

#import "BaseDataAccess.h"

@interface GreeterQueueAccess : BaseDataAccess<ADFSViewControllerDelegate>

-(void)saveGreeterQueueRecord;

@end
