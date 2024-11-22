import request from '../request/request'

interface LoginRequest{
  email:string,
  password:string
}

export interface LoginResponse{
  userid:string,
  username:string,
  email:string,
  avatar:string,
  sex?:string,
  token:string
}
export function login<T>(data:LoginRequest){
  return request<T>({
    url:'/users/login',
    method:'POST',
    data
  })
}

interface CodeLoginRequest{
  email:string,
  code:string
}

export function codeLogin<T>(data:CodeLoginRequest){
  return request<T>({
    url:'/users/codeLogin',
    method:'POST',
    data
  })
}