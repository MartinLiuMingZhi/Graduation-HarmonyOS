import request from '../request/request'

export interface CommentDTO{
  commentId: string,
  userId: string,
  content:  string,
  commentTime: string,
  likeCount: number,
  isDeleted:  boolean,
  parentCommentId: string,
  isLiked: boolean,
  children: CommentDTO[]
}

export function getComments<T>(postId:number){
  return  request<T>({
    url:`/comments/${postId}`,
    method:'GET',
    params: { postId }
  })
}

export function getCommentCounts<T>(postId:number){
  return request<T>({
    url:`/comments/count/${postId}`,
    method:'GET',
    params: { postId }
  })
}

interface PostCommentRequest{
  userId: number,
  postId: number,
  content: string,
  parentCommentId: number //可为null
}

export function createComment<T>(data:PostCommentRequest){
  return request<T>({
    url:'/comments/create',
    method:'POST',
    data
  })
}