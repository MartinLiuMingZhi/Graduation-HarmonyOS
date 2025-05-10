@Preview
@Component
export struct MessageComponent {
  @State content: string = '124456786546768798765686866686786767676'
  @State isMe: boolean = false;
  @State avatar: string = 'https://tse3-mm.cn.bing.net/th/id/OIP-C.7GLMYPqMlt2LgkbPsOnDIAAAAA?w=181&h=180&c=7&r=0&o=5&pid=1.7';

  build() {
    Row({space: 5}) {
      if (!this.isMe) {
        Image(this.avatar)
          .width(40)
          .height(40)
          .borderRadius(20)
          .margin({ right: 5,left: 5 })
          .shadow({
            color: '#00000029',
            offsetX: 0,
            offsetY: 2,
            radius: 4
          })
      }
      // 消息气泡
      Stack({ alignContent: this.isMe ? Alignment.End : Alignment.Start }) {
        Text(this.content)
          .padding({ left: 16, top: 8, right: 16, bottom: 8 })
          .backgroundColor(this.isMe ? '#007AFF' : '#F5F5F5')
          .borderRadius(15)
          .fontColor(this.isMe ? Color.White : Color.Black)
          .fontSize(14)
          .lineHeight(20)
          .width('auto')
          .shadow({
            color: '#0000001A',
            offsetX: 0,
            offsetY: 1,
            radius: 2
          })
      }
      .width('80%')

      // 自己消息：头像在右
      if (this.isMe) {
        Image(this.avatar)
          .width(40)
          .height(40)
          .borderRadius(20)
          .margin({ left: 5,right: 5 })
          .shadow({
            color: '#00000029',
            offsetX: 0,
            offsetY: 2,
            radius: 4
          })
      }
    }
    .width('100%')
    .justifyContent(this.isMe ? FlexAlign.End  : FlexAlign.Start )
    .margin({ top: 12})
    .alignItems(VerticalAlign.Top)
  }
}