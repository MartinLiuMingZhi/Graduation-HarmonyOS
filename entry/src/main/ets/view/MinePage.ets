import { CardView } from "./CardView"
import { SearchView } from "./SearchView"
import { PlayListItem } from "./PlayListItem"
import { PreferencesUtil } from "../utils/PreferencesUtil"
import { LoginResponse } from "../apis/login"

@Entry
@Component
export struct MinePage {
  @StorageLink('pathStack') pathStack: NavPathStack = new NavPathStack();
  @State user:LoginResponse = {
    userid: '',
    username: '',
    email: '',
    avatar: '',
    sex: '',
    token: ''
  }

  aboutToAppear(): void {
    this.loadUserInfo()
  }

  private async loadUserInfo(){
    // 加载登录用户数据
    try {
      const userData = await PreferencesUtil.getAsync<string>('userInfo');
      if (userData) {
        this.user = JSON.parse(userData)
      }else{
        console.warn('User info not found in PreferencesUtil');
      }
    } catch (error) {
      console.error('Failed to load user info:', error);
    }
  }

  build() {
    Column(){
     Row(){
      SearchView()
        .width('90%')
       Image($r('app.media.ic_setting'))
         .width(20)
         .height(20)
         .onClick(()=>{
            this.pathStack.pushPathByName('SettingPage',null)
         })
    }

      Scroll(){
         Column(){
           CardView({
             user: this.user
           })
           Text('我的歌单')
             .fontSize(12)
             .fontWeight(FontWeight.Bold)
             .width('95%')
             .margin({
               top: 10,
               left: 30
             })

           List({space: 10}){
             PlayListItem({
               PlayListName: '我的歌单1',
               PlayListCover: 'https://p1.music.126.net/BKj1SfKtM7UiZYnIOWGmrw==/109951169999071719.jpg',
               PlayListSongCount: '3首'
             })
             PlayListItem({
               PlayListName: '我的歌单2',
               PlayListCover: 'https://p1.music.126.net/BKj1SfKtM7UiZYnIOWGmrw==/109951169999071719.jpg',
               PlayListSongCount: '3首'
             })
           }
           .width('95%')
           .height('auto')
           .margin({
             top: 10,
           })

           Text('推荐歌单')
             .fontSize(12)
             .fontWeight(FontWeight.Bold)
             .width('95%')
             .margin({
               top: 10,
               left: 30
             })

           List({space: 10}){
             PlayListItem({
               PlayListName: '我的歌单1',
               PlayListCover: 'https://p1.music.126.net/BKj1SfKtM7UiZYnIOWGmrw==/109951169999071719.jpg',
               PlayListSongCount: '3首'
             })
             PlayListItem({
               PlayListName: '我的歌单2',
               PlayListCover: 'https://p1.music.126.net/BKj1SfKtM7UiZYnIOWGmrw==/109951169999071719.jpg',
               PlayListSongCount: '3首'
             })
           }
           .width('95%')
           .height('auto')
           .margin({
             top: 10,
           })

           Text('大家都在听')
             .fontSize(12)
             .fontWeight(FontWeight.Bold)
             .width('95%')
             .margin({
               top: 10,
               left: 30
             })

           List({space: 10}){
             PlayListItem({
               PlayListName: '我的歌单1',
               PlayListCover: 'https://p1.music.126.net/BKj1SfKtM7UiZYnIOWGmrw==/109951169999071719.jpg',
               PlayListSongCount: '3首'
             })
             PlayListItem({
               PlayListName: '我的歌单2',
               PlayListCover: 'https://p1.music.126.net/BKj1SfKtM7UiZYnIOWGmrw==/109951169999071719.jpg',
               PlayListSongCount: '3首'
             })
           }
           .listDirection(Axis.Horizontal)
           .listDirection(Axis.Horizontal)
           .width('95%')
           .height('auto')
           .margin({
             top: 10,
           })


         }
         .width('100%')
         .height('100%')
      }
      .scrollBar(BarState.Off)
      .height(550)

    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.white_background'))
  }



}