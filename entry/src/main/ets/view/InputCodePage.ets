import { verifyCode } from "../apis/mail"
import { CodeInputComponent } from "./CodeInputComponent"

@Component
export struct InputCodePage{
  @State codeIsCorrect:boolean = false
  @State email:string = '1950753216@qq.com'
  build() {
    Column() {
      CodeInputComponent({
        onCodeFinish:(code:string) =>{
          this.verifyCode(code)//接收结果回调
        },
        codeIsCorrect:$codeIsCorrect//设置校验结果初始值
      })
    }
  }
  private async verifyCode(code:string){
    const result = await verifyCode<string>({email:this.email,code:code})
    if (result.code === '200'){
      this.codeIsCorrect = true
    }else{
      this.codeIsCorrect = false
    }
  }
}