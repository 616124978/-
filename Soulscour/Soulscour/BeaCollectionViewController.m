//
//  BeaCollectionViewController.m
//  Soulscour
//
//  Created by lanou on 16/10/29.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "BeaCollectionViewController.h"

#import "CHCardItemModel.h"

@interface BeaCollectionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//收藏数组
@property(nonatomic,strong)NSMutableArray *dataArray;


@end

@implementation BeaCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title=@"我的美图文收藏";
    
    [self initTableView];
    
}

-(void)initTableView
{

    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
  
    
}

#pragma mark tableview delegate 方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{


    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    CHCardItemModel *model=self.dataArray[indexPath.row];
    cell.textLabel.text=model.title;
    return cell;

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
