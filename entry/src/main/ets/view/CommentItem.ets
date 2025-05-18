import { getUserById, LoginResponse, UserDTO } from '../apis/api';
import { CommentDTO, createComment } from '../apis/comment';
import { ChildCommentItem } from './ChildCommentItem';

@Component
export struct CommentItem {
  @Prop comment: CommentDTO;
  @Prop myInfo:LoginResponse
  @Prop postId: string;
  @State user: UserDTO = {} as UserDTO;
  @State isCommentStatus: boolean = false
  @State commentText: string = ''

  aboutToAppear(): void {
    this.getUserInfo()
  }

  build() {
    Column({ space: 5 }) {
      Row() {
        Image(this.user.avatar) // 替换为真实头像
          .width(50)
          .height(50)
          .borderRadius(15)

        Column({ space: 3 }) {
          Text(this.user.username).fontSize(12).fontWeight(FontWeight.Lighter)
          Text(this.comment.content).fontSize(14)
        }
        .alignItems(HorizontalAlign.Start)

        Text(this.comment.commentTime)
          .fontSize(10)
          .fontColor('#888')
          .alignSelf(ItemAlign.End)
          .margin({ left: 10 })
      }
      .width('100%')
      .onClick(() => {
        this.isCommentStatus = true
      })
      .bindSheet(this.isCommentStatus,this.CommentBuilder('回复',this.comment.commentId),{
        height: '100vp',
        dragBar: false,
        showClose: false,
        onDisappear: () => {
          console.log('bindSheet onDisappear, isShowPlay:', this.isCommentStatus);
          this.isCommentStatus = false; // 隐藏播放列表
        },
      })

      // 子评论
      if (this.comment.children?.length > 0) {
        Column({ space: 5 }) {
          ForEach(this.comment.children, (child: CommentDTO) => {
            ChildCommentItem({comment: child})
          })
        }
        .padding({ left: 20 })
      }
    }
    .width('100%')
    .padding({ left: 10, right: 10, top: 5, bottom: 5 })
    .backgroundColor(Color.White)
    .margin({ bottom: 5 })
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
        })

    }
    .width('100%')
    .padding(10)
  }

  private async getUserInfo(){
    try {
      const result = await getUserById<UserDTO>(Number(this.comment.userId));
      if (result.code === '200') {
        this.user = result.data;
      } else {
        console.error(`获取用户信息失败：${result.msg}`);
      }
    } catch (error) {
      console.error(`请求用户信息出错：`, error);
    }
  }

  private async submitComment(content: string, parentCommentId: string) {
    try {
      const result = await createComment<string>({
        userId: Number(this.myInfo.userid),
        postId: Number(this.postId),
        content,
        parentCommentId: Number(parentCommentId),
      });
      if (result.code === '200') {
        console.log('提交评论成功:', result.data);
        this.commentText = '';
      } else {
        console.error('提交评论失败:', result.msg);
      }
    }catch (e){
      console.error('提交评论出错:', e);
    }
  }
}
