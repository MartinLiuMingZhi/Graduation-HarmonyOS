import { LoginResponse } from "../apis/api";
import { getSingleHistoryMessages, Message, sendSingleMessage } from "../apis/message";
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
  @State userInfo: UserDTO = {} as UserDTO;
  @State messageList: Message[] = [];
  @State isLoading: boolean = false;
  @State  user:LoginResponse = {} as LoginResponse;
  private scrollController: Scroller = new Scroller();
  private wsManager: WebSocketManager = WebSocketManager.getInstance();
  @State private pollInterval: number = 3000; // 轮询间隔时间（毫秒）
  private pollingTimer: number | undefined;   // 定时器引用
  // 记录最后一条消息 ID，用于判断是否有新增消息
  @State private lastMessageId: string = '';
  @State isUsingPolling: boolean = false; // 是否正在使用轮询兜底


  aboutToAppear(): void {
    // this.connectAndSubscribe();

    // 加载用户信息并加载聊天记录
    this.loadUserInfoAndMessages();
    this.startPolling();
  }

  private async connectAndSubscribe() {
    try {
      await this.wsManager.connect();

      const userId = this.userInfo.userid;
      const topic = `/queue/user/${userId}`;

      this.wsManager.subscribe(topic, (message: Message) => {
        if (message.fromUserId === this.userInfo.userid || message.toUserId === this.user.userid) {
          this.messageList = [...this.messageList, message];
          this.lastMessageId = message.id as string;
          this.scrollToBottom();
        }
      });

      this.isUsingPolling = false;
      this.stopPolling(); // 关闭轮询
    } catch (error) {
      console.warn("WebSocket connection failed, fallback to polling", error);
      this.isUsingPolling = true;
      this.startPolling(); // 启用轮询兜底
    }
  }


  private async fetchNewMessages() {
    try {
      const result = await getSingleHistoryMessages<Message[]>(Number(this.userInfo.userid));
      if (result.code === '200') {
        const newMessages = result.data.slice(result.data.findIndex(msg => msg.id === this.lastMessageId) + 1);

        console.info('newMessages',JSON.stringify(newMessages))
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
    const userId = this.userInfo.userid;
    const topic = `/queue/user/${userId}`;
    this.wsManager.unsubscribe(topic); // 取消订阅

    this.stopPolling()
    this.isUsingPolling = true
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
      if (result.data.length > 0) {
        this.lastMessageId = result.data[result.data.length - 1].id; // 设置初始 lastMessageId
      }
      this.scrollToBottom(); // ✅ 加载完成后滚动到底部
    }
  }

  // 启动轮询
  private startPolling() {
    if (this.pollingTimer) {
      return; // 避免重复启动定时器
    }
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

        MessageBottomComponent({
          toUserId: Number(this.userInfo.userid),
          messageList:this.messageList,
          sendMessage:(content:string)=>{
            this.handleSendMessage(content);
          }})
          .width('100%')
          .padding(10)
      }
      .width('100%')
      .height('100%')
    }
    .title(this.userInfo.username)
  }

  // private handleSendMessage(content: string) {
  //   if (!content.trim()) return;
  //
  //   const newMessage: Message = {
  //     id: Date.now().toString(),
  //     content: content,
  //     fromUserId: this.user.userid,
  //     toUserId: this.userInfo.userid,
  //     sendTime: new Date().toISOString()
  //   };
  //
  //   this.messageList = [...this.messageList, newMessage];
  //   this.lastMessageId = newMessage.id;
  //   this.scrollToBottom();
  //
  //   // 发送 WebSocket 消息
  //   this.wsManager.send("/app/send/single", {
  //     toUserId: Number(this.userInfo.userid),
  //     content: content
  //   });
  // }


  private async handleSendMessage(content: string) {
    const result = await sendSingleMessage<Message>(Number(this.userInfo.userid), content)
    if (result.code === '200') {
      console.log('SendMessage:', JSON.stringify(result.data))
      this.messageList = [...this.messageList, result.data]
      this.lastMessageId = result.data.id
      this.scrollToBottom()
    } else {
      console.error('SendMessage:', JSON.stringify(result.msg))
    }

  }


}