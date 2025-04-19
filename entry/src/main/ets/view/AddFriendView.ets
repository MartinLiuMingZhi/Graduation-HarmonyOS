import { FriendView } from "./FriendView"

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
            Text('添加朋友')
          }.tabBar('添加朋友')

          TabContent() {
            Text('新朋友')
          }.tabBar('新朋友')

        }
      }
      .width('100%')
      .height('100%')
    }
    .hideTitleBar(true)
  }
}