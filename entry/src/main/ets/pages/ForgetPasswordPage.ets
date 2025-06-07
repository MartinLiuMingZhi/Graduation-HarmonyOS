import { TopView } from '../view/TopView';
import {CountdownButton} from '../view/CountdownButton'
import { sendCode } from '../apis/mail';
import { codeLogin, LoginResponse } from '../apis/login';
import { router } from '@kit.ArkUI';
import { PreferencesUtil } from '../utils/PreferencesUtil';
import { MediaService } from '../service/MediaService';
import { PasswordStrengthProgressBar } from '../view/PasswordStrengthProgressBar';
import { PasswordStrengthUtil } from '../utils/PasswordStrengthUtil';
import { forgetPassword } from '../apis/user';

@Entry
@Component
export struct ForgetPasswordPage {
  @State email: string = '';
  @State code: string = '';
  @State password: string = '';
  @State confirmPassword: string = '';
  @State passwordStrength: string = '' // 密码强度
  @State isLoading: boolean = false;

  build() {
    Column(){
      TopView()
        .margin({
          bottom:'20vh'
        })

      TextInput({ placeholder:'请输入邮箱' })
        .type(InputType.Email)
        .width('90%')
        .onChange((value:string)=>{
          this.email = value
        })

      Row(){
        TextInput({placeholder:'请输入邮箱验证码'})
          .width('60%')
          .onChange((value:string)=>{
            this.code = value
          })

        CountdownButton({
          email:this.email
        })
      }
      .width('90%')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({
        top:'10vh',
        bottom:'30vh'
      })

      // 新密码输入框 + 密码强度提示
      Column({ space: 5 }) {
        TextInput({ placeholder: '请输入新密码', text: this.password })
          .type(InputType.Password)
          .width('90%')
          .onChange((value: string) => {
            this.password = value
            this.passwordStrength = PasswordStrengthUtil.checkPasswordStrength(value)
          })
          .borderWidth(1)
          .borderColor('#CCCCCC')
          .padding(10)
          .borderRadius(8)

        PasswordStrengthProgressBar({ passwordStrength: this.passwordStrength })

        TextInput({ placeholder: '请确认新密码', text: this.confirmPassword })
          .type(InputType.Password)
          .width('90%')
          .onChange((value: string) => {
            this.confirmPassword = value
          })
          .borderWidth(1)
          .borderColor('#CCCCCC')
          .padding(10)
          .borderRadius(8)

      }
      .margin({ bottom: '5%' })

      Button("修改密码")
        .width("90%")
        .type(ButtonType.Capsule)
        .onClick(()=>{
          this.handleForgetPassword()
        })


      LoadingProgress()
        .width(50)
        .height(50)
        .visibility(this.isLoading ? Visibility.Visible : Visibility.Hidden)

      Blank()
    }
    .width('100%')

  }


  private async handleForgetPassword() {
    this.isLoading = true;

    // 检查新密码和确认密码是否一致
    if (this.password !== this.confirmPassword) {
      console.error('密码不一致')
      return
    }

    // 检查密码强度
    if (this.passwordStrength === '弱') {
      console.error("密码强度太低，请使用字母、数字和特殊字符")
      return
    }

    try {
      const result = await forgetPassword<string>({
        email:this.email,
        code:this.code,
        password:this.password,
        confirmPassword:this.confirmPassword
      })
      if (result.code === '200') {
        console.info("登录成功");
        router.replaceUrl({ url: 'pages/LoginPage'})
      }else {
        console.info('登录失败')
      }
    } catch (error) {
      console.error('登录请求失败:', error);
    } finally {
      this.isLoading = false
    }
  }
}