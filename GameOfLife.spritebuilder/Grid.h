//
//  Grid.h
//  GameOfLife
//
//  Created by Rachel Xiang on 7/7/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"

@interface Grid : CCSprite
@property (nonatomic, assign) int totalAlive;
@property (nonatomic, assign) int generation;

- (void) evolveStep;
- (void) blah;
- (void) countNeighbors;
- (void) updateCreatures;


@end
