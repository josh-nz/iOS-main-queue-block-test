//
//  SAMCoreData.m
//  main_queue_block_test
//
//  Created by Joshua Wood on 10/06/14.
//  Copyright (c) 2014 Joshua Wood. All rights reserved.
//

#import "SAMCoreData.h"

@interface SAMCoreData ()

@property (nonatomic, strong, readwrite) NSManagedObjectContext *context;

@end

@implementation SAMCoreData

//
//NSString * const WTPCoreDataContextDidSaveNotification = @"WTPCoreDataContextDidSaveNotification";
//NSString * const WTPCoreDataContextDidSaveFailedNotification = @"WTPCoreDataContextDidSaveFailedNotification";
//
//
//

- (instancetype)initWithQueueConcurrencyType:(NSManagedObjectContextConcurrencyType)concurrencyType Options:(NSDictionary *)options {
    if (self = [super init]) {
        // http://commandshift.co.uk/blog/2013/09/07/the-core-data-stack
        NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:[NSBundle allBundles]];
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        
        NSURL *url = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"Sample.sqlite"];
        
        if (!options) {
            options = @{NSPersistentStoreFileProtectionKey: NSFileProtectionComplete,
                        NSMigratePersistentStoresAutomaticallyOption:@YES,
                        NSInferMappingModelAutomaticallyOption:@YES};
        }
        
        NSError *error = nil;
        NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:options error:&error];
        if (!store)
        {
            NSLog(@"Error adding persistent store. Error %@",error);
            NSLog(@"Store already exists. Auto migration failed");
            abort();
            
            //            NSError *deleteError = nil;
            //            if ([[NSFileManager defaultManager] removeItemAtURL:url error:&deleteError])
            //            {
            //                NSLog(@"Removed database.");
            //                error = nil;
            //                store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:options error:&error];
            //                NSLog(@"Recreated database.");
            //            }
            //
            //            if (!store)
            //            {
            //                // Also inform the user...
            //                NSLog(@"Failed to create persistent store. Error %@. Delete error %@",error,deleteError);
            //                abort();
            //            }
        }
        
        self.context = [[NSManagedObjectContext alloc] initWithConcurrencyType:concurrencyType];
        self.context.persistentStoreCoordinator = psc;
    }
    return self;
}

//- (void)contextDidSave:(NSNotification *)notification {
//    SEL selector = @selector(mergeChangesFromContextDidSaveNotification:);
//    [self.context performSelectorOnMainThread:selector withObject:notification waitUntilDone:YES];
//}

+ (instancetype)sharedInstance {
    static SAMCoreData *sharedInstance;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] initWithQueueConcurrencyType:NSMainQueueConcurrencyType Options:nil];
    });
    return sharedInstance;
}

@end