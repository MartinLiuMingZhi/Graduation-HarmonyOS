import request from '../request/request'

export function sendFriendRequest<T>(receiverId:number){
  return request<T>({
    url:'/friend-requests/send',
    method:'POST',
    data:{receiverId}
  })
}

export function getFriendRequests<T>(){
  return request<T>({
    url:'/friend-requests/list',
    method:'GET',
  })
}

export function handleFriendRequest<T>(requestId:number, status:string){
  return request<T>({
    url:'/friend-requests/handle',
    method:'POST',
    data:{requestId,status}
  })
}