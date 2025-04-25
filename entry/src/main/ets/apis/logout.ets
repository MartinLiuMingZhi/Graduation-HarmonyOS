import request from '../request/request'

export function logout<T>(){
  return request<T>({
    url:'/users/logout',
    method:'Post'
  })
}