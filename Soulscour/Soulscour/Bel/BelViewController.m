//
//  BelViewController.m
//  Article
//
//  Created by 小强 on 16/10/26.
//  Copyright © 2016年 xiaoqiang. All rights reserved.


#import "BelViewController.h"
#import "SecViewController.h"
#import "BelTableViewCell.h"
#import "BelModel.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "AppDelegate.h"

#define sKscreenWidth   [UIScreen mainScreen].bounds.size.width
#define sKscreenHeight  [UIScreen mainScreen].bounds.size.height

@interface BelViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSTimeInterval *currentTime ;
    BOOL isMore;
    NSString *str;
}

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation BelViewController

//封装tableView
-(void)initTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, sKscreenWidth, sKscreenHeight-113) style:UITableViewStyleGrouped] ;
 
    self.tableView.delegate =self;
    self.tableView.dataSource =self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    //注册cell
    [self.tableView registerClass:[BelTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    
}


-(void) initleftSliderBtn {
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(0, 0, 20, 18);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(openOrCloseLeftList) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
}

- (void) openOrCloseLeftList
{
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (tempAppDelegate.LeftSlideVC.closed)
    {
        [tempAppDelegate.LeftSlideVC openLeftView];
    }
    else
    {
        [tempAppDelegate.LeftSlideVC closeLeftView];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear");
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:YES];
    self.tabBarController.tabBar.hidden = NO;
    
    
}



//菊花的使用
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [[NSMutableArray alloc]init];
    
    self.view.backgroundColor = [UIColor cyanColor];
    [self initTableView];
    isMore =0;
    
    self.tableView.tableHeaderView = [[UIView alloc]init];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.showsVerticalScrollIndicator = NO;

    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    self.tableView.mj_header = header;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self reloadData];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    
    [self initleftSliderBtn];
}

//获取请求
-(void)url
{
   
        //生成Url
        NSURL *url = [NSURL URLWithString:str];
        
        //创建会话
        NSURLSession *session = [NSURLSession sharedSession];
        
        //创建任务
        NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data) {
                
                //解析数据
                NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"dic = %@",array);
                
                for (NSDictionary *dic in array) {
                    BelModel *model =[[BelModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [self.dataArray addObject:model];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.tableView reloadData];
                    
                    
                });
            }
        }];
        [task resume];
    
}

//加载下拉数据
- (void)loadData{
    
        str=@"http://jtbk.vipappsina.com/yulu/card21/article26.php?pad=0&markId=0";
    //清空数组，然后获取最新数据
    
    [self.dataArray removeAllObjects];
    [self url];
    [self.tableView.mj_header endRefreshing];
    
}
//获取下一个URL的ID
-(NSString *)nextID
{
    BelModel *model  = self.dataArray.lastObject;
    NSString *last =model.id1;
    NSLog(@"last =%@",last);
    NSInteger las =[last intValue]-2;
    NSString *nextId =[NSString stringWithFormat:@"%d",las];
    NSLog(@"%@",nextId);
    return nextId;
}

//加载上拉数据
-(void)reloadData
    {
        if (isMore ==0) {
          
            str =[NSString stringWithFormat:@"http://jtbk.vipappsina.com/yulu/card21/article26.php?id=%@&pad=1",[self nextID]];
            isMore ++;
        }else if (isMore>=1)
        {
            str =[NSString stringWithFormat:@"http://jtbk.vipappsina.com/yulu/card21/article26.php?id=%@&pad=1",[self nextID]];
        }
        
        [self url];
        [self.tableView.mj_footer endRefreshing];
    
    }

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BelModel *model =self.dataArray[indexPath.row];
    BelTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.titleLabel.text =model.title;
    cell.timeLabel.text = model.CTime;
    
    NSURL *url =[NSURL URLWithString:model.pic];
    [cell.image sd_setImageWithURL:url];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BelModel *model = self.dataArray[indexPath.row];
    
    SecViewController *SVC =[[SecViewController alloc]init];
    
    SVC.mode =model;
    
    [self.navigationController pushViewController:SVC animated:YES];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 270;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
