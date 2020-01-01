<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%
    String path=request.getContextPath();
    String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path;
    %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
    <head>
        <meta charset="utf-8">
        <title></title>
        <link href="<%=basePath %>/layui/css/layui.css" rel="stylesheet" />
        <link href="<%=basePath %>/css/bootstrap.min.css" rel="stylesheet"/>
        <style type="text/css">
            #pageId a:hover{
                border:1px solid #009688;
            }
            #pageId a{
                color:#555555;
            }
        </style>
    </head>
    <body>
        <div class="layui-fluid" style="margin: 15px;">
                <div style="padding:10px;">
                    <h1>文章管理页面</h1>
                </div>
                <div class="layui-btn-group demoTable">
                      <button type="button" class="layui-btn" onclick="selectAllBtn();">全选</button>
                      <button type="button" class="layui-btn layui-btn-normal" onclick="insertArticle();">添加文章</button>
                      <button type="button" class="layui-btn layui-btn-danger" id="cleanMoreBtn">删除选中</button>
                 </div>
                 <table class="layui-table">
                    <colgroup>
                      <col width="10">
                      <col width="10">
                      <col width="80">
                      <col width="80">
                      <col width="50">
                      <col width="15">
                      <col width="60">
                      <col width="120">
                    </colgroup>
                    <thead>
                      <tr>
                        <th><input type="checkbox" id="all" onclick="selectAll(this);"></th>
                        <th>ID</th>
                        <th>文章标题</th>
                        <th>文章作者</th>
                        <th style="width:150px;">文章内容</th>
                        <th>最后修改</th>
                        <th>状态</th>
                        <th>操作</th>
                      </tr> 
                    </thead>
                    <tbody>
                      <c:forEach items="${requestScope.pages.getList()}" var="article">
                      <tr>
                        <th><input type="checkbox" class="a_id" name="a_id" value="${article.a_id }"></th>
                        <td>${article.a_id }</td>
                        <td>${article.a_title }</td>
                        <td>${article.a_username }</td>
                        <td>
                            <div style="width:260px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">
                            ${article.a_article }
                            </div>
                        </td>
                        <td>${article.a_lasttime}</td>
                        <td>
                        <c:if test="${article.a_status==1 }">
                        <span class="layui-badge layui-bg-green">存在</span>
                        </c:if>
                        <c:if test="${article.a_status==0 }">
                        <span class="layui-badge layui-btn-danger">已删除</span>
                        </c:if>
                        </td>
                        <td>
                            <a href="<%=basePath%>/article/toViewArticle?a_id=${article.a_id}"><button type="button" class="layui-btn layui-btn-xs">查看</button></a>
                            <a href="<%=basePath%>/article/toEditArticle?a_id=${article.a_id}"><button type="button" class="layui-btn layui-btn-normal layui-btn-xs">编辑</button></a>
                            <button type="button" onclick="return remove(${article.a_id});" class="layui-btn layui-btn-danger layui-btn-xs">删除</button>
                        </td>
                      </tr>
                      </c:forEach>
                    </tbody>
                  </table>
                  <form class="layui-form">
                      <ul id="pageId" class="pagination" style="float:left">
                            <li>
                            <a href="<%=basePath%>/article/findArticleByPage?pageN=1&pageSize=${requestScope.pages.pageSize}">首页</a>
                            </li>
                            <c:if test="${requestScope.pages.pageNum >2}">
                                <li>
                                      <a href="<%=basePath%>/article/findArticleByPage?pageN=${requestScope.pages.pageNum-1}&pageSize=${requestScope.pages.pageSize}">
                                                                                                                        &laquo;
                                      </a>
                                </li>
                            </c:if>
                            <c:choose>
                                <c:when test="${requestScope.pages.pages<=5}">
                                    <c:set var="begin" value="1"></c:set>
                                    <c:set var="end" value="${requestScope.pages.pages}"></c:set>
                                </c:when>
                                <c:otherwise>
                                    <c:set var="begin" value="${requestScope.pages.pageNum-1}"></c:set>
                                    <c:set var="end" value="${requestScope.pages.pageNum+3}"></c:set>
                                    
                                    <!-- 头溢出 -->
                                    <c:if test="${begin<1 }">
                                        <c:set var="begin" value="1"></c:set>
                                        <c:set var="end" value="5"></c:set>
                                    </c:if>
                                    
                                    <!-- 尾溢出  -->
                                    <c:if test="${end>requestScope.pages.pages }">
                                        <c:set var="begin" value="${requestScope.pages.pages-4}"></c:set>
                                        <c:set var="end" value="${requestScope.pages.pages}"></c:set>
                                    </c:if>
                                </c:otherwise>
                            </c:choose>
                            <c:forEach begin="${begin}" end="${end}" var="i">
                                <c:if test="${i==requestScope.pages.pageNum }">
                                    <li>
                                      <a style="background-color: #009688;color:#ffffff;" href="<%=basePath%>/article/findArticleByPage?pageN=${i}&pageSize=${requestScope.pages.pageSize}">
                                      ${i}
                                      </a>
                                    </li>
                                </c:if>
                                <c:if test="${i!=requestScope.pages.pageNum }">
                                    <li>
                                      <a href="<%=basePath%>/article/findArticleByPage?pageN=${i}&pageSize=${requestScope.pages.pageSize}">
                                      ${i}
                                      </a>
                                    </li>
                                </c:if>
                            </c:forEach>
                            <c:if test="${requestScope.pages.pageNum <requestScope.pages.pages}">
                                <li>
                           <a href="<%=basePath%>/article/findArticleByPage?pageN=${requestScope.pages.pageNum+1}&pageSize=${requestScope.pages.pageSize}">&raquo; </a>
                                </li>
                            </c:if>
                            <li>
                                 <a href="<%=basePath%>/article/findArticleByPage?pageN=${requestScope.pages.pages}&pageSize=${requestScope.pages.pageSize}">尾页</a>
                            </li>
                            <li>
                             <a>每页显示${requestScope.pages.pageSize}条/共${requestScope.pages.total}条</a>
                            </li>
                       </ul>
                  </form>
              </div>
        <script src="<%=basePath %>/layui/layui.all.js" type="text/javascript"></script>
        <script src="<%=basePath %>/js/jquery.min.js" type="text/javascript"></script>
        <script src="<%=basePath %>/js/jquery.timers.min.js" type="text/javascript"></script>
        <script src="<%=basePath %>/js/my.js" type="text/javascript"></script>
        <script type="text/javascript">
        function selectAll(obj){
            $(".a_id").prop("checked",obj.checked);
        }
        function selectAllBtn(){
            $("#all").prop("checked",true);
            $(".a_id").prop("checked",true);
        }
        function insertArticle(){
            $.ajax({
                url:'<%=basePath%>/article/insertArticle',
                type:'POST',
                success:function(data){
                    $("body").html(data);
                }
            });
        }
        function remove(a_id){
            layer.open({
                title:'警告信息',
                content:'你确定要删除Id为（'+a_id+'）的文章？',
                icon: 7,
                btn:['确定','取消'],
                btn1:function(index,layero){
                    $.ajax({
                        url:'<%=basePath%>/article/remove',
                        type:'POST',
                        data:{a_id:a_id},
                        success:function(data){
                            layer.open({
                                title:'提示信息',
                                content:'删除成功!',
                                icon:1,
                                time:1000
                            });
                            $("body").oneTime('1s',function(){
                                $("body").html(data);
                            });
                            
                        },
                        error:function(){
                            layer.open({
                                title:'错误信息',
                                icon: 2,
                                content:'删除失败!',
                            })
                        }
                    });
                    layer.close(index);
                }
            })
            
        }
        $("#cleanMoreBtn").click(function(){
            var arr=[];
            //遍历选中的checkbox
            $('input[name="a_id"]').each(function(){
                var state=$(this).prop('checked');
                if(state){
                    arr.push(+$(this).val());
                }
            })
            layer.open({
                title:'提示信息',
                icon: 7,
                content:'你确定要删除选中的文章？',
                btn:['确定','取消'],
                btn1:function(index,layero){
                    $.ajax({
                        url:'<%=basePath%>/article/removeMore',
                        type:'POST',
                        data:{a_id:"["+arr+"]"},
                        success:function(data){
                            layer.open({
                                title:'提示信息',
                                content:'删除成功!',
                                icon:1,
                                time:1000
                            });
                            $("body").oneTime('1s',function(){
                                $("body").html(data);
                            });
                        },
                        error:function(){
                            layer.open({
                                title:'错误信息',
                                icon: 2,
                                content:'删除失败!',
                            })
                        }
                    });
                    layer.close(index);
                }
            })
        })
        </script>
    </body>
</html>
