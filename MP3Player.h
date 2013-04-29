//
//  MP3Player.h
//  Google Play Project
//
//  Created by William Joshua Billingham on 4/28/13.
//  Copyright 2013 University of Michigan. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MP3Player : NSObject {

}

-(void)playSong:(NSString*)songID withDelegate:(id)delgate;

@property (nonatomic, retain) NSString* cur_playing;
@property (nonatomic, retain) id delegate;

@end
