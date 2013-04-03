//
//  Google_Play_ProjectAppDelegate.h
//  Google Play Project
//
//  Created by William Joshua Billingham on 11/2/12.
//  Copyright 2012 University of Michigan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Google_Play_ProjectAppDelegate : NSObject <UIApplicationDelegate> {
    IBOutlet UIWindow *window;
	IBOutlet UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

