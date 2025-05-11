import { getUserById, UserDTO } from "../apis/api";
import { CommentDTO } from "../apis/comment";

@Component
export struct ChildCommentItem {
  @Prop comment : CommentDTO;
  @State user:UserDTO = {} as UserDTO;

  aboutToAppear(): void {
    this.getUserInfo()
  }

  build() {
    Row() {
      Image(this.user.avatar)
        .width(25)
        .height(25)
        .borderRadius(12)

      Column({ space: 3 }) {
        Text(this.user.username).fontSize(12).fontWeight(FontWeight.Lighter)
        Text(this.comment.content).fontSize(13)
      }
      .alignItems(HorizontalAlign.Start)

      Text(this.comment.commentTime)
        .fontSize(9)
        .fontColor('#888')
        .alignSelf(ItemAlign.End)
        .margin({ left: 10 })
    }
    .width('100%')
  }

  private async getUserInfo() {
    try {
      const result = await getUserById<UserDTO>(Number(this.comment.userId));
      if (result.code === '200') {
        this.user = result.data;
      } else {
        console.error(`子评论获取用户信息失败：${result.msg}`);
      }
    } catch (error) {
      console.error(`子评论请求用户信息出错：`, error);
    }
  }
}