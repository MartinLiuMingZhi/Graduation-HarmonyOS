import request from '../request/request'

export interface FriendRequestResponse{
  userid: string,
  username: string,
  email: string,
  avatar: string,
  sex: string,
  status: boolean
}

export interface UserDTO{
  userid: string,
  username: string,
  email: string,
  avatar: string,
  sex: string,
}


export function getUserByEmailOrUsername<T>(emailOrUsername:string){
  return request<T>({
    url:'/users/getUserByEmailOrUsername',
    method:'GET',
    params: { emailOrUsername }
  })
}

export function getUserById<T>(id:number){
  return request<T>({
    url:`/users/${id}`,
    method:'GET',
    params: { id }
  })
}

interface ChangePasswordRequest{
  oldPassword: string,
  newPassword: string,
  confirmPassword: string
}
export function changePassword<T>(data:ChangePasswordRequest){
  return request<T>({
    url:'/users/changePassword',
    method:'POST',
    data
  })
}

interface ForgetPasswordRequest{
  email: string,
  code: string,
  password: string,
  confirmPassword: string
}
export function forgetPassword<T>(data: ForgetPasswordRequest){
  return request<T>({
    url:'/users/forgetPassword',
    method:'PUT',
    data
  })
}

interface User{
  userId: number,
  username: string,
  password: string,
  email: string,
  avatar: string,
  sex: string,
  createdTime:  string,
  musicPreferences:string
}
export function update<T>(data: User){
  return request<T>({
    url:'/users/update',
    method:'PUT',
    data
  })
}