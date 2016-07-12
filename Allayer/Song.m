//
//  Song.m
//  Allayer
//
//  Created by Vadim Molchanov on 2/5/16.
//  Copyright © 2016 Vadim Molchanov. All rights reserved.
//

#import "Song.h"

@implementation Song

- (id)initWithServerResponse:(NSDictionary *)responseObject {
    
    self = [super init];
    if (self) {

        self.ID = [[responseObject objectForKey:@"id"] integerValue];
        self.ownerID = [[responseObject objectForKey:@"owner_id"] integerValue];
        self.artist = [responseObject objectForKey:@"artist"];
        self.title = [responseObject objectForKey:@"title"];
        self.duration = [[responseObject objectForKey:@"duration"] integerValue];
        
        NSString *urlString = [responseObject objectForKey:@"url"];
        if (urlString) {
            
            NSString *fileURL = [[urlString componentsSeparatedByString:@"?"] objectAtIndex:0];
            self.audioURL = [NSURL URLWithString:fileURL];
        }
    }
    return self;
}

@end
