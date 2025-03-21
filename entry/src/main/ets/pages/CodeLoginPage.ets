import { TopView } from '../view/TopView';
import {CountdownButton} from '../view/CountdownButton'
import { sendCode } from '../apis/mail';
import { codeLogin, LoginResponse } from '../apis/login';
import { router } from '@kit.ArkUI';
import { PreferencesUtil } from '../utils/PreferencesUtil';

@Builder
export function CodeLoginPageBuilder(){
  CodeLoginPage()
}

@Entry
@Component
struct CodeLoginPage {
  @State email: string = '';
  @State code: string = '';
  @State isLoading: boolean = false;
  @StorageLink('pathStack') pathStack: NavPathStack = new NavPathStack();

  build() {
    NavDestination(){
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

        Button("登录")
          .width("90%")
          .type(ButtonType.Capsule)
          .onClick(()=>{
            console.log("登录")
            this.handleCodeLogin()
          })


        LoadingProgress()
          .width(50)
          .height(50)
          .visibility(this.isLoading ? Visibility.Visible : Visibility.Hidden)

        Blank()
      }
      .width('100%')
    }

  }


  private async handleCodeLogin() {
    this.isLoading = true;
    try {
      const result = await codeLogin<LoginResponse>({
        email:this.email,
        code:this.code
      })
      if (result.code === '200') {
        console.info("登录成功");
        await PreferencesUtil.putAsync('token', result.data.token)
        this.pathStack.replacePathByName('MainPage',null)
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