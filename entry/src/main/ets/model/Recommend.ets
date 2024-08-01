

export let recommend :RecommendBean [] = [{
  title:'热门博文',
  url:'',
  res:''
},{
  title:'每日一问',
  url:'',
  res:''
}]

export class RecommendBean{
  title:string = ''
  url:string  = ''
  res:ResourceStr = ''
}