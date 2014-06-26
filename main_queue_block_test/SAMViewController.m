//
//  SAMViewController.m
//  main_queue_block_test
//
//  Created by Joshua Wood on 10/06/14.
//  Copyright (c) 2014 Joshua Wood. All rights reserved.
//

#import "SAMViewController.h"
#import "SAMSyncManager.h"
#import "SAMCoreData.h"
#import "Person.h"

@interface SAMViewController ()

@end

@implementation SAMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncDone) name:@"syncdone" object:nil];
    [self startTest];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTouchIBActionTest:(id)sender {
    [self startTest];
}

- (IBAction)didTouchCoreDataTest:(id)sender {
    // Immediately launch sync in background.
    [[SAMSyncManager sharedSyncManager] sync];
    // Loop for a while to ensure the sync notification is executed before Core Data save block.
    // Does the notification fire before Core Data save block? Or does the main queue Core Data stack
    // get inlined in to this code block on the main queue?
    for (int64_t i = 0; i < 5000; i++) {
        NSLog(@"Waiting %lld", i);
    }
    
    NSManagedObjectContext *context = [SAMCoreData sharedInstance].context;
    // This block is queued on the main queue. Because the above sync notification
    // gets in the queue first, it is logically processed first before the
    // following block.
    [context performBlock:^{
        NSLog(@"Context block");
    }];
}

- (void)startTest {
    // Immediately launch sync in background.
    [[SAMSyncManager sharedSyncManager] sync];
    // Do work for a long time to see if we block in viewDidLoad on main queue.
    // Either:
    // - viewDidLoad will finish before the notification is received (viewDidLoad blocks main queue)
    // - notification is received during viewDidLoad processing (viewDidLoad is not a block on main queue)
    // Answer:
    // - 'events' such as viewDidLoad and IBActions are contiguous code blocks on the main queue and will not
    // be interrupted. Other main queue actions such as notification observers will be scheduled
    // on to the queue and actioned some time later after the current 'block' is done.
    for (int64_t i = 0; i < 10000; i++) {
        NSLog(@"Working %lld", i);
    }
}

- (void)syncDone {
    NSLog(@"--------------------------------- syncdone notification received ---------------------------------");
}

@end
