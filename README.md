This is a quick test to determine how code blocks are scheduled on the main queue in iOS.

I have some critical sections of code that must be guaranteed to be executed as a whole and not interrupted by other threads.

This test appears to suggest that 'events' such as viewDidLoad and IBActions are wholly scheduled on to the main queue.

Any other main queue event that occurs during processing of this code block is simply scheduled onto the end of the queue and will be processed in due time. In other words, when such an 'event' is being executed on the main queue, it will not be interrupted.

Makes sense, and this is how you'd expect it to work. I just haven't been able to find anything stating this explicitly.