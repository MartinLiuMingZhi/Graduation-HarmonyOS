import { Page } from "../apis/BaseResponse"
import { getFriendList } from "../apis/friend"
import { UserDTO } from "../apis/user"
import { FriendItem } from "./FriendItem"

@Component
export struct FriendView{
  @State friend_number:string = ''
  @State friendList: UserDTO[] = []
  @StorageLink('pathStack') pathStack: NavPathStack = new NavPathStack();
  @State page:  number = 1
  @State pageSize: number = 10
  @State isLoading: boolean = false

  aboutToAppear() {
      this.getFriends()
  }

  private async getFriends(){
    if (this.isLoading) return
    this.isLoading = true
    try {
      const result = await getFriendList<Page<UserDTO[]>>(this.page, this.pageSize)
      if (result.code === '200') {
        if (this.page === 1) {
          this.friendList = result.data.records // 刷新时重置列表
          console.log('Received friend list:', JSON.stringify(result.data.records))
        } else {
          this.friendList = [...this.friendList, ...result.data.records] // 加载更多
        }
        this.friend_number = result.data.total
      } else {
        console.error('请求失败:', result.msg)
      }
    } catch (error) {
      console.error('请求异常:', error)
    } finally {
      this.isLoading = false
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
        })

        if (this.isLoading && this.page > 1) {
          ListItem() {
            LoadingProgress()
              .width(20)
              .height(20)
              .margin({ top: 10, bottom: 10 })
              .alignSelf(ItemAlign.Center)
          }
        }
      }
      .layoutWeight(1)
      .padding({
        bottom: 20
      })
      .width('100%')
      .onReachEnd(()=>{
        if (!this.isLoading && this.friendList.length >= this.page * this.pageSize) {
          this.page += 1;
          this.getFriends();
        }
      })

    }
    .width('100%')
    .height('100%')
    .margin({
      left:10,
      right:10,
    })
  }
}