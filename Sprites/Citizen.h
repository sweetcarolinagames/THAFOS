//
//  Grams.h
//  ggl
//
//  Created by Ian Coleman on 11/10/12.
//  Copyright 2012 Ian Coleman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Enemy.h"
#import "RunAction.h"
//#import "FallAction.h"
#import "HitAction.h"

typedef enum
{
    CITIZEN_MALE = 0, 
    CITIZEN_FEMALE = (1 << 0)
} CitizenGender;

@interface Citizen : Enemy {


}

-(id)initWithSpriteFrameName;

@end
