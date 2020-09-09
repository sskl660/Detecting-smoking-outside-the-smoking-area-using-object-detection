<%-- Created by IntelliJ IDEA. User: qwead Date: 2020-04-10 Time: 오후 11:36 To
change this template use File | Settings | File Templates. --%>
<%@ page contentType = "text/html;charset=EUC-KR" language = "java" %>
<%@page import="st.*"%>

<html>
  <head>
    <link rel="stylesheet" href="capstone.css" type="text/css" />

    <link
      href="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css"
      rel="stylesheet"
      id="bootstrap-css"
    />
    <script src="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js"></script>
    <script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
    <title>캡스톤</title>

  </head>
  <body>
    <div class="container login-container">
      <div class="row">
        <div class="col-md-6 login-form-1">
          <div id="top_title">Don't cross the line</div>
          <form action="LoginProc.jsp" method="post">
            <div class="form-group">
              <input type="text" name = "id"
                class="form-control"
                placeholder="아이디를 입력하세요."
                value=""
              />
            </div>
            <div class="form-group">
              <input type="password" name = "pw"
                class="form-control"
                placeholder="비밀번호를 입력하세요."
                value=""
              />
            </div>

            <div class="form-group">
              <input type = submit class = "btnSubmit" value = "Login">
            </div>

          </form>
        </div>
      </div>
    </div>
  </body>
</html>
