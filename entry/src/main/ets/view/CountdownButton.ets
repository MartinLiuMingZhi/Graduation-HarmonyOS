@Component
export struct CountdownButton {
  @State countdown: number = 0; // 当前倒计时剩余秒数
  @State isCounting: boolean = false; // 是否正在倒计时
  private intervalId: number| null = null; // 保存计时器 ID

  @Prop text: string = '获取验证码'; // 按钮默认文字
  @Prop duration: number = 10; // 倒计时时长

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
        }
      });
  }
}
