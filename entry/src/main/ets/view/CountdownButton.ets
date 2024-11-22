import { sendCode } from "../apis/mail";

@Component
export struct CountdownButton {
  @State countdown: number = 0; // 当前倒计时剩余秒数
  @State isCounting: boolean = false; // 是否正在倒计时
  private intervalId: number| null = null; // 保存计时器 ID

  @Prop text: string = '获取验证码'; // 按钮默认文字
  @Prop duration: number = 60; // 倒计时时长
  @Prop email: string = '';

  private startCountdown() {
    if (this.isCounting) return; // 防止重复点击
    this.isCounting = true;
    this.countdown = this.duration;

    // 每秒更新倒计时
    this.intervalId = setInterval(() => {
      this.countdown--;
      if (this.countdown <= 0) {
        clearInterval(this.intervalId);
        this.intervalId = null;
        this.isCounting = false; // 倒计时结束
      }
    }, 1000);

  }

  build() {
    Button(this.isCounting ? `${this.countdown}秒后重试` : this.text)
      .width('30%')
      .type(ButtonType.Capsule)
      .backgroundColor(this.isCounting ? '#cccccc' : '#007dff')
      .onClick(() => {
        if (!this.isCounting) {
          this.startCountdown();
            this.handleGetCode()
        }
      });
  }

  private async handleGetCode() {
    console.info('CountdownButton:handleGetCode', this.email)
    try {
      const result = await sendCode<string>(this.email);
      if (result.code === '200') {
        console.info("获取验证码成功");
      } else {
        console.info('获取验证码失败')
      }
    } catch (error) {
      console.error('获取验证码请求失败:', error);
    }
  }
}
