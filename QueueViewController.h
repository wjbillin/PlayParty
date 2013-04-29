//
//  QueueViewController.h
//  Google Play Project
//
//  Created by William Joshua Billingham on 4/24/13.
//  Copyright 2013 University of Michigan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MP3Player;
@interface QueueViewController : UITableViewController {

}

- (void)setTimestamp;

@property (nonatomic, retain) NSMutableArray* queue;
@property (nonatomic, assign) BOOL isInitialized;
@property (nonatomic, retain) NSDate* lastModified;
@property (nonatomic, retain) NSTimer* timer;
@property (nonatomic, retain) MP3Player* mp3_player;

@property (nonatomic, retain) UIWebView* backgroundWebView;

@end
