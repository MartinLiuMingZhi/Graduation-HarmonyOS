import { FriendRequestResponse, getUserByEmailOrUsername } from "../apis/user"
import { promptAction } from "@kit.ArkUI"
import { FriendRequestItem } from "./FriendRequestItem"
import { FriendRequests, recommendFriend, sendFriendRequest } from "../apis/friend"
import { Page } from "../apis/BaseResponse"

@Component
export struct FriendRequestView{
  @State emailOrUsername: string = ''
  @State friendRequestList: FriendRequestResponse[] = [] // 添加@State装饰器
  @State isLoading: boolean = false // 新增加载状态
  @State recommendedFriends: FriendRequestResponse[] = [] // 新增：推荐好友列表
  @State isDataLoaded: boolean = false // 新增状态：是否已加载完数据

  aboutToAppear(): void {
    this.loadRecommendedFriends()
    console.log('FriendRequestView aboutToAppear')
    console.log("加载推荐",JSON.stringify(this.recommendedFriends))
  }

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

      if (this.isDataLoaded){
        List({ space: 10 }) {
          // 搜索结果优先展示
          if (this.friendRequestList.length > 0) {
            ForEach(this.friendRequestList, (item: FriendRequestResponse) => {
              ListItem() {
                FriendRequestItem({
                  item: item,
                  onCustomClick: () => {
                    this.handleAddFriend(Number(item.userid))
                  }
                })
                  .onClick(() => {
                    // 可选跳转逻辑
                    // router.pushUrl({ url: 'pages/UserDetailPage', params: { userId: item.id } })
                  })
              }
            })
          } else if (!this.emailOrUsername.trim()) {
            // 显示推荐好友
            if (this.recommendedFriends.length === 0) {
              ListItem() {
                Text("暂无推荐好友")
                  .fontSize(16)
                  .textAlign(TextAlign.Center)
                  .width('100%')
                  .margin({ top: 10 })
              }
            } else {
              ListItem() {
                Text("推荐好友")
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .margin({ top: 10 })
                }
              ForEach(this.recommendedFriends, (item: FriendRequestResponse) => {
                ListItem() {
                  FriendRequestItem({
                    item: item,
                    onCustomClick: () => {
                      this.handleAddFriend(Number(item.userid))
                    }
                  })
                    .onClick(() => {
                      // 可选跳转逻辑
                      // router.pushUrl({ url: 'pages/UserDetailPage', params: { userId: item.id } })
                    })
                }
              })
            }
          } else {
            // 搜索但无结果
            ListItem() {
              Text("暂无搜索结果")
                .fontSize(16)
                .textAlign(TextAlign.Center)
                .width('100%')
                .margin({ top: 10 })
            }
          }
        }
        .layoutWeight(1)
        .padding(5)
      }else {
        // 可选：显示“正在加载”提示
        Text("正在加载推荐好友...")
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .width('100%')
          .margin({ top: 20 })
      }

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

  private async loadRecommendedFriends() {
    this.isDataLoaded  = false
    try {
      const result = await recommendFriend<Page<FriendRequestResponse[]>>()
      if (result.code === '200') {
        this.recommendedFriends = result.data.records
        console.log('加载推荐好友成功:', JSON.stringify(this.recommendedFriends))
      } else {
        console.warn('加载推荐好友失败:', result.msg)
        this.recommendedFriends = []
      }
    } catch (error) {
      console.error('请求失败:', error)
      this.recommendedFriends = []
    }finally {
      this.isDataLoaded  = true
    }
  }
}