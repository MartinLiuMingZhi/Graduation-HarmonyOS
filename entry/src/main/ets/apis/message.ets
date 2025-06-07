import request from '../request/request'

export interface Message{
  id: string,
  fromUserId: string,
  toUserId?: string,
  toGroupId?: string,
  toType?: string,
  content: string,
  sendTime: string
}

export function getSingleHistoryMessages<T>(user2:number){
  return request<T>({
    url:'/messages/history/single',
    method:'GET',
    params: { user2 }
  })
}

export function sendSingleMessage<T>(toUserId:number,content:string ) {
  return request<T>({
    url:'/messages/send/single',
    method:'POST',
    params: { toUserId,content }
  })

}

export interface ContactItem{
  userId: string,
  username: string,
  avatar: string,
  lastMessage: string,
  lastTime: string
}

export function getContact<T>(){
  return request<T>({
    url:'/messages/contact',
    method:'GET'
  })
}