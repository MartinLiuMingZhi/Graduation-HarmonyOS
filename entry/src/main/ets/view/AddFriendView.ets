import { FriendRequestView } from "./FriendRequestView"
import { FriendView } from "./FriendView"
import { NewFriendView } from "./NewFriendView"

@Builder
export function AddFriendViewBuilder() {
  AddFriendView()
}

@Preview
@Component
export struct AddFriendView{
  @State selectedIndex: number = 1
  @StorageLink('pathStack') pathStack: NavPathStack = new NavPathStack()

  aboutToAppear(): void {
    const param = this.pathStack.getParamByName('AddFriendView') as number[]
    if (param && param.length > 0) {
      this.selectedIndex = param[0]
    }
  }

  build() {
    NavDestination(){
      Column() {
        Tabs({barPosition: BarPosition.Start,index:this.selectedIndex}){
          TabContent() {
            FriendView()
          }.tabBar('朋友')

          TabContent() {
            FriendRequestView()
          }.tabBar('添加朋友')

          TabContent() {
            NewFriendView()
          }.tabBar('新朋友')

        }
      }
      .width('100%')
      .height('100%')
    }
    .hideTitleBar(true)
  }
}