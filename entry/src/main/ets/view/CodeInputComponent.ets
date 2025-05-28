@Preview
@Component
export struct CodeInputComponent{
  @State index:number = 0
  @State cursorBg:Color = Color.Blue

  @State lastInputContent:string = ''
  @Link codeIsCorrect:boolean  //需要父组件传入验证码校验结果
  onCodeFinish:Function = (value:string)=>{};//返回验证码回调
  private codeLen = 6
  private codeArray:Array<number> = [0,1,2,3,4,5]

  build(){
    Stack(){
      Row(){
        ForEach(this.codeArray,(item:number)=>{
          Text(this.getCode(item))
            .codeInputStyle(this.index == item)
        })
      }
      .width('82%')
      .margin({
        top:20
      })
      .justifyContent(FlexAlign.SpaceBetween)
      Row(){
        ForEach(this.codeArray,(item:number)=>{
          Line().cursorLine(this.index == item,this.cursorBg)
        },)
      }
      .width('85%')
      .margin({
        top:20
      })
      .justifyContent(FlexAlign.SpaceAround)
      .onAppear(()=>{
        this.cursorBg = Color.Transparent
      })
      TextInput({
        text:this.lastInputContent
      })
        .width('82%')
        .type(InputType.Number)
        .maxLength(this.codeLen)
        .fontSize(12)
        .focusable(true)
        .fontColor(Color.Transparent)
        .caretColor(Color.Transparent)
        .backgroundColor(Color.Transparent)
        .margin({
          top:20
        })
        .copyOption(CopyOptions.None)
        .onChange((value:string) =>{
          this.dispatchInputCode(value)
        })
    }
  }

  getCode(pos:number):string{
    if (this.lastInputContent.length > pos){
      return this.lastInputContent.charAt(pos);
    }else{
      return ''
    }
  }

  dispatchInputCode(input:string){
    if (this.lastInputContent.length >= input.length){
      if (this.index > 0){
        this.index--
      }
    }else{
      if (this.index < this.codeLen){
        this.index ++
      }
    }
    this.lastInputContent = input
    if (input.length == this.codeLen){
      this.onCodeInputFinish()
    }
  }

  onCodeInputFinish(){
    this.onCodeFinish(this.lastInputContent)
    if (!this.codeIsCorrect){
      this.lastInputContent = '';
      this.index = 0;
    }
  }
}
//扩展Text属性
@Extend(Text) function codeInputStyle(select:boolean){
  .width(44)
  .height(44)
  .fontSize(18)
  .textAlign(TextAlign.Center)
  .backgroundColor(select?$r('app.color.input_bg_select'):$r('app.color.input_bg'))
  .fontColor(Color.Black)
  .borderRadius(8)
  .focusable(select)
}
//扩展Line属性
@Extend(Line) function cursorLine(select:boolean,cursorBg:Color){
  .width(2)
  .height(22)
  .visibility(select ? Visibility.Visible:Visibility.Hidden)
  .backgroundColor(cursorBg)
  .animation({
    duration:600,
    tempo:1,
    curve:Curve.Smooth,
    delay:0,
    iterations:-1,
    playMode:PlayMode.AlternateReverse
  })
}
