import { TopView } from '../view/TopView';

@Entry
@Component
struct CodeLoginPage {
  @State email: string = '';
  @State code: string = '';

  build() {
    Column(){
      TopView()
        .margin({
          bottom:'20vh'
        })

      TextInput({ placeholder:'请输入邮箱' })
        .type(InputType.Email)
        .width('90%')

      Row(){
        TextInput({placeholder:'请输入邮箱验证码'})
          .width('60%')

        Button('获取验证码')
          .width('30%')
          .type(ButtonType.Capsule)
      }
      .width('90%')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({
        top:'10vh',
        bottom:'30vh'
      })

      Button("登录")
        .width("90%")
        .type(ButtonType.Capsule)


      LoadingProgress()
        .width(50)
        .height(50)
        .visibility(Visibility.Hidden)

      Blank()
    }
    .width('100%')

  }
}