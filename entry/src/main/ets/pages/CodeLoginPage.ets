import { TopView } from '../view/TopView';
import {CountdownButton} from '../view/CountdownButton'
import { sendCode } from '../apis/mail';


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

        CountdownButton()
          .onClick(()=>{
              this.handleGetCode()
          })
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
        .onClick(()=>{
          console.log("登录")
        })


      LoadingProgress()
        .width(50)
        .height(50)
        .visibility(Visibility.Hidden)

      Blank()
    }
    .width('100%')

  }

  private async handleGetCode() {
    try {
      const result = await sendCode<string>(this.email);
      if (result.code === '200') {
        console.info("获取验证码成功");
      } else {
        console.info('获取验证码失败')
      }
    } catch (error) {
      console.error('获取验证码请求失败:', error);
    }
  }
}