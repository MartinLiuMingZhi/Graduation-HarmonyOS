import { FriendRequestResponse, getUserByEmailOrUsername } from "../apis/user"
import { promptAction } from "@kit.ArkUI"
import { FriendRequestItem } from "./FriendRequestItem"
import { FriendRequests, sendFriendRequest } from "../apis/friend"

@Component
export struct FriendRequestView{
  @State emailOrUsername: string = ''
  @State friendRequestList: FriendRequestResponse[] = [] // 添加@State装饰器
  @State isLoading: boolean = false // 新增加载状态

  build() {
    Column() {
      Search({placeholder: '搜索用户名 / 邮箱号'})
        .margin({
          left: 10,
          right: 10
        })
        .searchButton('搜索')
        .onChange((value:string)=>{
          this.emailOrUsername = value
          if (!value.trim()) {
            this.emailOrUsername = '';
            this.friendRequestList = [];
            this.isLoading = false;
          }
        })
        .onSubmit(()=>{
          if (this.emailOrUsername.trim()) {
            this.handleSearch()
          } else {
            promptAction.showToast({
              message: '请输入搜索内容'
            })
          }
        })

      // 加载指示器
      LoadingProgress()
        .width(5)
        .height(5)
        .visibility(this.isLoading ? Visibility.Visible : Visibility.Hidden)

      List({ space: 10 }) {
        if (this.friendRequestList.length === 0 && !this.isLoading) {
          ListItem() {
            Text("暂无搜索结果")
              .fontSize(16)
              .textAlign(TextAlign.Center)
              .width('100%')
              .margin({
                top:10
              })
          }
        }

        ForEach(this.friendRequestList, (item: FriendRequestResponse) => {
          ListItem() {
            FriendRequestItem({ item: item , onCustomClick:()=>{ this.handleAddFriend(item.userid)}})
              .onClick(() => {
                // 跳转到用户详情页
                // router.pushUrl({ url: 'pages/UserDetailPage', params: { userId: item.id } })
              })
          }
        }, (item: FriendRequestResponse) => item.toString())
      }
      .layoutWeight(1)
      .padding(5)




    }
    .width('100%')
    .height('100%')
  }

  private async handleSearch() {
    this.isLoading = true
    try {
      const result = await getUserByEmailOrUsername<FriendRequestResponse[]>(this.emailOrUsername.trim())
      if (result.code === '200') {
        this.friendRequestList = result.data
        promptAction.showToast({
          message: `找到${result.data.length}个结果`
        })
      } else {
        promptAction.showToast({
          message: '搜索失败，请重试'
        })
        this.friendRequestList = []
      }
    } catch (error) {
      console.error('请求失败:', error)
      this.friendRequestList = []
    } finally {
      this.isLoading = false
    }
  }

  private async handleAddFriend(receiverId: number){
    try {
      const result = await sendFriendRequest<FriendRequests>(receiverId)
      if (result.code === '200') {
          console.log('请求成功:', result.msg)
          promptAction.showToast({
            message: '已发送请求'
          })
      } else {
        console.error('请求失败:', result.msg)
      }
    }catch (e){
      console.error('请求失败:', e)
    }
  }
}