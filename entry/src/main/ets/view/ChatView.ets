import { LoginResponse } from "../apis/api";
import { getSingleHistoryMessages, Message } from "../apis/message";
import { UserDTO } from "../apis/user";
import { WebSocketManager } from "../request/WebSocketManager";
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
  private scrollController: Scroller = new Scroller();
  // private wsManager: WebSocketManager = WebSocketManager.getInstance();
  @State private pollInterval: number = 5000; // 轮询间隔时间（毫秒）
  private pollingTimer: number | undefined;   // 定时器引用
  // 记录最后一条消息 ID，用于判断是否有新增消息
  @State private lastMessageId: string = '';



  aboutToAppear(): void {
    // this.wsManager.connect();
    // this.wsManager.startHeartbeat();
    //
    // // 订阅消息
    // this.wsManager.subscribeMessage((rawMessage: string) => {
    //   try {
    //     const message:Message = JSON.parse(rawMessage); // 解析为对象
    //
    //     console.info('收到新消息:', message);
    //
    //     // 判断是否是当前聊天用户的对话
    //     if (message.fromUserId === this.userInfo.userid ||
    //       message.toUserId === this.user.userid) {
    //       // 更新 messageList，触发 UI 刷新
    //       this.messageList = [...this.messageList, message];
    //     }
    //   } catch (e) {
    //     console.error('消息解析失败:', rawMessage);
    //   }
    // });

    // 加载用户信息并加载聊天记录
    this.loadUserInfoAndMessages();

    // 启动轮询
    this.startPolling();
  }

  private async fetchNewMessages() {
    try {
      const result = await getSingleHistoryMessages<Message[]>(Number(this.userInfo.userid));
      if (result.code === '200') {
        const newMessages = result.data.slice(result.data.findIndex(msg => msg.id === this.lastMessageId) + 1);

        if (newMessages.length > 0) {
          this.messageList = [...this.messageList, ...newMessages];
          this.lastMessageId = newMessages[newMessages.length - 1].id; // 更新最新消息ID
          this.scrollToBottom(); // ✅ 加载完成后滚动到底部
        }
      }
    } catch (error) {
      console.error('轮询获取消息失败:', error);
    }
  }

  aboutToDisappear(): void {
    // this.wsManager = WebSocketManager.getInstance();
    // this.wsManager.stopHeartbeat();
    // this.wsManager.close();

    this.stopPolling();
  }

  private async loadUserInfoAndMessages(): Promise<void> {
    // 获取用户信息
    const param: UserDTO[] = this.pathStack.getParamByName('ChatView') as UserDTO[];
    if (Array.isArray(param) && param.length > 0) {
      this.userInfo = param[0];
    }
    console.info('param',JSON.stringify(param))

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
      this.scrollToBottom(); // ✅ 加载完成后滚动到底部
    }
  }

  // private async onMessageSent(message: Message) {
  //   // 在发送消息成功后更新消息列表
  //   await this.getMessageInit();
  // }

  // 启动轮询
  private startPolling() {
    this.pollingTimer = setInterval(() => {
      this.fetchNewMessages();
    }, this.pollInterval);
  }

  // 停止轮询
  private stopPolling() {
    if (this.pollingTimer) {
      clearInterval(this.pollingTimer);
      this.pollingTimer = undefined;
    }
  }

  private scrollToBottom() {
    if (this.messageList.length > 0) {
      this.scrollController.scrollEdge(Edge.Bottom)
    }
  }

  build() {
    NavDestination() {
      Column() {
        List({space: 10,scroller: this.scrollController}){
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