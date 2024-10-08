<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.6.3/css/all.css">
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<meta charset="UTF-8">
	<script>
	$(document).ready(function(){
		//생년월일 가져와서 선택
		var year = $('#birth').val().substr(0,4);
		var month = $('#birth').val().substr(5,2);
		var day = $('#birth').val().substr(8,2);
	    $('#year').val(year).prop("selected",true);
	    $('#month').val(month).prop("selected",true);
	    $('#day').val(day).prop("selected",true);
		
	    //전화번호 앞자리 선택
		var fir_tel=$('#fir_telvalue').val();
		$('#fir_tel').val(fir_tel).prop("selected",true);
		
		//이메일 가져와서 선택
		var email = $('#email').val().split('@');		
	    $('#email_id').val(email[0]);
	    $('#mail_select').val(email[1]).prop("selected",true);
	    mailSelect();
	    
		//운동 종목 및 팀 가져와서 변환
	    var sportname=$('#sportvalue').val();
	    var teamname=$('#teamvalue').val();
		if(sportname=='축구'){
		    $('#sport1').prop("checked",true);	
		}else{
		    $('#sport2').prop("checked",true);		
		}
		    updateList(sportname);
		    $('#team').val(teamname).prop("selected",true);

		//비밀번호 보기 구현
	    $('.pw1 i').on('click',function(){
	        $('input').toggleClass('active');
	        if($('input').hasClass('active')){
	            $(this).attr('class',"fa fa-eye fa-lg")
	            .prev('input').attr('type',"text");
	        }else{
	            $(this).attr('class',"fa fa-eye-slash fa-lg")
	            .prev('input').attr('type','password');
	        }
	    });
	    // 비밀번호 수정 버튼 클릭 시 모달 창 표시
	    $("btn-pwCheck").click(function () {
	        $("#PwCheckModal").modal("show");
	    });
    	$("#PwCheckModal").on("shown.bs.modal", function () {		
    		$("#pw").focus();
    	});

		////비밀번호 확인(유효성 검사,AJAX) 후 비밀번호 수정창으로 이동
		$("#pwCheck").click(function() {
			var id=$('#id').val();
			var pw=$('#pw').val();
			$.ajax({
				type:"post",
				url:"pwCheck",
				async:true,
				data:{"id":id, "pw":pw},
				success:function(data) {
					if(data=='1') {
						////수정창 띄우기
						$("#PwUpdateModal").modal("show");
					}else{
						alertShow('오류',"비밀번호가 다릅니다 다시 입력해주세요.");
					}
				},
				error:function() {
					alertShow('오류','비밀번호를 다시 입력해주세요');
				}
			});
		});
    	$("#PwUpdateModal").on("shown.bs.modal", function () {		
    		$("#pwcheck").focus();
    	});
		///수정한 비밀번호 유효성 검사
		$("#pwupdate").click(function() {
			var vpw=/^[a-zA-Z0-9]{6,16}$/;
			var id=$('#id').val();
			var pw=$('#pwcheck').val();
			
			if(pw=="") {
				alertShow('오류','비밀번호를 입력해주세요.');
				return false;
			}
			else if(!vpw.test(pw)) {
				alertShow('오류','비밀번호는 영문자+숫자 6~16글자 이내로 작성해야합니다.');
				return false;
			}
			$.ajax({
				type: "post",
				url: "pwUpdate",
				async: true,
				data: {"id":id,"pw":pw},
				success(){
					alertShow('변경 완료',"비밀번호가 변경되었습니다");
				},
				error(){
					alertShow("오류",'비밀번호를 다시 입력해주세요');
				}
			});
		});
	});
	//비밀번호 확인 Enter
	function btn_pwcheck(e) {
		if(e.key == 'Enter') {
			$('#pwupdate').click();
		}
	}
	//비밀번호 수정 Enter
	function btn_pwupdate(e) {
		if(e.key == 'Enter') {
			$('#pwupdate2').click();
		}
	}	
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
	 	var gf = document.updateform;
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
		var birth = year + "-" + month + "-" + day;
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
		var email_id = $('#email_id').val();
		var email_domain = $('#email_domain').val();
		var email = email_id + "@" + email_domain;
		var email_regexp = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;//이메일 정규식
		if(email_regexp.test(email)) {
			$('#email').val(email);				
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
		$('#updateform').submit();
	}
	</script>
	<style type="text/css">
		.updateform{
			width: 800px;
			margin: 0 auto;
		}
		.updateform div{
			display: flex;
		    align-items: center;
		    height:40px;
		    margin: 0 auto 20px auto;
		    
		}
		.updateform input[type="text"]{
			width: 280px;
			height: auto;
			margin: 0 10px 0 10px;
			border: 1px solid #e8e8e8;
		}
		label{
			width: 120px;
		}
		.modal-body .pw1 input[type="password"]{
			display: flex;
		    align-items: center;
		    margin: 0;
		    width: max-content;
		}
		#pw,#pwcheck{
			margin: 0 10px 0 10px;
		}
		.modal-body .pw1 i{
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
		
		.updateform input[type="text"]#mid_tel,
		.updateform input[type="text"]#end_tel{
			width:60px;
		}
		.updateform .email_write{
			width:300px;
			margin:0;
		}
		.updateform .email_write .form_w200{
			width:120px;
		}
	</style>
</head>
<body>
	<form action="memberUpdate" method="post" id="updateform" name="updateform" enctype="multipart/form-data">
		<input type="hidden" name="part" id="part" value="${my.part}">
		<input type="hidden" name="refvoe" id="refvoe" value="${my.voe}">
		<input type="hidden" name="refrr" id="refrr" value="${my.rr}">
		<input type="hidden" name="sportvalue" id="sportvalue" value="${my.sport}">
		<input type="hidden" name="teamvalue" id="teamvalue" value="${my.team}">
		<div class="id">
			<label for="id">아이디</label>
			<input type="text" name="id" id="id" value="${my.id}" readonly>
		</div>
		<div>
			<label for="pwchange">비밀번호</label>
			<button type="button" id="pwchange" class="btn btn-pwCheck" data-toggle="modal" data-target="#PwCheckModal">비밀번호 수정</button>
		</div>
		<div class="name">
			<label for="name">이름</label>
			<input type="text" name="name" id="name" value="${my.name}">
		</div>
		<div>
			<label for="year">생년월일</label>
			<input type="hidden" id="birth" name="birth" value="${my.birth}">
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
		</div>
		<div class="phone">
			<label for="fir_tel">전화번호</label>
			<input type="hidden" name="fir_telvalue" id="fir_telvalue" value="${my.tel.substring(0,3)}">
			<select id="fir_tel">
				<option value="010">010</option>
				<option value="011">011</option>
				<option value="016">016</option>
				<option value="017">017</option>
				<option value="019">019</option>
			</select>
			-
			<input type="text" maxlength="4" id="mid_tel" size="5" value="${my.tel.substring(4,8)}">
			-
			<input type="text" maxlength="4" id="end_tel" size="5" value="${my.tel.substring(9,13)}">
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
			<input type="hidden" id="email" name="email" value="${my.email}">
		</div>
		<div class="col-sm-10">
		    <label for="zipp_btn" class="form-label">주소</label><br/>
		    <c:choose>
				<c:when test="${my.zzip_code.length() <= 4}">
		    		<input type="text" class="form-control mb-2" id="zipp_code_id" name="zipp_code" maxlength="10" placeholder="우편번호" style="width: 10%; display: inline;" readonly value="0${my.zzip_code}">
				</c:when>
				<c:otherwise>
			 	   <input type="text" class="form-control mb-2" id="zipp_code_id" name="zipp_code" maxlength="10" placeholder="우편번호" style="width: 10%; display: inline;" readonly value="${my.zzip_code}">
				</c:otherwise>
			</c:choose>
		    <input type="button" id="zipp_btn" class="btn btn-primary" onclick="execDaumPostcode()" value="우편번호 찾기"><br>
		    <input type="text" class="form-control mb-2" name="user_add1" id="UserAdd1" maxlength="40" placeholder="기본 주소를 입력하세요" required readonly value="${my.user_add1}">
		    <div class="invalid-feedback">주소를 입력해주시기 바랍니다!</div>
		    <input type="text" class="form-control" name="user_add2" id="UserAdd2" maxlength="40" placeholder="상세 주소를 입력하세요" value="${my.user_add2}">
		</div>
		<div>
			<label><c:if test="${my.part=='일반'}">선호 </c:if>종목</label>
			<label>
			<input type="radio" name="sport" id="sport1" onclick="updateList(this.value)" checked value="축구"><span><span></span></span><span>축구</span>
			</label>
			<label>
			<input type="radio" name="sport" id="sport2" onclick="updateList(this.value)" value="야구"><span><span></span></span><span>야구</span>
			</label>
		</div>
		<div>
			<c:if test="${my.part == '일반'}">
				<label>관심 팀</label>
			</c:if>
			<c:if test="${my.part == '감독'}">
				<label>관리 팀</label>
			</c:if>
			<select name="team" id="team">
				<option value="강원">강원</option>
				<option value="울산">울산</option>
				<option value="수원FC">수원FC</option>
				<option value="김천">김천</option>
				<option value="서울">서울</option>
				<option value="포항">포항</option>
				<option value="광주">광주</option>
				<option value="제주">제주</option>
				<option value="대전">대전</option>
				<option value="인천">인천</option>
				<option value="전북">전북</option>
				<option value="대구">대구</option>
			</select>	
		</div>
		<c:if test="${my.part == '감독'}">
			<div>
				<label>재직 증명서</label>
				<img src="./image/member/super/${my.voe}" width="100px" height="70px">
				<input type="file" name="voe" id="voe">
			</div>
			<div>
				<label>등본</label>			
				<img src="./image/member/super/${my.rr}" width="100px" height="70px">
				<input type="file" name="rr" id="rr">
			</div>
		</c:if>
		<div>
			<input type="button" value="수정 완료" onclick="check()">
			<input type="button" value="취소" onclick="location.href='mypage?id=${my.id}'">
		</div>
	</form>
	<!-- 모달창: 비밀번호 확인 -->
	<div class="modal fade" id="PwCheckModal" tabindex="-1" role="dialog" aria-labelledby="PwCheckModalLabel" aria-hidden="true">
	    <div class="modal-dialog" role="document">
	        <div class="modal-content">
	            <div class="modal-header">
	                <h5 class="modal-title" id="PwCheckModalLabel">비밀번호 확인</h5>
	                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	                    <span aria-hidden="true">&times;</span>
	                </button>
	            </div>
	            <div class="modal-body">
		            <div class="pw">
		                <p>비밀번호를 입력해주세요.</p>
		                <div class="pw1">
			                <input type="password" name="pw" id="pw" onkeydown="btn_pwcheck(event)">
			                <i class="fa fa-eye-slash fa-lg"></i>
		                </div>
		            </div>
	            </div>
	            <div class="modal-footer">
	                <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
	                <button type="button" class="btn btn-primary" data-dismiss="modal" id="pwCheck">확인</button>
	            </div>
	        </div>
	    </div>
	</div>
	<!-- 모달창: 비밀번호 확인 -->
	<div>
		<input type="hidden" class="btn btn-PwUpdate" data-toggle="modal" data-target="#PwUpdateModal">
		<div class="modal fade" id="PwUpdateModal" tabindex="-1" role="dialog" aria-labelledby="PwUpdateModalLabel" aria-hidden="true">
		    <div class="modal-dialog" role="document">
		        <div class="modal-content">
		            <div class="modal-header">
		                <h5 class="modal-title" id="PwUpdateModalLabel">비밀번호 수정</h5>
		                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
		                    <span aria-hidden="true">&times;</span>
		                </button>
		            </div>
		            <div class="modal-body">
			            <div class="pw">
			                <p>수정할 비밀번호를 입력해주세요.</p>
			                <div class="pw1">
				                <input type="password" name="pwcheck" id="pwcheck" onkeydown="btn_pwupdate(event)">
				                <i class="fa fa-eye-slash fa-lg"></i>
			                </div>
			            </div>
		            </div>
		            <div class="modal-footer">
		                <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
		                <button type="button" class="btn btn-primary" data-dismiss="modal" id="pwupdate">확인</button>
		            </div>
		        </div>
		    </div>
		</div>
	</div>
</body>
</html>