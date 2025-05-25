import { CardView } from "./CardView"
import { SearchView } from "./SearchView"
import { PlayListItem } from "./PlayListItem"
import { PreferencesUtil } from "../utils/PreferencesUtil"
import { LoginResponse } from "../apis/login"
import { getRandomSong } from "../apis/song"
import { Page } from "../apis/BaseResponse"
import { SongItem } from "../data/SongData"

@Entry
@Component
export struct MinePage {
  @StorageLink('pathStack') pathStack: NavPathStack = new NavPathStack();
  @State user:LoginResponse = {} as LoginResponse
  @State playListItems:SongItem[] = []
  list:number[] = [1,2,3,4]

  aboutToAppear(): void {
    this.loadUserInfo()
    this.getRecommend(1,9)
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

           List({ space: 10 }) {
             ForEach(this.playListItems.slice(0, 3), (item: SongItem) => {
               PlayListItem({
                 PlayListName: item.title,
                 PlayListCover: item.label,
                 PlayListSongCount: '10首'
               })
             }, (item: SongItem) => item.id.toString())
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

           List({ space: 10 }) {
             ForEach(this.playListItems.slice(3, 6), (item: SongItem) => {
               PlayListItem({
                 PlayListName: item.title,
                 PlayListCover: item.label,
                 PlayListSongCount: '10首'
               })
             }, (item: SongItem) => item.id.toString())
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

           List({ space: 10 }) {
             ForEach(this.playListItems.slice(6, 9), (item: SongItem) => {
               PlayListItem({
                 PlayListName: item.title,
                 PlayListCover: item.label,
                 PlayListSongCount: '10首'
               })
             }, (item: SongItem) => item.id.toString())
           }
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
      .layoutWeight(1)

    }
    .margin({
      bottom:10
    })
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.white_background'))
  }

  private async getRecommend(page:number,pageSize:number){
    const result = await getRandomSong<Page<SongItem[]>>(page,pageSize)
    if (result.code === '200') {
      this.playListItems = result.data.records
      console.log('mine:', JSON.stringify(this.playListItems))
    } else {
      console.error('请求失败:', result.msg)
    }
  }


}