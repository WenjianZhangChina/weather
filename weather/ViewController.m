//
//  ViewController.m
//  weather
//
//  Created by zwj on 15/8/17.
//  Copyright (c) 2015年 SJTU. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITextFieldDelegate,UITextViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg  {
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, HttpArg];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: @"请替换成您自己的密钥" forHTTPHeaderField: @"apikey"];
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
                               } else {
                                   NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                   
                                   //  解析JSON，所有数据放在innerDict字典中
                                   self.weatherDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                                   NSLog(@"HttpResponseCode:%ld", responseCode);
                                   self.weatherArray = [self.weatherDict objectForKey:@"HeWeather data service 3.0"];
                                   self.innerDict = [self.weatherArray objectAtIndex:0];
                                   
                                   // 静态表第一组，现在天气和气温
                                   NSDictionary *nowDict = [self.innerDict objectForKey:@"now"];
                                   NSDictionary *condDict = [nowDict objectForKey:@"cond"];
                                   self.condLabel.text = [condDict objectForKey:@"txt"];
                                   NSMutableString *tmp= [[NSMutableString alloc] initWithString:[nowDict objectForKey:@"tmp"]];
                                   [tmp appendString:@"℃"];
                                   self.tmpLabel.text = tmp;
                                   
                                   // 静态表第二组，第一排日期和最高温最低温
                                   NSArray *dailyArray = [self.innerDict objectForKey:@"daily_forecast"];
                                   NSDictionary *today = [dailyArray objectAtIndex:0];
                                   NSDictionary *tmpToday = [today objectForKey:@"tmp"];
                                   self.dateLabel.text = [today objectForKey:@"date"];
                                   self.maxTmpLabel.text = [tmpToday objectForKey:@"max"];
                                   self.minTmpLabel.text = [tmpToday objectForKey:@"min"];
                                   // 第二排第三排显示接下来的温度变化
                                   NSArray *hourlyArray = [self.innerDict objectForKey:@"hourly_forecast"];
                                   NSDictionary *time1Dict = [hourlyArray objectAtIndex:0];
                                   NSString *time1 = [time1Dict objectForKey:@"date"];
                                   self.time1Label.text = [time1 substringFromIndex:11];
                                   NSMutableString *tmp1 = [[NSMutableString alloc] initWithString:[time1Dict objectForKey:@"tmp"]];
                                   [tmp1 appendString:@"℃"];
                                   self.tmp1Label.text = tmp1;
                                   NSDictionary *time2Dict = [hourlyArray objectAtIndex:1];
                                   NSString *time2 = [time2Dict objectForKey:@"date"];
                                   self.time2Label.text = [time2 substringFromIndex:11];
                                   NSMutableString *tmp2 = [[NSMutableString alloc] initWithString:[time2Dict objectForKey:@"tmp"]];
                                   [tmp2 appendString:@"℃"];
                                   self.tmp2Label.text = tmp2;
                                   
                                   // 补充风向风速
                                   NSDictionary *windDict = [today objectForKey:@"wind"];
                                   NSMutableString *wind = [[NSMutableString alloc] initWithString:[windDict objectForKey:@"dir"]];
                                   [wind appendString:[windDict objectForKey:@"sc"]];
                                   self.windLabel.text = wind;
                                   
                                   // 判断天黑天亮
                                   NSDate *  senddate=[NSDate date];
                                   NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
                                   [dateformatter setDateFormat:@"HH:mm"];
                                   NSString *  locationString=[dateformatter stringFromDate:senddate];
                                   //NSLog(@"%@", locationString);
                                   NSDictionary *astroDict = [today objectForKey:@"astro"];
                                   NSString *sr = [astroDict objectForKey:@"sr"];
                                   NSString *ss = [astroDict objectForKey:@"ss"];
                                   BOOL afterSr = [locationString compare:sr];
                                   BOOL beforeSS = [ss compare:locationString];
                                   if(afterSr && beforeSS) self.darkLabel.text = @"否";
                                   else self.darkLabel.text = @"是";
                                   
                                   // 空气质量
                                   NSDictionary *aqiDict = [self.innerDict objectForKey:@"aqi"];
                                   NSDictionary *cityDict = [aqiDict objectForKey:@"city"];
                                   self.qltyLabel.text = [cityDict objectForKey:@"qlty"];
                                   
                                   // 天气情况和建议
                                   NSDictionary *suggestionDict = [self.innerDict objectForKey:@"suggestion"];
                                   NSDictionary *comfDict = [suggestionDict objectForKey:@"comf"];
                                   NSMutableString *suggestionTxt = [[NSMutableString alloc] initWithString:[comfDict objectForKey:@"txt"]];
                                   NSDictionary *drsgDict = [suggestionDict objectForKey:@"drsg"];
                                   [suggestionTxt appendString:[drsgDict objectForKey:@"txt"]];
                                   NSDictionary *travDict = [suggestionDict objectForKey:@"trav"];
                                   [suggestionTxt appendString:[travDict objectForKey:@"txt"]];
                                   self.seggestionText.text = suggestionTxt;
                               }
                           }];
}


#pragma mark -UITextField Delegate Method
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

/*
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //开始编辑时触发，文本字段将成为first responder
}
*/
-(void) viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [super viewWillAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

-(void) keyboardDidShow: (NSNotification *)notif{
}

// 当键盘关闭时显示天气信息
-(void) keyboardDidHide: (NSNotification *)notif{
    NSString *httpUrl = @"http://apis.baidu.com/heweather/weather/free";
    NSString *city = self.cityTextField.text;
    NSMutableString *httpArg = [[NSMutableString alloc] initWithString:@"city="];
    [httpArg appendString:city];
    [self request: httpUrl withHttpArg: httpArg];    
}

@end
