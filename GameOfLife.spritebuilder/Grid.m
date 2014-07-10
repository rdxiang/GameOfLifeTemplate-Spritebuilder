//
//  Grid.m
//  GameOfLife
//
//  Created by Rachel Xiang on 7/7/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Grid.h"
#import "Creature.h"

static const int GRID_ROWS = 8;
static const int GRID_COlUMNS   = 10;

@implementation Grid {
    NSMutableArray *_gridArray;
    float _cellWidth;
    float _cellHeight;
}
- (void) blah {
    NSLog(@"H")
}
-(void)onEnter{
    [super onEnter];
    
    [self setupGrid];
    
    self.userInteractionEnabled = YES;
}


- (void) setupGrid {
    _cellWidth = self.contentSize.width /GRID_COlUMNS;
    _cellHeight  = self.contentSize.height /GRID_ROWS;
    
    float x = 0;
    float y = 0;
    
    _gridArray = [NSMutableArray array];
    
    for (int i = 0; i < GRID_ROWS; i++){
        _gridArray[i] = [NSMutableArray array];
        x = 0;
        
        for (int j = 0; j < GRID_COlUMNS; j++) {
            Creature *creature = [[Creature alloc] initCreature];
            creature.anchorPoint = ccp(0,0);
            creature.position = ccp(x,y);
            [self addChild:creature];
            
            _gridArray[i][j] = creature;
            
            //creature.isAlive = YES;
            
            x+= _cellWidth;
        }
        y += _cellHeight;
    }
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touch locationInNode:self];
    
    Creature *creature = [self creatureForTouchPosition:touchLocation];

    creature.isAlive = !creature.isAlive;
}

- (Creature *)creatureForTouchPosition:(CGPoint)touchPosition
{
    int row = touchPosition.y / _cellHeight;
    int col = touchPosition.x / _cellWidth;
    
    return _gridArray[row][col];
}

- (void) evolveStep {
    
//    [self countNeighbors];
//    [self updateCreatures];
//    
    _generation++;
}

-(void) countNeighbors {
    for (int i = 0; i < [_gridArray count]; i++) {
        for (int j = 0; j < [_gridArray count]; j++)
        {
            Creature * current = _gridArray[i][j];
            current.livingNeighbors = 0;
            
            for (int x = (i-1); x <= (i+1); x++)
            {
                for (int y = (j-1); y <= (j+1); j++)
                {
                    BOOL indexValid = [self isIndexValidForX: x andY:y];
                    
                    if (!((x == i ) && (y == j)) && indexValid)
                    {
                        Creature *neighbor = _gridArray[x][y];
                        if (neighbor.isAlive)
                        {
                            current.livingNeighbors += 1;
                        }
                    }
                }
            }
        
        }
    }
}

-(BOOL) isIndexValidForX: (int)x andY:(int)y
{
    BOOL isIndexValid = YES;
    if (x<0 || y < 0 || x >= GRID_ROWS || y >= GRID_COlUMNS)
        isIndexValid = NO;
    return isIndexValid;
}

-(void) updateCreatures {
    for (int i = 0; i < [_gridArray count]; i++) {
        for (int j = 0; j < [_gridArray count]; j++)
        {
            Creature * current = _gridArray[i][j];
            if (current.livingNeighbors == 3)
                current.isAlive = YES;
            else if (current.livingNeighbors <= 1 || current.livingNeighbors >= 4)
                current.isAlive = NO;
        }
    }

}

@end
