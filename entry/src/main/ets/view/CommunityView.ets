import { DynamicItem } from "./DynamicItem";
import { TitleBar } from "./TitleBar"
import { router } from "@kit.ArkUI";
import { DynamicDataSource, DynamicItemData } from "../data/DynamicDataSource";
import { getPostList } from "../apis/post";


@Preview
@Component
export struct CommunityView {
  @State items: DynamicItemData[] = []
  private dataSource: DynamicDataSource = new DynamicDataSource();

  @StorageLink('pathStack') pathStack: NavPathStack = new NavPathStack();

  @State minSize: number = 80;
  @State maxSize: number = 180;

  aboutToAppear(): void {
    this.getPostList()
  }

  private async getPostList(){
    const result = await getPostList<DynamicItemData[]>()
    console.log('获取动态列表成功:', JSON.stringify(result.data))
    if(result.code === '200'){
      this.items = result.data
      this.dataSource.setDataArray(this.items)
      console.log('dataSource',JSON.stringify(this.dataSource))
    }else {
      console.error('获取动态列表失败:', JSON.stringify(result.msg))
    }
  }

  build() {
    Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center }){
      Column(){
          TitleBar({
            title: '社区',
            leftIcon: $r('app.media.ic_vip'),
            rightIcon: $r('app.media.ic_add'),
            rightIconClick: () => {
              this.pathStack.pushPathByName('PostEditorPage',null)
            }
          })

          WaterFlow(){
            // 使用LazyForEach需要实现IDataSource接口
            LazyForEach(this.dataSource, (item: DynamicItemData,index:number) => {
              FlowItem(){
                DynamicItem({
                  dynamic_title: item.title,
                  dynamic_img: item.imageUrls[0],
                  dynamic_avatar: 'https://ts1.cn.mm.bing.net/th/id/R-C.57384e4c2dd256a755578f00845e60af?rik=uy9%2bvT4%2b7Rur%2fA&riu=http%3a%2f%2fimg06file.tooopen.com%2fimages%2f20171224%2ftooopen_sy_231021357463.jpg&ehk=whpCWn%2byPBvtGi1%2boY1sEBq%2frEUaP6w2N5bnBQsLWdo%3d&risl=&pid=ImgRaw&r=0',
                  dynamic_name: item.userId,
                  dynamic_likes: item.likeCount.toString(),
                  dynamic_like_state: index % 2 === 0 ? true : false
                })
              }
              // 瀑布流项目样式
              .width('100%')
              .margin({ bottom: 10 })
            }, (item: DynamicItemData,index:number) => index.toString())
          }
          .layoutWeight(1)
          .layoutDirection(FlexDirection.Column)
          .columnsTemplate('1fr 1fr')
          .columnsGap(5)
          .rowsGap(10)
          .scrollBar(BarState.Off)
          .backgroundColor($r('app.color.white_background'))
          .margin({ left: 5, right: 5 })

      }
    }
    .width('100%')
    .height('100%')
  }
}