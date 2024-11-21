import request from '../request/request'

interface RegisterRequest{
  email:string,
  password:string,
  checkPassword:string,
  code:string
}

export interface RegisterResponse{
  userid:string,
  username:string,
  email:string,
  avatar:string,
  sex:string,
  token:string
}

export function register<T>(data:RegisterRequest){
  return request<T>({
    url:'/users/register',
    method:'POST',
    data
  })
}