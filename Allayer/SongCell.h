//
//  SongCell.h
//  Allayer
//
//  Created by Vadim Molchanov on 2/12/16.
//  Copyright © 2016 Vadim Molchanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"

@interface SongCell : UITableViewCell

@property (assign, nonatomic) NSInteger index;

@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;

- (IBAction)menuAction:(UIButton *)sender;

@end
