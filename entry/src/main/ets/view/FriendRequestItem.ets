import { FriendRequestResponse } from "../apis/user"

@Preview
@Component
export struct FriendRequestItem{
  @Prop item:FriendRequestResponse
  private onCustomClick?: () => void

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
        Button(this.item.status === false ? '添加':'已添加',{type:ButtonType.Normal})
          .fontSize(14)
          .borderRadius(10)
          .backgroundColor(this.item.status === false ? Color.Red : Color.Gray)
          .width(80)
          .height(30)
          .margin({
            right: 20
          })
          .enabled(this.item.status === false ? true : false)
          .onClick(()=>{
            if (this.onCustomClick) {
                this.onCustomClick()
            }
          })
      }
      .justifyContent(FlexAlign.End)
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width('100%')
    .height(60)
  }
}