import { logout } from "../apis/logout"
import { PreferencesUtil } from "../utils/PreferencesUtil"
import ItemData from "../viewmodel/ItemData"
import SettingViewModel from "../viewmodel/SettingViewModel"
import { promptAction, router } from "@kit.ArkUI"
import { MediaService } from "../service/MediaService"

@Builder
export function SettingPageBuilder() {
  SettingPage()
}

@Preview
@Component
export struct  SettingPage{
  @StorageLink('pathStack') pathStack: NavPathStack = new NavPathStack();

  @Builder
  settingCell(item: ItemData) {
    Row() {
      Row() {
        Text(item.title)
          .fontSize('16fp')
          .padding({
            left:10
          })
      }

      if (item.others === undefined) {
        Image($r('app.media.right_grey'))
          .width('12vp')
          .height('24vp')
      } else {
        Toggle({ type: ToggleType.Switch, isOn: false })
      }
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width('100%')
    .padding({
      left: '8vp',
      right: '22vp'
    })
  }

  @Builder
  TitleBuilder(){
    Row(){
      Text('设置')
        .textAlign(TextAlign.Center)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({
          top: 18
        })
    }
    .width('70%')
    .justifyContent(FlexAlign.Center)
  }

  build() {
    NavDestination(){
      Scroll(){
        Column(){

          List({ space: 12 }) {
            ForEach(SettingViewModel.getSettingListData(), (item: ItemData[], index: number) => {
              ListItemGroup() {
                ForEach(item, (cell: ItemData) => {
                  ListItem() {
                    this.settingCell(cell)
                  }
                  .height('48vp')
                  //根据cellIndex添加不同的点击事件
                  .onClick(()=>{
                    switch (cell.id) {
                      case 0:
                        //跳转到个人资料页面
                        this.pathStack.pushPathByName('PersonalPage',null);
                        break;
                      case 1:
                        //跳转到账号与安全页面
                        this.pathStack.pushPathByName('AccountSafePage',null);
                        break;
                      case 2:
                        this.pathStack.pushPathByName('AddFriendView',null)
                        //跳转到关于页面
                        break;
                      case 3:
                        //跳转到隐私设置页面
                      case 4:
                        this.pathStack.pushPathByName('PrivacyPolicyPage',null)
                        //跳转到隐私政策管理页面
                        break;
                      case 5:
                        //跳转到清除缓存页面
                        break;
                      default:
                        break;
                    }
                  })
                })
              }
              .divider({
                strokeWidth: '1vp',
                color: '#0d000000',
                startMargin: '42vp',
                endMargin: '24vp'
              })
              .backgroundColor('#ffffff')
              .borderRadius('16vp')

            }, (item: ItemData) => JSON.stringify(item))
          }
          .scrollBar(BarState.Off)
          .width('100%')
          .padding({
            top: '4vp',
            bottom: '4vp'
          })

          Blank()

          Button('退出登录', { type: ButtonType.Capsule })
            .width('95%')
            .height('40vp')
            .fontSize('16fp')
            .fontColor('#fffa2a3b')
            .fontWeight(FontWeight.Medium)
            .backgroundColor('#ffffff')
            .margin({ bottom: '16vp' })
            .onClick(() => {
             //提示弹窗
              this.handleShowDialog()
            })
        }
        .height('100%')
      }
      .scrollBar(BarState.Off)
      .height('100%')
      .width('100%')
    }
    .title(this.TitleBuilder)
    .backgroundColor($r('app.color.white_background'))
    .padding({
      left: '12vp',
      right: '12vp'
    })
  }

  private async handleShowDialog(){
    promptAction.showDialog({
      message: '确定要退出吗？',
      buttons: [
        {
          text: '取消',
          color: '#ff413838',
        },
        {
          text: '确定',
          color: '#ff413838',
        },
      ]
    }).then((result) => {
      if (result.index === 0) {
        console.log('用户点击了取消按钮');
      }else if (result.index === 1) {
        this.handleLogout();
      }
    })
      .catch((error: Error) => {
        console.error('显示对话框失败:', error);
      })
  }


  private async handleLogout(){
    try {
      const result = await logout<string>();
      if (result.code === '200') {
        //如果有MediaService服务运行，释放资源，关闭播放的歌曲
        MediaService.getInstance().pause()
        MediaService.getInstance().release()
        await PreferencesUtil.deleteAsync('token');
        //清空路由栈，并跳转登录页
        this.pathStack.clear();
        router.replaceUrl({ url: 'pages/LoginPage' });
      }else{
        promptAction.showToast({
          message: result.msg
        })
      }

    }catch (e) {
      console.error('退出登录失败:', e);
    }
  }
}