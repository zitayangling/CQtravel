//
//  Sights.m
//  new、CQtravel
//
//  Created by zitayangling on 16/4/24.
//  Copyright © 2016年 yangling. All rights reserved.
//

#import "Sights.h"

@implementation Sights
- (void)setPosition:(NSString *)Position {
    if (![_Position isEqualToString:Position]) {
//#warning copy
        _Position = [Position copy];
        NSArray *sightCoordinates = [Position componentsSeparatedByString:@","];
        CGFloat latitude = [sightCoordinates.firstObject doubleValue];
        CGFloat longitude = [sightCoordinates.lastObject doubleValue];
        _coordinate.latitude = latitude;
        _coordinate.longitude = longitude;
    }
}
@end
