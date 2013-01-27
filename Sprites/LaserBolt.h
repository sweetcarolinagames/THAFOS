//
//  LaserBolt.h
//  ggj13
//
//  Created by Rogelio E. Cardona-Rivera on 1/27/13.
//  Copyright 2013 Sweet Carolina Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Collidable.h"
#import "cocos2d.h"

@interface LaserBolt : CCSprite<Collidable>

+(LaserBolt*) generate:(CGPoint) origin;
+(LaserBolt*) generate:(CGPoint) origin: (CGFloat)offsetVerticallyBy;

@end
