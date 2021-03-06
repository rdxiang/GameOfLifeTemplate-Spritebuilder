//
//  Creature.h
//  GameOfLife
//
//  Created by Rachel Xiang on 7/7/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"

@interface Creature : CCSprite

@property (nonatomic, assign) BOOL isAlive;

@property (nonatomic, assign) NSInteger livingNeighbors;

- (id)initCreature;

@end
