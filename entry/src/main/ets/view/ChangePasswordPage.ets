import { changePassword } from "../apis/api"
import { PasswordRule } from "../data/PasswordRule"
import { PasswordStrengthProgressBar } from "./PasswordStrengthProgressBar"

@Builder
export function ChangePasswordPageBuilder() {
  ChangePasswordPage()
}

@Preview
@Component
export struct ChangePasswordPage {

  @State oldPassword: string = ''      // 原密码
  @State newPassword: string = ''      // 新密码
  @State confirmPassword: string = ''  // 确认密码
  @State passwordStrength: string = '' // 密码强度
  @State errorMessage: string = ''     // 错误信息
  @State successMessage: string = ''   // 成功信息
  @State isSubmitting: boolean = false // 提交状态

  @StorageLink('pathStack') pathStack: NavPathStack = new NavPathStack();

  // 密码强度检测
  private checkPasswordStrength(password: string): void {
    const regex:PasswordRule = {
      strong: /^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$/,  // 强密码：至少8位字母、数字和特殊字符
      medium: /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$/,  // 中等密码：至少6位字母和数字
    }

    if (regex.strong.test(password)) {
      this.passwordStrength = '强'
    } else if (regex.medium.test(password)) {
      this.passwordStrength = '中'
    } else {
      this.passwordStrength = '弱'
    }
  }

  // 处理修改密码逻辑
  private async handleChangePassword() {
    this.errorMessage = ''
    this.successMessage = ''

    // 检查新密码和确认密码是否一致
    if (this.newPassword !== this.confirmPassword) {
      this.errorMessage = '新密码与确认密码不一致'
      return
    }

    // 检查密码强度
    if (this.passwordStrength === '弱') {
      this.errorMessage = '密码强度太低，请使用字母、数字和特殊字符'
      return
    }

    this.isSubmitting = true

    // 模拟提交请求，调用实际API替换此处
    try {
      const result = await changePassword<string>({oldPassword: this.oldPassword, newPassword: this.newPassword, confirmPassword: this.confirmPassword})
      if (result.code === '200') {
        this.successMessage = '密码修改成功！'
      } else {
        this.errorMessage = '修改密码失败，请稍后再试'
      }
    } catch (e) {
      this.errorMessage = '网络错误，请稍后再试'
    } finally {
      this.isSubmitting = false
    }
  }

  // 页面构建
  build() {
    NavDestination(){
      Column({space:10}){
        Text('修改密码')
          .width('100%')
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Start)
          .margin({left:30,top:40,bottom:10})
        // 原密码输入框
        TextInput({ placeholder: '请输入原密码', text: this.oldPassword })
          .type(InputType.Password)
          .width('90%')
          .onChange((value: string) => {
            this.oldPassword = value
          })
          .borderWidth(1)
          .borderColor('#CCCCCC')
          .padding(10)
          .borderRadius(8)

        // 新密码输入框 + 密码强度提示
        Column({ space: 5 }) {
          TextInput({ placeholder: '请输入新密码', text: this.newPassword })
            .type(InputType.Password)
            .width('90%')
            .onChange((value: string) => {
              this.newPassword = value
              this.checkPasswordStrength(value)
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

        // 提交按钮
        Column() {
          if (!this.isSubmitting) {
            Text('提交')
              .fontSize(16)
              .fontColor(Color.White)
              .width('90%')
              .height(45)
              .textAlign(TextAlign.Center)
              .borderRadius(10)
              .backgroundColor($r('app.color.blue'))
              .onClick(() => {
                this.handleChangePassword()
                this.pathStack.popToName('SettingPage');
              })
          } else {
            Row() {
              LoadingProgress()
              Text('正在提交...')
                .fontSize(16)
                .fontColor(Color.White)
                .margin({ left: 10 })
            }
            .width('90%')
            .height(45)
            .justifyContent(FlexAlign.SpaceAround)
            .backgroundColor($r('app.color.blue'))
          }
        }
        .margin({ bottom: '5%' })
      }
      .width('100%')
      .height('100%')
    }
  }
}
