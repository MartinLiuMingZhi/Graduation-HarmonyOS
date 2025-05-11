import { getUserById, UserDTO } from '../apis/api';
import { CommentDTO } from '../apis/comment';
import { ChildCommentItem } from './ChildCommentItem';

@Component
export struct CommentItem {
  @Prop comment: CommentDTO;
  @State user: UserDTO = {} as UserDTO;

  aboutToAppear(): void {
    this.getUserInfo()
  }

  build() {
    Column({ space: 5 }) {
      Row() {
        Image(this.user.avatar) // 替换为真实头像
          .width(40)
          .height(40)
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

}
