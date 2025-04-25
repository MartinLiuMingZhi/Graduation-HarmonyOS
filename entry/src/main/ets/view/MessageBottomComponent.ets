@Preview
@Component
export struct MessageBottomComponent {
  @State message: string = ''

  build() {
    Row() {
      TextArea()
        .width('75%')
        .height(50)
        .backgroundColor(Color.White)
        .onChange((value: string) => {
          this.message = value
        })

      Button('发送', { type: ButtonType.Normal })
        .width('20%')
        .borderRadius(5)
        .onClick(() => {
          console.log('发送消息:', this.message)
        })
        .margin({
          left: 10
        })

      // Image($r('app.media.ic_add_white'))
      //   .width(40)
      //   .height(40)
      //   .margin({
      //     left: 10
      //   })
    }
    .width('100%')
    .height(60)
    .backgroundColor('#ffe2d9d9')
    .padding(10)
  }
}