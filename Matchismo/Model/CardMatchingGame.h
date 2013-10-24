//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Diego Canales on 9/30/13.
//  Copyright (c) 2013 Diego Canales. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

//These are used to determine whether the flip caused a match, no match, etc...
static const int MATCH_ID = 0;
static const int NO_MATCH_ID = 1;
static const int SELECT_ID = 2;
static const int UNSELECT_ID = 3;

//You can set these game modes to any number (these game modes are the match numbers (i.e. a 2 match game or a 3 match game
static const int GAME_MODE_1 = 3;
static const int GAME_MODE_2 = 2;

@interface CardMatchingGame : NSObject

//this is the designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck;

- (void)chooseCardAtIndex:(NSUInteger)index;

-(Card *)cardAtIndex:(NSUInteger)index;
-(int) getScoreFromLastTurn;
-(int) getResultFromTurn;
-(void) setGameMode: (int)numMatches;
-(int) getGameMode;



@property (nonatomic, readonly) NSInteger score;

@end
