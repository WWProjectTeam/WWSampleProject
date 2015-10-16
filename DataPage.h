//
//  DataPage.h
//  AiShouAPP
//
//  Created by push on 15/4/14.
//  Copyright (c) 2015年 suwang All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataPage : NSObject
@property (readonly, nonatomic, assign) NSUInteger      pageSize;       //分页大小
@property (readonly, nonatomic, assign) NSArray         *data;          //数据容器的快捷访问方法

@property (nonatomic, assign) NSUInteger                pageCount;      //数据的总分页数目

+ (id)pageWithPageSize:(NSUInteger)pageSize;
+ (id)page;

- (id)initWithPageSize:(NSUInteger)pageSize;
- (id)init; //init with default page size 15



/*
 count
 返回当前数据容器中拥有的数据个数
 */
- (NSUInteger)count;

/*
 canLoadMore
 查询是否还有未数据可以加载. (根据pageCount和当前pageIndexRange进行判断)
 */
- (BOOL)canLoadMore;

/*
 nextPageIndex
 返回当前数据的下一页数据的分页索引值
 
 Special Considerations:
 此方法不会判断是否已经超出了分页的总大小.
 */
- (NSUInteger)nextPageIndex;

//- (NSUInteger)asNext

/*
 appendPage:
 在当前数据容器中加上一个分页的数据
 
 Parameters
 pageData:   一个分页大小的数据
 */
- (void)appendPage:(NSArray *)pageData;
- (void)appendData:(id)objectData;
////加载本地数据
- (void)appendLocadData:(NSArray *)locadData;


/*
 deleteData:
 删除当前数据容器中的一个指定数据
 
 Parameters
 data:   当前数据容器中需要移除的数据对象
 !!!!!   删除数据不会影响当前的分页索引数值. 当前是第几页，删除一些数据后仍然是第几页。
 */
- (void)deleteData:(id)data;
- (void)deleteDatas:(NSArray* )datas;
- (void)deleteDataAtIndex:(NSUInteger)index;
/*
 cleanAllData
 清除当前携带的所有数据。恢复到没有任何数据时的状态
 */
- (void)cleanAllData;
////清空本地数据
- (void)cleanLocationData;

//- (void)

- (void)setDataHasNextPage:(NSInteger)hasPage;
- (void)setFirst:(NSInteger)next;
@end

