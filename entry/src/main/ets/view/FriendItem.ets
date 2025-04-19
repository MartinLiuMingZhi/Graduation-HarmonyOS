@Preview
@Component
export struct FriendItem{
  @State avatar: string = 'https://tse1-mm.cn.bing.net/th/id/OIP-C.aCW_Ax9FtUGhnDBetciYoQAAAA?w=234&h=206&c=7&r=0&o=5&pid=1.7'
  @State name: string = '小明'
  @State operation: string = '发私信'


  build() {
    Row() {
      Row(){
        Image(this.avatar)
          .width(50)
          .height(50)
          .borderRadius(25)
          .margin({
            left: 10,
            right: 10
          })
        Text(this.name)
          .fontSize(16)
          .fontColor(Color.Black)
      }
      .justifyContent(FlexAlign.Start)

      Row(){
        Button(this.operation,{type:ButtonType.Normal})
          .fontSize(14)
          .borderRadius(10)
          .backgroundColor('#ffa09a9a')
          .width(80)
          .height(30)

        Image($r('app.media.ic_more2'))
          .width(20)
          .height(20)
          .margin({
            left: 10,
            right: 20
          })
      }
      .justifyContent(FlexAlign.End)
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width('100%')
    .height(60)
  }
}