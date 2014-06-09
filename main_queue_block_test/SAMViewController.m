//
//  SAMViewController.m
//  main_queue_block_test
//
//  Created by Joshua Wood on 10/06/14.
//  Copyright (c) 2014 Joshua Wood. All rights reserved.
//

#import "SAMViewController.h"
#import "SAMSyncManager.h"

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

- (IBAction)didTouchButton:(id)sender {
    [self startTest];
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
    for (int64_t i = 0; i < 100000; i++) {
        NSLog(@"Working %lld", i);
    }
}

- (void)syncDone {
    NSLog(@"--------------------------------- syncdone notification received ---------------------------------");
}

@end
