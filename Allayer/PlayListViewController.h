//
//  PlayListViewController.h
//  Allayer
//
//  Created by Vadim Molchanov on 2/22/16.
//  Copyright © 2016 Vadim Molchanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayQueueManager.h"
#import "SongCell.h"
#import "Song.h"

@interface PlayListViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *songsArray;

- (IBAction)playQueueAction:(UIButton *)sender;

@end
