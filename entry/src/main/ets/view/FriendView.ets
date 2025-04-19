@Component
export struct FriendView{
  @State friend_number:number = 0

  build() {
    Column() {
      Search({placeholder: this.friend_number+'位朋友'})
      List({space: 10}) {
        ListItem(){
          Text('朋友')
            .fontSize(12)
        }

        ListItem(){

        }

      }
      .width('100%')
      .height('auto')

    }
    .width('100%')
    .height('100%')
    .margin({
      left:20,
      right:20
    })
  }
}