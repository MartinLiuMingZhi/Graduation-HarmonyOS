import { IconColumnComponent } from "./IconColumnComponent"
import { MessageItem } from "./MessageItem"
import { TitleBar } from "./TitleBar"

@Component
@Preview
export struct MessageView {

  build() {
    Column(){
      TitleBar({
        title:'消息',
        rightIcon:$r('app.media.ic_group_chats')
      })

      Scroll(){
        Column(){
          Row() {
            IconColumnComponent({
              icon:$r('app.media.ic_like_favorite'),
              text:'赞和收藏'
            })

            IconColumnComponent({
              icon:$r('app.media.ic_new_friend'),
              text:'新朋友'
            })

            IconColumnComponent({
              icon:$r('app.media.ic_comment'),
              text:'评论和@'
            })
          }
          .width('100%')
          .height('auto')
          .justifyContent(FlexAlign.SpaceBetween)
          .padding({
            left: 30,
            right:30
          })

          MessageItem()
          MessageItem()
          MessageItem()
          MessageItem()
          MessageItem()
          MessageItem()
          MessageItem()
          MessageItem()
          MessageItem()
          MessageItem()
          MessageItem()
          MessageItem()
          MessageItem()
          MessageItem()
          MessageItem()
        }
      }
      .scrollBar(BarState.Off)
      .width('100%')
      .height('auto')
      .backgroundColor(Color.White)

    }
  }
}