import { Page } from "../apis/BaseResponse"
import { getFriendList } from "../apis/friend"
import { UserDTO } from "../apis/user"
import { FriendItem } from "./FriendItem"

@Component
export struct FriendView{
  @State friend_number:string = ''
  @State friendList: UserDTO[] = []
  @StorageLink('pathStack') pathStack: NavPathStack = new NavPathStack();

  aboutToAppear() {
      this.getFriends()
  }

  private async getFriends(){
    const result = await getFriendList<Page<UserDTO[]>>(1,10)
    if (result.code === '200') {
      this.friendList = result.data.records
      this.friend_number = result.data.size
    }else {
      console.error('请求失败:', result.msg)
    }
  }

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
              top:10
            })
        }

        ForEach(this.friendList, (item: UserDTO) => {
          ListItem() {
            FriendItem({item: item})
              .onClick(() => {
                // 跳转到用户详情页
                // router.pushUrl({ url: 'pages/UserDetailPage', params: { userId: item.id } })
              })
          }
        }, (item: UserDTO) => item.toString())

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
    })
  }
}