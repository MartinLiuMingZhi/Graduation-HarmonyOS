@Preview
@Component
export struct MessageComponent {
  @State content: string = '根据研究机构Counterpoint Research发布的最新数据，2024年第一季度，鸿蒙OS份额由去年一季度的8%上涨至17%，iOS份额则从20%下降至16%。\n' +
    '这意味着，华为鸿蒙OS在中国市场的份额超越苹果iOS，已成中国第二大操作系统\n' +
    '随着鸿蒙市场份额的不断提升，相应的岗位也会迎来一个爆发式的增长。这对于想要换赛道的程序员来说是一个非常好的消息，话说大家最近有想法转型鸿蒙开发吗？\n' +
    '————————————————\n' +
    '\n' +
    '                            版权声明：本文为博主原创文章，遵循 CC 4.0 BY - SA 版权协议，转载请附上原文出处链接和本声明。\n' +
    '                        \n' +
    '原文链接：https://blog.csdn.net/HarmonyOS_001/article/details/139755588';
  @State isMe: boolean = true;
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
      Stack({ alignContent: Alignment.Start }) {
        Text(this.content)
          .padding({ left: 16, top: 8, right: 16, bottom: 8 })
          .backgroundColor(this.isMe ? '#007AFF' : '#F5F5F5')
          .borderRadius(15)
          .fontColor(this.isMe ? Color.White : Color.Black)
          .fontSize(14)
          .lineHeight(20)
          .width('100%')
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