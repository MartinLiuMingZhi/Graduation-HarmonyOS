import { LoginResponse } from "../apis/api";
import { getSingleHistoryMessages, Message } from "../apis/message";
import { UserDTO } from "../apis/user";
import { PreferencesUtil } from "../utils/PreferencesUtil";
import { MessageBottomComponent } from "./MessageBottomComponent";
import { MessageComponent } from "./MessageComponent";

@Builder
export function ChatViewBuilder() {
  ChatView()
}

@Component
export struct ChatView {
  @StorageLink('pathStack') pathStack: NavPathStack = new NavPathStack();
  @State userInfo: UserDTO = {
    userid: '',
    username: '',
    email: '',
    avatar: '',
    sex: ''
  };
  @State messageList: Message[] = [];
  @State isLoading: boolean = false;
  @State  user:LoginResponse = {
    userid: '',
    username: '',
    email: '',
    avatar: '',
    sex: '',
    token: ''
  };

  aboutToAppear(): void {
    this.loadUserInfoAndMessages();
  }

  private async loadUserInfoAndMessages(): Promise<void> {
    // 获取用户信息
    const param: UserDTO[] = this.pathStack.getParamByName('ChatView') as UserDTO[];
    if (Array.isArray(param) && param.length > 0) {
      this.userInfo = param[0];
    }

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

    // 加载聊天记录
    await this.getMessageInit();
  }

  private async  getMessageInit(){
    const result = await getSingleHistoryMessages<Message[]>(Number(this.userInfo.userid))
    if (result.code === '200'){
      this.messageList = result.data
    }
  }

  private async onMessageSent(message: Message) {
    // 在发送消息成功后更新消息列表
    await this.getMessageInit();
  }

  build() {
    NavDestination() {
      Column() {
        Scroll(){
          List({space: 10}){
            ForEach(this.messageList, (item: Message) => {
              MessageComponent({
                content: item.content,
                isMe: item.fromUserId === this.user.userid,
                avatar: item.fromUserId === this.user.userid ? this.user.avatar : this.userInfo.avatar,
              })
            })
          }
          .scrollBar(BarState.Off)
          .width('100%')
          .height('100%')

        }
        .width('100%')
        .layoutWeight(1)

        MessageBottomComponent({ toUserId: Number(this.userInfo.userid),messageList:this.messageList})
          .width('100%')
          .padding(10)
      }
      .width('100%')
      .height('100%')
    }
    .title(this.userInfo.username)
  }
}