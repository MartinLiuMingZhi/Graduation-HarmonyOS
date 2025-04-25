import request from '../request/request'

export interface FriendRequestResponse{
  userid: number,
  username: string,
  email: string,
  avatar: string,
  sex: string,
  status: boolean
}

export interface UserDTO{
  userid: number,
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

