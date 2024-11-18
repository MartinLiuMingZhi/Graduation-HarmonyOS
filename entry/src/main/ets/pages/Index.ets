@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    Column(){
      Image($r('app.media.imgIcon'))
        .width(100)
        .height(100)
        .borderRadius(5)
        .margin({
          top: '120vh'
        })

      Text("音情协友")
        .fontColor(Color.Gray)
        .fontSize(14)
        .margin({
          top: '20vh',
        })

      Text("奏响心灵共鸣的交友旋律")
        .fontColor(Color.Gray)
        .fontSize(14)
        .margin({
          top: '10vh',
          bottom:'20vh'
        })

      TextInput({ placeholder:'请输入邮箱' })
        .margin({
          bottom:'10vh'
        })
      TextInput({ placeholder:'请输入密码' })
        .type(InputType.Password)

      Row(){
        Text("邮箱验证码登录")
          .fontColor(Color.Blue)
          .fontSize(14)
        Text("忘记密码")
          .fontColor(Color.Blue)
          .fontSize(14)
      }
      .width("90%")
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({
        top:'10vh',
        bottom:'50vh'
      })

      Button("登录")
        .width("90%")
        .type(ButtonType.Capsule)

      Text("注册账号")
        .fontColor(Color.Blue)
        .fontSize(14)
        .margin({
          top:'10vh'
        })

      LoadingProgress()
        .width(50)
        .height(50)

      Blank()
    }
    .width('100%')

  }
}