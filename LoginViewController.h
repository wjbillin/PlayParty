//
//  LoginViewController.h
//  Google Play Project
//
//  Created by William Joshua Billingham on 11/2/12.
//  Copyright 2012 University of Michigan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController {
}

@property (nonatomic, retain) IBOutlet UITextField *emailInput;
@property (nonatomic, retain) IBOutlet UITextField *passwordInput;
@property (nonatomic, retain) NSMutableData* responseData;


- (IBAction)submitButtonPressed:(id) sender;
- (IBAction)backgroundTapPassword:(id) sender;

@end
