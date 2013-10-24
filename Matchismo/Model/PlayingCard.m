//
//  PlayingCard.m
//  Matchismo
//
//  Created by Diego Canales on 9/28/13.
//  Copyright (c) 2013 Diego Canales. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (int)match:(NSArray *)otherCards {
    int maxScore = 0;
    for (PlayingCard *card1 in otherCards) {
        for (PlayingCard *card2 in otherCards) {
            if (card2 != card1) {
                if ([card1.suit isEqualToString:card2.suit]) {
                    if (maxScore == 0) {
                        maxScore = 1;
                    }
                } else if (card1.rank == card2.rank) {
                    maxScore = 4;
                }
            }
        }
    }
//    if ([otherCards count] == 1) {
//        PlayingCard *otherCard = [otherCards firstObject];
//        if ([self.suit isEqualToString:otherCard.suit]) {
//            score = 1;
//        } else if (self.rank == otherCard.rank) {
//            score = 4;
//        }
//    }
    NSLog(@"RETURNING SCORE OF: %d", maxScore
          );
    return maxScore;
}

- (NSString *)contents {
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit;

+ (NSArray *)validSuits {
    return @[@"♥",@"♣", @"♠", @"♦"];
}

- (NSString *)suit {
    return _suit ? _suit : @"?";
}

- (void) setSuit:(NSString *)suit {
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

+ (NSArray *)rankStrings {
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+ (NSUInteger) maxRank {
    return [[PlayingCard rankStrings] count] - 1;
}

- (void) setRank:(NSUInteger)rank {
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}
@end
