function goHome() {
    location.href = "Check.jsp";
}

function goCheck() {
    location.href = "Check.jsp";
}

function goSearch() {
    location.href = "Search.jsp";
}



function showimg() {
    var pic = document.getElementById("picture");
    pic.style.backgroundRepeat = "no-repeat";
    pic.style.backgroundImage = 'url("test.jpg ")';
    pic.style.backgroundSize = "600px 400px";
    pic.style.backgroundPosition = "center";

}


function searchCheck(fm) {
    if(fm.keyword.value == "") {
        alert("검색 단어를 입력하세요.");
        fm.keyword.focus();
        return;
    }
    fm.submit();
}


