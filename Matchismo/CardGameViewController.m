//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Diego Canales on 9/28/13.
//  Copyright (c) 2013 Diego Canales. All rights reserved.
//

#import "CardGameViewController.h"
#import "Deck.h"
#import "PlayingCardDeck.h"
#import "Card.h"
#import "CardMatchingGame.h"
#import "HistoryViewController.h"


@interface CardGameViewController ()
//@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
//@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;

@property (nonatomic, strong) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISwitch *toggleGameType;
@property (weak, nonatomic) IBOutlet UILabel *matchReportLabel;
@property (nonatomic) NSMutableArray *selectedCards;
@property (nonatomic) NSMutableArray *history;
@property (nonatomic) Card *currCard;

-(NSMutableArray *) cardsSelectedBeforeUpdate: (int)index;
@end

@implementation CardGameViewController

- (CardMatchingGame *)game {
    if (!_game) _game = [[CardMatchingGame alloc]initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
    [_game setGameMode:2];
    return _game;
}


-(NSMutableArray *) history {
    if (!_history) _history = [[NSMutableArray alloc] init];
    return _history;
}

//Resets the game and udpates the UI
- (IBAction)touchResetButton:(UIButton *)sender {
    [self resetGame];
    [self updateUI];
    self.matchReportLabel.text = @"Cards have been reset!"; //Overrides the label text that is generated in updateUI
    self.history = nil;
}


//Reset game by setting self.game to a new instance of CardMatchingGame
- (void) resetGame {
    self.toggleGameType.enabled = true;
    int tempNumMatches = [self.game getGameMode];
    self.game = nil;
    [self.game setGameMode:tempNumMatches];
}


-(Deck *) createDeck {
    return [[PlayingCardDeck alloc]init];
}


//This is called when the UISwitch is toggled
- (IBAction)touchNumberMatchesSwitch:(UISwitch *)sender {
    if ([self.game getGameMode] == GAME_MODE_1){
        [self.game setGameMode:GAME_MODE_2];
        self.matchReportLabel.text = [NSString stringWithFormat:@"Switched to a %d match game!", GAME_MODE_2];
    } else {
        [self.game setGameMode:GAME_MODE_1];
        self.matchReportLabel.text = [NSString stringWithFormat:@"Switched to a %d match game!", GAME_MODE_1];
    }
}

//get cards that are face up at the beginning of the turn
-(NSMutableArray *) cardsSelectedBeforeUpdate: (int)index {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (UIButton *cardButton in self.cardButtons) {
        int cardIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardIndex];
        if (card.isChosen && !card.isMatched) {
            [arr addObject:[NSString stringWithFormat:@"%@ ", card.contents]];
        }
    }
    //Add the currently selected card
    Card *card = [self.game cardAtIndex:index];
    if (![arr containsObject:[NSString stringWithFormat:@"%@ ", card.contents]]) {
        [arr addObject:[NSString stringWithFormat:@"%@ ", card.contents]];
    }
    return arr;
}

- (IBAction)touchCardButton:(UIButton *)sender {
    if (self.toggleGameType.enabled) self.toggleGameType.enabled = false;
    int cardIndex = [self.cardButtons indexOfObject:sender];
    self.currCard = [self.game cardAtIndex:cardIndex];
    self.selectedCards = [self cardsSelectedBeforeUpdate:cardIndex];
    [self.game chooseCardAtIndex:cardIndex];
    
    [self updateUI]; //"Sinks up the model with the UI"
}

-(void)updateUI {
    [self updateReportLabel];
    for (UIButton *cardButton in self.cardButtons) {
        int cardIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}



//Update the label that shows the report for the game.  I have this code in the view controller because this code directly generates content for the view.
- (void) updateReportLabel {
    NSMutableString *strToReport = [[NSMutableString alloc] init];
    int resultType = [self.game getResultFromTurn];
    
    switch (resultType)
    {
        case MATCH_ID: //match (these constants are taken from the CardMatchingGame.h file
            [strToReport appendString:[NSString stringWithFormat:@"Found a match between %@for %d points",[self getStringFromCardArray:self.selectedCards], [self.game getScoreFromLastTurn]]];
            break;
        case NO_MATCH_ID: //no match
            [strToReport appendString:[NSString stringWithFormat:@"2 point penalty!  Couldn't find a match between %@", [self getStringFromCardArray:self.selectedCards]]];
            break;
        case SELECT_ID: //select
            [strToReport appendString:[NSString stringWithFormat:@"You chose %@", self.currCard.contents]];
            break;
        case UNSELECT_ID: //unselect
            [strToReport appendString:[NSString stringWithFormat:@"You unselected %@", self.currCard.contents]];
            break;
        default:
            break;
    }
    self.matchReportLabel.text = strToReport;
    [strToReport appendString:[NSString stringWithFormat:@"  Your score went to %d", self.game.score]];
    [self.history addObject:strToReport];
  
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"history"])
    {
        HistoryViewController *historyViewController = [segue destinationViewController];
        
        historyViewController.regularCardGameHistory = self.history;
    }
}



//implodes the array of cards and returns a string of their contents concatenated together
- (NSString *) getStringFromCardArray: (NSMutableArray *)arr {
    NSMutableString *str = [[NSMutableString alloc] init];
    for (NSString *contents in arr) {
        [str appendString:[NSString stringWithFormat:@"%@ ",contents]];
    }
    return str;
}


-(NSString *) titleForCard:(Card *)card {
    return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card {
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

@end
