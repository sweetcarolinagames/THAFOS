//
//  Battery.h
//  ggj13
//
//  Created by Rogelio E. Cardona-Rivera on 1/26/13.
//  Copyright 2013 Sweet Carolina Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Battery : CCSprite 
{
    @private
    CGFloat _batteryLife;
    CGFloat _batteryDecay;
}

@property (nonatomic, readonly) CGFloat batteryDecay;
@property (atomic, getter = getBatteryLife, setter = setBatteryLife:) CGFloat batteryLife;


@end
