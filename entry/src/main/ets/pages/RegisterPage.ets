import { TopView } from '../view/TopView';

@Entry
@Component
struct RegisterPage{
  @State email:string = '';
  @State code:string = '';
  @State Password:string = '';
  @State CheckPassword:string = '';

  build() {
    Column(){
      TopView()
        .margin({
          bottom:'20vh'
        })

      TextInput({placeholder:'Email Address'})
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
          top:'10vh'
        })

      TextInput({placeholder:'Password'})
        .type(InputType.Password)
        .width('90%')
        .margin({
          top:'10vh',
          bottom:'10vh'
        })

      TextInput({placeholder:'CheckPassword'})
        .type(InputType.Password)
        .width('90%')

      Button('注册')
        .width('90%')
        .type(ButtonType.Capsule)
        .margin({
          top:'50vh'
        })

      LoadingProgress()
        .width(50)
        .height(50)
        .visibility(Visibility.Hidden)

      Blank()

    }
    .width('100%')

  }

}