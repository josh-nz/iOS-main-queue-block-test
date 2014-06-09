//
//  SAMSyncManager.h
//  main_queue_block_test
//
//  Created by Joshua Wood on 10/06/14.
//  Copyright (c) 2014 Joshua Wood. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAMSyncManager : NSObject

+ (instancetype)sharedSyncManager;

- (void)sync;

@end
