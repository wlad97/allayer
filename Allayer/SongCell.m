//
//  SongCell.m
//  Allayer
//
//  Created by Vadim Molchanov on 2/12/16.
//  Copyright © 2016 Vadim Molchanov. All rights reserved.
//

#import "SongCell.h"
#import "PlayQueueManager.h"

@implementation SongCell

- (void)awakeFromNib {
    
    self.backgroundColor = [UIColor colorWithRed:237 / 255.0 green:232 / 255.0 blue:238 / 255.0 alpha:1.0];
    
    
    UIImage *menuImage = [[UIImage imageNamed:@"menu30.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.menuButton setImage:menuImage forState:UIControlStateNormal];
    self.menuButton.tintColor = [UIColor colorWithRed:1 / 255.0 green:163 / 255.0 blue:196 / 255.0 alpha:1.0];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (IBAction)menuAction:(UIButton *)sender {

    self.menuButton.tag = self.index;
}


@end
