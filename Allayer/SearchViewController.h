//
//  SearchViewController.h
//  Allayer
//
//  Created by Vadim Molchanov on 2/5/16.
//  Copyright © 2016 Vadim Molchanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "PlayListViewController.h"

@interface SearchViewController : PlayListViewController <UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *songSearchBar;


@end
