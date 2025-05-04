// // WebSocketUtil.ets 改造版
// import { webSocket } from '@kit.NetworkKit';
// import { BusinessError } from '@kit.BasicServicesKit';
// import { PreferencesUtil } from './PreferencesUtil';
// import { Logger } from './Logger';
//
// class WebSocketUtil {
//   private ws: webSocket.WebSocket | null = null;
//   private subscriptions: Map<string, (data: Record<string,unknown>) => void> = new Map();
//
//   // 配置项类型声明
//   async connect() {
//     this.ws = webSocket.createWebSocket();
//     this.setupEventListeners();
//     this.ws.connect('ws://10.0.2.2:5600/app');
//   }
//
//   private setupEventListeners() {
//     const ws = this.ws!;
//
//     ws.on('open', (err: BusinessError) => {
//       if (err) {
//         Logger.error('连接失败:', err);
//         return;
//       }
//       Logger.info('WS连接成功');
//       this.reSubscribeAll();
//     });
//
//     ws.on('message', (err: BusinessError, data: string) => {
//       if (err) return;
//       try {
//         const msg = JSON.parse(data);
//         this.subscriptions.get(msg.destination)?.(msg.body);
//       } catch (e) {
//         Logger.error('消息解析失败:', e);
//       }
//     });
//
//     ws.on('close', (err: BusinessError, res: CloseResult) => {
//       Logger.info(`连接关闭: ${res.code} ${res.reason}`);
//     });
//
//     ws.on('error', (err: BusinessError) => {
//       Logger.error('连接异常:', err);
//     });
//   }
//
//   public subscribe(topic: string, callback: (data: any) => void) {
//     this.subscriptions.set(topic, callback);
//   }
//
//   public send(topic: string, payload: any) {
//     const message = JSON.stringify({
//       destination: topic,
//       body: payload
//     });
//     this.ws?.send(message);
//   }
//
//   private reSubscribeAll() {
//     this.subscriptions.forEach((callback, topic) => {
//       this.subscribe(topic, callback);
//     });
//   }
// }
//
// export default new WebSocketUtil();
