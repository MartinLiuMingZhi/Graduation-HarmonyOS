import { DynamicItem } from "./DynamicItem";
import { TitleBar } from "./TitleBar"


// 定义一个接口来表示 items 数组中的对象
interface DynamicItemData {
  dynamic_title: string;
  dynamic_img: string;
  dynamic_avatar: string;
  dynamic_name: string;
  dynamic_likes: string;
  dynamic_like_state: boolean;
}

@Preview
@Component
export struct CommunityView {
  @State items: DynamicItemData[] = new Array(100).fill(null).map((_: null, i: number): DynamicItemData => ({
    dynamic_title: `动态标题 ${i + 1}`,
    dynamic_img: 'https://ts1.cn.mm.bing.net/th/id/R-C.57384e4c2dd256a755578f00845e60af?rik=uy9%2bvT4%2b7Rur%2fA&riu=http%3a%2f%2fimg06file.tooopen.com%2fimages%2f20171224%2ftooopen_sy_231021357463.jpg&ehk=whpCWn%2byPBvtGi1%2boY1sEBq%2frEUaP6w2N5bnBQsLWdo%3d&risl=&pid=ImgRaw&r=0',
    dynamic_avatar: 'https://ts1.cn.mm.bing.net/th/id/R-C.57384e4c2dd256a755578f00845e60af?rik=uy9%2bvT4%2b7Rur%2fA&riu=http%3a%2f%2fimg06file.tooopen.com%2fimages%2f20171224%2ftooopen_sy_231021357463.jpg&ehk=whpCWn%2byPBvtGi1%2boY1sEBq%2frEUaP6w2N5bnBQsLWdo%3d&risl=&pid=ImgRaw&r=0',
    dynamic_name: `用户 ${i + 1}`,
    dynamic_likes: `${Math.floor(Math.random() * 1000)}`,
    dynamic_like_state: Math.random() > 0.5,
  }));



  build() {
    Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center }){
      Column(){
          TitleBar({
            title: '社区',
            leftIcon: $r('app.media.ic_vip'),
            rightIcon: $r('app.media.ic_add')
          })

        Grid(){
          ForEach(this.items, (item: DynamicItemData, index: number) => {
            GridItem() {
              DynamicItem({
                dynamic_title: item.dynamic_title,
                dynamic_img: item.dynamic_img,
                dynamic_avatar: item.dynamic_avatar,
                dynamic_name: item.dynamic_name,
                dynamic_likes: item.dynamic_likes,
                dynamic_like_state: item.dynamic_like_state
              })
            }
          }, (item: DynamicItemData, index: number): string => index.toString()) // 将 index 转为 string 类型

        }
        .columnsTemplate('1fr 1fr')
        .columnsGap(5)
        .rowsGap(5)
        .scrollBar(BarState.Off)
        .backgroundColor($r('app.color.white_background'))
        .margin({
          left:5,
          right:5
        })

      }
    }
    .width('100%')
    .height('100%')
  }
}