//
//  PlayQueueManager.h
//  Allayer
//
//  Created by Vadim Molchanov on 2/17/16.
//  Copyright © 2016 Vadim Molchanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Song;

@interface PlayQueueManager : NSObject
@property (strong, nonatomic) Song *currentSong;

+ (PlayQueueManager *)sharedManager;

- (void)play;
- (void)stop;
- (void)playNow:(Song *)song;
- (void)queueNext:(Song *)song;
- (void)queueLast:(Song *)song;
- (void)advanceToNext;
- (BOOL)isPlaying;
- (Float64)currentTime;

@end
