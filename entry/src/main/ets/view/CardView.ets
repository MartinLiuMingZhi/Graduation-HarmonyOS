@Component
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

          Text('Username')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
        }
        .width('100%')
        .height('auto')
        .padding({ top: 10, bottom: 10, left: 10, right: 10 })

        // 卡片内容
        Text('This is a sample card with more content.')
          .fontSize(14)
          .fontColor($r('app.color.light_blue'))
          .padding({ top: 10, bottom: 10,  right: 10 })

        // 卡片底部
        // Row() {
        //   Button('Action')
        //     .width('50%')
        //     .height(40)
        //     .backgroundColor(Color.Green)
        //     .borderRadius(10)
        //     .margin({ right: 10 })
        //
        //   Button('Cancel')
        //     .width('50%')
        //     .height(40)
        //     .backgroundColor($r('app.color.black'))
        //     .borderRadius(10)
        // }
        // .width('100%')
        // .height('auto')
        // .padding({ top: 10, bottom: 10, left: 10, right: 10 })
      }
      .width('90%')
      .height('auto')
      .borderRadius(10)
      .backgroundColor(Color.White)
      .shadow(10)
    }
    .width('100%')
    .height('100%')
  }
}
