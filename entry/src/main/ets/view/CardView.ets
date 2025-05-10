import { LoginResponse } from "../apis/api"
import { MIText } from "./MIText"

@Component
@Preview
export struct CardView {
  @Prop user: LoginResponse

  build() {
    Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center }) {
      Column() {
        // 卡片头部
        Row() {
          Image(this.user.avatar)
            .width(40)
            .height(40)
            .borderRadius(12)
            .margin({ right: 10 , top:10, left:10 })

          Text(this.user.username)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
        }
        .width('100%')
        .height('auto')
        .padding({ top: 12, bottom: 8, left: 12, right: 12 })
        .border({ width: 0, color: '#e0e0e0', radius: 0 })

        Divider().margin({ left: 12, right: 12, top: 4, bottom: 8 })

        // 卡片内容
        Row({ space: 20 }) {
          MIText({ number: '1', text: '好友' })
          MIText({ number: '2', text: '关注' })
          MIText({ number: '3', text: '动态' })
        }
        .justifyContent(FlexAlign.Center)
        .padding({ bottom: 16 })
      }
      .width('92%')
      .borderRadius(16)
      .backgroundColor(Color.White)
      .shadow({ radius: 12, color: 'rgba(0,0,0,0.08)', offsetX: 0, offsetY: 4 })
    }
    .width('100%')
  }
}
