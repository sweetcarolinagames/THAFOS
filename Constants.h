//
//  Constants.h
//  ggj13
//
//  Created by Rogelio E. Cardona-Rivera on 1/26/13.
//  Copyright (c) 2013 Sweet Carolina Games. All rights reserved.
//

#ifndef ggj13_Constants_h
#define ggj13_Constants_h

//Layer Orderings
#define BACKGROUND_LAYER_LEVEL 0
#define SPRITE_LAYER_LEVEL 1

//Battery Information
#define MAX_BATTERY_LIFE 100.0
#define BATTERY_STAGES 3
#define BATTERY_STAGE_DELTA (MAX_BATTERY_LIFE / BATTERY_STAGES)
#define BAD_HEART_PENALTY 20.0

//Laser Information
#define LASER_TAG 777
#define LASER_BATTERY_PENALTY 5.0

// Citizen Generation Constants
#define EASY_DELAY 5.0
#define MED_DELAY 4.0
#define HARD_DELAY 3.0
#define INSANE_DELAY 2.0

#endif
