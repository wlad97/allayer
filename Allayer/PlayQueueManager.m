//
//  PlayQueueManager.m
//  Allayer
//
//  Created by Vadim Molchanov on 2/17/16.
//  Copyright © 2016 Vadim Molchanov. All rights reserved.
//

#import "PlayQueueManager.h"
#import <AVFoundation/AVFoundation.h>
#import "Song.h"

@interface PlayQueueManager () {
    AVQueuePlayer *streamPlayer;
}

@end


@implementation PlayQueueManager

+ (PlayQueueManager *)sharedManager {
    
    static PlayQueueManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PlayQueueManager alloc] init];
    });
    return manager;
}


- (instancetype)init {
    
    self = [super init];
    if (self) {
        streamPlayer = [[AVQueuePlayer alloc] init];
    }
    return self;
}

- (void)play {

    if (!streamPlayer.rate) {
        [streamPlayer play];
    }
}

- (void)stop {
//    self.currentSong.ID = 0;
    [streamPlayer pause];
}


- (void)playNow:(Song *)song {
    
    self.currentSong = song;
    NSURL *songURL = song.audioURL;
    
    [streamPlayer replaceCurrentItemWithPlayerItem:[AVPlayerItem playerItemWithURL:songURL]];  //[[AVQueuePlayer alloc] initWithURL:songURL];
    [self play];
}

- (void)queueNext:(Song *)song {
    
    NSURL *songURL = song.audioURL;

    [streamPlayer insertItem:[AVPlayerItem playerItemWithURL:songURL] afterItem:[streamPlayer currentItem]];
    [self play];

}

- (void)queueLast:(Song *)song {

    NSURL *songURL = song.audioURL;

    [streamPlayer insertItem:[AVPlayerItem playerItemWithURL:songURL] afterItem:nil];
    [self play];

}

- (void)advanceToNext {
    [streamPlayer advanceToNextItem];
    [self play];

}

- (BOOL)isPlaying {
    
    if (streamPlayer.rate) {
        return YES;
        
    } else {
        return NO;
    }
}

- (Float64)currentTime {
    
    return CMTimeGetSeconds([streamPlayer currentTime]);
}



//-(void)printItems {
//    NSLog(@"\n\n");
//    NSLog(@"CURRENT ITEM %@", [streamPlayer currentItem].description);
//
//    NSArray *items = [streamPlayer items];
//    for (AVPlayerItem *iItem in items) {
//        NSLog(@"%@", iItem.description);
//    }
//}

@end
