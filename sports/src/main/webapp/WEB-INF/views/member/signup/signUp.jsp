<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.6.3/css/all.css">
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script>
	$(document).ready(function(){
		//비밀번호 보기 구현
	    $('.pw i').on('click',function(){
	        $('input').toggleClass('active');
	        if($('input').hasClass('active')){
	            $(this).attr('class',"fa fa-eye fa-lg")
	            .prev('input').attr('type',"text");
	        }else{
	            $(this).attr('class',"fa fa-eye-slash fa-lg")
	            .prev('input').attr('type','password');
	        }
	    });
		//아이디 유효성 검사후 중복체크
		$("#idcheck").click(function() {
			var id = $("#id").val();
			var vid=/^[a-zA-Z0-9]{4,10}$/;
			
			if(id=="") {
				alertShow('오류','아이디를 입력해주세요.');
				return false;
			}
			else if(!vid.test(id)) {
				alertShow('오류','아이디는 영문자와 숫자로만 4~10글자 이내로만 작성해야합니다.');
				return false;
			}
			
			$.ajax({
				type:"post",
				url:"idcheck",
				async:true,
				data:{"id":id},
				success:function(data) {
					if(data==1) {
						alertShow('중복확인',"이미 사용중인 아이디 입니다.");
						$('#idcheck2').val(1);
					}else{
						alertShow('중복확인',"사용가능한 아이디 입니다.");
						$('#idcheck2').val(0);
					}
				},
				error:function() {
					alertShow('에러','아이디를 다시 입력해주세요');
				}
			});
		});
	});
	//주소 API CDN 방식 사용
    function execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
              	// 팝업을 통한 검색 결과 항목 클릭 시 실행
                var addr = ''; // 주소_결과값이 없을 경우 공백 
                var extraAddr = ''; // 참고항목

                //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                if (data.userSelectedType === 'R') { // 도로명 주소를 선택
                    addr = data.roadAddress;
                } else { // 지번 주소를 선택
                    addr = data.jibunAddress;
                }

                if(data.userSelectedType === 'R'){
                    if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                        extraAddr += data.bname;
                    }
                    if(data.buildingName !== '' && data.apartment === 'Y'){
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    if(extraAddr !== ''){
                        extraAddr = ' (' + extraAddr + ')';
                    }
                } else {
                    document.getElementById("UserAdd1").value = '';
                }
                // 선택된 우편번호와 주소 정보를 input 박스에 넣는다.
                document.getElementById('zipp_code_id').value = data.zonecode;
                document.getElementById("UserAdd1").value = addr;
                document.getElementById("UserAdd1").value += extraAddr;
                document.getElementById("UserAdd2").focus(); // 우편번호 + 주소 입력이 완료되었음으로 상세주소로 포커스 이동
            }
        }).open();
    }
	//비밀번호 일치 유무
	function passwordCheck() {
		var pw = $("#pw").val();	
		var pwcheck = $("#pwcheck").val();	
		var pw_message = document.getElementById("pw_message");	//확인 메세지
		var correctColor = "#416b41";	//맞았을 때 출력되는 색깔.
		var wrongColor = "#ff0000";		//틀렸을 때 출력되는 색깔
		if(pw == pwcheck){ //password 변수의 값과 passwordConfirm 변수의 값과 동일하다.
			if(pw.length<6 ||pw.length>16){
				pw_message.style.color = wrongColor;
				pw_message.innerHTML = "비밀번호는 6~16자 이내로 입력해주세요.";				
			}
			else{
				pw_message.style.color = correctColor;/* span 태그의 ID(confirmMsg) 사용  */
				pw_message.innerHTML = "비밀번호가 일치합니다.";/* innerHTML : HTML 내부에 추가적인 내용을 넣을 때 사용하는 것. */
		}
		}else{
			pw_message.style.color = wrongColor;
			pw_message.innerHTML = "비밀번호가 일치하지 않습니다.";
		}
	}
	//중복확인 후 아이디 수정 시 다시 중복확인 구현
	function idcheck_reset() {
		$('#idcheck2').val(1);
	}
	//이메일 도메인에 값 넣기
	function mailSelect() {
		var domain = $('#mail_select').find('option:selected').val();		
		if(domain == 'emailall') {
			$('#email_domain').val("");
		}
		else {
			$('#email_domain').val(domain);
		}		
	}
	//축구를 고를 떄와 야구를 골랐을 때 Select 내용 바꾸기
	function Activity(name, list){
	    this.name = name;
	    this.list = list;
	}
	var acts = new Array();
	    acts[0] = new Activity('축구', ['강원', '울산', '수원FC', '김천', '서울', '포항', '광주', '제주', '대전', '인천', '전북', '대구']);
	    acts[1] = new Activity('야구', ['KIA', '삼성', 'LG', '두산', 'KT', '한화', '롯데', 'SSG', 'NC', '키움']);
	function updateList(str){
		var gf = document.memberform;
	    var teamLen = gf.team.length;
	    var numActs;
	    for (var i = 0; i < acts.length; i++){
	        if (str == acts[i].name) {
	            numActs = acts[i].list.length;
	            for (var j = 0; j < numActs; j++)
	            	gf.team.options[j] = new Option(acts[i].list[j], acts[i].list[j]);
	            for (var j = numActs; j < teamLen; j++)
	            	gf.team.options[numActs] = null;
	        }
	    }
	}

	//유효성 체크
	function check() {
		////아이디 체크
		var vid = /^[a-zA-Z0-9]{4,10}$/;
		var id = $('#id').val();
	 	var idchecked = $('#idcheck2').val();
	 	
		if(id == "") {
			alertShow('오류','아이디를 입력해주세요.');
			$('#id').focus();
			return false;
		}
		else if(!vid.test(id)) {
			alertShow('오류','아이디는 영문자+숫자 4~10글자 이내로 작성해야합니다.');
			$('#id').focus();
			return false;
		}
		if(idchecked == "" || idchecked == 1) {
	 		alertShow('오류','아이디 중복확인을 해주세요.');
	 		return false;
	 	}
		//비밀번호 체크
		var vpw = /^[a-zA-Z0-9]{6,16}$/;
		var pw = $('#pw').val();
		var pwcheck = $('#pwcheck').val();
		if(pw=="") {
			alertShow('오류','비밀번호를 입력해주세요.');
			$('#pw').focus();
			return false;
		}
		else if(!vpw.test(pw)) {
			alertShow('오류','비밀번호는 영문자+숫자 6~16글자 이내로 작성해야합니다.');
			$('#pw').focus();			
			return false;
		}
		else if(pw != pwcheck) {
			alertShow('오류','입력한 비밀번호가 일치하지 않습니다.다시 입력해주세요');
			$('#pwcheck').focus();
			return false;
		}
		////이름 체크
		var vname=/^[가-힣]{2,5}$/;
		var name=$('#name').val();
		if(name=="") {
			alertShow('오류','이름을 입력해주세요.');
			$('#name').focus();
			return false;
		}
		else if(!vname.test(name)) {
			alertShow('오류','이름은 한글 2~5글자 이내로 작성해주세요.');
			$('#name').focus();
			return false;
		}	
		//생년월일 체크 후 이어붙이기		
		var year = $("select[id='year'] option:selected").val();
		var month = $("select[id='month'] option:selected").val();
		var day = $("select[id='day'] option:selected").val();
		var birth= year + "-" + month + "-" + day;
		var birth_regexp = /^\d{4}-\d{2}-\d{2}$/;//생년월일 정규식		
		if(birth_regexp.test(birth)) {
			$('#birth').val(birth);
		}
		else {
			alertShow('오류','생년월일을 입력해주세요');
			$('#year').focus();
			return false;
		}
		//전화번호 체크 후 이어붙이기
		var fir_tel = $("select[id='fir_tel'] option:selected").val();
		var mid_tel = $('#mid_tel').val();
		var end_tel = $('#end_tel').val();
		var total_tel = fir_tel + "-" + mid_tel + "-" + end_tel;		
		var tel_regexp = /^01(?:0|1|[6-9])-(?:\d{3}|\d{4})-\d{4}$/;//전화번호 정규식
		if(tel_regexp.test(total_tel)) {
			$('#total_tel').val(total_tel);
		}
		else {
			alertShow('오류','전화번호를 다시 입력해주세요');
			$('#mid_tel').focus();
			return false;
		}
		//이메일 이어붙이기
		var email_val1 = $('#email_id').val();
		var email_val2 = $('#email_domain').val();
		var total_email = email_val1 + "@" + email_val2;
		var email_regexp = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;//이메일 정규식
		if(email_regexp.test(total_email)) {
			$('#total_email').val(total_email);				
		}
		else {
			alertShow('오류','이메일 형식이 맞지 않습니다');
			$('#email_id').focus();
			return false;
		}			
		//주소 체크
		var code = $('#zipp_code').val();
		var cadd1 = $('#UserAdd1').val();
		var cadd2 = $('#UserAdd2').val();
		if(code=="" || cadd1=="") {
			alertShow('오류','우편주소를 검색해주세요.');
			return false;
		}
		if(cadd2=="") {
			alertShow('오류','상세 주소를 입력해주세요.');
			return false;
		}
		//파일 체크
		var part = $('#part').val();
		if(part == '감독'){
			//재직증명서 확인
			var voe = $('#voe').val();
			if(voe == "") {
				alertShow('재직 증명서 등록 오류','재직 증명서를 등록해주세요.');
				return false;
			}
			//등본 확인
			var rr = $('#rr').value;		
			if(rr == "") {
				alertShow('등본 등록 오류','등본을 등록해주세요.');
				return false;
			}
		}
		$('#memberform').submit();
	}
	</script>
	<style type="text/css">
		.signform{
			width: 800px;
			margin: 0 auto;
		}
		.signform div{
			display: flex;
		    align-items: center;
		    height:40px;
		    margin: 0 auto 20px auto;
		    
		}
		.signform input[type="password"],
		.signform input[type="text"]{
			width: 280px;
			height: auto;
			margin: 0 10px 0 10px;
			border: 1px solid #e8e8e8;
		}
		label{
			width: 120px;
		}
		.signform .pw1{
			display: flex;
		    align-items: center;
		    margin: 0;
		}
		#pw,#pwcheck{
			margin: 0 10px 0 10px;
		}
		.pw1 i{
			margin: auto 0 auto 0;
	        color: darkgreen;
		}
		#year,
		#month,
		#day,
		.phone #fir_tel{
			text-align: center;
			width: 75px;
			height: 25px;
			margin: 0 10px 0 10px;
			border: 1px solid #e8e8e8;
		}
		.col-sm-10{
			display: block;
		}
		
		.signform input[type="text"]#mid_tel,
		.signform input[type="text"]#end_tel{
			width:60px;
		}
		.signform .email_write{
			width:300px;
			margin:0;
		}
		.signform .email_write .form_w200{
			width:120px;
		}
	</style>
</head>
<body>
	<h1>회원가입</h1>
	<form action="memberSave" method="post" name="memberform" id="memberform" class="signform" enctype="multipart/form-data">
		<input type="hidden" name="part" id="part" value="${part}">
	<div class="id">
			<label for="id">아이디</label>
			<input type="text" name="id" id="id" placeholder="4~10글자 이내로 입력" onchange="idcheck_reset()">
			<input type="button" value="중복확인" id="idcheck">
			<input type="hidden" id="idcheck2" value="">
		</div>
		<div class="pw">
			<label for="pw">비밀번호</label>
			<div class="pw1">
				<input type="password" name="pw" id="pw" placeholder="6~16글자 이내로 입력">
				<i class="fa fa-eye-slash fa-lg"></i>
			</div>
		</div>
		<div class="pw">
			<label for="pwcheck">비밀번호 확인</label>
			<div class="pw1">
				<input type="password" name="pwcheck" id="pwcheck" placeholder="비밀번호를 한번 더 입력" onkeyup="passwordCheck()">
				<i class="fa fa-eye-slash fa-lg"></i>
				  <span id="pw_message"></span>
			</div>
		</div>
		<div class="name">
			<label for="name">이름</label>
			<input type="text" name="name" id="name">
		</div>
		<div>
			<label for="year">생년월일</label>
			<select name="year" id="year">
				<option value="">--</option>
					<c:forEach var="i" begin="1920" end="2024">
					<option value="${i}">${i}</option>
					</c:forEach>
			</select>년
			<select name="month" id="month">
				<option value="">--</option>
					<c:forEach var="i" begin="1" end="12">
						<c:choose>
							<c:when test="${i lt 10}">
								<option value="0${i}">0${i}</option>
							</c:when>
							<c:otherwise>
								<option value="${i}">${i}</option>
							</c:otherwise>
						</c:choose>
					</c:forEach>
			</select>월
			<select name="day" id="day">
				<option value="">--</option>
					<c:forEach var="i" begin="1" end="31">
						<c:choose>
							<c:when test="${i lt 10}">
								<option value="0${i}">0${i}</option>
							</c:when>
							<c:otherwise>
								<option value="${i}">${i}</option>
							</c:otherwise>
						</c:choose>
					</c:forEach>
			</select>일
			<input type="hidden" id="birth" name="birth" value="">
		</div>
		<div class="phone">
			<label for="fir_tel">전화번호</label>
			<select id="fir_tel">
				<option value="010">010</option>
				<option value="011">011</option>
				<option value="016">016</option>
				<option value="017">017</option>
				<option value="019">019</option>
			</select>
			-
			<input type="text" maxlength="4" id="mid_tel" size="5">
			-
			<input type="text" maxlength="4" id="end_tel" size="5">
			<input type="hidden" id="total_tel" name="tel" value="">
		</div>
		<div>
			<label for="email_id">이메일</label>
			<div class="email_write">
				<input type="text" id="email_id" class="form_w200" value="" title="이메일 아이디" placeholder="이메일" maxlength="18" /> @ 
				<input type="text" id="email_domain" class="form_w200" value="" title="이메일 도메인" placeholder="이메일 도메인" maxlength="18"/> 
			<select class="select" id="mail_select" title="이메일 도메인 주소 선택" onchange="mailSelect()">
			    <option value="emailall" selected>-선택-</option>
			    <option value="naver.com">naver.com</option>
			    <option value="gmail.com">gmail.com</option>
			    <option value="hanmail.net">hanmail.net</option>
			    <option value="hotmail.com">hotmail.com</option>
			    <option value="korea.com">korea.com</option>
			    <option value="nate.com">nate.com</option>
			    <option value="yahoo.com">yahoo.com</option>
			</select>
			</div>
			<input type="hidden" id="total_email" name="email" value="">
		</div>
		<div class="col-sm-10">
		    <label for="zipp_btn" class="form-label">주소</label><br/>
		    <input type="text" class="form-control mb-2" id="zipp_code_id" name="zipp_code" maxlength="10" placeholder="우편번호" style="width: 10%; display: inline;">
		    <input type="button" id="zipp_btn" class="btn" onclick="execDaumPostcode()" value="우편번호 찾기"><br>
		    <input type="text" class="form-control mb-2" name="user_add1" id="UserAdd1" maxlength="40" placeholder="기본 주소를 입력하세요" required readonly>
		    <input type="text" class="form-control" name="user_add2" id="UserAdd2" maxlength="40" placeholder="상세 주소를 입력하세요">
		</div>
		<div>
			<label><c:if test="${part=='일반'}">선호 </c:if>종목</label>
			<label>
			<input type="radio" name="sport" onclick="updateList(this.value)" checked value="축구"><span><span></span></span><span>축구</span>
			</label>
			<label>
			<input type="radio" name="sport" onclick="updateList(this.value)" value="야구"><span><span></span></span><span>야구</span>
			</label>
		</div>
		<div>
		<c:if test="${part=='일반'}">
			<label for="team">선호 팀</label>
		</c:if>
		<c:if test="${part=='감독'}">
			<label for="team">관리 팀</label>
		</c:if>
			<select name="team" id="team">
				<option value="">
			</select>
		</div>
		<c:if test="${part=='감독'}">
			<div>
				<label>재직증명서</label>
				<input type="file" name="voe" id="voe">
			</div>
			<div>
				<label>등본</label>
				<input type="file" name="rr" id="rr">
			</div>
		</c:if>
		<div>
			<input type="button" value="회원가입" onclick="check()">
			<input type="button" value="취소" onclick="location.href='./'">
		</div>
	</form>
</body>
</html>