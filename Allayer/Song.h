//
//  Song.h
//  Allayer
//
//  Created by Vadim Molchanov on 2/5/16.
//  Copyright © 2016 Vadim Molchanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Song : NSObject

@property (assign, nonatomic) NSInteger ID;
@property (assign, nonatomic) NSInteger ownerID;
@property (strong, nonatomic) NSString *artist;
@property (strong, nonatomic) NSString *title;
@property (assign, nonatomic) NSInteger duration;
@property (strong, nonatomic) NSURL *audioURL;

- (id)initWithServerResponse:(NSDictionary *)responseObject;

@end
