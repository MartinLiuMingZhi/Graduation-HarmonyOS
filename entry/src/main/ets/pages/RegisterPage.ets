import { register, RegisterResponse, sendCode } from '../apis/api';
import { PreferencesUtil } from '../utils/PreferencesUtil';
import { TopView } from '../view/TopView';
import {CountdownButton} from '../view/CountdownButton';
import { router } from '@kit.ArkUI';
import { MediaService } from '../service/MediaService';


@Entry
@Component
export struct RegisterPage {
  @State email: string = '';
  @State code: string = '';
  @State password: string = '';
  @State checkPassword: string = '';
  @State isLoading: boolean = false;
  @State errorMessage: string = '';

  build() {
    Column() {
      TopView()
        .margin({ bottom: '20vh' })

      TextInput({ placeholder: '请输入邮箱地址' })
        .type(InputType.Email)
        .width('90%')
        .onChange((value: string) => {
          this.email = value
        })

      Row() {
        TextInput({ placeholder: '请输入邮箱验证码' })
          .width('60%')
          .onChange((value: string) => {
            this.code = value
          })

        // 点击获取验证码后进入倒计时
        CountdownButton({
          email: this.email
        })
      }
      .width('90%')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ top: '10vh' })

      TextInput({ placeholder: '请输入密码' })
        .type(InputType.Password)
        .width('90%')
        .margin({ top: '10vh', bottom: '10vh' })
        .onChange((value: string) => {
          this.password = value
        })

      TextInput({ placeholder: '请确认密码' })
        .type(InputType.Password)
        .width('90%')
        .onChange((value: string) => {
          this.checkPassword = value
        })

      Text(this.errorMessage)
        .fontColor(Color.Red)
        .margin({ top: '5vh' })

      Button('注册')
        .width('90%')
        .type(ButtonType.Capsule)
        .margin({ top: '50vh' })
        .onClick(() => {
          console.log('注册')
          this.handleRegister()
        })

      LoadingProgress()
        .width(50)
        .height(50)
        .visibility(this.isLoading ? Visibility.Visible : Visibility.Hidden)

      Blank()
    }
    .width('100%')
  }

  private async handleRegister() {
    this.isLoading = true;
    this.errorMessage = '';

    // 表单验证
    if (!this.email) {
      this.errorMessage = '请输入邮箱地址';
      this.isLoading = false;
      return;
    }

    if (!this.password || !this.checkPassword) {
      this.errorMessage = '请输入密码和确认密码';
      this.isLoading = false;
      return;
    }

    if (this.password !== this.checkPassword) {
      this.errorMessage = '两次输入的密码不一致';
      this.isLoading = false;
      return;
    }

    try {
      const result = await register<RegisterResponse>({
        email: this.email,
        password: this.password,
        checkPassword: this.checkPassword,
        code: this.code
      });
      console.log('Received register response:', JSON.stringify(result));
      if (result.code === '200') {
        await PreferencesUtil.putAsync('token', result.data.token);
        // 计算并存储 Token 过期时间（当前时间加上一天）
        const currentTime = new Date().getTime();
        const oneDayInMillis = 24 * 60 * 60 * 1000; // 一天的毫秒数
        const expirationTime = currentTime + oneDayInMillis;
        await PreferencesUtil.putAsync('tokenExpiration', expirationTime.toString());
        await PreferencesUtil.putAsync('userInfo', JSON.stringify(result.data))
        MediaService.getInstance()

        router.replaceUrl({ url: 'pages/MainPage' })
      } else {
        this.errorMessage = result.msg || '注册失败';
      }
    } catch (error) {
      console.error('注册请求失败:', error);
      this.errorMessage = '网络请求失败，请稍后再试';
    } finally {
      this.isLoading = false;
    }
  }

}
