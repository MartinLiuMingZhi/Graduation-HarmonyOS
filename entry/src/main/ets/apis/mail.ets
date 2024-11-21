import request from '../request/request'

export function sendCode<T>(email:string){
  return request<T>({
    url:'/mail/sendCode',
    method:'GET',
    data: email
  })
}

interface VerifyCodeRequest{
  email:string,
  code:string
}

export function verifyCode<T>(data:VerifyCodeRequest){
  return request<T>({
    url:'/mail/verifyCode',
    method:'POST',
    data
  })
}

