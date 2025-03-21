import request from '../request/request'

interface PostRequest{
  title:string,
  content:string,
  images:string[]
}

export function createPost<T>(data:PostRequest){
  return request<T>({
    url:'/posts/create',
    method:'POST',
    data
  })
}

export function deletePost<T>(postId:number){
  return request<T>({
    url:`/posts/delete/${postId}`,
    method:'DELETE',
  })
}

export function getPostById<T>(postId:number){
  return request<T>({
    url: `/posts/detail/${postId}`,  // 使用模板字符串替换路径参数
    method:'GET',
  })
}

export function getUserPostList<T>(page:number,pageSize:number){
  return request<T>({
    url:'/posts/user/list',
    method:'GET',
    params:{page,pageSize}
  })
}

export function likePost<T>(postId:number){
  return request<T>({
    url:'/posts/like',
    method:'POST',
    data:{postId}
  })
}

export function cancelPost<T>(postId:number){
  return request<T>({
    url:'/posts/cancel',
    method:'POST',
    data:{postId}
  })
}
