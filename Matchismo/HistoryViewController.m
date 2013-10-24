//
//  HistoryViewController.m
//  Matchismo
//
//  Created by Diego Canales on 10/16/13.
//  Copyright (c) 2013 Diego Canales. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()
@property (weak, nonatomic) IBOutlet UITextView *historyText;

@end

@implementation HistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    if (self.setGameHistory != nil) {
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@""];
        [attrStr appendAttributedString: self.historyText.attributedText];
        for (int i = 0; i < [self.setGameHistory count]; ++i) {
            [attrStr appendAttributedString:self.setGameHistory[i]];
            [attrStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
            self.historyText.attributedText = attrStr;
        }
    } else if (self.regularCardGameHistory != nil) {
        NSMutableString *str = [[NSMutableString alloc] initWithString:self.historyText.text];
        for (int i = 0; i < [self.regularCardGameHistory count]; ++i) {
            [str appendString:@"\n\n"];
            [str appendString:self.regularCardGameHistory[i]];
        }
        self.historyText.text = str;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
