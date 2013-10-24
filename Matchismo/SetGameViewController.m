//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Diego Canales on 10/15/13.
//  Copyright (c) 2013 Diego Canales. All rights reserved.
//

#import "SetGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "HistoryViewController.h"

@interface SetGameViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (nonatomic, strong) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchReportLabel;
@property (nonatomic) NSMutableArray *selectedCards;
@property (nonatomic) Card *currCard;
@property (nonatomic) NSMutableArray *history;
@property (nonatomic) NSMutableArray *cardsInHistory;
@property (nonatomic) NSMutableArray *scores;
@property (weak, nonatomic) IBOutlet UILabel *reportLabel;



@end

@implementation SetGameViewController


-(NSMutableArray *) history {
    if (!_history) _history = [[NSMutableArray alloc] init];
    return _history;
}


-(NSMutableArray *) cardsInHistory {
    if (!_cardsInHistory) _cardsInHistory = [[NSMutableArray alloc] init];
    return _cardsInHistory;
}


-(NSMutableArray *) scores {
    if (!_scores) _scores = [[NSMutableArray alloc] init];
    return _scores;
}

- (CardMatchingGame *)game {
    if (!_game) _game = [[CardMatchingGame alloc]initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
    return _game;
}

-(Deck *) createDeck {
    return [[SetCardDeck alloc]init];
}

//Resets the game and udpates the UI
- (IBAction)touchResetButton:(UIButton *)sender {
    [self resetGame];
    [self updateUI];
    self.history = nil;
    self.reportLabel.text = @"Cards have been reset!"; //Overrides the label text that is generated in updateUI
    

}


//Reset game by setting self.game to a new instance of CardMatchingGame
- (void) resetGame {
  //  self.toggleGameType.enabled = true;
    int tempNumMatches = [self.game getGameMode];
    self.game = nil;
    [self.game setGameMode:tempNumMatches];
}


//get cards that are face up at the beginning of the turn
-(NSMutableArray *) cardsSelectedBeforeUpdate: (int)index {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (UIButton *cardButton in self.cardButtons) {
        int cardIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardIndex];
        if (card.isChosen && !card.isMatched) {
            [arr addObject:card.attributedContents];
        }
    }
    //Add the currently selected card
    Card *card = [self.game cardAtIndex:index];
    if (![arr containsObject:card.attributedContents]) {
        [arr addObject:card.attributedContents];
    }
    return arr;
}

- (IBAction)touchCardButton:(UIButton *)sender {
//    if (self.toggleGameType.enabled) self.toggleGameType.enabled = false;
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
        [cardButton setAttributedTitle:[self attributedTitleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

-(NSAttributedString *) attributedTitleForCard:(Card *)card {
    NSAttributedString *str = [[NSAttributedString alloc] init];
    return card.isChosen ? card.attributedContents : str;
}

//Update the label that shows the report for the game.  I have this code in the view controller because this code directly generates content for the view.
- (void) updateReportLabel {
    NSString *strToReport;
    NSMutableAttributedString *str;
    int resultType = [self.game getResultFromTurn];
    
    switch (resultType)
    {
        case MATCH_ID: //match (these constants are taken from the CardMatchingGame.h file
            strToReport = [NSString stringWithFormat:@"Found a match between"];
            str = [[NSMutableAttributedString alloc] initWithString:@"Found a match between "];
            [str appendAttributedString:[self getStringFromCardArray:self.selectedCards]];
            [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" for %d points", [self.game getScoreFromLastTurn]]]];
            [self.cardsInHistory addObject:[self getStringFromCardArray:self.selectedCards]];
            break;
        case NO_MATCH_ID: //no matchctedCards]];
            str = [[NSMutableAttributedString alloc] initWithString:@"2 point penalty!  Couldn't find a match between "];
            [str appendAttributedString:[self getStringFromCardArray:self.selectedCards]];
            break;
        case SELECT_ID: //select
            str = [[NSMutableAttributedString alloc] initWithString:@"You chose "];
            [str appendAttributedString:self.currCard.attributedContents];
            break;
        case UNSELECT_ID: //unselect
            str = [[NSMutableAttributedString alloc] initWithString:@"You unselected "];
            [str appendAttributedString:self.currCard.attributedContents];
            break;
        default:
            break;
    }
    self.reportLabel.attributedText = str;
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  Your score went to %d", self.game.score]]];
    [self.history addObject:str];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"history"]) {
        HistoryViewController *historyViewController = [segue destinationViewController];
        historyViewController.setGameHistory = self.history;
    }
}



//implodes the array of cards and returns a string of their contents concatenated together
- (NSAttributedString *) getStringFromCardArray: (NSMutableArray *)arr {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
    NSAttributedString *comma = [[NSAttributedString alloc] initWithString:@" , "];
    NSAttributedString *and = [[NSAttributedString alloc] initWithString:@" and "];
    int arrSize = [arr count];
    for (int i = 0; i < arrSize; i++) {
        NSAttributedString *contents = arr[i];
        [str appendAttributedString:contents];
        if (i != arrSize - 2) {
            [str appendAttributedString:comma];
        } else {
            [str appendAttributedString:and];
        }
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
