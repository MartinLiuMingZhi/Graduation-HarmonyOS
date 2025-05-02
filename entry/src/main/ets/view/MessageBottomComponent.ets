import { Message, sendSingleMessage } from "../apis/message"
import { emitter } from "@kit.BasicServicesKit"

@Preview
@Component
export struct MessageBottomComponent {
  @State message: string = ''
  @Prop toUserId: number
  @Link messageList: Message[]

  build() {
    Row() {
      TextArea()
        .width('75%')
        .height(35)
        .backgroundColor(Color.White)
        .onChange((value: string) => {
          this.message = value
        })

      Button('发送', { type: ButtonType.Normal })
        .width('20%')
        .height(30)
        .borderRadius(5)
        .onClick(() => {
          console.log('点击了按钮')
          this.sendMessage()
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
    .height(40)
    .backgroundColor('#FFF5F5F5')
    .padding(10)
  }

  private async sendMessage() {
    // 发送消息
    const result = await sendSingleMessage<Message>(this.toUserId, this.message)
    if (result.code === '200') {
      console.log('SendMessage:', JSON.stringify(result.data))
      this.messageList.push(result.data)
    } else {
      console.error('SendMessage:', JSON.stringify(result.msg))
    }
  }
}