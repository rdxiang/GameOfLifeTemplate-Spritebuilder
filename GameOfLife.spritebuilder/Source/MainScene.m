//
//  Grid.m
//  GameOfLife
//
//  Created by Rachel on 7/8/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Grid.h"
#import "Creature.h"
#import "math.h"

static const int GRID_ROWS = 8;
static const int GRID_COLUMNS = 10;

@implementation Grid {
    NSMutableArray *_gridArray;
    float _cellWidth;
    float _cellHeight;
}

- (void) onEnter {
    [super onEnter];
    [self setupGrid];
    self.userInteractionEnabled = YES;
}

- (void)setupGrid {
    _cellWidth = self.contentSize.width / GRID_COLUMNS;
    _cellHeight = self.contentSize.height / GRID_ROWS;
    
    float x = 0;
    float y = 0;
    
    _gridArray = [NSMutableArray array];
    
    for (int i=0; i < GRID_ROWS; i++) {
        _gridArray[i] = [NSMutableArray array];
        
        x = 0;
        for (int j=0; j < GRID_COLUMNS; j++) {
            Creature *creature = [[Creature alloc] initCreature];
            creature.anchorPoint = ccp(0,0);
            creature.position = ccp(x,y);
            [self addChild:creature];
            
            _gridArray[i][j] = creature;
            
            x+=_cellWidth;
        }
        y+=_cellHeight;
    }
    NSLog(@"Setup grid!");
}

-(void)evolveStep {
    NSLog(@"Started evolving...");
    [self countNeighbors];
    NSLog(@"Counted neighbors");
    [self updateCreatures];
    NSLog(@"Updated creatures");
    _generation++;
    NSLog(@"Evolved!");
}

-(void) countNeighbors {
    // iterate through the rows
    // note that NSArray has a method 'count' that will return the number of elements in the array
    for (int i = 0; i < [_gridArray count]; i++)
    {
        // iterate through all the columns for a given row
        for (int j = 0; j < [_gridArray[i] count]; j++)
        {
            // access the creature in the cell that corresponds to the current row/column
            Creature *currentCreature = _gridArray[i][j];
            
            // remember that every creature has a 'livingNeighbors' property that we created earlier
            currentCreature.livingNeighbors = 0;
            
            // now examine every cell around the current one
            
            // go through the row on top of the current cell, the row the cell is in, and the row past the current cell
            for (int x = (i-1); x <= (i+1); x++)
            {
                // go through the column to the left of the current cell, the column the cell is in, and the column to the right of the current cell
                for (int y = (j-1); y <= (j+1); y++)
                {
                    // check that the cell we're checking isn't off the screen
                    BOOL isIndexValid;
                    isIndexValid = [self isIndexValidForX:x andY:y];
                    
                    // skip over all cells that are off screen AND the cell that contains the creature we are currently updating
                    if (!((x == i) && (y == j)) && isIndexValid)
                    {
                        Creature *neighbor = _gridArray[x][y];
                        if (neighbor.isAlive)
                        {
                            currentCreature.livingNeighbors += 1;
                        }
                    }
                }
            }
        }
    }
}

-(void) updateCreatures {
    int numAlive = 0;
    for (int i = 0; i < [_gridArray count]; i++) {
        for (int j = 0; j < [_gridArray count]; j++) {
            Creature *currentCreature = _gridArray[i][j];
            if (currentCreature.livingNeighbors == 3) {
                numAlive++;
                currentCreature.isAlive = TRUE;
            } else if (currentCreature.livingNeighbors >= 4 || currentCreature.livingNeighbors <= 1) {
                currentCreature.isAlive = FALSE;
            }
        }
    }
    _totalAlive = numAlive;
}

- (BOOL)isIndexValidForX:(int)x andY:(int)y
{
    BOOL isIndexValid = YES;
    if(x < 0 || y < 0 || x >= GRID_ROWS || y >= GRID_COLUMNS)
    {
        isIndexValid = NO;
    }
    return isIndexValid;
}


-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [touch locationInNode:self];
    
    Creature *creature = [self creatureForTouchPosition:touchLocation];
    
    creature.isAlive = !creature.isAlive;
}

-(Creature *)creatureForTouchPosition:(CGPoint)touchPosition {
    //get the row and column that was touched, return the Creature inside the corresponding cell
    int row = floor(touchPosition.y / _cellHeight);
    int column = floor(touchPosition.x / _cellWidth);
    return _gridArray[row][column];
}
@end