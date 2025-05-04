import webSocket from '@ohos.net.webSocket';
import { BusinessError } from '@kit.BasicServicesKit';

// 单例模式

export class WebSocketManager {

  private static instance: WebSocketManager;
  private  ws: webSocket.WebSocket;
  private  defaultIpAddress:string;
  private heartbeatInterval: number = 20000; // 20秒
  private heartbeatMessage: string = 'ping'; // 心跳消息
  private heartbeatTimer: number | undefined; // 用于保存定时器ID

  private constructor() {
    // 私有构造函数，防止外部实例化对象
    this.ws = webSocket.createWebSocket();
    this.defaultIpAddress = "ws://10.0.2.2:8080/ws";
  }

  public static getInstance(): WebSocketManager {
    if (!WebSocketManager.instance) {
      WebSocketManager.instance = new WebSocketManager();
    }
    return WebSocketManager.instance;
  }

  //  根据URL地址，建立一个WebSocket连接。
  public async connect(){
    this.ws.connect(this.defaultIpAddress,(err: BusinessError,value: boolean)=>{
      if (!err) {
        console.log("Connected successfully");
      } else {
        console.log("Connection failed. Err:" + JSON.stringify(err));
      }
    })
  }

  //关闭WebSocket连接
  public async close(){
    this.ws.close((err: BusinessError,value: boolean)=>{
      if (!err) {
        console.log("Close successfully");
      } else {
        console.log("Close failed. Err:" + JSON.stringify(err));
      }
    })
  }

  // 订阅WebSocket的打开事件。
  public async subscribeOpen(content:string){
    this.ws.on('open', (err: BusinessError, value: Object)=>{
      console.log("on open, status:" + JSON.stringify(value));
      // 当收到on('open')事件时，可以通过send()方法与服务器进行通信
      this.ws.send(content, (err: BusinessError, value: boolean) => {
        if (!err) {
          console.log("Message send successfully");
        } else {
          console.log("Failed to send the message. Err:" + JSON.stringify(err));
        }
      });
    })
  }

  // 取消订阅WebSocket的打开事件。
  public async unsubscribeOpen(){
    this.ws.off('open');
  }

  //订阅WebSocket的接收到服务器消息事件。
  public async subscribeMessage(callback:(message:string)=>void){
    this.ws.on('message', (err: BusinessError, value: string | ArrayBuffer) => {
      if (!err && typeof value === 'string') {
        console.log("Received message:" + value);
        if (value === 'pong') {
          console.log("Received pong response.");
        } else {
          console.log("Received business message:" + value);
          callback(value); // 正常业务消息回调
        }
      } else {
        console.error("Failed to receive the message. Err:" + JSON.stringify(err));
      }
    });
  }

  // 取消订阅WebSocket的接收到服务器消息事件。
  public async unsubscribeMessage(){
    this.ws.off('message');
  }

  // 订阅WebSocket的关闭事件。
  public async subscribeClose(){
    this.ws.on('close', (err: BusinessError, value: webSocket.CloseResult)=>{
      console.log("on close, status:" + JSON.stringify(value));
    })
  }

  // 取消订阅WebSocket的关闭事件。
  public async unsubscribeClose(){
    this.ws.off('close');
  }

  // 订阅WebSocket的Error事件。
  public async subscribeError(){
    this.ws.on('error', (err: BusinessError)=>{
      console.log("on error, status:" + JSON.stringify(err));
    })
  }

  // 取消订阅WebSocket的Error事件。
  public async unsubscribeError(){
    this.ws.off('error');
  }

  // 启动心跳机制
  public startHeartbeat(): void {
    if (this.heartbeatTimer) {
      clearInterval(this.heartbeatTimer); // 防止重复启动
    }
    this.heartbeatTimer = setInterval(() => {
      if (this.ws) {
        console.log("Sending heartbeat...");
        this.ws.send(this.heartbeatMessage, (err: BusinessError, value: boolean) => {
          if (!err) {
            console.log("Heartbeat sent successfully");
          } else {
            console.error("Failed to send heartbeat. Err:" + JSON.stringify(err));
            this.handleConnectionError(); // 可触发重连逻辑
          }
        });
      }
    }, this.heartbeatInterval);
  }

  // 停止心跳机制
  public stopHeartbeat(): void {
    if (this.heartbeatTimer) {
      clearInterval(this.heartbeatTimer);
      this.heartbeatTimer = undefined;
    }
  }

  // 处理连接异常（如重启连接或重连）
  private handleConnectionError(): void {
    console.warn("Connection lost. Attempting to reconnect...");
    this.stopHeartbeat();
    setTimeout(() => {
      this.connect().then(() => this.startHeartbeat());
    }, 5000); // 5秒后尝试重连
  }
}