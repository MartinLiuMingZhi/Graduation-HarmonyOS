import { LoginResponse } from "../apis/login";
import { sendCode } from "../apis/mail";
import { PreferencesUtil } from "../utils/PreferencesUtil";

@Builder
export function AccountSafePageBuilder() {
  AccountSafePage()
}

@Component
export struct AccountSafePage {
  private TAG:string = 'AccountSafePage';
  @State email:string = ''
  @State content:string = ''
  @StorageLink('pathStack') pathStack: NavPathStack = new NavPathStack();

  aboutToAppear(): void {
    this.getUserInfo()
  }

  private async getUserInfo() {
    const userInfo = await PreferencesUtil.getAsync<string>('userInfo')
    if (userInfo) {
      const user:LoginResponse = JSON.parse(userInfo)
      this.email = user.email
      this.content = `点击“获取验证码”,验证码将发送到你的邮箱: ${this.email}`
      console.log(this.TAG,  JSON.stringify(user))
    }
  }

  build() {
    NavDestination(){
      Column(){
        Text('账号验证')
          .fontSize(25)
          .fontWeight(FontWeight.Bold)
          .margin({
            top: 20,
          })
          .textAlign(TextAlign.Start)
          .alignSelf(ItemAlign.Start)

        Text(this.content)
          .fontSize(16)
          .fontWeight(FontWeight.Regular)
          .margin({
            top: 20,
            bottom: 80
          })
          .textAlign(TextAlign.Start)
          .alignSelf(ItemAlign.Start)

        Button("获取验证码")
          .width('60%')
          .height(40)
          .type(ButtonType.Normal)
          .borderRadius(10)
          .onClick(()=>{
            this.getCode()
            this.pathStack.pushPathByName("InputCodePage",this.email)
          })


      }
      .width('100%')
      .height('100%')
      .padding({
        left:20,
        right:20
      })
    }
  }

  private async getCode(){
    const result = await sendCode<string>(this.email)
    if (result.code === '200') {
      console.log(result.msg)
    }else {
      console.log("发送验证码失败")
    }
  }
}