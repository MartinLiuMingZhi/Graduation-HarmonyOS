export interface BaseResponse<T>{
  code?:string,
  msg?:string,
  data:T
}

export interface Page<T>{
  records:T,
  total: string,
  size: string,
  current: string,
  pages: string
}