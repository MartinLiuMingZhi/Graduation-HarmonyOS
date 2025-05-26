import { LoginResponse } from "../apis/login";
import { PreferencesUtil } from "../utils/PreferencesUtil";
import ItemData, { SettingFieldType } from "../viewmodel/ItemData"
import PersonalViewModel from "../viewmodel/PersonalViewModel"
import { promptAction } from "@kit.ArkUI";

@Builder
export function PersonalPageBuilder() {
  PersonalPage()
}

@Component
export struct PersonalPage{
  @State user:LoginResponse = {} as LoginResponse;
  @State isLoading: boolean = true;

  @Builder
  settingCell(item: ItemData) {
    Row() {
      Row({}) {
        Text(item.title)
          .fontSize('16fp')
          .padding({
            left:10
          })
      }

      Row(){
        // 判断字段类型并展示对应内容
        if (item.fieldType === SettingFieldType.AVATAR && item.value) {
          Image(item.value as string)
            .width('24vp')
            .height('24vp')
            .borderRadius('12vp')
            .margin({
              right:10
            })
        } else if (item.fieldType === SettingFieldType.TEXT && item.value) {
          Text(item.value as string)
            .fontSize('16fp')
            .padding({
              left:10
            })
        }

        Image($r('app.media.right_grey'))
          .width('12vp')
          .height('24vp')
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

  aboutToAppear(): void {
    this.loadData()
  }

  private async loadData(): Promise<void> {
    try {
      const userData = await PreferencesUtil.getAsync<string>('userInfo');
      if (userData) {
        this.user = JSON.parse(userData);
        PersonalViewModel.setUser(this.user);
      } else {
        console.warn('User info not found in PreferencesUtil');
      }
    } catch (error) {
      console.error('Failed to load user info:', error);
    } finally {
      this.isLoading = false; // 加载完成后关闭 loading
    }
  }


  build() {
    NavDestination(){
      if (!this.isLoading){
        Scroll(){
          Column(){

            List({ space: 12 }) {
              ForEach(PersonalViewModel.getPersonalListData(), (item: ItemData[], index: number) => {
                ListItemGroup() {
                  ForEach(item, (cell: ItemData, cellIndex) => {
                    ListItem() {
                      this.settingCell(cell)
                    }
                    .height('48vp')
                    .onClick(() => {
                      switch (cellIndex){
                        case 0:
                          this.avatarClick();
                          break;
                        case 1:
                          this.usernameClick();
                          break;
                        case 2:
                          this.sexClick();
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
            .layoutWeight(1)
            .padding({
              top: '4vp',
              bottom: '4vp'
            })

          }
          .height('100%')
        }
        .scrollBar(BarState.Off)
        .height('100%')
        .width('100%')
      }else {
        LoadingProgress()
          .width(20)
          .height(20)
      }
    }
    .title(this.TitleBuilder)
    .backgroundColor($r('app.color.white_background'))
    .padding({
      left: '12vp',
      right: '12vp'
    })
  }

  private avatarClick(){
    //进行换头像
  }

  private usernameClick(){

  }

  private sexClick(){

  }
}