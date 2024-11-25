import { HomePage } from '../view/HomePage';
import { UserPage } from '../view/UserPage';

@Entry
@Component
struct MainPage {
  @State TooTmp: ToolbarItem = {'value': "func", 'icon': "./image/ic_public_highlights.svg", 'action': ()=> {}}
  @Provide('pageInfos') pageInfos: NavPathStack = new NavPathStack()
  private arr: number[] = [1, 2, 3];

  @Builder
  PageMap(name: string) {
    if (name === "NavDestinationTitle1") {
      HomePage()
    } else if (name === "NavDestinationTitle2") {
      UserPage()
    } else if (name === "NavDestinationTitle3") {
      UserPage()
    }
  }

  build() {
    Column() {
      Navigation(this.pageInfos) {

      }
      .title("主标题")
      .mode(NavigationMode.Auto)
      .navDestination(this.PageMap)
      .toolbarConfiguration([this.TooTmp, this.TooTmp, this.TooTmp])
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#F1F3F5')
  }
}