-- 선수(축구, 야구) 번호
CREATE SEQUENCE PLAYERNUM_SEQ INCREMENT BY 1 MAXVALUE 9999999999999999999999999999 MINVALUE 1 CACHE 20;

-- 댓글 테이블
CREATE TABLE SPLAYER_COMMENT (
  PLAYERNUM NUMBER(6, 0) 
, STEP NUMBER 
, INDENT NUMBER 
, WRITER VARCHAR2(100 BYTE) 
, UCOMMENT VARCHAR2(500 BYTE) 
, CDATE DATE DEFAULT sysdate 
, HEART NUMBER(10, 0) DEFAULT 0 
) ;

-- 캘린더 테이블 
    CREATE TABLE DIRECT_TRADE (
      TRNAME VARCHAR2(30 BYTE) 
    , TRDATE DATE 
    , TRDATE2 DATE 
    , TRMEMBER VARCHAR2(1000 BYTE) 
    , TRPLACE VARCHAR2(100 BYTE) 
    , TRCONTENT VARCHAR2(1000 BYTE) 
    , TRMEMO VARCHAR2(1000 BYTE) 
    , TRNUM NUMBER(6, 0) 
    , TRINFO VARCHAR2(20 BYTE) 
    );

CREATE SEQUENCE TRNUM_SEQ INCREMENT BY 1 MAXVALUE 9999999999999999999999999999 MINVALUE 1 CACHE 20;

-- 전략 테이블
    CREATE TABLE DIRECT_STRATEGY (
      STNUM NUMBER(6, 0) 
    , STNAME VARCHAR2(30 BYTE) 
    , STKIND VARCHAR2(20 BYTE) 
    , STDATE DATE 
    , STAREA VARCHAR2(30 BYTE) 
    , STINFO VARCHAR2(1000 BYTE) 
    );
CREATE SEQUENCE STNUM_SEQ INCREMENT BY 1 MAXVALUE 9999999999999999999999999999 MINVALUE 1 CACHE 20;