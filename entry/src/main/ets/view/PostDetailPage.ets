import { CommentDTO,
  createComment,
  getCommentCounts,
  getComments,
  getUserById, LoginResponse, UserDTO } from "../apis/api";
import { DynamicItemData } from "../data/DynamicDataSource";
import { PreferencesUtil } from "../utils/PreferencesUtil";
import { CommentItem } from "./CommentItem";
import { LengthUnit } from "@kit.ArkUI";

@Builder
export function PostDetailPageBuilder(){
  PostDetailPage()
}

@Preview
@Component
export struct PostDetailPage {
  @StorageLink('pathStack') pathStack: NavPathStack = new NavPathStack();
  @State post: DynamicItemData = {} as DynamicItemData;
  @State user: UserDTO = {} as UserDTO;
  @State commentCount:  string = '';
  @State myInfo:LoginResponse = {} as LoginResponse;
  @State commentList: CommentDTO[] = [];    //评论列表
  @State isLoadingComments: boolean = false; // 加载状态
  @State showBottomCommentSheet: boolean = false   // 底部评论按钮用
  @State showInlineCommentSheet: boolean = false  // 内容区评论输入框用
  @State commentText: string = ''

  aboutToAppear(): void {
    const param: DynamicItemData[] = this.pathStack.getParamByName('PostDetailPage') as DynamicItemData[];
    if (Array.isArray(param) && param.length > 0) {
      this.post = param[0];
    }
    this.getUserInfo()
    this.getMyInfo()
    this.getCounts()
    this.loadComments()
  }

  build() {
    NavDestination(){
      Column(){
        Scroll(){
          Column(){
            Swiper(){
              ForEach(this.post.imageUrls, (item:string, index) => {
                Image(item)
                  .width('100%')
                  .height('60%')
              })
            }
            Text(this.post.title).fontSize(18).fontWeight(FontWeight.Bold).textAlign(TextAlign.Start).alignSelf(ItemAlign.Start).margin({top: 10,left:10})
            Text(this.post.content).fontSize(14).textAlign(TextAlign.Start).alignSelf(ItemAlign.Start).margin({top: 5,left:10})
            Text(this.post.updatedTime).fontSize(10).fontWeight(FontWeight.Lighter).textAlign(TextAlign.Start).alignSelf(ItemAlign.Start).margin({top: 10,left:10})

            Divider()
              .width('95%')
              .height(1)
              .backgroundColor('#cccccc')
              .margin({top: 10,  bottom: 10})

            Text(`共${this.commentCount}条评论`).fontSize(10).textAlign(TextAlign.Start).alignSelf(ItemAlign.Start).margin({top: 10,left:10})

            Row(){
              Image(this.myInfo.avatar)
                .width(40)
                .height(40)
                .borderRadius(10)

              TextInput({placeholder:'有话要说,快来评论'})
                .margin({left:10})
                .width('80%')
                .enableKeyboardOnFocus(false)
                .focusable(false)
                .onClick(() => {
                  this.showInlineCommentSheet = true
                })
                .bindSheet(this.showInlineCommentSheet,this.CommentBuilder('评论','0'),{
                  height: '200vp',
                  dragBar: false,
                  showClose: false,
                  onDisappear: () => {
                    console.log('bindSheet onDisappear, isShowPlay:', this.showInlineCommentSheet);
                    this.showInlineCommentSheet = false; // 隐藏播放列表
                  },
                })

            }
            .width('100%')
            .padding(5)

            if (this.isLoadingComments) {
              // 正在加载中...
              Row() {
                LoadingProgress()
                  .width(20)
                  .height(20)
                Text('加载中...')
                  .fontSize(14)
                  .fontColor('#888')
              }
              .justifyContent(FlexAlign.Center)
              .width('100%')
              .margin({ top: 20 })

            } else if (this.commentList.length === 0) {
              // 没有评论的情况
              Text('暂无评论，快来抢沙发吧～')
                .fontSize(14)
                .textAlign(TextAlign.Center)
                .width('100%')
                .margin({ top: 20 })

            } else {
              // 已加载到评论，正常展示
              ForEach(this.commentList, (item: CommentDTO) => {
                CommentItem({ comment: item, myInfo: this.myInfo,postId: this.post.postId })
              })
            }

            Divider()
              .width('90%')
              .margin({ top: 10 })

            Text('—— 到底了 ——')
              .fontSize(14)
              .fontWeight(FontWeight.Lighter)
              .margin({ top: 20,bottom: 20})

          }
        }
        .scrollBar(BarState.Off)
        .width('100%')
      }
      .width('100%')
      .layoutWeight(1)


      //评论框
      Row(){
        TextInput({placeholder:'说点什么...'})
          .placeholderColor($r('app.color.text_secondary'))
          .backgroundColor($r('app.color.white_background'))
          .borderRadius(20)
          .width('50%')
          .enableKeyboardOnFocus(false)
          .focusable(false)
          .onClick(() => {
            this.showBottomCommentSheet = true
          })
          .bindSheet(this.showBottomCommentSheet,this.CommentBuilder('评论','0'),{
            height: '100vp',
            dragBar: false,
            showClose: false,
            onDisappear: () => {
              console.log('bindSheet onDisappear, isShowPlay:', this.showBottomCommentSheet);
              this.showBottomCommentSheet = false; // 隐藏播放列表
            },
          })

        SymbolGlyph($r('sys.symbol.heart'))
          .width(30)
          .height(30)
          .margin({
            left: 10,
          })

        Text('267')
          .fontSize(14)

        SymbolGlyph($r('sys.symbol.star'))
          .width(30)
          .height(30)
          .margin({
            left: 10,
          })

        Text('267')
          .fontSize(14)

        SymbolGlyph($r('sys.symbol.ellipsis_message'))
          .width(30)
          .height(30)
          .margin({
            left: 10,
          })

        Text('267')
          .fontSize(14)

      }
      .width('100%')
      .padding({
        left:10,
        right:10,
        top: 5,
        bottom: 5
      })
    }
    .title(this.TitleBuilder())
  }

  @Builder
  TitleBuilder(){
    Row(){
      Image(this.user.avatar)
        .width(30)
        .height(30)
        .borderRadius(15)
        .margin({left: 10})

      Text(this.user.username)
        .fontSize(16)
        .margin({left: 10})
    }
    .width('100%')
    .margin({top: 10})
  }

  @Builder
  CommentBuilder(placeholderContent:string,parentCommentId:string){
    Row({space:10}) {
      TextArea({placeholder:placeholderContent})
        .width('75%')
        .height('auto')
        .onChange((value: string) => {
          this.commentText = value
        })

      Button("发送")
        .width('20%')
        .height('auto')
        .fontSize(16)
        .onClick(() => {
          this.submitComment(this.commentText, parentCommentId)
          this.commentText = ''
          this.showBottomCommentSheet = false
        })

    }
    .width('100%')
    .padding(10)
  }


  private async getUserInfo(){
    const result = await getUserById<UserDTO>(Number(this.post.userId))
    console.log('获取用户信息成功:', JSON.stringify(result.data))
    if(result.code === '200'){
      this.user = result.data
    }else {
      console.error('获取用户信息失败:', JSON.stringify(result.msg))
    }
  }

  private async getMyInfo(){
    // 加载登录用户数据
    try {
      const userData = await PreferencesUtil.getAsync<string>('userInfo');
      if (userData) {
        this.myInfo = JSON.parse(userData)
      }else{
        console.warn('User info not found in PreferencesUtil');
      }
    } catch (error) {
      console.error('Failed to load user info:', error);
    }
  }

  private async getCounts(){
    const result = await getCommentCounts<string>(Number(this.post.postId))
    if (result.code === '200') {
      this.commentCount = result.data
    }else{
      console.warn('获取评论数失败:', JSON.stringify(result.msg))
    }
  }

  private async loadComments(){
    this.isLoadingComments = true;

    try {
      const result = await getComments<CommentDTO[]>(Number(this.post.postId));
      if (result.code === '200') {
        this.commentList = result.data || [];
      } else {
        console.error('加载评论失败:', result.msg);
      }
    } catch (error) {
      console.error('请求评论出错:', error);
    } finally {
      this.isLoadingComments = false;
    }
  }

  private async submitComment(content: string, parentCommentId: string) {
    try {
      const result = await createComment<string>({
        userId: Number(this.myInfo.userid),
        postId: Number(this.post.postId),
        content,
        parentCommentId: Number(parentCommentId),
      });
      if (result.code === '200') {
        console.log('提交评论成功:', result.data);
        this.commentText = '';
        this.loadComments();
      } else {
        console.error('提交评论失败:', result.msg);
      }
    }catch (e){
      console.error('提交评论出错:', e);
    }
  }
}