import axios, { AxiosError, AxiosResponse, InternalAxiosRequestConfig,AxiosRequestConfig } from '@ohos/axios'
import { Logger } from '../utils/Logger';
import { PreferencesUtil } from '../utils/PreferencesUtil';

interface BaseResponse<T>{
  code?:string,
  msg?:string,
  data:T
}

const instance = axios.create({
  baseURL: 'http://10.0.2.2:5600/api',
  timeout: 30000,
  headers: {
    'Content-Type': 'application/json',
  },
});


// 添加请求拦截器
instance.interceptors.request.use(async (config:InternalAxiosRequestConfig)=>{
  const token = await PreferencesUtil.getAsync('token')
  if (token) {
    config.headers['Authorization'] = 'Bearer ' + token;
  }
  return config
}, (error:AxiosError) => {
  // 对请求错误做些什么
  console.error('request error:' + error);
  return Promise.reject(error);
})

// 添加响应拦截器
instance.interceptors.response.use((response: AxiosResponse) => {
  return response.data
}, (error: AxiosError) => {
  if (error.response) {
    // 处理已知错误
    console.error('Response Error:', error.response.data)
    handleResponseError(error.response);
  } else if (error.request) {
    // 处理请求发送失败
    console.error('Request Error:', error.request)
  } else {
    // 处理其他错误
    console.error('Error:', error.message)
  }
  return Promise.reject(error)
})

// 处理响应错误的函数
const handleResponseError = (response: AxiosResponse) => {
  switch (response.status) {
    case 401:
      // Token 过期或无效，清除本地存储的 Token 并跳转到登录页面
      PreferencesUtil.deleteAsync('token');
      Logger.info('Token expired or invalid. Redirect to login page.');
      // 这里可以添加跳转到登录页面的逻辑
      break;
    case 403:
      Logger.info('Forbidden: You do not have permission to access this resource.');
      break;
    case 404:
      Logger.info('Resource not found.');
      break;
    case 500:
      Logger.info('Server error. Please try again later.');
      break;
    default:
      Logger.info(`Unexpected error: ${response.status}`);
  }
};

export default <T> (config:AxiosRequestConfig):Promise<BaseResponse<T>>=>{
  return instance(config)
}


