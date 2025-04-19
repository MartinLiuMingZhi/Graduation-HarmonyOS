import { FriendItem } from "./FriendItem"

@Component
export struct FriendView{
  @State friend_number:number = 0

  build() {
    Column() {
      Search({placeholder: this.friend_number+'位朋友'})
        .margin({
          left: 10,
          right: 10
        })
      List({space: 10}) {
        ListItem(){
          Text('朋友')
            .fontSize(14)
            .margin({
              left: 10,
            })
        }

        ForEach([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20], (item:number, index) => {
          FriendItem()
        })

      }
      .layoutWeight(1)
      .padding({
        bottom: 20
      })
      .width('100%')

    }
    .width('100%')
    .height('100%')
    .margin({
      left:10,
      right:10,
      top:10,
    })
  }
}