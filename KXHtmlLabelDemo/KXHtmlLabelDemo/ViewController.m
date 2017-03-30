// ViewController.m
// Copyright (c) 2016-2017 kxzen ( https://github.com/kxzen/KXHtmlLabel )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ViewController.h"
#import "KXHtmlLabel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupViews];
}

-(void) setupViews{
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.backgroundColor = [UIColor yellowColor];
    label1.textColor = [UIColor blackColor];
    label1.textAlignment = NSTextAlignmentLeft;
    label1.translatesAutoresizingMaskIntoConstraints = NO;
    [label1 setHtml:@"<p align=\"right\"><b>This is a </b><font size=\"+4\">Bigger</font> world <i class=\"fa-globe\"></i>!</p> <p align=\"left\"><font color=\"#1899c4\">This is a <font color=\"#f04b05\"><b>left aligned</b></font> text</font></p>"];
    [self.view addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.backgroundColor = [UIColor clearColor];
    label2.textColor = [UIColor blackColor];
    label2.textAlignment = NSTextAlignmentLeft;
    label2.translatesAutoresizingMaskIntoConstraints = NO;
    [label2 setHtml:@"<p align=\"center\"><font size=\"12\"><i class=\"fa-coffee\"></i></font> <b>This is <u>awesome</u>!</b> <font size=\"20\"><i class=\"fa-bus\"></i></font> <font size=\"30\"><i class=\"fa-volume-up\"></i></font></p>"];
    [self.view addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc] init];
    label3.backgroundColor = [UIColor clearColor];
    label3.textColor = [UIColor blackColor];
    label3.textAlignment = NSTextAlignmentLeft;
    label3.translatesAutoresizingMaskIntoConstraints = NO;
    [label3 setHtml:@"<p align=\"justify\"><font color=\"#808080\" face=\"BradleyHandITCTT-Bold\">The quick <s>brown</s> fox <b>jumps</b> over the <u><font size=+8>lazy</font></u> dog</font></p>"];
    [self.view addSubview:label3];
    
    
    UILabel *label4 = [[UILabel alloc] init];
    label4.backgroundColor = [UIColor clearColor];
    label4.textColor = [UIColor blackColor];
    label4.textAlignment = NSTextAlignmentLeft;
    label4.translatesAutoresizingMaskIntoConstraints = NO;
    [label4 setHtml:@"<p align=\"left\">is a <font size=+4 bgcolor=\"#21a310\" color=\"#ffffff\">sentence</font> that <font size=-2>contains</font> all of the <u>letters</u> of the <b><font bgcolor=\"#2284d4\" color=\"#ffffff\">alphabet</font></b>.</p><br><font size=\"38\" color=\"#9830c9\"><i class=\"fa-bicycle\"></i></font>"];
    [self.view addSubview:label4];
    
    // font weight only works on iOS 8.2 and above.
    UILabel *label5 = [[UILabel alloc] init];
    label5.backgroundColor = [UIColor clearColor];
    label5.textColor = [UIColor blackColor];
    label5.textAlignment = NSTextAlignmentLeft;
    label5.translatesAutoresizingMaskIntoConstraints = NO;
    [label5 setHtml:@"<font weight=ultralight>ULTRALIGHT</font> <font weight=\"thin\">THIN</font> <font weight=\"light\">LIGHT</font> <font weight=\"regular\">REGULAR</font> <font weight=\"medium\">MEDIUM</font> <font weight=\"semibold\">SEMIBOLD</font> <font weight=\"bold\">BOLD</font> <font weight=heavy >HEAVY</font>"];
    [self.view addSubview:label5];
    
    UILabel *label6 = [[UILabel alloc] init];
    label6.backgroundColor = [UIColor clearColor];
    label6.textColor = [UIColor colorWithWhite:0.25 alpha:1.0];
    label6.textAlignment = NSTextAlignmentLeft;
    label6.translatesAutoresizingMaskIntoConstraints = NO;
    [label6 setHtml:@"<p align='left' linespacing='17' linebreakmode=\"truncatetail\"><u><b>Line spacing</b></u> can be adjusted very <i>easily</i>. You can also control the <b><font size='+2' bgcolor=\"#f2e2a2\">linebreakmode</font></b> and you will find some words are truncated...because it is too long and it is very very very cool!!!</p>"];
    [self.view addSubview:label6];
    
    
    NSDictionary *views = @{@"topLayoutGuide": self.topLayoutGuide,
                            @"label1": label1,
                            @"label2": label2,
                            @"label3": label3,
                            @"label4": label4,
                            @"label5": label5,
                            @"label6": label6};
    
    NSDictionary *metrics = @{@"padding": @(15)};
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding)-[label1]-(padding)-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding)-[label2]-(padding)-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding)-[label3]-(padding)-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding)-[label4]-(padding)-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding)-[label5]-(padding)-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding)-[label6]-(padding)-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLayoutGuide]-(padding)-[label1]-(padding)-[label2]-(padding)-[label3]-(padding)-[label4]-(padding)-[label5]-(padding)-[label6(==120)]"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
