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

  build() {
    NavDestination(){
      Column() {
        Tabs({barPosition: BarPosition.Start,index:1}){
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