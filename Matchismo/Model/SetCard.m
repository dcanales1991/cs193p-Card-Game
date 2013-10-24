//
//  SetCard.m
//  Matchismo
//
//  Created by Diego Canales on 10/16/13.
//  Copyright (c) 2013 Diego Canales. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

static const int MATCH_BONUS = 4;

- (int)match:(NSArray *)otherCards {
    SetCard *card1 = otherCards[0];
    SetCard *card2 = otherCards[1];
    SetCard *card3 = otherCards[2];
    if (card1.rank == card2.rank && card2.rank == card3.rank && card1.rank == card3.rank) {
        return 1 * MATCH_BONUS;
    }
    if (card1.color == card2.color && card2.color == card3.color && card1.color == card3.color) {
        return 1 * MATCH_BONUS;
    }
    if (card1.shade == card2.shade && card2.shade == card3.shade && card1.shade == card3.shade) {
        return 1* MATCH_BONUS;
    }
    if ([card1.symbol isEqualToString:card2.symbol] && [card2.symbol isEqualToString:card3.symbol] && [card1.symbol isEqualToString:card3.symbol]) {
        return 1* MATCH_BONUS;
    }
    if (card1.rank != card2.rank && card2.rank != card3.rank && card1.rank != card3.rank) {
        return 1* MATCH_BONUS;
    }
    if (card1.color != card2.color && card2.color != card3.color && card1.color != card3.color) {
        return 1* MATCH_BONUS;
    }
    if (card1.shade != card2.shade && card2.shade != card3.shade && card1.shade != card3.shade) {
        return 1* MATCH_BONUS;
    }
    if (![card1.symbol isEqualToString:card2.symbol] && ![card2.symbol isEqualToString:card3.symbol] && ![card1.symbol isEqualToString:card3.symbol]) {
        return 1* MATCH_BONUS;
    }
    return 0;
}



- (NSString *)contents {
    NSMutableString *str = [[NSMutableString alloc]init];
    for (int i = 0; i < self.rank; i++) {
        [str appendString:self.symbol];
        
    }
    return str;
}

- (NSAttributedString *) attributedContents {
    NSString *newSymbol = self.symbol;
    if (self.shade == 2) {
        if ([self.symbol isEqualToString:@"●"]) {
             newSymbol = @"○";
        }
        else if ([self.symbol isEqualToString:@"■"]) {
             newSymbol = @"☐";
        }
        else if ([self.symbol isEqualToString:@"▲"]) {
             newSymbol = @"△";
        }
    }
    NSMutableString *str = [[NSMutableString alloc]init];
    for (int i = 0; i < self.rank; i++) {
        [str appendString:newSymbol];
        if (i != self.rank - 1) {
            [str appendString:@" "];
        }
    }

    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:str];
    [string addAttribute:NSForegroundColorAttributeName value:[SetCard validColors][self.color] range:NSMakeRange(0,str.length)];
    if (self.shade == 1) {
        [string addAttributes:@{
                            NSStrokeWidthAttributeName : @-13,
                            NSStrokeColorAttributeName : [UIColor blackColor] } range:NSMakeRange(0,str.length)];
    } 
    return string;
}

@synthesize symbol = _symbol;

+ (NSArray *)validSymbols {
    return @[@"●", @"▲", @"■"];
}

+ (NSArray *)validShades {
    return @[@"?", @1, @2, @3];
}

- (NSString *)symbol {
    return _symbol ? _symbol : @"?";
}

- (void) setSymbol:(NSString *)symbol {
    if ([[SetCard validSymbols] containsObject:symbol]) {
        _symbol = symbol;
    }
}

+ (NSArray *)validRanks {
    return @[@"?", @"1", @"2", @"3"];
}

+ (NSArray *)validColors {
    return @[[UIColor yellowColor], [UIColor greenColor],[UIColor blueColor], [UIColor orangeColor]];
}


+ (NSUInteger) maxRank {
    return [[SetCard validRanks] count] - 1;
}
+ (NSUInteger) maxShade {
    return [[SetCard validShades] count] - 1;
}

+ (NSUInteger) maxColor {
    return [[SetCard validColors] count] - 1;
}

-(NSUInteger) getRank {
    return self.rank;
}
-(NSUInteger) getColor {
    return self.color;
}
-(NSUInteger) getShade {
    return self.shade;
}

- (void) setRank:(NSUInteger)rank {
    if (rank <= [SetCard maxRank]) {
        _rank = rank;
    }
}



@end
