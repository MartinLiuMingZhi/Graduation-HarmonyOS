import { verifyCode } from "../apis/mail"
import { CodeInputComponent } from "./CodeInputComponent"

@Builder
export function InputCodePageBuilder(){
  InputCodePage()
}

@Component
export struct InputCodePage{
  @State codeIsCorrect:boolean = false
  @State email:string = ''
  @StorageLink('pathStack') pathStack: NavPathStack = new NavPathStack();
  @State TimeDown:number = 60
  private countdownInterval: number | undefined = undefined


  aboutToAppear(): void {
    this.getEmail()
    this.startCountdown()
  }

  private async getEmail(){
    const param = this.pathStack.getParamByName("InputCodePage") as string[]
    this.email = param[0]
  }

  build() {
    NavDestination(){
      Column() {
        Text('输入验证码')
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .textAlign(TextAlign.Start)
          .margin({
            top: 20,
            bottom: 20,
          })
        CodeInputComponent({
          onCodeFinish:(code:string) =>{
            this.verifyCode(code)//接收结果回调
          },
          codeIsCorrect:this.codeIsCorrect//设置校验结果初始值
        })

        Row(){
          Text(`验证码已经发送到您的邮箱:${this.email}`)
            .fontSize(13)
            .fontColor($r('app.color.text_color'))

          Text('重新发送')
            .fontSize(13)
            .fontColor(this.TimeDown > 0 ? $r('app.color.text_color') : $r('app.color.blue'))
            .onClick(()=>{
              this.startCountdown()
            })
        }
        .width('100%')
        .margin({
          top:30
        })

        if (this.TimeDown > 0){
          Text(`(${this.TimeDown}s)`)
            .fontSize(13)
            .fontColor($r('app.color.text_color'))
            .width('100%')
            .textAlign(TextAlign.Start)
        }

        Text('未收到验证码？')
          .fontColor($r('app.color.blue'))
          .width('100%')
          .textAlign(TextAlign.Start)
      }
      .padding({
        left: 20,
        right: 20
      })
    }
  }
  private async verifyCode(code:string){
    const result = await verifyCode<string>({email:this.email,code:code})
    if (result.code === '200'){
      this.codeIsCorrect = true
      this.pathStack.pushPathByName('ChangePasswordPage',this.email)
    }else{
      this.codeIsCorrect = false
    }
  }

  // 在 InputCodePage 结构中添加倒计时方法
  private startCountdown(): void {
    // 清除已有定时器
    if (this.countdownInterval) {
      clearInterval(this.countdownInterval)
      this.countdownInterval = undefined
    }

    this.TimeDown = 60 // 重置时间

    this.countdownInterval = setInterval(() => {
      if (this.TimeDown > 0) {
        this.TimeDown -= 1
      } else {
        clearInterval(this.countdownInterval)
        this.countdownInterval = undefined
      }
    }, 1000)
  }

}