import { MIText } from "./MIText"

@Component
@Preview
export struct CardView {

  build() {
    Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center }) {
      Column() {
        // 卡片头部
        Row() {
          Image($r('app.media.imgIcon'))
            .width(40)
            .height(40)
            .borderRadius(10)
            .margin({ right: 10 , top:10, left:10 })

          Text('青春勿语')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
        }
        .width('100%')
        .height('auto')
        .padding({ top: 10, bottom: 10, left: 10, right: 10 })


        // 卡片内容
        Row({space:10}) {
            MIText({
              number:'1',
              text:'好友'
            })
            MIText({
              number:'2',
              text:'关注'
            })
            MIText({
              number:'3',
              text:'动态'
            })
        }
        .justifyContent(FlexAlign.Center)
        .margin({
          bottom:10
        })

      }
      .width('90%')
      .height('auto')
      .borderRadius(10)
      .backgroundColor(Color.White)
      .shadow(10)
    }
    .width('100%')
    .height('auto')
  }
}
