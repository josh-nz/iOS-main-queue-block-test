//
//  SAMSyncManager.m
//  main_queue_block_test
//
//  Created by Joshua Wood on 10/06/14.
//  Copyright (c) 2014 Joshua Wood. All rights reserved.
//

#import "SAMSyncManager.h"

static dispatch_queue_t syncQueue;

@implementation SAMSyncManager

+ (instancetype)sharedSyncManager {
    static SAMSyncManager *sharedManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
        syncQueue = dispatch_queue_create("com.wildbamboo.honosapp.sync", DISPATCH_QUEUE_SERIAL);
    });
    
    return sharedManager;
}

- (void)sync {
    dispatch_async(syncQueue, ^{
        // Immediately dispatch notification on main queue.
        NSLog(@"Dispatching sync notification");
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"syncdone" object:nil];
        });
    });
}

@end
