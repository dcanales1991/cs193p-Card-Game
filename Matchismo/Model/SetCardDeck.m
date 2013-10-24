//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Diego Canales on 10/16/13.
//  Copyright (c) 2013 Diego Canales. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (instancetype) init {
    self = [super init];
    if (self) {
        for (NSString *symbol in [SetCard validSymbols]) {
            for (NSUInteger color = 1; color <= [SetCard maxColor]; color++) {
                for (NSUInteger rank = 1; rank <= [SetCard maxRank]; rank++) {
                    for (NSUInteger shade = 1; shade <= [SetCard maxShade]; shade++) {
                        SetCard *card = [[SetCard alloc]init];
                        card.rank = rank;
                        card.symbol = symbol;
                        card.shade = shade;
                        card.color = color;
                        [self addCard:card];
                    }
                }
            }
        }
    }
    return self;
}
@end
