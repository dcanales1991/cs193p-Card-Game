//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Diego Canales on 9/30/13.
//  Copyright (c) 2013 Diego Canales. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic) NSInteger tempScore;
@property (nonatomic) int result;
@property (nonatomic) NSInteger previousScore;
@property (nonatomic) NSInteger numMatches;
@property (nonatomic) BOOL matchFound;

@property (nonatomic, strong) NSMutableArray *cards; //of Cards

- (void) updateCards: (Card *)card withAttempts:(int) numOtherCardsSelected cardArray:(NSArray *)selectedCards;

@end

@implementation CardMatchingGame

- (NSMutableArray *)cards {
    if (!_cards) _cards = [[NSMutableArray alloc]init];
    return _cards;
}

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck {
    self = [super init];
    if (self) {
        self.matchFound = false;
        self.numMatches = GAME_MODE_1;
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                self.cards[i] = card;
            } else {
                self = nil;
                break;
            }
        }
    }
    return self;
    
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;



//If card is face up, face it back down.  Otherwise, compute any matches by looping through the cards.

-(void)chooseCardAtIndex:(NSUInteger)index {
    Card *card = [self cardAtIndex:index];
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
            self.matchFound = false;
            self.tempScore = 0;
            self.result = UNSELECT_ID;
        } else {
            NSMutableArray *chosenCards = [[NSMutableArray alloc] init];
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    [chosenCards addObject:otherCard];
                }
            }
            [chosenCards addObject:card];
            if ([chosenCards count] == self.numMatches) {
                [self updateCards:card withAttempts:[chosenCards count] cardArray:chosenCards];
                
            } else {
                self.result = SELECT_ID;
            }
            card.chosen = YES;
            self.score -= COST_TO_CHOOSE;
        }
    }
}

//Returns the ID of the result (the IDs are defined in CardMatchingGame.h)
-(int) getResultFromTurn {
    return self.result;
}

-(int) getScoreFromLastTurn {
    return self.previousScore;
}

- (void) updateCards: (Card *)card withAttempts:(int) numOtherCardsSelected cardArray:(NSArray *)selectedCards {
    int score = [card match:selectedCards] * MATCH_BONUS;
    if (score == 0) {
        self.score -= MISMATCH_PENALTY;
        self.result = NO_MATCH_ID;
    } else {
        self.score += score;
        self.result = MATCH_ID;
        card.matched = YES;
    }
    for (Card *otherCard in selectedCards) {
            if (otherCard.chosen == YES && !otherCard.isMatched) {
                if (score > 0) {
                    otherCard.matched = YES;
                } else {
                    otherCard.chosen = NO;
                }
            }
        }
    self.previousScore = score;
}

//Goes through each card and sets each card as matched/chosen etc...  Also updates the game's score


//This sets the game to either a 3 match game or a 2 match game
-(void) setGameMode: (int)numMatches {
    self.numMatches = numMatches;
    
}

-(int) getGameMode {
    return self.numMatches;
}


-(Card *)cardAtIndex:(NSUInteger)index {
    return (index < [self.cards count]) ? self.cards[index] : nil;
}
//This was done in lecture
- (instancetype) init {
    return nil;
}



@end
