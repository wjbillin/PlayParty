//
//  SplashViewController.h
//  Google Play Project
//
//  Created by William Joshua Billingham on 11/2/12.
//  Copyright 2012 University of Michigan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginViewController;
@interface SplashViewController : UIViewController {
	IBOutlet LoginViewController *loginViewController;
}

@property (nonatomic, retain) IBOutlet LoginViewController *loginViewController;


- (IBAction)hostButtonPressed:(id) sender;
- (IBAction)joinButtonPressed:(id) sender;

@end
