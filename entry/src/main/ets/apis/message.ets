import request from '../request/request'

export interface Message{
  id: string,
  fromUserId: string,
  toUserId: string,
  toGroupId: string,
  toType: string,
  content: string,
  sendTime: string
}

export function getMessageList(){

}
