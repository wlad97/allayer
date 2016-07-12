//
//  PlayerTabBar.m
//  Allayer
//
//  Created by Vadim Molchanov on 2/21/16.
//  Copyright © 2016 Vadim Molchanov. All rights reserved.
//

#import "PlayerTabBar.h"
#import "PlayQueueManager.h"
#import "Song.h"

@interface PlayerTabBar ()

@property (strong, nonatomic) UIButton *playButton;
@property (strong, nonatomic) UIProgressView *songProgress;
@property (strong, nonatomic) UILabel *artistLabel;
@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation PlayerTabBar

-(CGSize)sizeThatFits:(CGSize)size {
    
    CGSize sizeThatFits = [super sizeThatFits:size];
    sizeThatFits.height = 100.0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self addControls];
    });
    
    return sizeThatFits;
}

#pragma mark - Controls

- (void)addControls {
    
    UIProgressView *songProgress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    songProgress.tintColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.5 alpha:1.0];
    songProgress.translatesAutoresizingMaskIntoConstraints = NO;

    [self addSubview:songProgress];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:songProgress attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:40.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:songProgress attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:songProgress attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
    self.songProgress = songProgress;

    UIImage *playImage = [[UIImage imageNamed:@"play30.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton* playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    playButton.frame = CGRectMake(0.0, 0.0, playImage.size.width, playImage.size.height);
    [playButton setImage:playImage forState:UIControlStateNormal];

    playButton.translatesAutoresizingMaskIntoConstraints = NO;
    [playButton addTarget:self action:@selector(currentSongAction) forControlEvents:UIControlEventTouchUpInside];
    
    playButton.tintColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.5 alpha:1.0];

    [self addSubview:playButton];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:playButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:playButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:5.0]];
    self.playButton = playButton;

    UIImage *nextImage = [[UIImage imageNamed:@"ff30.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton* nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(0.0, 0.0, nextImage.size.width, nextImage.size.height);
    [nextButton setImage:nextImage forState:UIControlStateNormal];
    nextButton.translatesAutoresizingMaskIntoConstraints = NO;
    [nextButton addTarget:self action:@selector(nextSongAction) forControlEvents:UIControlEventTouchUpInside];
    
    nextButton.tintColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.5 alpha:1.0];
    [self addSubview:nextButton];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:nextButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:nextButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:5.0]];
    
    UILabel *artistLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 200, 15)];
    artistLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:15.0];
    artistLabel.textAlignment = NSTextAlignmentCenter;
    artistLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:artistLabel];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:artistLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:5.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:artistLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:35.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:artistLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-45.0]];
    self.artistLabel = artistLabel;

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 200, 15)];
    titleLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:12.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:titleLabel];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:23.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:35.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-45.0]];
    self.titleLabel = titleLabel;
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateControls) userInfo:nil repeats:YES];
}


- (void)updateControls {
    
    Song *song = [PlayQueueManager sharedManager].currentSong;
    self.artistLabel.text = song.artist;
    self.titleLabel.text = song.title;
    self.songProgress.progress = [[PlayQueueManager sharedManager] currentTime] / (Float64)song.duration;
    
    if ([[PlayQueueManager sharedManager] isPlaying]) {
        [self.playButton setImage:[[UIImage imageNamed:@"pause30.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        
    } else {
        [self.playButton setImage:[[UIImage imageNamed:@"play30.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    }
}


#pragma mark - Actions

- (void)currentSongAction {

    if ([[PlayQueueManager sharedManager] isPlaying]) {
        [self.playButton setImage:[[UIImage imageNamed:@"play30.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [[PlayQueueManager sharedManager] stop];

    } else {
        [self.playButton setImage:[[UIImage imageNamed:@"pause30.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [[PlayQueueManager sharedManager] play];
    }
}


- (void)nextSongAction {

    [[PlayQueueManager sharedManager] advanceToNext];
}


//- (void)drawRect:(CGRect)rect {
//}


@end
