<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
	<style type="text/css">
	.header_logo_inner.scroll_inn{
		display: none;
	}
	.main_section{
		margin-top: 20px;
	}
	h1{
		margin: 40px auto;	
	}
	.mainFrame{
		width: 500px;
		margin: 0 auto;
		text-align: center;
	}
	.mainFrame div{
		margin: 15px auto;
		height: 35px;
	}
	.mainFrame label{
		width: 80px;
		text-align: left;
		margin-right: 10px;
	}
	.mainFrame select{
		width: calc(80% - 22px);
		height: 40px;
		border: 1px solid #eee;
		padding: 0 10px; 
		border-radius: 5px;
		outline: none;
	}
	.mainFrame input{
		width: 75%;
		border: 1px solid #eee;
		padding: 0 10px; 
		border-radius: 5px;
	}

	#value{
		border: 1px solid #e8e8e8;
		width: 95%;
	    height: 280px;
		border-radius: 5px;
	    padding: 10px 10px 0 10px;	
	}
	.mainFrame input[type="button"]{
		width: 25%;
	    height: 50px;
	    border-radius: 10px;
	    background-color: #fff;
	    border-color: #0c400c;
	    color: #0c400c;
	}
	.mainFrame input[type="button"]:hover{
	    background-color: #0c400c20;
	}
	.mainFrame input[type="text"]:read-only{
	    background-color: #e8e8e8;
	}
	.mainFrame input[type="button"]+input[type="button"]{
		margin-left: 20px;
	}
	.mainFrame div.value,
	.mainFrame div.button{
		height: auto;
	}
	.mainFrame div.value label{
		text-align: center;
	}
	.mainFrame .value #textlen{
	    width: 36px;
	    text-align: end;
	    border: none;
	    padding: 0;
	    background-color: transparent;
	}
	.mainFrame .value p{
		display:block;
	    text-align: right;
	}
	.mainFrame hr{
		margin: 0;
	}
	.mainFrame .check{
	    align-items: center;
	    display: flex;
	    padding-left: 4px;
	}
	.mainFrame .check label{
        display: flex;
		width: 100%;
		margin: 0;
	    align-items: center;
	}
	.mainFrame .check .checking{
		width: 130px;
	    border: 1px solid #b0c4b0;
	    align-items: center;
	    display: flex;
	    border-radius: 5px;
	}
    #check+span{
		margin: 0 10px;
    	width: 20px;
    	height: 20px;
    	display:block; 
        background-repeat: no-repeat;
        background-image: url('./image/member/logo/keyoff.png'); /*off 이미지*/
        background-size: contain;
    }
    #check:checked+span{
        background-repeat: no-repeat; /* 반복 방지 */
        background-image: url('./image/member/logo/keyon.png'); /*on 이미지*/
        background-size: contain;
    }
	</style>
		<meta charset="UTF-8">
	<script type="text/javascript">
		$(document).ready(function(){
			var part= `${dto.part}`;
			$('#part').val(part).prop("selected",true);
			
			var check = `${dto.checking}`;
			if (check == 'y') { 
				$('#check').prop('checked',true); 
				$('#checkval').text("나 만 보 기");
			}else{ 
				$('#check').prop('checked',false);
				$('#checkval').text("전 체 공 개");		
			}
		});
		function deleted(){
			alert('삭제되었습니다.');
			$("#deleteboard").submit();
		}
	</script>
</head>
	<body>
		<h1>정말로 삭제하시겠습니까?</h1>
		<form action="deleteBoard" id="deleteboard" method="post">
			<input type="hidden" name="num" value="${dto.num}">
			<div class="mainFrame">
				<div>
					<label for ="part">분 류	</label>
					<select name="part" id="part" disabled>
						<option value="login">로그인 관련 문의</option>
						<option value="player">선수 정보 문의</option>
						<option value="content">내용 추가/오류 수정/삭제 문의</option>
						<option value="member">댓글 비방/모욕 신고</option>
						<option value="error">오류 신고</option>
						<option value="etc">기타 문의</option>
					</select>
				</div>
				<div>
					<label for ="title"> 제 목 </label>
					<input type="text" id="title" name="title" placeholder="30자 이내로 입력" value="${dto.title}" maxlength="30" readonly>
				</div>
				<div>
					<label for ="writer"> 작 성 자 </label>
					<input type="text" id="writer" name="writer" value="${dto.writer}" readonly>
				</div>
				<div class="check">
					<label for ="check">
						 잠 금 여 부
						 <div class="checking">
							<input type="hidden" id="checked" name="checked">
							<input type="checkbox" id="check" name="check" hidden="hidden" disabled><span></span>
							<p id="checkval"></p>
						 </div>
					</label>
				</div>
				<hr>
				<div class="value">
					<label for ="value"> 내 용 </label>
					<textarea id="value" name="value" placeholder="내용을 500자 이내로 입력해주세요" onkeyup="textlength()" maxlength="500" readonly>${dto.content}</textarea>
				</div>
				<div class="button">
					<input type="button" value="취소" onclick="history.back()">
					<input type="button" value="삭제하기" onclick="deleted()">
				</div>
			</div>
		</form>
	</body>
</html>