import { router } from '@kit.ArkUI';
import { TopView } from '../view/TopView';
import {login, LoginResponse} from '../apis/api'
import promptAction from '@ohos.promptAction'
import { PreferencesUtil } from '../utils/PreferencesUtil';

@Entry
@Component
struct LoginPage {
  @State email: string = '';
  @State password: string = '';
  @State isLoading: boolean = false;

  build() {
    Column(){
      TopView()

      TextInput({ placeholder:'请输入邮箱' })
        .type(InputType.Email)
        .margin({
          bottom:'10vh',
          top:'20vh'
        })
        .width('95%')
        .onChange((value:string)=>{
          this.email = value
        })


      TextInput({ placeholder:'请输入密码' })
        .type(InputType.Password)
        .width('95%')
        .onChange((value:string)=>{
          this.password = value
        })

      Row(){
        Text("邮箱验证码登录")
          .fontColor($r('app.color.blue'))
          .fontSize(14)
          .onClick(()=>{
            router.pushUrl({
              url:'pages/CodeLoginPage'
            }).then(()=>{
              console.log("跳转成功")
            }).catch(()=>{
              console.log("跳转失败")
            })
          })


        Text("忘记密码")
          .fontColor($r('app.color.blue'))
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
        .onClick(()=>{
          this.handleLogin()
        })

      Text("注册账号")
        .fontColor($r('app.color.blue'))
        .fontSize(14)
        .margin({
          top:'10vh'
        })
        .onClick(()=>{
            router.pushUrl({
              url:'pages/RegisterPage'
            }).then(()=>{
              console.log("跳转成功")
            }).catch(()=>{
              console.log("跳转失败")
            })
        })

      LoadingProgress()
        .width(50)
        .height(50)
        .visibility(this.isLoading ? Visibility.Visible : Visibility.Hidden)

      Blank()
    }
    .width('100%')

  }

  private async  handleLogin() {
    this.isLoading = true;
    try {
      const result = await login<LoginResponse>({
        email:this.email,
        password:this.password
      })
      console.log('Received login response:', JSON.stringify(result));
      if (result.code === '200') {
        // TokenUtil.setToken(result.data.token)
        PreferencesUtil.put('token', result.data.token)
        router.replaceUrl({
          url:'pages/MainPage'
        })
      }else {
        promptAction.showToast({
          message: result.msg
        })
      }
    }catch (error){
      console.error('登录请求失败:', error);
    } finally {
      this.isLoading = false
    }
  }

}