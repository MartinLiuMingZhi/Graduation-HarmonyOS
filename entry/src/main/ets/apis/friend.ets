import request from '../request/request'

export interface FriendRequests{
  id: number,
  requesterId: number,
  receiverId: number,
  status: boolean,
  requestTime: string,
}



export function sendFriendRequest<T>(receiverId: number){
  return request<T>({
    url:'/friend-requests/send',
    method:'POST',
    params: { receiverId }
  })
}

export function getFriendRequests<T>(){
  return request<T>({
    url:'/friend-requests/list',
    method:'GET'
  })
}

export function handleFriendRequest<T>(requesterId: number){
  return request<T>({
    url:'/friend-requests/handle',
    method:'POST',
    params: { requesterId }
  })
}


export function getFriendList<T>(page: number, pageSize: number){
  return request<T>({
    url:'/friends/list',
    method:'GET',
    params: { page, pageSize }
  })
}
