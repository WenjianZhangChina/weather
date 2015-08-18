//
//  ViewController.h
//  weather
//
//  Created by zwj on 15/8/17.
//  Copyright (c) 2015年 SJTU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UITableViewController<UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) NSDictionary *weatherDict;
@property (nonatomic, strong) NSDictionary *innerDict;
@property (nonatomic, strong) NSArray *weatherArray;


@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UILabel *condLabel;
@property (weak, nonatomic) IBOutlet UILabel *tmpLabel;
@property (weak, nonatomic) IBOutlet UILabel *windLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxTmpLabel;
@property (weak, nonatomic) IBOutlet UILabel *minTmpLabel;
@property (weak, nonatomic) IBOutlet UILabel *time1Label;
@property (weak, nonatomic) IBOutlet UILabel *time2Label;
@property (weak, nonatomic) IBOutlet UILabel *tmp1Label;
@property (weak, nonatomic) IBOutlet UILabel *tmp2Label;

@property (weak, nonatomic) IBOutlet UILabel *darkLabel;
@property (weak, nonatomic) IBOutlet UILabel *qltyLabel;
@property (weak, nonatomic) IBOutlet UITextView *seggestionText;

@end

