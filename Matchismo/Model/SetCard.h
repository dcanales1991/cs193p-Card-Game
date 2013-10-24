//
//  SetCard.h
//  Matchismo
//
//  Created by Diego Canales on 10/16/13.
//  Copyright (c) 2013 Diego Canales. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (strong, nonatomic) NSString *symbol;
@property (nonatomic) NSUInteger rank;
@property (nonatomic) NSUInteger color;
@property (nonatomic) NSUInteger shade;



+ (NSArray *)validSymbols;
+ (NSArray *)validShades;
+ (NSArray *)validColors;
+ (NSUInteger)maxRank;
+ (NSUInteger)maxColor;
+ (NSUInteger)maxShade;
-(NSUInteger) getRank;
-(NSUInteger) getColor;
-(NSUInteger) getShade;

@end
