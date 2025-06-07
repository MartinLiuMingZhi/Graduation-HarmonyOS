import webSocket from '@ohos.net.webSocket';
import { BusinessError } from '@kit.BasicServicesKit';
// 引入 STOMP 客户端
import {Stomp, CompatClient,StompSubscription,FrameImpl } from '@ohos/stompjs';
import { PreferencesUtil } from '../utils/PreferencesUtil';
import { Message } from '../apis/message';

export interface MessageDTO {
  toUserId: number;
  content: string;
}

interface StompMessage {
  body: string;
}

export class WebSocketManager {
  private static instance: WebSocketManager;
  private defaultIpAddress: string = "ws://10.0.2.2:5600/ws";
  private heartbeatInterval: number = 5000; // 每5秒发送一次心跳
  private compatClient: CompatClient | undefined;
  private isConnect: boolean = false;
  private subscriptions: Map<string, StompSubscription> = new Map(); // 存储订阅
  private reconnectAttempts: number = 0; // 当前重试次数
  private maxReconnectAttempts: number = 5; // 最大重试次数
  private reconnectInterval: number = 5000; // 每隔多久重试一次（ms）
  private reconnectTimer: number | undefined;

  private constructor() {
    // 初始化STOMP客户端
    this.compatClient = Stomp.client(this.defaultIpAddress);
    // 设置默认心跳间隔（outgoing 和 incoming）
    if (this.compatClient) {
      this.compatClient.heartbeat.outgoing = this.heartbeatInterval;
      this.compatClient.heartbeat.incoming = this.heartbeatInterval;
    }
  }

  // 获取单例实例
  public static getInstance(): WebSocketManager {
    if (!WebSocketManager.instance) {
      WebSocketManager.instance = new WebSocketManager();
    }
    return WebSocketManager.instance;
  }

  //连接到WebSocket
  public async connect(): Promise<void> {
    if (this.isConnect || !this.compatClient) {
      console.warn('Already connected or not initialized.');
      return;
    }
    const token = await PreferencesUtil.getAsync('token')
    console.log("token:"+token)
    this.compatClient?.connect({Authorization: `Bearer ${token}`}, (frame: FrameImpl) => {
        console.log('Connected to WebSocket:', frame);
        this.isConnect = true;
        this.reconnectAttempts = 0; // 成功连接后重置重试次数
    },
      (error:  BusinessError)=>{
        console.log('WebSocket error:', error);
        this.isConnect = false;
        this.handleReconnect(); // 启动自动重连
      })
    console.log('Connecting to WebSocket...')
    console.log("Connect状态"+this.isConnect)
  }

  //断开连接
  public disconnect(): void {
    if (!this.compatClient || !this.isConnect){
      console.warn('Not connected or not initialized.');
      return;
    }
    this.compatClient.disconnect(() => {
      console.log("Disconnected from WebSocket");
      this.isConnect = false;
      this.subscriptions.forEach(sub => sub.unsubscribe());
      this.subscriptions.clear();
    });
  }

  //订阅节点并接收WebSocket数据。
  public subscribe(topic: string, callback: (message: Message) => void): void {
    if (!this.compatClient || !this.isConnect) {
      console.warn(`Cannot subscribe to ${topic}: Not connected`);
      return;
    }

    if (this.subscriptions.has(topic)) {
      console.warn(`Already subscribed to topic: ${topic}`);
      return;
    }

    const subscription = this.compatClient.subscribe(topic, (message: StompMessage) => {
      try {
        const messageDto: Message = JSON.parse(message.body)
        console.log(`Received message from ${topic}:`, messageDto);
        callback(messageDto); // 或者直接传整个对象
      } catch (error) {
        console.error("Failed to parse message:", error);
      }
    });

    this.subscriptions.set(topic, subscription);
    console.log(`Subscribed to topic: ${topic}`);
  }

  //取消订阅
  public unsubscribe(topic: string): void {
    const subscription = this.subscriptions.get(topic);
    if (subscription) {
      subscription.unsubscribe();
      this.subscriptions.delete(topic);
      console.log(`Unsubscribed from topic: ${topic}`);
    }
  }

  //发送数据
  // 发送消息到指定目的地（如 /app/send/single）
  public send(destination: string, body: MessageDTO): void {
    if (!this.compatClient || !this.isConnect) {
      console.warn("Not connected, message not sent.");
      return;
    }

    this.compatClient.send(destination, {}, JSON.stringify(body));
    console.log(`Message sent to ${destination}`, body);
  }

  // 获取当前连接状态
  public isConnected(): boolean {
    return this.isConnect;
  }

  // 自动重连方法
  private handleReconnect(): void {
    if (this.reconnectAttempts >= this.maxReconnectAttempts) {
      console.warn('Maximum reconnect attempts reached. Giving up.');
      return;
    }

    this.reconnectAttempts += 1;
    console.log(`Attempting to reconnect... Attempt ${this.reconnectAttempts} of ${this.maxReconnectAttempts}`);

    this.reconnectTimer = setTimeout(() => {
      this.connect().catch(console.error);
    }, this.reconnectInterval);
  }

  // 主动触发重连
  public reconnect(): void {
    if (!this.isConnect) {
      clearTimeout(this.reconnectTimer);
      this.reconnectAttempts = 0;
      this.connect().catch(console.error);
    }
  }


}