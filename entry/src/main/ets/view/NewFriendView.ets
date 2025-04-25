import { getFriendRequests, handleFriendRequest } from "../apis/friend"
import { FriendRequestResponse } from "../apis/user"
import { FriendRequestItem } from "./FriendRequestItem"

@Component
export struct NewFriendView{
  @State friendRequestList: FriendRequestResponse[] = [] // 添加@State装饰器

  aboutToAppear(): void {
    this.getFriendRequests()
  }

  private async getFriendRequests(){
    const result = await getFriendRequests<FriendRequestResponse[]>()
    if (result.code === '200') {
      this.friendRequestList = result.data
    }else {
      console.error('请求失败:', result.msg)
    }
  }

  build() {
    Column() {
      List({space: 10}){
          ForEach(this.friendRequestList, (item: FriendRequestResponse) => {
            ListItem() {
              FriendRequestItem({item: item , onCustomClick:()=>{ this.handleAddFriend(item.userid) }})
                .onClick(() => {
                  // 跳转到用户详情页
                  // router.pushUrl({ url: 'pages/UserDetailPage', params: { userId: item.id } })
                })
            }
          }, (item: FriendRequestResponse) => item.toString())
      }

    }
    .width('100%')
    .height('100%')
  }

  private async handleAddFriend(requesterId: number){
    try {
      const result = await handleFriendRequest<FriendRequestResponse[]>(requesterId)
      if (result.code === '200') {
          console.log('请求成功:', result.msg)
        // 移除已处理的请求项以更新 UI
        this.friendRequestList = this.friendRequestList.filter(item => item.userid!== requesterId);
      } else {
        console.error('请求失败:', result.msg)
      }
    }catch (e){
     console.error('请求失败:', e)
    }
  }

}