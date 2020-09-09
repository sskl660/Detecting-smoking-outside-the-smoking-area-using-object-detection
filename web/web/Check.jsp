<%-- Created by IntelliJ IDEA. User: qwead Date: 2020-04-10 Time: 오후 11:36 To
change this template use File | Settings | File Templates. --%>
<%@ page contentType = "text/html;charset=EUC-KR" language = "java" %>
<%@page import = "st.*" %>
<%@page import = "java.util.ArrayList" %>
<%@ page import = "java.sql.Blob" %>
<%@ page import = "java.sql.ResultSet" %>
<%@ page import = "java.sql.Statement" %>
<%@ page import = "java.sql.Connection" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.io.*" %>

<html>
<head>
  <!-- MY CSS -->
  <link rel = "stylesheet" href = "style.css?after" type = "text/css"/>

  <!--JS -->
  <script type = "text/javascript" src = "capstone.js"></script>
  <script src = "https://code.jquery.com/jquery-3.2.1.min.js"></script>


  <!-- CSS only -->
  <link rel = "stylesheet" href = "https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css"
        integrity = "sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk"
        crossorigin = "anonymous">

  <!-- JS, Popper.js, and jQuery -->
  <script src = "https://code.jquery.com/jquery-3.5.1.slim.min.js"
          integrity = "sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj"
          crossorigin = "anonymous"></script>
  <script src = "https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"
          integrity = "sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo"
          crossorigin = "anonymous"></script>
  <script src = "https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js"
          integrity = "sha384-OgVRvuATP1z7JjHLkuOU7Xw704+h835Lr+6QL9UvYjZE3Ipu6Tp75j7Bh/kR0JKI"
          crossorigin = "anonymous"></script>
</head>
<body>
<div class = "container">

  <div id = "top_title" onclick = "goHome()">Don't cross the line</div>

  <div class = "row">
    <div class = "col-4">
      <div class = "row">
        <div class = "col">
          <div class = "card">
            <div class = "card-header bg-danger">
              <p class = "text-white text-center font-weight-bold" style = "margin: 0;">흡연 구역 위반 현장
                이미지</p>
            </div>
            <%
              String filename = request.getParameter("filename");

              if (filename == null) {
                filename = "./img/noimg.jpg";
              }
            %>

            <img id = "changeimg" src = "<%=filename%>" alt = "위반 적발 사진" class = "img-fluid">
          </div>
        </div>
      </div>
      <%!
        public Integer toInt(String x) {
          int a = 0;
          try {
            a = Integer.parseInt(x);
          } catch (Exception e) {
          }
          return a;
        }
      %>

      <%

        Connection conn = Config.getInstance().sqlLogin();
        PreparedStatement pstmt = null;
        Statement stmt = null;
        ResultSet rs = null;

        String sql = "select COUNT(*) from sys.students";
        stmt = conn.createStatement();
        rs = stmt.executeQuery(sql);

        int total_record = 0;


        if (rs.next()) {
          total_record = rs.getInt(1); //총 레코드 수
        }

//    int total_record=750;
        int pageno = toInt(request.getParameter("pageno"));
        if (pageno < 1) {//현재 페이지
          pageno = 1;
        }

        int page_per_record_cnt = 9;  //페이지 당 레코드 수
        int group_per_page_cnt = 5;     //페이지 당 보여줄 번호 수[1],[2],[3],[4],[5]
//                                              [6],[7],[8],[9],[10]

        int record_end_no = pageno * page_per_record_cnt;
        int record_start_no = record_end_no - (page_per_record_cnt - 1);
        if (record_end_no > total_record) {
          record_end_no = total_record;
        }

        int total_page = total_record / page_per_record_cnt + (total_record % page_per_record_cnt > 0 ? 1 : 0);
        if (pageno > total_page) {
          pageno = total_page;
        }

//    현재 페이지(정수) / 한페이지 당 보여줄 페지 번호 수(정수) + (그룹 번호는 현제 페이지(정수) % 한페이지 당 보여줄 페지 번호 수(정수)>0 ? 1 : 0)
        int group_no = pageno / group_per_page_cnt + (pageno % group_per_page_cnt > 0 ? 1 : 0);
//      현재 그룹번호 = 현재페이지 / 페이지당 보여줄 번호수 (현재 페이지 % 페이지당 보여줄 번호 수 >0 ? 1:0)
//   ex)    14      =   13(몫)      =    (66 / 5)      1   (1(나머지) =66 % 5)

        int page_eno = group_no * group_per_page_cnt;
//      현재 그룹 끝 번호 = 현재 그룹번호 * 페이지당 보여줄 번호
//   ex)    70      =   14   *   5
        int page_sno = page_eno - (group_per_page_cnt - 1);
//       현재 그룹 시작 번호 = 현재 그룹 끝 번호 - (페이지당 보여줄 번호 수 -1)
//   ex)    66   =   70 -    4 (5 -1)

        if (page_eno > total_page) {
//      현재 그룹 끝 번호가 전체페이지 수 보다 클 경우
          page_eno = total_page;
//      현재 그룹 끝 번호와 = 전체페이지 수를 같게
        }

        int prev_pageno = page_sno - group_per_page_cnt;  // <<  *[이전]* [21],[22],[23]... [30] [다음]  >>
//      이전 페이지 번호   = 현재 그룹 시작 번호 - 페이지당 보여줄 번호수
//   ex)      46      =   51 - 5
        int next_pageno = page_sno + group_per_page_cnt;   // <<  [이전] [21],[22],[23]... [30] *[다음]*  >>
//      다음 페이지 번호 = 현재 그룹 시작 번호 + 페이지당 보여줄 번호수
//   ex)      56      =   51 - 5
        if (prev_pageno < 1) {
//      이전 페이지 번호가 1보다 작을 경우
          prev_pageno = 1;
//      이전 페이지를 1로
        }
        if (next_pageno > total_page) {
//      다음 페이지가 전체페이지 수보다 클경우
//               next_pageno = total_page / group_per_page_cnt * group_per_page_cnt + 1;
          next_pageno=total_page;
//      다음 페이지 = 전체페이지수 / 페이지당 보여줄 번호수 * 페이지당 보여줄 번호수 + 1
//   ex)            =    76 / 5 * 5 + 1   ????????
        }

        // [1][2][3].[10]
        // [11][12]
      %>
      <%
        String stid = request.getParameter("studentId");
        String stName, stMajor, stMail, stImg;
        int stCnt;

        infoDAO infoDao = new infoDAO();
        infoVO info = infoDao.getInfo(stid);

        if (info != null) {
          stName = info.getName();
          stMajor = info.getMajor();
          stMail = info.getMail();
          stImg = "./stimg/" + info.getImg();
          stCnt = info.getDetectnum();
        } else {
          stName = "-";
          stMajor = "-";
          stMail = "-";
          stCnt = 0;
          stImg = "./img/noimg.jpg";
        }
      %>


      <div class = "row mt-3">
        <div class = "col">
          <div class = "card">
            <div class = "card-header">
              <p class = "text-center font-weight-bold" style = "margin: 0;">위반자 정보</p>
            </div>
            <div class = "card-body">
              <div class = "row">
                <div class = "col">
                  <img id = "stimg" src = "<%=stImg%>" alt = "위반자 사진" class = "img-fluid">
                </div>
                <div class = "col">
                  <h3 id = "name" class = "card-title font-weight-bold mb-0"><%=stName%>
                  </h3>
                  <p id = "stid" name = "stid" class = "card-text"><%=stid%>
                  </p>
                  <p id = "major" class = "card-text"><%=stMajor%>
                  </p>

                  <button id = "mail" class = "btn btn-primary btn-sm active"
                          onclick = "location.href='mailto:<%=stMail%>?\n'
                                  +'\t&subject=Don\'t cross the line 관리자입니다.\n'+
                                  '&body= 지정되지 않은 흡연구역에서 흡연을 하였습니다. 해당과사무실로 찾아오시길 바랍니다.'">
                    <%=stMail%>
                  </button>

                  <button type = "button" class = "btn btn-danger mt-1"/>
                  적발 횟수 <span><%=stCnt%></span>
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class = "col-8">

      <div class = "table-responsive">

        <table id = "findtxt" class = "table">
          <thead class = "thead-dark">
          <tr>
            <th scope = "col">날짜</th>
            <th scope = "col">이름</th>
            <th scope = "col">학번</th>
            <th scope = "col">학과</th>
          </tr>
          </thead>

          <tbody>
          <%
            stDAO dao = new stDAO();
            ArrayList<stVO> list = dao.stList();

            for (int i = list.size() - record_start_no ; i >= list.size() - record_start_no - 8; i--) {
              if (i - 1 < 0)
                break;
              stVO vo = new stVO();
              vo = list.get(i);
          %>
          <tr class = "findtxt" onclick = "" onmouseover = "this.style.background='skyblue'"
              onmouseout = "this.style.backgroundColor=''">
            <td><%=vo.getDate() %>
            </td>
            <td><%=vo.getName() %>
            </td>
            <td><%=vo.getId() %>
            </td>
            <td><%=vo.getMajor() %>
            </td>
            <td style = "display:none"><%=vo.getAddr() %>
            </td>
            </td>
            <td style = "display:none"><%=vo.getMail() %>
            </td>
            </td>
            <td style = "display:none"><%=vo.getImg() %>
            </td>
          </tr>

          <%
            } //for 문의 끝
          %>

          <%
            if(list.size() >= 1) {
            stVO vo1 = new stVO();
            vo1 = list.get(0);
          %>
          <tr class = "findtxt" onclick = "" onmouseover = "this.style.background='skyblue'"
              onmouseout = "this.style.backgroundColor=''">
            <td><%=vo1.getDate() %>
            </td>
            <td><%=vo1.getName() %>
            </td>
            <td><%=vo1.getId() %>
            </td>
            <td><%=vo1.getMajor() %>
            </td>
            <td style = "display:none"><%=vo1.getAddr() %>
            </td>
            </td>
            <td style = "display:none"><%=vo1.getMail() %>
            </td>
            </td>
            <td style = "display:none"><%=vo1.getImg() %>
            </td>
          </tr>
          <%
            }
          %>
          </tbody>

        </table>

        <nav aria-label="Page navigation example">
          <ul class="pagination justify-content-center">
            <li class="page-item"><a class="page-link" href = "Check.jsp?pageno=1&studentId=<%=stid%>&filename=<%=filename%>">[<<]</a></li>
            <li class="page-item"><a class="page-link" href = "Check.jsp?pageno=<%=prev_pageno%>&studentId=<%=stid%>&filename=<%=filename%>">[<]</a></li>

        <%for (int i = page_sno; i <= page_eno; i++) {%>
            <li class="page-item"><a class="page-link" href = "Check.jsp?pageno=<%=i%>&studentId=<%=stid%>&filename=<%=filename%>">
          <%if (pageno == i) { %>
          [<%=i %>]
          <%} else { %>
          <%=i %>
          <%} %>
        </a></li>
        <%--   콤마    --%>
        <%if (i < page_eno) { %>
        ,
        <%} %>
        <%} %>

            <li class="page-item"><a class="page-link" href = "Check.jsp?pageno=<%=next_pageno%>&studentId=<%=stid%>&filename=<%=filename%>">[>]</a></li>
            <li class="page-item"><a class="page-link" href = "Check.jsp?pageno=<%=total_page%>&studentId=<%=stid%>&filename=<%=filename%>">[>>]</a></li>

          </ul>
        </nav>
      </div>

      <div class="col-12">
        <div class="align-middle">
        <form name = "search" method = "post" action = "Search.jsp">
          <div class = "input-group mb-3">
            <div class = "input-group-prepend">
              <select class = "input-group-text" name = "keyField">
                <option value = "0"> 선택</option>
                <option value = "id"> 학번</option>
                <option value = "name"> 이름</option>
                <option value = "major"> 학과</option>
              </select>
            </div>
            <input type = "text" name = "keyword" class = "form-control" aria-label = "Sizing example input"
                   aria-describedby = "inputGroup-sizing-default" placeholder = "검색어를 입력하세요.">
            <div class = "input-group-append">
              <button class = "btn btn-outline-secondary btn-primary badge-primary text-wrap"
                      onclick = "searchCheck(form)" type = "button" id = "button-addon2">검색
              </button>
            </div>
          </div>
        </form>
        </div>
      </div>

    </div>
  </div>
</div>


<script>
  var email;
  $("#findtxt tr").click(function () {
    var pageno = <%=pageno%>;
    var tr = $(this);
    var td = tr.children();

//        var date = td.eq(0).text();
//        var name = td.eq(1).text();
    var stid = td.eq(2).text();
//        var major = td.eq(3).text();
    var filename = "./img/" + td.eq(4).text();
    var mail = td.eq(5).text();
    email = mail;
//        var stimg = "./stimg/" + td.eq(6).text();

//        document.getElementById("stimg").src = stimg;
//          document.getElementById("name").innerHTML = name;
//       document.getElementById("stid").innerHTML = stid;
//      document.getElementById("major").innerHTML = major;
//  document.getElementById("mail").innerHTML = mail;

    window.location.href = "Check.jsp?pageno="+pageno+"&studentId=" + stid + "&filename=" + filename;

  });

</script>


</body>
</html>