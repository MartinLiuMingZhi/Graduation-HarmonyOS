import { UserDTO } from "../apis/user"

@Preview
@Component
export struct FriendItem{
  @Prop item: UserDTO
  @State operation: string = '发私信'
  @StorageLink('pathStack') pathStack: NavPathStack = new NavPathStack();

  build() {
    Row() {
      Row(){
        Image(this.item.avatar)
          .width(50)
          .height(50)
          .borderRadius(25)
          .margin({
            left: 10,
            right: 10
          })
        Text(this.item.username)
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
          .onClick(() => {
            this.pathStack.pushPathByName('ChatView',this.item)
          })

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