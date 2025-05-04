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

