--PL-SQL.sql

SET serveroutput ON
SET DEFINE OFF;

-------------------------------A. 공통 기능
-------------------------------A01-01. 로그인
--관리자 로그인
CREATE OR REPLACE PROCEDURE procLoginAdmin (
    pId VARCHAR2,
    pPw VARCHAR2
)
IS
    vAdminName tblAdmin.adminName%TYPE;
BEGIN
    SELECT adminName INTO vAdminName FROM tblAdmin WHERE adminName = pId AND SUBSTR(adminSsn, 8) = pPw;
    
    DBMS_OUTPUT.PUT_LINE('관리자이름: ' || vAdminName);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('로그인 실패');
END procLoginAdmin;
/

BEGIN
    procLoginAdmin('차민재', '3333332');
END;
/

--교사 로그인
CREATE OR REPLACE PROCEDURE procLoginTeacher (
    pId VARCHAR2,
    pPw VARCHAR2
)
IS
    vTeacherName tblTeacher.teacherName%TYPE;
BEGIN
    SELECT teacherName INTO vTeacherName FROM tblTeacher WHERE teacherName = pId AND  teacherSsn = pPw;
    
    DBMS_OUTPUT.PUT_LINE('교사이름: ' || vTeacherName);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('로그인 실패');
END procLoginTeacher;
/

BEGIN
    procLoginTeacher('곽우갓', '1583697');
END;
/

--학생 로그인
CREATE OR REPLACE PROCEDURE procLoginStudent (
    pId VARCHAR2,
    pPw VARCHAR2
)
IS
    vStudentName vwStudent.studentName%TYPE;
BEGIN
    SELECT studentName INTO vStudentName FROM vwStudent WHERE studentName = pId AND SUBSTR(studentSsn, 8) = pPw;
    DBMS_OUTPUT.PUT_LINE('학생이름: ' || vStudentName);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('로그인 실패');
END procLoginStudent;
/

BEGIN
    procLoginStudent('최성빈', '2445915');
END;
/



-------------------------------A01-02. 로그아웃




-------------------------------A01-03. 학생 생일 조회
CREATE OR REPLACE PROCEDURE procBirthday(
    pMonth VARCHAR2,
    pCursor OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN pCursor
    FOR
    SELECT * FROM vwBirthday WHERE SUBSTR(birthday, 1, 2) = pMonth ORDER BY Birthday ASC;
END procBirthday;
/

DECLARE
    vCursor SYS_REFCURSOR;
    vRow vwBirthday%ROWTYPE;
    vMonth VARCHAR2(30) := '10';
BEGIN
    procBirthday(vMonth, vCursor);
    DBMS_OUTPUT.PUT_LINE('───────────────────────' || vMonth || '월 생일자 목록───────────────────────');
    LOOP
        FETCH vCursor INTO vRow;
        EXIT WHEN vCursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(vRow.interviewerName || ': ' || vRow.birthday);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────────');
END;
/



-------------------------------B. 관리자 기능
-------------------------------B01-01. 기초 정보 등록 및 관리
--과정
--기초 정보 관리 (과정 추가)
CREATE OR REPLACE PROCEDURE procAddBicCourse(
	pcourseName VARCHAR2,
    presult OUT VARCHAR2
)
IS
BEGIN
	INSERT INTO tblCourse (courseNum, courseName) VALUES ((SELECT NVL(MAX(LPAD(courseNum, 5, '0')), 0) + 1 FROM tblCourse) , pcourseName);
    
	presult := '정상적으로 등록하였습니다.';
    
EXCEPTION
	WHEN OTHERS THEN
		presult := '등록을 실패하였습니다.'; --실패    

END procAddBicCourse;

--실행
DECLARE
	vresult VARCHAR2(300);
BEGIN
	procAddBicCourse('개발자 한걸음', vresult);
	DBMS_OUTPUT.PUT_LINE(vresult);
END;


--기초 정보 관리 (과정 수정)
CREATE OR REPLACE PROCEDURE procUpdateBicCourse(
	pcourseNum VARCHAR2,
    pcourseName VARCHAR2,
    presult OUT VARCHAR2
)
IS
BEGIN
	UPDATE tblCourse SET courseName = pcourseName WHERE courseNum = pcourseNum;
    
	presult := '정상적으로 수정하였습니다.';
    
EXCEPTION
	WHEN OTHERS THEN
		presult := '수정을 실패하였습니다.'; --실패    

END procUpdateBicCourse;

--실행
DECLARE
	vresult VARCHAR2(300);
BEGIN
	procUpdateBicCourse('15', '정보시스템 구축, 운영 기반 정보보안 전문가 양성 과정', vresult);
	DBMS_OUTPUT.PUT_LINE(vresult);
END;


--기초 정보 관리 (과정 삭제)
CREATE OR REPLACE PROCEDURE procDeleteBicCourse(
	pcourseNum VARCHAR2,
    presult OUT VARCHAR2
)
IS
BEGIN
    
	DELETE FROM tblCourse WHERE courseNum = pcourseNum;
    
	presult := '정상적으로 삭제하였습니다.';

EXCEPTION
	WHEN OTHERS THEN
		presult := '삭제를 실패하였습니다.'; --실패       
        
END procDeleteBicCourse;

--실행
DECLARE
	vresult VARCHAR2(300);
BEGIN
	procDeleteBicCourse('16', vresult);
	DBMS_OUTPUT.PUT_LINE(vresult);
END;


--기초 정보 관리 (과정 조회)
CREATE OR REPLACE PROCEDURE procSelectBicCourse (
    pcursor OUT sys_refcursor
)
IS
BEGIN

        OPEN pcursor
        FOR
        SELECT courseNum, courseName FROM tblCourse;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('예외처리');
END procSelectBicCourse;

--실행
DECLARE
    vcursor sys_refcursor;
    vrow tblCourse%rowTYPE;
BEGIN
    
    procSelectBicCourse(vcursor);
    
    LOOP
        FETCH vcursor INTO vrow;
        EXIT WHEN vcursor%notfound;
        
        DBMS_OUTPUT.PUT_LINE(vrow.courseNum || '. ' || vrow.courseName);
        
    END LOOP;
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('예외처리');
        
END;


--과목
--기초 정보 관리 (과목 추가)
CREATE OR REPLACE PROCEDURE procAddBicSubject(
	pSubjectName VARCHAR2,
    presult OUT VARCHAR2
)
IS
BEGIN
	INSERT INTO tblSubject (subjectNum, subjectName) VALUES ((SELECT NVL(MAX(LPAD(subjectNum, 5, '0')), 0) + 1 FROM tblSubject) , psubjectName);
    
	presult := '정상적으로 등록하였습니다.';
    
EXCEPTION
	WHEN OTHERS THEN
		presult := '등록을 실패하였습니다.'; --실패    

END procAddBicSubject;

--실행
DECLARE
	vresult VARCHAR2(300);
BEGIN
	procAddBicSubject('수학', vresult);
	DBMS_OUTPUT.PUT_LINE(vresult);
END;


--기초 정보 관리 (과목 수정)
CREATE OR REPLACE PROCEDURE procUpdateBicSubject(
	psubjectNum VARCHAR2,
    psubjectName VARCHAR2,
    presult OUT VARCHAR2
)
IS
BEGIN
	UPDATE tblSubject SET subjectName = psubjectName WHERE subjectNum = psubjectNum;
    
	presult := '정상적으로 수정하였습니다.';
    
EXCEPTION
	WHEN OTHERS THEN
		presult := '수정을 실패하였습니다.'; --실패    

END procUpdateBicSubject;

--실행
DECLARE
	vresult VARCHAR2(300);
BEGIN
	procUpdateBicSubject('41', '과학', vresult);
	DBMS_OUTPUT.PUT_LINE(vresult);
END;


--기초 정보 관리 (과목 삭제)
CREATE OR REPLACE PROCEDURE procDeleteBicSubject(
	psubjectNum VARCHAR2,
    presult OUT VARCHAR2
)
IS
BEGIN
    
	DELETE FROM tblSubject WHERE subjectNum = psubjectNum;
    
	presult := '정상적으로 삭제하였습니다.';

EXCEPTION
	WHEN OTHERS THEN
		presult := '삭제를 실패하였습니다.'; --실패       
        
END procDeleteBicSubject;

--실행
DECLARE
	vresult VARCHAR2(300);
BEGIN
	procDeleteBicSubject('41', vresult);
	DBMS_OUTPUT.PUT_LINE(vresult);
END;


--기초 정보 관리 (과목 조회)
CREATE OR REPLACE PROCEDURE procSelectBicSubject (
    pcursor OUT sys_refcursor
)
IS
BEGIN

        OPEN pcursor
        FOR
        SELECT subjectNum, subjectName FROM tblSubject;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('예외처리');
END procSelectBicSubject;

--실행
DECLARE
    vcursor sys_refcursor;
    vrow tblSubject%rowTYPE;
BEGIN
    
    procSelectBicSubject(vcursor);
    
    LOOP
        FETCH vcursor INTO vrow;
        EXIT WHEN vcursor%notfound;
        
        DBMS_OUTPUT.PUT_LINE(vrow.subjectNum || '. ' || vrow.subjectName);
        
    END LOOP;
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('예외처리');
        
END;


--강의실
--기초 정보 관리 (강의실 등록)
CREATE OR REPLACE PROCEDURE procAddBicLectureRoom(
	pLectureRoomCapacity VARCHAR2,
    presult OUT VARCHAR2
)
IS
BEGIN
	INSERT INTO tblLectureRoom (lectureRoomNum, capacity) VALUES ((SELECT NVL(MAX(LPAD(lectureRoomNum, 5, '0')), 0) + 1 FROM tblLectureRoom) , plectureRoomCapacity);
    
	presult := '정상적으로 등록하였습니다.';
    
EXCEPTION
	WHEN OTHERS THEN
		presult := '등록을 실패하였습니다.'; --실패    

END procAddBicLectureRoom;

--실행
DECLARE
	vresult VARCHAR2(300);
BEGIN
	procAddBicLectureRoom('30', vresult);
	DBMS_OUTPUT.PUT_LINE(vresult);
END;	


--기초 정보 관리 (강의실 수정)
CREATE OR REPLACE PROCEDURE procUpdateBicLectureRoom (
	plectureRoomNum VARCHAR2,
    pcapacity VARCHAR2,
    presult OUT VARCHAR2
)
IS
BEGIN
	UPDATE tblLectureRoom SET capacity = pcapacity WHERE lectureRoomNum = plectureRoomNum;
    
	presult := '정상적으로 수정하였습니다.';
    
EXCEPTION
	WHEN OTHERS THEN
		presult := '수정을 실패하였습니다.'; --실패    

END procUpdateBicLectureRoom;

--실행
DECLARE
	vresult VARCHAR2(300);
BEGIN
	procUpdateBicLectureRoom('7', '26', vresult);
	DBMS_OUTPUT.PUT_LINE(vresult);
END;


--기초 정보 관리 (강의실 삭제)   
CREATE OR REPLACE PROCEDURE procDeleteBicLectureRoom (
	plectureRoomNum VARCHAR2,
    presult OUT VARCHAR2
)
IS
BEGIN
	DELETE FROM tblLectureRoom WHERE lectureRoomNum = plectureRoomNum;
    
	presult := '정상적으로 삭제하였습니다.';
    
EXCEPTION
	WHEN OTHERS THEN
		presult := '삭제를 실패하였습니다.'; --실패    

END procDeleteBicLectureRoom;

--실행
DECLARE
	vresult VARCHAR2(300);
BEGIN
	procDeleteBicLectureRoom('7', vresult);
	DBMS_OUTPUT.PUT_LINE(vresult);
END;	


--기초 정보 관리 (강의실 조회)   
CREATE OR REPLACE PROCEDURE procSelectBicLectureRoom (
    pcursor OUT sys_refcursor
)
IS
BEGIN

        OPEN pcursor
        FOR
        SELECT lectureRoomNum, capacity FROM tblLectureRoom;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('예외처리');
END procSelectBicLectureRoom;

--실행
DECLARE
    vcursor sys_refcursor;
    vrow tblLectureRoom%rowTYPE;
BEGIN
    
    procSelectBicLectureRoom(vcursor);
    
    LOOP
        FETCH vcursor INTO vrow;
        EXIT WHEN vcursor%notfound;
        
        DBMS_OUTPUT.PUT_LINE(vrow.lectureRoomNum || ' 강의실 정원: ' || vrow.capacity || '명');
        
    END LOOP;
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('예외처리');
        
END;


--기초 정보 관리 (교재 등록)
CREATE OR REPLACE PROCEDURE procAddBicTextBook(
	ptextBookName VARCHAR2,
    ptextBookWriter VARCHAR2,
    ptextBookPublISher VARCHAR2,
    ptextBookPrice NUMBER,
    psubjectNum VARCHAR2,
    presult OUT VARCHAR2
)
IS
BEGIN
	INSERT INTO tblTextBook (textBookNum, textBookName, textBookWriter, textBookPublISher, textBookPrice, subjectNum) 
        VALUES ((SELECT NVL(MAX(LPAD(textBookNum, 5, '0')), 0) + 1 FROM tblTextBook) , ptextBookName, ptextBookWriter, ptextBookPublISher, ptextBookPrice, psubjectNum);
    
	presult := '정상적으로 등록하였습니다.';
    
EXCEPTION
	WHEN OTHERS THEN
		presult := '등록을 실패하였습니다.'; --실패    

END procAddBicTextBook;

--실행
DECLARE
	vresult VARCHAR2(300);
BEGIN
	procAddBicTextBook('신나는 자바 공부', '홍길동', '한빛미디어', 40000, '40', vresult);
	DBMS_OUTPUT.PUT_LINE(vresult);
END;	


--기초 정보 관리 (교재 수정)

    CREATE OR REPLACE PROCEDURE procUpdateBicTextBook(
	psel NUMBER,
    ptextBookNum VARCHAR2,
    ptextBookChange VARCHAR2,
    presult OUT VARCHAR2
)
IS
BEGIN
	
    IF psel = 1 THEN
        UPDATE tblTextBook SET textBookName = ptextBookChange WHERE textBookNum = ptextBookNum;
    ELSIF psel = 2 THEN
        UPDATE tblTextBook SET textBookWriter = ptextBookChange WHERE textBookNum = ptextBookNum;
    ELSIF psel = 3 THEN
        UPDATE tblTextBook SET textBookPublISher = ptextBookChange WHERE textBookNum = ptextBookNum;
    ELSIF psel = 4 THEN
        UPDATE tblTextBook SET textBookPrice = ptextBookChange WHERE textBookNum = ptextBookNum;
    ELSIF psel = 5 THEN
        UPDATE tblTextBook SET subjectNum = ptextBookChange WHERE textBookNum = ptextBookNum;
    END IF;
    
	presult := '정상적으로 수정하였습니다.';
    
EXCEPTION
	WHEN OTHERS THEN
		presult := '수정을 실패하였습니다.'; --실패    

END procUpdateBicTextBook;

--실행
DECLARE
	vresult VARCHAR2(300);
BEGIN
	procUpdateBicTextBook(1, '42', '신나는 오라클 수업', vresult);
	DBMS_OUTPUT.PUT_LINE(vresult);
END;

--실행
DECLARE
	vresult VARCHAR2(300);
BEGIN
	procUpdateBicTextBook(2, '42', '아무개', vresult);
	DBMS_OUTPUT.PUT_LINE(vresult);
END;

--실행
DECLARE
	vresult VARCHAR2(300);
BEGIN
	procUpdateBicTextBook(3, '42', '한빛아카데미', vresult);
	DBMS_OUTPUT.PUT_LINE(vresult);
END;

--실행
DECLARE
	vresult VARCHAR2(300);
BEGIN
	procUpdateBicTextBook(4, '42', 20000, vresult);
	DBMS_OUTPUT.PUT_LINE(vresult);
END;

--실행
DECLARE
	vresult VARCHAR2(300);
BEGIN
	procUpdateBicTextBook(5, '42', '36', vresult);
	DBMS_OUTPUT.PUT_LINE(vresult);
END;


--기초 정보 관리 (교재 삭제)   
CREATE OR REPLACE PROCEDURE procDeleteBicTextBook (
	ptextBookNum VARCHAR2,
    presult OUT VARCHAR2
)
IS
BEGIN
	DELETE FROM tblTextBook WHERE textBookNum = ptextBookNum;
    
	presult := '정상적으로 삭제하였습니다.';
    
EXCEPTION
	WHEN OTHERS THEN
		presult := '삭제를 실패하였습니다.'; --실패    

END procDeleteBicTextBook;

--실행
DECLARE
	vresult VARCHAR2(300);
BEGIN
	procDeleteBicTextBook('42', vresult);
	DBMS_OUTPUT.PUT_LINE(vresult);
END;	


--기초 정보 관리 (교재 조회)   
CREATE OR REPLACE PROCEDURE procSelectBicTextBook (
    pcursor OUT sys_refcursor
)
IS
BEGIN

        OPEN pcursor
        FOR
        SELECT textBookNum, textBookName, textBookWriter, textBookPublISher, textBookPrice, s.subjectname FROM tblTextBook tb
            INNER JOIN tblSubject s
                ON tb.subjectnum = s.subjectnum;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('예외처리');
END procSelectBicTextBook;

--실행
DECLARE
    vcursor sys_refcursor;
    vrow tblTextBook%rowTYPE;
BEGIN
    
    procSelectBicTextBook(vcursor);
    DBMS_OUTPUT.PUT_LINE('────────────────────────── 교재 조회 ─────────────────────────');
   
    LOOP
        FETCH vcursor INTO vrow;
        EXIT WHEN vcursor%notfound;
        
        DBMS_OUTPUT.PUT_LINE(vrow.textBookNum || '. ' || vrow.textBookName);
        DBMS_OUTPUT.PUT_LINE('저자: ' || vrow.textBookWriter);
        DBMS_OUTPUT.PUT_LINE('출판사: ' || vrow.textBookPublISher);
        DBMS_OUTPUT.PUT_LINE('가격: ' || vrow.textBookPrice || '원');
        DBMS_OUTPUT.PUT_LINE('과목명: ' || vrow.subjectNum);
        DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────────');
        
    END LOOP;
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('예외처리');
        
END;


--도서
--1. 도서 추가
CREATE OR REPLACE PROCEDURE procAddBook (
    pbookNum VARCHAR2,
    pbookName VARCHAR2,
    pbookLevel NUMBER
)
AS
BEGIN
    INSERT INTO tblBook (bookNum, bookName, bookLevel)
        VALUES ((SELECT NVL(MAX(LPAD(bookNum, 5, '0')), 0) + 1 FROM tblBook), pbookName, pbookLevel);
    DBMS_OUTPUT.PUT_LINE('도서가 추가되었습니다.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류가 발생했습니다.');
END procAddBook;

/*
Begin
    procAddBook(seqBook.nextVal, <도서명>, <난이도>);
end;
*/
Begin
    procAddBook(seqBook.nextVal, '혼자 공부하는 SQL', 3);
end;


--2. 도서 수정하기
CREATE OR REPLACE PROCEDURE procUpdateBook (
    pbookNum VARCHAR2,
    pBookName VARCHAR2,
    pBookLevel NUMBER
)
AS
BEGIN
    UPDATE tblBook
        SET bookName = pBookName,
            bookLevel = pBookLevel
        WHERE bookNum = pbookNum;
    DBMS_OUTPUT.PUT_LINE('도서 정보가 업데이트되었습니다.');
END procUpdateBook;

/*
Begin
    procUpdateBook(<도서번호>, <도서명>,<난이도>);
End;
*/
Begin
    procUpdateBook(77, '혼자 공부하는 파이썬 2',3);
End;


--3. 도서 삭제
CREATE OR REPLACE PROCEDURE procDeleteBook (
    pbookNum VARCHAR2
)
AS
BEGIN
    DELETE FROM tblRecommendBook
        WHERE bookNum = pbookNum;
    DELETE FROM tblBook
     WHERE bookNum = pbookNum;
    DBMS_OUTPUT.PUT_LINE('도서가 삭제되었습니다.');
END procUpdateBook;

/*
BEGIN
    procDeleteBook(<도서번호>);
END;
*/
BEGIN
    procDeleteBook(12);
END;


--4. 도서 전체 목록 조회
CREATE OR REPLACE PROCEDURE proListBooks
AS
    vbookNum tblBook.bookNum%TYPE;
    vbookName tblBook.bookName%TYPE;
    vbookLevel tblBook.bookLevel%TYPE;
BEGIN
   
    FOR bookrecord IN (SELECT * FROM tblBook)
    LOOP
        vbookNum := bookrecord.bookNum;
        vbookName := bookrecord.bookName;
        vbookLevel := bookrecord.bookLevel;
        
        --조회 도서정보 출력.
        DBMS_OUTPUT.PUT_LINE('도서번호: ' || vbookNum);
        DBMS_OUTPUT.PUT_LINE('도서명: ' || vbookName);
        DBMS_OUTPUT.PUT_LINE('난이도: ' || vbookLevel);
        DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────────');
    END LOOP;
END proListBooks;

BEGIN
    DBMS_OUTPUT.PUT_LINE('────────────────────────── 도서 조회 ─────────────────────────');
    proListBooks;
END;



-------------------------------B01-02. 교사 정보 등록 및 관리

-- 관리자 (교사 등록)

CREATE OR REPLACE PROCEDURE procAddTeacher(
    pteacherName varchar2,
    pteacherSsn varchar2,
    pteacherTel varchar2,
    pstatus varchar2,
    pworkingStartDate varchar2,
    psubjectNum1 varchar2,
    psubjectNum2 varchar2,
    psubjectNum3 varchar2,
    psubjectNum4 varchar2,
    psubjectNum5 varchar2,
    psubjectNum6 varchar2,
    presult out varchar2
)
IS
    pteacherNum tblTeacher.teacherNum%type;
BEGIN

	INSERT INTO tblTeacher(teacherNum, teacherName, teacherSsn, teacherTel, status, workingStartDate)
		VALUES ((select nvl(max(lpad(teacherNum, 5, '0')), 0) + 1 from tblTeacher), pteacherName, pteacherSsn, pteacherTel, pstatus, pworkingStartDate);
	
    SELECT max(lpad(teacherNum, 5, '0')) INTO pteacherNum FROM tblTeacher;
    
    SELECT REPLACE(pteacherNum, '0', '') INTO pteacherNum FROM dual;
    
	INSERT INTO tblAvailableLecture (availableLectureNum, subjectNum, teacherNum)
		VALUES ((select nvl(max(lpad(availableLectureNum, 5, '0')), 0) + 1 from tblAvailableLecture), psubjectNum1, pteacherNum);
        
	INSERT INTO tblAvailableLecture (availableLectureNum, subjectNum, teacherNum)
		VALUES ((select nvl(max(lpad(availableLectureNum, 5, '0')), 0) + 1 from tblAvailableLecture), psubjectNum2, pteacherNum);

	INSERT INTO tblAvailableLecture (availableLectureNum, subjectNum, teacherNum)
		VALUES ((select nvl(max(lpad(availableLectureNum, 5, '0')), 0) + 1 from tblAvailableLecture), psubjectNum3, pteacherNum);
        
	INSERT INTO tblAvailableLecture (availableLectureNum, subjectNum, teacherNum)
		VALUES ((select nvl(max(lpad(availableLectureNum, 5, '0')), 0) + 1 from tblAvailableLecture), psubjectNum4, pteacherNum);
        
	INSERT INTO tblAvailableLecture (availableLectureNum, subjectNum, teacherNum)
		VALUES ((select nvl(max(lpad(availableLectureNum, 5, '0')), 0) + 1 from tblAvailableLecture), psubjectNum5, pteacherNum);
    
	INSERT INTO tblAvailableLecture (availableLectureNum, subjectNum, teacherNum)
		VALUES ((select nvl(max(lpad(availableLectureNum, 5, '0')), 0) + 1 from tblAvailableLecture), psubjectNum6, pteacherNum);
        
	presult := '정상적으로 등록하였습니다.';
    
EXCEPTION
	WHEN OTHERS THEN
		presult := '등록을 실패하였습니다.'; --실패    

END procAddTeacher;

-- 실행
DECLARE
	vresult varchar2(300);
BEGIN
	procAddTeacher('홍길동', '1234567', '010-1111-1111', '재직', '2023-09-18', '20', '21', '22', '23', '24', '25', vresult);
	dbms_output.put_line(vresult);
END;	    

-- 관리자 (교사 수정)

CREATE OR REPLACE PROCEDURE procUpdateTeacher(
    psel varchar2,
	pchangeTeacher varchar2,
    pteacherNum varchar2,
    presult out varchar2
)
IS
BEGIN
    
    IF psel = 1 THEN
        UPDATE tblTeacher SET teacherName = pchangeTeacher WHERE teacherNum = pteacherNum;
    ELSIF psel = 2 THEN    
        UPDATE tblTeacher SET teacherSsn = pchangeTeacher WHERE teacherNum = pteacherNum;
    ELSIF psel = 3 THEN
        UPDATE tblTeacher SET teacherTel = pchangeTeacher WHERE teacherNum = pteacherNum;
    ELSIF psel = 4 THEN
        UPDATE tblTeacher SET status = pchangeTeacher WHERE teacherNum = pteacherNum;  
    ELSIF psel = 5 THEN
        UPDATE tblTeacher SET workingStartDate = pchangeTeacher WHERE teacherNum = pteacherNum;
    ELSIF psel = 6 THEN
        UPDATE tblTeacher SET workingEndDate = pchangeTeacher WHERE teacherNum = pteacherNum;    
    END IF;
    
	presult := '정상적으로 수정하였습니다.';
    
EXCEPTION
	WHEN OTHERS THEN
		presult := '수정을 실패하였습니다.'; --실패    

END procUpdateTeacher;

-- 실행
DECLARE
	vresult varchar2(300);
BEGIN
	procUpdateTeacher(1, '아무개', '15', vresult);
    procUpdateTeacher(2, '2345678', '15', vresult);
    procUpdateTeacher(3, '010-2222-2222', '15', vresult);
    procUpdateTeacher(4, '퇴사', '15', vresult);
    procUpdateTeacher(5, '2023-09-17', '15', vresult);
    procUpdateTeacher(6, '2023-09-18', '15', vresult);
	dbms_output.put_line(vresult);
END;

-- 관리자 (교사 삭제)

CREATE OR REPLACE PROCEDURE procDeleteTeacher(
	pteacherNum varchar2,
    presult out varchar2
)
IS
BEGIN

    DELETE FROM tblAvailableLecture WHERE teacherNum = pteacherNum;
    DELETE FROM tblTeacher WHERE teacherNum = pteacherNum;
    
	presult := '정상적으로 삭제하였습니다.';
    
EXCEPTION
	WHEN OTHERS THEN
		presult := '삭제를 실패하였습니다.'; --실패    

END procDeleteTeacher;

-- 실행
DECLARE
	vresult varchar2(300);
BEGIN
	procDeleteTeacher('15', vresult);
	dbms_output.put_line(vresult);
END;


-- 관리자 (교사 조회)

CREATE OR REPLACE PROCEDURE procSelectTeacher
IS

pteacherName tblTeacher.teacherName%type;
pteacherSsn tblTeacher.teacherSsn%type;
pteacherTel tblTeacher.teacherTel%type;
psubjectName tblSubject.subjectName%type;


CURSOR vcursor IS

	SELECT teacherName AS "교사 이름",
           teacherSsn AS "교사 주민등록번호",
           teacherTel AS "교사 전화번호",
           s.subjectName AS "강의 가능 과목명" 
    FROM tblTeacher t
		INNER JOIN tblAvailableLecture al
			ON al.teacherNum = t.teacherNum
				INNER JOIN tblSubject s
					ON s.subjectNum = al.subjectNum
						ORDER BY t.teacherName ASC;		

BEGIN
    OPEN vcursor;
        LOOP
            FETCH vcursor INTO pteacherName, pteacherSsn, pteacherTel, psubjectName;
        EXIT WHEN vcursor%NOTFOUND;
        
        dbms_output.put_line('교사 이름: ' || pteacherName);
        dbms_output.put_line('교사 주민등록번호: ' || pteacherSsn);        
        dbms_output.put_line('교사 전화번호: ' || pteacherTel);
        dbms_output.put_line('강의 가능 과목명: ' || psubjectName);  
 
        
		dbms_output.put_line('===================================================================================================');

        END LOOP;
    CLOSE vcursor;

END;
										
BEGIN
    procSelectTeacher;
END;

--특정 교사 선택 시
CREATE OR REPLACE PROCEDURE procReadAboutTeacher (
    pTeacherNum IN VARCHAR2,
    pCursor OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN pCursor
    FOR
    SELECT * FROM vwCourseGather WHERE teacherNum = pTeacherNum;
    DBMS_OUTPUT.PUT_LINE('특정 교사 선택 성공');
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('특정 교사 선택 실패');
END procReadAboutTeacher;
/

--교사명 받아오는 FUNCTION
CREATE OR REPLACE FUNCTION fnTeacherName(
    pTeacherNum VARCHAR2
) RETURN VARCHAR2
IS
    vTeacherName tblTeacher.teacherName%TYPE;
BEGIN
    IF pTeacherNum IS NULL THEN
        vTeacherName := NULL;
        RETURN vTeacherName;
    ELSE
        SELECT teacherName INTO vTeacherName FROM tblTeacher WHERE teacherNum = pTeacherNum;
        RETURN vTeacherName;
    END IF;

END fnTeacherName;
/

--학생명 받아오는 FUNCTION
CREATE OR REPLACE FUNCTION fnStudentName(
    pStudentNum VARCHAR2
) RETURN VARCHAR2
IS
    vStudentName VARCHAR2(255);
BEGIN
    IF pStudentNum IS NULL THEN
        vStudentName := NULL;
        RETURN vStudentName;
    ELSE
        SELECT studentName INTO vStudentName FROM vwStudent WHERE studentNum = pStudentNum;
        RETURN vStudentName;
    END IF;
END fnStudentName;
/

DECLARE
    vCursor SYS_REFCURSOR;
    vRow vwCourseGather%ROWTYPE;
    vTeacherNum VARCHAR2(255) := '1';
    vTeacherName VARCHAR2(255);
BEGIN
    procReadAboutTeacher(vTeacherNum, vCursor);
    vTeacherName := fnTeacherName(vTeacherNum);
    DBMS_OUTPUT.PUT_LINE('선택한 교사명: ' || vTeacherName);
    DBMS_OUTPUT.PUT_LINE('──────────────────── ' || vTeacherName || ' 교사 강의목록 ────────────────────');
    LOOP
        FETCH vCursor INTO vRow;
        EXIT WHEN vCursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('과목명: ' || vRow.subjectName);
        DBMS_OUTPUT.PUT_LINE('과목기간: ' || vRow.subjectStartDate || ' ~ ' || vRow.subjectEndDate);
        DBMS_OUTPUT.PUT_LINE('교재명: ' || vRow.textBookName);
        DBMS_OUTPUT.PUT_LINE('과정명: ' || vRow.courseName);
        DBMS_OUTPUT.PUT_LINE('과정기간: ' || vRow.courseStartDate || ' ~ ' || vRow.courseEndDate);
        DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────────');
    END LOOP;
	CLOSE vCursor;
END;
/


--강의 수료 시, 수료 날짜 지정
CREATE OR REPLACE PROCEDURE procCourseComplete (
    pCourseDetailNum VARCHAR2
)
IS
    CURSOR vCursor
    IS
    SELECT studentNum, courseEndDate
       FROM vwCourseComplete WHERE courseDetailNum = pCourseDetailNum AND failReason IS NULL;
    vStudentNum VARCHAR2(30);
    vCourseEndDate DATE;
BEGIN
    OPEN vCursor;
    LOOP
        FETCH vCursor INTO vStudentNum, vCourseEndDate;
        EXIT WHEN vCursor%NOTFOUND;
        
        INSERT INTO tblComplete (completeNum, studentNum, completeDate)
                    VALUES ((SELECT NVL(MAX(LPAD(completeNum, 8, '0')), 0) + 1 FROM tblComplete), vStudentNum, vCourseEndDate);
    END LOOP;
    CLOSE vCursor;
    DBMS_OUTPUT.PUT_LINE('수료 날짜 지정 성공');
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('수료 날짜 지정 실패');
END procCourseComplete;
/

BEGIN
    procCourseComplete(17);
END;
/



-------------------------------B01-03. 개설 과정 등록 및 관리
--개설 과정 관리 (등록)
CREATE OR REPLACE PROCEDURE procAddOpenCourse(
	pcourseNum VARCHAR2,
    pcourseStartDate VARCHAR2,
    pcourseEndDate VARCHAR2,
    plectureRoomNum VARCHAR2,
    pISCourseRun NUMBER,
    pteacherNum VARCHAR2,
    psubjectAmount NUMBER,
    presult OUT VARCHAR2
)
IS
BEGIN
    
	INSERT INTO tblCourseDetail (courseDetailNum, courseNum, courseStartDate, courseEndDate, lectureRoomNum, ISCourseRun, teacherNum, subjectAmount) 
		VALUES ((SELECT NVL(MAX(LPAD(courseDetailNum, 5, '0')), 0) + 1 FROM tblCourseDetail) , pcourseNum, pcourseStartDate, pcourseEndDate, plectureRoomNum, pISCourseRun, pteacherNum, psubjectAmount);    
    
	presult := '정상적으로 등록하였습니다.';
    
EXCEPTION
	WHEN OTHERS THEN
		presult := '등록을 실패하였습니다.'; --실패    

END procAddOpenCourse;

--실행
DECLARE
	vresult VARCHAR2(300);
BEGIN
	procAddOpenCourse('15', '2023-09-15', '2024-03-18', '6', 0, '10', 6, vresult);
	DBMS_OUTPUT.PUT_LINE(vresult);
END;	    


--개설 과정 관리 (수정)
CREATE OR REPLACE PROCEDURE procUpdateOpenCourse(
	psel NUMBER,
    pcourseDetailNum VARCHAR2,
    pchangeDetail VARCHAR2,
    presult OUT VARCHAR2
)
IS
BEGIN
	
    IF psel = 1 THEN
        UPDATE tblCourseDetail SET courseNum = pchangeDetail WHERE courseDetailNum = pcourseDetailNum;
    ELSIF psel = 2 THEN
        UPDATE tblCourseDetail SET courseStartDate = pchangeDetail WHERE courseDetailNum = pcourseDetailNum;
    ELSIF psel = 3 THEN
        UPDATE tblCourseDetail SET courseEndDate = pchangeDetail WHERE courseDetailNum = pcourseDetailNum;
    ELSIF psel = 4 THEN
        UPDATE tblCourseDetail SET lectureRoomNum = pchangeDetail WHERE courseDetailNum = pcourseDetailNum;
    ELSIF psel = 5 THEN
        UPDATE tblCourseDetail SET ISCourseRun = pchangeDetail WHERE courseDetailNum = pcourseDetailNum;
    ELSIF psel = 6 THEN
        UPDATE tblCourseDetail SET teacherNum = pchangeDetail WHERE courseDetailNum = pcourseDetailNum;
    ELSIF psel = 7 THEN
        UPDATE tblCourseDetail SET subjectAmount = pchangeDetail WHERE courseDetailNum = pcourseDetailNum;    
    END IF;
    
	presult := '정상적으로 수정하였습니다.';
    
EXCEPTION
	WHEN OTHERS THEN
		presult := '수정을 실패하였습니다.'; --실패    

END procUpdateOpenCourse;

--실행
DECLARE
	vresult VARCHAR2(300);
BEGIN
	procUpdateOpenCourse(1, '20', '14', vresult);
    procUpdateOpenCourse(2, '20', '2023-09-20', vresult);
    procUpdateOpenCourse(3, '20', '2023-03-20', vresult);
    procUpdateOpenCourse(4, '20', '5', vresult);
    procUpdateOpenCourse(5, '20', 1, vresult);
    procUpdateOpenCourse(6, '20', '7', vresult);
    procUpdateOpenCourse(7, '20', '5', vresult);
	DBMS_OUTPUT.PUT_LINE(vresult);
END;   

--개설 과정 관리 (삭제)
CREATE OR REPLACE PROCEDURE procDeleteOpenCourse(
	psel NUMBER,
    presult OUT VARCHAR2
)
IS
BEGIN

	DELETE FROM tblCourseDetail WHERE courseDetailNum = psel; 
    
	presult := '정상적으로 삭제하였습니다.';
    
EXCEPTION
	WHEN OTHERS THEN
		presult := '삭제를 실패하였습니다.'; --실패    

END procDeleteOpenCourse;

--실행
DECLARE
	vresult VARCHAR2(300);
BEGIN
	procDeleteOpenCourse('20', vresult);
	DBMS_OUTPUT.PUT_LINE(vresult);
END;  
	

--개설 과정 관리 (조회)
CREATE OR REPLACE PROCEDURE procSelectOpenCourse
IS
    pcoursename tblCourse.courseName%TYPE;
    pcoursestartdate tblCourseDetail.courseStartDate%TYPE;
    pcourseENDdate tblCourseDetail.courseEndDate%TYPE;	
    plectureroomnum tblCourseDetail.lectureRoomNum%TYPE;
    pcount NUMBER;
CURSOR vcursor IS

	SELECT c.coursename AS "과정명",
		   cd.coursestartdate AS "과정 시작일",
		   cd.courseENDdate AS "과정 종료일",
		   cd.lectureroomnum AS "강의실",
		   count(*) AS "교육생 등록 인원"
	FROM tblStudent s 
		INNER JOIN tblCourseDetail cd
			ON cd.coursedetailnum = s.coursedetailnum
				INNER JOIN tblCourse c
					ON cd.coursenum = c.coursenum
						GROUP BY c.coursename, cd.coursedetailnum, cd.coursestartdate, cd.courseENDdate, cd.lectureroomnum
							ORDER BY LPAD(cd.coursedetailnum, 3, '0');
	
 
BEGIN
    OPEN vcursor;
		DBMS_OUTPUT.PUT_LINE('─────────────────────── 개설 과정 조회 ───────────────────────');
        LOOP
            FETCH vcursor INTO pcoursename, pcoursestartdate, pcourseENDdate, plectureroomnum, pcount;
        EXIT WHEN vcursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('과정명: ' || pcoursename);
        DBMS_OUTPUT.PUT_LINE('과정 시작일: ' || pcoursestartdate);
        DBMS_OUTPUT.PUT_LINE('과정 종료일: ' || pcourseENDdate);
        DBMS_OUTPUT.PUT_LINE('강의실: ' || plectureroomnum || '강의실');
        DBMS_OUTPUT.PUT_LINE('교육생 등록 인원: ' || pcount || '명');
		DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────────');

        END LOOP;
 CLOSE vcursor;

END;

--실행
BEGIN
    procSelectOpenCourse;
END;


--특정 과정 조회
CREATE OR REPLACE PROCEDURE procSelectPickCourse (
    vcourseDetailNum VARCHAR2
)
IS

psubjectName tblSubject.subjectName%TYPE;
psubjectStartDate tblSubjectDetail.subjectStartDate%TYPE;
psubjectEndDate tblSubjectDetail.subjectEndDate%TYPE;
ptextbookName tblTextBook.textBookName%TYPE;
pteacherName tblTeacher.teacherName%TYPE;
pinterviewername tblInterviewer.interviewerName%TYPE;
pinterviewerssn tblInterviewer.interviewerSsn%TYPE;
pinterviewertel tblInterviewer.interviewerTel%TYPE;
pinterviewerdate tblInterviewer.interviewerDate%TYPE;

CURSOR vcursor IS

	SELECT s.subjectName, sd.subjectStartDate, sd.subjectEndDate, tb.textbookName, t.teacherName, i.interviewername, i.interviewerssn, i.interviewertel, i.interviewerdate FROM tblCourseDetail cd
		INNER JOIN tblSubjectDetail sd
			ON cd.courseDetailNum = sd.courseDetailNum
				INNER JOIN tblSubject s
					ON s.subjectNum = sd.subjectNum
						INNER JOIN tblTextBook tb
							ON tb.subjectNum = sd.subjectNum
								INNER JOIN tblTeacher t
									ON t.teacherNum = cd.teacherNum
										INNER JOIN tblStudent st
											ON cd.courseDetailNum = st.courseDetailNum
												INNER JOIN tblInterviewRegISter ir
													ON ir.interviewReginum = st.interviewReginum
														INNER JOIN tblInterviewer i
															ON i.interviewerNum = ir.interviewerNum
																WHERE cd.coursedetailnum = vcourseDetailNum
																	ORDER BY s.subjectname ASC;
BEGIN                        
    OPEN vcursor;
		DBMS_OUTPUT.PUT_LINE('─────────────────────── 특정 과정 조회 ───────────────────────');
        LOOP
            FETCH vcursor INTO psubjectName, psubjectStartDate, psubjectEndDate, ptextbookName, pteacherName, pinterviewername, pinterviewerssn, pinterviewertel, pinterviewerdate;
        EXIT WHEN vcursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('과목명: ' || psubjectName);
        DBMS_OUTPUT.PUT_LINE('과목 시작일: ' || psubjectStartDate);
        DBMS_OUTPUT.PUT_LINE('과목 종료일: ' || psubjectEndDate);
        DBMS_OUTPUT.PUT_LINE('교재명: ' || ptextbookName);
        DBMS_OUTPUT.PUT_LINE('교사이름: ' || pteacherName);
        DBMS_OUTPUT.PUT_LINE('교육생 이름: ' || pinterviewername);
        DBMS_OUTPUT.PUT_LINE('교육생 주민등록번호: ' || pinterviewerssn);
        DBMS_OUTPUT.PUT_LINE('교육생 전화번호: ' || pinterviewertel);
        DBMS_OUTPUT.PUT_LINE('교육생 등록일: ' || pinterviewerdate);
		DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────────');

        END LOOP;
    CLOSE vcursor;

END;

--실행
BEGIN
    procSelectPickCourse('10');
END;


--교사명단 & 강의 가능 과목 비교
CREATE OR REPLACE PROCEDURE procSubjectTeacher(
    pSubjectNum IN VARCHAR2,
    pCursor OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN pCursor
    FOR
    SELECT * FROM vwSubjectTeacher WHERE subjectNum = pSubjectNum;
    DBMS_OUTPUT.PUT_LINE('선택 과목 가능 교사 출력 성공');
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('선택 과목 가능 교사 출력 실패');
END procSubjectTeacher;
/

DECLARE
    vSubjectNum vwSubjectTeacher.subjectNum%TYPE := 2; --<과목번호>
    vCursor SYS_REFCURSOR;
    vRow vwSubjectTeacher%ROWTYPE;
    vSubjectName tblSubject.subjectName%TYPE;
BEGIN
    procSubjectTeacher(vSubjectNum, vCursor);
    
    SELECT subjectName INTO vSubjectName FROM tblSubject WHERE subjectNum = vSubjectNum;
    DBMS_OUTPUT.PUT_LINE('─────────────────── ' || vSubjectName|| ' 강의 가능 교사 ────────────────────');
    LOOP
        FETCH vCursor INTO vRow;
        EXIT WHEN vCursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('교사번호: ' || vRow.teacherNum);
        DBMS_OUTPUT.PUT_LINE('교사이름: ' || vRow.teacherName);
        DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────────');
    END LOOP;
END;
/



-------------------------------B01-04. 개설 과목 등록 및 관리
--개설 과목 관리 (등록)
CREATE OR REPLACE PROCEDURE procAddOpenSubject(
    pcourseNum VARCHAR2,
    pcourseDetailNum VARCHAR2,
    psubjectStartDate VARCHAR2,
    psubjectEndDate VARCHAR2,
    presult OUT VARCHAR2
)
IS
BEGIN
    
	INSERT INTO tblSubjectDetail (subjectDetailNum, subjectNum, courseDetailNum, subjectStartDate, subjectEndDate) 
		VALUES ((SELECT NVL(MAX(LPAD(subjectDetailNum, 5, '0')), 0) + 1 FROM tblSubjectDetail), pcourseNum, pcourseDetailNum, psubjectStartDate, psubjectEndDate);
    
	presult := '정상적으로 등록하였습니다.';
    
EXCEPTION
	WHEN OTHERS THEN
		presult := '등록을 실패하였습니다.'; --실패    

END procAddOpenSubject;

--실행
DECLARE
	vresult VARCHAR2(300);
BEGIN
	procAddOpenSubject('15', '16', '2023-09-20', '2023-10-20', vresult);
    procAddOpenSubject('27', '16', '2023-10-21', '2023-11-21', vresult);
    procAddOpenSubject('38', '16', '2023-11-22', '2023-12-22', vresult);
    procAddOpenSubject('16', '16', '2023-12-23', '2024-01-23', vresult);
    procAddOpenSubject('8', '16', '2024-01-24', '2024-02-24', vresult);
    procAddOpenSubject('4', '16', '2024-02-25', '2024-03-25', vresult);
	DBMS_OUTPUT.PUT_LINE(vresult);
END;	    


--개설 과목 관리 (수정)
CREATE OR REPLACE PROCEDURE procUpdateOpenSubject(
	psel NUMBER,
    psubjectDetailNum VARCHAR2,
    pchangeDetail VARCHAR2,
    presult OUT VARCHAR2
)
IS
BEGIN
	
    IF psel = 1 THEN
        UPDATE tblSubjectDetail SET subjectNum = pchangeDetail WHERE subjectDetailNum = psubjectDetailNum;
    ELSIF psel = 2 THEN
        UPDATE tblSubjectDetail SET courseDetailNum = pchangeDetail WHERE subjectDetailNum = psubjectDetailNum;
    ELSIF psel = 3 THEN
        UPDATE tblSubjectDetail SET subjectStartDate = pchangeDetail WHERE subjectDetailNum = psubjectDetailNum;
    ELSIF psel = 4 THEN
        UPDATE tblSubjectDetail SET subjectEndDate = pchangeDetail WHERE subjectDetailNum = psubjectDetailNum;
    END IF;
    
	presult := '정상적으로 수정하였습니다.';
    
EXCEPTION
	WHEN OTHERS THEN
		presult := '수정을 실패하였습니다.'; --실패    

END procUpdateOpenSubject;

--실행
DECLARE
	vresult VARCHAR2(300);
BEGIN
	procUpdateOpenSubject(1, '109', '16', vresult);
    procUpdateOpenSubject(2, '109', '17', vresult);
    procUpdateOpenSubject(3, '109', '2023-09-21', vresult);
    procUpdateOpenSubject(4, '109', '2023-10-21', vresult);
	DBMS_OUTPUT.PUT_LINE(vresult);
END;   


--개설 과목 관리 (삭제)
CREATE OR REPLACE PROCEDURE procDeleteOpenSubject(
	psubjectDetailNum NUMBER,
    presult OUT VARCHAR2
)
IS
BEGIN

	DELETE FROM tblSubjectDetail WHERE subjectDetailNum = psubjectDetailNum; 
    
	presult := '정상적으로 삭제하였습니다.';
    
EXCEPTION
	WHEN OTHERS THEN
		presult := '삭제를 실패하였습니다.'; --실패    

END procDeleteOpenSubject;

--실행
DECLARE
	vresult VARCHAR2(300);
BEGIN
	procDeleteOpenSubject('109', vresult);
    procDeleteOpenSubject('110', vresult);
    procDeleteOpenSubject('111', vresult);
    procDeleteOpenSubject('112', vresult);
    procDeleteOpenSubject('113', vresult);
    procDeleteOpenSubject('114', vresult);
	DBMS_OUTPUT.PUT_LINE(vresult);
END;  
	

--개설 과목 관리 (조회)
CREATE OR REPLACE PROCEDURE procSelectOpenSubject
IS

pcourseName tblCourse.courseName%TYPE;
pcourseStartDate tblCourseDetail.courseStartDate%TYPE;
pcourseEndDate tblCourseDetail.courseEndDate%TYPE;
plectureRoomNum tblCourseDetail.lectureRoomNum%TYPE;
psubjectName tblSubject.subjectName%TYPE;
psubjectStartDate tblSubjectDetail.subjectStartDate%TYPE;
psubjectEndDate tblSubjectDetail.subjectEndDate%TYPE;
ptextBookName tblTextBook.textBookName%TYPE;
pteacherName tblTeacher.teacherName%TYPE;

CURSOR vcursor IS

SELECT c.coursename,
	   cd.coursestartdate,
	   cd.courseENDdate,
	   cd.lectureroomnum,
	   s.subjectname,
	   sd.subjectstartdate,
	   sd.subjectENDdate,
	   tb.textbookname,
	   t.teachername
FROM tblSubjectDetail sd
	INNER JOIN tblCourseDetail cd
		ON cd.coursedetailnum = sd.coursedetailnum
			INNER JOIN tblCourse c
				ON c.coursenum = cd.coursenum
					INNER JOIN tblSubject s
						ON sd.subjectnum = s.subjectnum
							INNER JOIN tblTextBook tb
								ON tb.subjectnum = sd.subjectnum
									INNER JOIN tblAvailableLecture al
										ON al.subjectnum = sd.subjectnum
											INNER JOIN tblTeacher t
												ON t.teachernum = al.teachernum
													WHERE cd.teachernum = al.teachernum
														ORDER BY c.coursename;

 
BEGIN
    OPEN vcursor;
		DBMS_OUTPUT.PUT_LINE('─────────────────────── 개설 과목 조회 ───────────────────────');
        LOOP
            FETCH vcursor INTO pcourseName, pcourseStartDate, pcourseEndDate, plectureRoomNum, psubjectName, psubjectStartDate, psubjectEndDate, ptextBookName, pteacherName;
        EXIT WHEN vcursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('과정명: ' || pcourseName);
        DBMS_OUTPUT.PUT_LINE('과정 시작일: ' || pcourseStartDate);
        DBMS_OUTPUT.PUT_LINE('과정 종료일: ' || pcourseEndDate);
        DBMS_OUTPUT.PUT_LINE('강의실: ' || plectureRoomNum || '강의실');
        DBMS_OUTPUT.PUT_LINE('과목명: ' || psubjectName);
        DBMS_OUTPUT.PUT_LINE('과목 시작일: ' || psubjectStartDate);
        DBMS_OUTPUT.PUT_LINE('과목 종료일: ' || psubjectEndDate);
        DBMS_OUTPUT.PUT_LINE('교재명: ' || ptextBookName);
        DBMS_OUTPUT.PUT_LINE('교사명: ' || pteacherName);
        DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────────');

        END LOOP;
	CLOSE vcursor;
END;

--실행
BEGIN
    procSelectOpenSubject;
END;


--특정 과목 조회
CREATE OR REPLACE PROCEDURE procSelectPickSubject (
    vcourseDetailNum VARCHAR2
)
IS

pcourseName tblCourse.courseName%TYPE;
pcourseStartDate tblCourseDetail.courseStartDate%TYPE;
pcourseEndDate tblCourseDetail.courseEndDate%TYPE;
plectureRoomNum tblCourseDetail.lectureRoomNum%TYPE;
psubjectName tblSubject.subjectName%TYPE;
psubjectStartDate tblSubjectDetail.subjectStartDate%TYPE;
psubjectEndDate tblSubjectDetail.subjectEndDate%TYPE;
ptextBookName tblTextBook.textBookName%TYPE;
pteacherName tblTeacher.teacherName%TYPE;

CURSOR vcursor IS

SELECT c.coursename,
	   cd.coursestartdate,
	   cd.courseENDdate,
	   cd.lectureroomnum,
	   s.subjectname,
	   sd.subjectstartdate,
	   sd.subjectENDdate,
	   tb.textbookname,
	   t.teachername
FROM tblSubjectDetail sd
	INNER JOIN tblCourseDetail cd
		ON cd.coursedetailnum = sd.coursedetailnum
			INNER JOIN tblCourse c
				ON c.coursenum = cd.coursenum
					INNER JOIN tblSubject s
						ON sd.subjectnum = s.subjectnum
							INNER JOIN tblTextBook tb
								ON tb.subjectnum = sd.subjectnum
									INNER JOIN tblAvailableLecture al
										ON al.subjectnum = sd.subjectnum
											INNER JOIN tblTeacher t
												ON t.teachernum = al.teachernum
													WHERE cd.teachernum = al.teachernum AND cd.courseDetailNum = vcourseDetailNum
														ORDER BY c.coursename;

 
BEGIN
    OPEN vcursor;
		DBMS_OUTPUT.PUT_LINE('─────────────────────── 특정 과목 조회 ───────────────────────');
        LOOP
            FETCH vcursor INTO pcourseName, pcourseStartDate, pcourseEndDate, plectureRoomNum, psubjectName, psubjectStartDate, psubjectEndDate, ptextBookName, pteacherName;
        EXIT WHEN vcursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('과정명: ' || pcourseName);
        DBMS_OUTPUT.PUT_LINE('과정 시작일: ' || pcourseStartDate);
        DBMS_OUTPUT.PUT_LINE('과정 종료일: ' || pcourseEndDate);
        DBMS_OUTPUT.PUT_LINE('강의실: ' || plectureRoomNum || '강의실');
        DBMS_OUTPUT.PUT_LINE('과목명: ' || psubjectName);
        DBMS_OUTPUT.PUT_LINE('과목 시작일: ' || psubjectStartDate);
        DBMS_OUTPUT.PUT_LINE('과목 종료일: ' || psubjectEndDate);
        DBMS_OUTPUT.PUT_LINE('교재명: ' || ptextBookName);
        DBMS_OUTPUT.PUT_LINE('교사명: ' || pteacherName);
        
		DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────────');

        END LOOP;
    CLOSE vcursor;
END;

--실행
BEGIN
    procSelectPickSubject('14');
END;

SELECT * FROM tblInterviewRegister;

-------------------------------B02-01. 교육생 정보 등록 및 명단 조회
--1. 면접에 합격한 지원생은 과정 등록 여부에 따라 교육생 정보가 생성된다. 관리자가 교육생 등록일 및 과정 상세 번호를 입력한다. 주민등록번호 뒷자리는 교육생 본인이 로그인시 패스워드로 사용된다.
--• 교육생 등록일은 등록한 날짜가 자동으로 입력되도록 한다.
--﻿• 교육생 등록 여부 리스트에서 교육생이 등록을 하지 않을 경우 교육생 정보가 생성되지 않는다.
--• 교육생 정보 생성 시, 면접 지원 당시 입력한 정보를 사용한다.
--• 교육생은 하나의 과정만 등록하여 수강이 가능하다.

--[교육생 등록 및 등록 여부 리스트 '등록여부' 변경]
--[프로시저 생성]
CREATE OR REPLACE PROCEDURE procAddStudent(
	pnum NUMBER, --교육생 면접번호
	pcnum NUMBER --과정상세번호
)
IS
BEGIN
	UPDATE tblInterviewRegister SET isEnrollment = 1 WHERE interviewerNum = pnum;
	INSERT INTO tblStudent (studentNum,interviewRegiNum,registrationDate,signUpCnt,courseDetailNum)
			VALUES (seqStudent.nextVal,fnGetInterviewRegiNum(pnum), SYSDATE, 1, pcnum);
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('등록에 실패했습니다.');
END procAddStudent;

--[프로시저내에서 사용할 저장 함수 생성]
CREATE OR REPLACE FUNCTION fnGetInterviewRegiNum(
	pnum NUMBER --교육생 면접번호
) RETURN NUMBER --교육생 등록여부번호 반환
IS
	vnum NUMBER;
BEGIN
	SELECT interviewRegiNum INTO vnum FROM tblInterviewRegister WHERE interviewerNum = pnum;
	RETURN vnum;
END fnGetInterviewRegiNum;

--[프로시저 실행]
BEGIN
	procAddStudent(515, 20); --교육생 면접번호(515), 과정 상세번호(20)
END;

--[실행 확인]
SELECT * FROM tblInterviewRegister; --515 교육생등록여부번호
SELECT * FROM tblStudent;

--2. 교육생 정보에 대한 입력, 출력, 수정, 삭제 기능을 사용할 수 있어야 한다.
--[입력]
--> 위 1번에서 구현

--[출력]
--> 아래 3번에서 구현

--[수정]
--[프로시저 생성]
CREATE OR REPLACE PROCEDURE procUpdateStudent(
    pnum NUMBER, --교육생 번호
    pname VARCHAR2, --교육생 이름
    pssn VARCHAR2, --교육생 주민등록번호
    ptel VARCHAR2 --교육생 전화번호
)
IS
    vnum NUMBER; --교육생 번호를 받아서 반환할 면접번호를 담는 변수
BEGIN
    vnum := fnGetInterviewerNum(pnum);
    UPDATE tblInterviewer SET interviewerName = pname, interviewerSsn = pssn, interviewerTel = ptel WHERE interviewerNum = vnum;
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('갱신에 실패했습니다.');
END procUpdateStudent;
SELECT * FROM tblInterviewer;

--[프로시저내에서 사용할 저장 함수 생성] > 교육생 번호 입력 시, 교육생 면접번호 반환
CREATE OR REPLACE FUNCTION fnGetInterviewerNum(
	pnum NUMBER --교육생 번호
) RETURN NUMBER --반환 자료형
IS
	vnum NUMBER; --교육생 면접 번호 반환
BEGIN
    SELECT interviewRegiNum INTO vnum FROM tblStudent WHERE studentNum = pnum; --vnum = 등록여부번호
    SELECT interviewerNum INTO vnum FROM tblInterviewRegister WHERE interviewRegiNum = vnum;
    RETURN vnum;
END fnGetInterviewerNum;

--[프로시저 실행]
BEGIN
	procUpdateStudent(1, '김테스', '991212-1011111','010-1234-1234');
END;

--[실행 확인]
SELECT * FROM tblStudent WHERE studentNum = 1; --면접번호 1
SELECT * FROM tblInterviewer WHERE interviewerNum = 1;

--3. 교육생 정보 출력시 교육생 번호, 이름, 주민등록번호, 전화번호, 등록일, 수강(신청) 횟수를 출력한다.
--[프로시저 생성]
CREATE OR REPLACE PROCEDURE procReadAllStudent
IS
BEGIN
	DBMS_OUTPUT.PUT_LINE('───────────────────────── 교육생 조회 ────────────────────────');
    FOR student IN (
    SELECT
    s.studentNum AS "교육생 번호",
	i.interviewerName AS "교육생 이름",
	i.interviewerSsn AS 주민등록번호,
	i.interviewerTel AS 전화번호,
	TO_CHAR(s.registrationDate,'YYYY-MM-DD') AS 등록일,
	s.signUpCnt AS "수강(신청) 횟수"
    FROM tblInterviewer i
        INNER JOIN tblInterviewRegister r
            ON i.interviewerNum = r.interviewerNum
                INNER JOIN tblStudent s
                    ON r.interviewRegiNum = s.interviewRegiNum
    )
    LOOP
    DBMS_OUTPUT.PUT_LINE('교육생 번호: ' || student."교육생 번호" || ' | 교육생 이름: ' || student."교육생 이름" || ' | 주민등록번호: ' || student.주민등록번호 || ' | 전화번호: ' || student.전화번호 || ' | 등록일: ' || student.등록일 || ' | 수강(신청) 횟수: ' || student."수강(신청) 횟수");
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────────');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('교육생 정보 조회에 실패했습니다.');
END procReadAllStudent;

--[프로시저 실행]
BEGIN
	procReadAllStudent;
END;

--4. 특정 교육생 선택시 교육생 번호, 교육생 이름, 교육생이 수강 신청한 또는 수강중인, 수강했던 개설 과정 정보(과정명, 과정기간(시작 년월일, 끝 년월일), 강의실, 수료 및 중도탈락 여부, 수료 및 중도탈락 날짜)를 출력한다.
--﻿• 교육생 정보를 쉽게 확인하기 위한 검색 기능을 사용할 수 있어야 한다.
--[프로시저 생성]
CREATE OR REPLACE PROCEDURE procReadOneStudent(
    pnum NUMBER --교육생 번호
)
IS
BEGIN
	DBMS_OUTPUT.PUT_LINE('───────────────────────── 교육생 조회 ────────────────────────');
    FOR student IN (
    SELECT 
        studentNum AS "교육생 번호",
        studentName AS "교육생 이름",
        courseDetailNum AS 과정명,
        courseStartDate AS "과정 시작일",
        courseEndDate AS "과정 종료일",
        lectureRoomNum AS 강의실,
        completionStatus AS "수료 상태",
        completionDate AS "수료(탈락)일"
    FROM vwCompletionStatus
        WHERE studentNum = pnum
    )
    LOOP
    DBMS_OUTPUT.PUT_LINE('교육생 번호: ' || student."교육생 번호");
    DBMS_OUTPUT.PUT_LINE('교육생 이름: ' || student."교육생 이름");
    DBMS_OUTPUT.PUT_LINE('과정명: ' || student.과정명);
    DBMS_OUTPUT.PUT_LINE('과정 시작일: ' || student."과정 시작일");
    DBMS_OUTPUT.PUT_LINE('과정 종료일: ' || student."과정 종료일");
    DBMS_OUTPUT.PUT_LINE('강의실: ' || student."강의실");
    DBMS_OUTPUT.PUT_LINE('수료 상태: ' || student."수료 상태");
    DBMS_OUTPUT.PUT_LINE('수료(탈락)일: ' || student."수료(탈락)일");
    DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────────');
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('교육생 정보 조회에 실패했습니다.');
END procReadOneStudent;

--[프로시저 실행]
BEGIN
	procReadOneStudent(514); --교육생 번호(514)
END;

--5. 교육생에 대한 수료 및 중도 탈락 처리를 할 수 있어야 한다. 수료 또는 중도탈락 날짜를 입력할 수 있어야 한다.
--수료처리
--[프로시저 생성]
CREATE OR REPLACE PROCEDURE procToComplete(
	pnum NUMBER, --교육생번호
	pdate DATE --수료일
)
IS 
BEGIN
	INSERT INTO tblComplete (completeNum, studentNum, completeDate) VALUES ((SELECT NVL(MAX(LPAD(completeNum, 5, '0')), 0) + 1 FROM tblComplete), pnum, TO_CHAR(pdate,'YYYY-MM-DD'));
EXCEPTION
	WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('등록에 실패했습니다.');
END procToComplete;

--[프로시저 실행]
BEGIN
	procToComplete(412, SYSDATE); --교육생 번호(412), 수료일
END;

--[실행 확인]
SELECT * FROM tblStudent;
SELECT * FROM tblComplete;

--중도 탈락 처리
--[프로시저 생성]
CREATE OR REPLACE PROCEDURE procToFail(
	pnum NUMBER, --교육생번호
	pdate DATE, --탈락일
	preason VARCHAR2 --탈락사유
)
IS 
BEGIN
	INSERT INTO tblFail (failNum, studentNum, failDate, failReason) VALUES ((SELECT NVL(MAX(LPAD(failNum, 5, '0')), 0) + 1 FROM tblFail), pnum, pdate, preason);
EXCEPTION
	WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('등록에 실패했습니다.');
END procToFail;

--[프로시저 실행]
BEGIN
	procToFail(413, SYSDATE, '테스트'); --교육생 번호(413), 탈락일, 사유
END;

--[실행 확인]
SELECT * FROM tblStudent;
SELECT * FROM tblFail;

--6. 강의 예정인 과정, 강의 중인 과정, 강의 종료된 과정 중에서 선택한 과정을 신청한 교육생 정보를 확인할 수 있어야 한다.
--교육생 번호, 이름, 주민등록번호, 전화번호, 등록일, 수강(신청) 횟수
--[강의 예정인 과정 > 교육생 정보 조회]
CREATE OR REPLACE PROCEDURE procBeforeCourseSt
IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('───────────────── 강의 예정 과정 교육생 정보 ─────────────────');
    FOR student IN (
        SELECT 
        s.studentNum AS "교육생 번호",
        vs.studentName AS "교육생 이름",
        vs.studentSsn AS 주민등록번호,
        vs.studentTel AS 전화번호,
        s.registrationDate AS 등록일,
        s.signUpCnt AS "수강(신청) 횟수",
        vc.courseName AS 과정명,
        vc.completionStatus AS "수료 상태"
      FROM tblStudent s
          INNER JOIN vwStudent vs
                ON s.studentNum = vs.studentNum
          INNER JOIN vwCompletionStatus vc
                ON s.studentNum = vc.studentNum
     WHERE vc.courseStartDate > SYSDATE --강의 예정인 과정
     ORDER BY TO_NUMBER("교육생 번호")
    )
    LOOP
     DBMS_OUTPUT.PUT_LINE('교육생 번호: ' || student."교육생 번호");
    DBMS_OUTPUT.PUT_LINE('교육생 이름: ' || student."교육생 이름");
    DBMS_OUTPUT.PUT_LINE('주민등록번호: ' || student.주민등록번호);
    DBMS_OUTPUT.PUT_LINE('전화번호: ' || student.전화번호);
    DBMS_OUTPUT.PUT_LINE('등록일: ' || student.등록일);
    DBMS_OUTPUT.PUT_LINE('수강(신청) 횟수: ' || student."수강(신청) 횟수");
    DBMS_OUTPUT.PUT_LINE('과정명: ' || student.과정명);
    DBMS_OUTPUT.PUT_LINE('수료 상태: ' || student."수료 상태");
    DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────────');
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('교육생 정보 조회에 실패했습니다.');
END procBeforeCourseSt;

--[프로시저 실행]
BEGIN
	procBeforeCourseSt;
END;

--[강의 중인 과정 > 교육생 정보 조회]
CREATE OR REPLACE PROCEDURE procIngCourseSt
IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('───────────────── 강의 중인 과정 교육생 정보 ─────────────────');
    FOR student IN (
        SELECT 
        s.studentNum AS "교육생 번호",
        vs.studentName AS "교육생 이름",
        vs.studentSsn AS 주민등록번호,
        vs.studentTel AS 전화번호,
        s.registrationDate AS 등록일,
        s.signUpCnt AS "수강(신청) 횟수",
        vc.courseName AS 과정명,
        vc.completionStatus AS "수료 상태"
      FROM tblStudent s
          INNER JOIN vwStudent vs
                ON s.studentNum = vs.studentNum
          INNER JOIN vwCompletionStatus vc
                ON s.studentNum = vc.studentNum
     WHERE vc.courseStartDate <= SYSDATE AND vc.courseEndDate >= SYSDATE --강의 중인 과정
     ORDER BY TO_NUMBER("교육생 번호")
    )
    LOOP
     DBMS_OUTPUT.PUT_LINE('교육생 번호: ' || student."교육생 번호");
    DBMS_OUTPUT.PUT_LINE('교육생 이름: ' || student."교육생 이름");
    DBMS_OUTPUT.PUT_LINE('주민등록번호: ' || student.주민등록번호);
    DBMS_OUTPUT.PUT_LINE('전화번호: ' || student.전화번호);
    DBMS_OUTPUT.PUT_LINE('등록일: ' || student.등록일);
    DBMS_OUTPUT.PUT_LINE('수강(신청) 횟수: ' || student."수강(신청) 횟수");
    DBMS_OUTPUT.PUT_LINE('과정명: ' || student.과정명);
    DBMS_OUTPUT.PUT_LINE('수료 상태: ' || student."수료 상태");
    DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────────');
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('교육생 정보 조회에 실패했습니다.');
END procIngCourseSt;

--[프로시저 실행]
BEGIN
	procIngCourseSt;
END;

--[강의 종료된 과정 > 교육생 정보 조회]
CREATE OR REPLACE PROCEDURE procAfterCourseSt
IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('───────────────── 강의 종료 과정 교육생 정보 ─────────────────');
    FOR student IN (
        SELECT 
        s.studentNum AS "교육생 번호",
        vs.studentName AS "교육생 이름",
        vs.studentSsn AS 주민등록번호,
        vs.studentTel AS 전화번호,
        s.registrationDate AS 등록일,
        s.signUpCnt AS "수강(신청) 횟수",
        vc.courseName AS 과정명,
        vc.completionStatus AS "수료 상태"
      FROM tblStudent s
          INNER JOIN vwStudent vs
                ON s.studentNum = vs.studentNum
          INNER JOIN vwCompletionStatus vc
                ON s.studentNum = vc.studentNum
     WHERE vc.courseEndDate < SYSDATE --강의 종료된 과정
     ORDER BY TO_NUMBER("교육생 번호")
    )
    LOOP
    DBMS_OUTPUT.PUT_LINE('교육생 번호: ' || student."교육생 번호");
    DBMS_OUTPUT.PUT_LINE('교육생 이름: ' || student."교육생 이름");
    DBMS_OUTPUT.PUT_LINE('주민등록번호: ' || student.주민등록번호);
    DBMS_OUTPUT.PUT_LINE('전화번호: ' || student.전화번호);
    DBMS_OUTPUT.PUT_LINE('등록일: ' || student.등록일);
    DBMS_OUTPUT.PUT_LINE('수강(신청) 횟수: ' || student."수강(신청) 횟수");
    DBMS_OUTPUT.PUT_LINE('과정명: ' || student.과정명);
    DBMS_OUTPUT.PUT_LINE('수료 상태: ' || student."수료 상태");
    DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────────');
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('교육생 정보 조회에 실패했습니다.');
END procAfterCourseSt;

--[프로시저 실행]
BEGIN
	procAfterCourseSt;
END;



-------------------------------B02-02. 기간별 교육생 상담일지 관리
--1. 교사가 교육생과 상담을 진행한 후 작성한 상담일지를 조회 및 관리한다.
--4. 상담일지에 관한 입력, 출력, 수정, 삭제할 수 있다.
--• 상담일자는 상담일을 기준으로 자동으로 입력되도록 한다.
-------------------------[입력]-----------------------------------------
--[프로시저 생성]
CREATE OR REPLACE PROCEDURE procAddConsulting(
	psnum NUMBER, --교육생 번호
	ptnum NUMBER, --교사 번호
	pcontent VARCHAR2 --상담 내용
)
IS
BEGIN
	INSERT INTO tblConsulting (consultingNum, consultingDate, studentNum, teacherNum, consultingContent, isComplete)
			VALUES ((SELECT NVL(MAX(LPAD(consultingNum, 5, '0')), 0) + 1 FROM tblConsulting), SYSDATE, psnum, ptnum, pcontent, 1);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('생성에 실패했습니다.');
END procAddConsulting;

--[프로시저 실행]
﻿BEGIN
    procAddConsulting(500, 6, '취업상담'); --교육생 번호, 교사 번호, 상담내용
END;

--[실행 확인]
SELECT * FROM tblConsulting;

-------------------------[출력]-----------------------------------------
--> 아래 2,3번에서 구현

-------------------------[수정]-----------------------------------------
--[프로시저 생성] (상담일, 상담완료여부 빼고 전체 수정)
CREATE OR REPLACE PROCEDURE procUpdateConsulting(
	pnum NUMBER, --상담 번호
	psNum NUMBER, --교육생 번호
	ptNum NUMBER, --교사 번호
	pcontent VARCHAR2 --상담 내용
)
IS
BEGIN
	UPDATE tblConsulting SET studentNum = psNum, teacherNum = ptNum, consultingContent = pcontent WHERE consultingNum = pnum;
EXCEPTION
	WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('갱신에 실패했습니다.');
END;

--[프로시저 실행]
BEGIN
    procUpdateConsulting(31,6,4,'상담상담상담'); --상담번호, 교육생번호, 교사번호, 상담내용
END;

--[실행 확인]
SELECT * FROM tblConsulting;

-------------------------[삭제]-----------------------------------------
--[프로시저 생성]
CREATE OR REPLACE PROCEDURE procDeleteConsulting(
	pnum NUMBER --상담 번호
)
IS
BEGIN
	DELETE FROM tblConsulting WHERE consultingNum = pnum;
EXCEPTION
	WHEN OTHERS THEN
	DBMS_OUTPUT.PUT_LINE('삭제에 실패했습니다.');
END;

--[프로시저 실행]
BEGIN
    procDeleteConsulting(31);
END;

--[실행 확인]
SELECT * FROM tblConsulting;

--2. 전체 상담일지 출력 시 교육생 번호, 교육생 이름, 상담날짜, 상담 교사, 상담 내용을 출력한다.
----------------------------------------------------- [전체 상담일지 조회] ------------------------------------------------------------------------------
-- [프로시저 생성]
/
CREATE OR REPLACE PROCEDURE procReadAllConsulting
IS
    vcnt NUMBER; --전체 상담일지의 데이터가 존재하는지 확인하는 변수
BEGIN
    
    SELECT COUNT(*) INTO vcnt FROM tblconsulting;
    
    DBMS_OUTPUT.PUT_LINE('──────────────────── 전체 상담일지 조회 ────────────────────');

    IF vcnt > 0 THEN --전체 상담일지의 데이터가 1건 이상 존재할 경우,
    
        FOR consulting IN (
        SELECT
            vs.studentNum AS "교육생 번호",
            vs.studentName AS "교육생 이름",
            TO_CHAR(cs.consultingDate,'YYYY-MM-DD') AS "상담 날짜",
            t.teacherName AS "상담 교사",
            cs.consultingContent AS "상담 내용"
        FROM vwStudent vs
            INNER JOIN tblConsulting cs
                ON vs.studentNum = cs.studentNum
                    INNER JOIN tblTeacher t
                        ON t.teacherNum = cs.teacherNum
                            ORDER BY "상담 날짜" ASC, "교육생 번호" ASC
        )
        LOOP 
            DBMS_OUTPUT.PUT_LINE('교육생 번호: ' || consulting."교육생 번호");
            DBMS_OUTPUT.PUT_LINE('교육생 이름: ' || consulting."교육생 이름");
            DBMS_OUTPUT.PUT_LINE('상담 날짜: ' || consulting."상담 날짜");
            DBMS_OUTPUT.PUT_LINE('상담 교사: ' || consulting."상담 교사");
            DBMS_OUTPUT.PUT_LINE('상담 내용: ' || consulting."상담 내용");
            DBMS_OUTPUT.PUT_LINE('───────────────────────────────────────────────────────────');
        END LOOP;
        
    ELSE --해당 tblConsulting 테이블에 데이터가 1건도 없을 경우
    DBMS_OUTPUT.PUT_LINE('해당 내역이 존재하지 않습니다.');
        DBMS_OUTPUT.PUT_LINE('───────────────────────────────────────────────────────────');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('전체 상담일지 조회에 실패했습니다.');    
END procReadAllConsulting;
/

-- [프로시저 실행]
/
BEGIN
    procReadAllConsulting;
END;
/

--3. 특정 상담일지 선택 시 교육생이 수강 신청한 또는 수강중인, 수강했던 개설 과정 정보(과정명, 과정기간(시작 년월일, 끝 년월일), 강의실, 수료 및 중도탈락 여부, 수료 및 중도탈락 날짜)를 출력하고, 상담일지의 정보(교사명, 상담일자, 상담내용)를 출력한다.
----------------------------------------------------- [특정 교육생의 상담일지 조회] ------------------------------------------------------------------------------
-- [프로시저 생성]
/
CREATE OR REPLACE PROCEDURE procReadOneConsulting(
    pnum IN NUMBER --교육생 번호    
)
IS
    vflag NUMBER := 0;

BEGIN
    FOR consulting IN (
    SELECT 	
        s.studentNum AS "교육생 번호",
        vs.studentName AS "교육생 이름",
        TO_CHAR(cst.consultingDate,'YYYY-MM-DD') AS "상담 날짜",
        t.teacherName AS "상담 교사",
        cst.consultingContent AS "상담 내용",
        cs.courseName AS 과정명,
        TO_CHAR(cd.courseStartDate,'YYYY-MM-DD') AS "과정 시작일",
        TO_CHAR(cd.courseEndDate,'YYYY-MM-DD') AS "과정 종료일",
        cd.lectureRoomNum AS 강의실,
        CASE 
            WHEN c.studentNum IS NOT NULL THEN '수료'
            WHEN f.studentNum IS NOT NULL THEN '중도 탈락'
            WHEN TO_CHAR(cd.courseStartDate,'YYYY-MM-DD') > TO_CHAR(sysdate,'YYYY-MM-DD') THEN '진행 예정'
            ELSE '진행중'
        END AS "수료 상태",
        CASE
            WHEN c.studentNum IS NOT NULL THEN TO_CHAR(c.completeDate,'YYYY-MM-DD')
            WHEN f.studentNum IS NOT NULL THEN TO_CHAR(f.failDate,'YYYY-MM-DD')
            ELSE NULL
        END AS "수료(탈락)일"
    FROM tblStudent s
        INNER JOIN tblCourseDetail cd
            ON cd.courseDetailNum = s.courseDetailNum
                INNER JOIN tblCourse cs
                    ON cs.courseNum = cd.courseNum
                        FULL JOIN tblComplete c
                            ON s.studentNum = c.studentNum
                                FULL JOIN tblFail f
                                    ON s.studentNum = f.studentNum
                                        INNER JOIN tblConsulting cst
                                            ON s.studentNum = cst.studentNum
                                                INNER JOIN tblTeacher t
                                                    ON t.teacherNum = cst.teacherNum
                                                        INNER JOIN vwStudent vs
                                                            ON s.studentNum = vs.studentNum
        WHERE s.studentNum = pnum --교육생 번호
    )

    LOOP
        IF (vflag = 0)
            THEN 
                DBMS_OUTPUT.PUT_LINE('──────────────────── 상담일지 조회 ────────────────────');
                DBMS_OUTPUT.PUT_LINE('[교육생 정보]');
                DBMS_OUTPUT.PUT_LINE('교육생 번호: ' || consulting."교육생 번호");
                DBMS_OUTPUT.PUT_LINE('교육생 이름: ' || consulting."교육생 이름");
                DBMS_OUTPUT.PUT_LINE('과정명: ' || consulting.과정명);
                DBMS_OUTPUT.PUT_LINE('과정 시작일: ' || consulting."과정 시작일");
                DBMS_OUTPUT.PUT_LINE('과정 종료일: ' || consulting."과정 종료일");
                DBMS_OUTPUT.PUT_LINE('강의실: ' || consulting."강의실");
                DBMS_OUTPUT.PUT_LINE('수료 상태: ' || consulting."수료 상태");
                DBMS_OUTPUT.PUT_LINE('수료(탈락)일: ' || consulting."수료(탈락)일");
                DBMS_OUTPUT.PUT_LINE(' ');
                DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────');
                vflag := 1;
        END IF;    
        -- 특정 상담번호의 일지 정보 및 해당 상담 교육생의 정보 출력
        DBMS_OUTPUT.PUT_LINE('[상담 내역]');
        DBMS_OUTPUT.PUT_LINE('상담 날짜: ' || consulting."상담 날짜");
        DBMS_OUTPUT.PUT_LINE('상담 교사: ' || consulting."상담 교사");
        DBMS_OUTPUT.PUT_LINE('상담 내용: ' || consulting."상담 내용");
        DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────');
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('해당 교육생의 상담일지 조회에 실패했습니다.');
END procReadOneConsulting;
/

-- [프로시저 실행]
/
BEGIN
    procReadOneConsulting(54); --교육생 번호 54번
END;
/


-------------------------------B03-01. 교육생 시험관리 및 성적조회
--시험리스트
--1. 특정 개설 과정을 선택하는 경우) 등록된 개설 과목 정보를 출력하고, 개설 과목 별로 성적 등록 여부, 시험 문제 파일 등록 여부를 확인할 수 있어야 한다.
CREATE OR REPLACE PROCEDURE procCourseInfo (
    pcoursedetailnum IN NUMBER
) AS
    --커서
    CURSOR coursecursor IS
        SELECT DISTINCT
            cg.coursename,
            cg.subjectname,
            CASE 
                WHEN writtenscore IS NULL THEN '입력안함'
                ELSE '입력함'
            END AS scorestatus,
            t.isregistration AS registrationstatus
        FROM vwCourseGather cg
            LEFT OUTER JOIN tbltest t 
                ON t.subjectDetailNum = cg.subjectDetailNum
                    LEFT OUTER JOIN tbltestscore ts 
                        ON ts.testnum = t.testnum
        WHERE cg.coursedetailnum = pcoursedetailnum;
BEGIN
    DBMS_OUTPUT.PUT_LINE('────────────────── 개설 과목 시험 여부 조회 ──────────────────');
     
    FOR courserec IN coursecursor 
    LOOP
        DBMS_OUTPUT.PUT_LINE('과목명: ' || courserec.subjectname);
        DBMS_OUTPUT.PUT_LINE('성적 등록 여부: ' || courserec.scorestatus);
        DBMS_OUTPUT.PUT_LINE('시험 문제 등록 여부: ' || courserec.registrationstatus);
        DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────────');
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('조회에 실패했습니다.');
END procCourseInfo;

DECLARE
    pcoursedetailnum NUMBER := 1;
BEGIN
    procCourseInfo(pcoursedetailnum);
END;


--2. 과목별 출력시) 개설 과정명, 개설 과정기간, 강의실명, 개설 과목명, 교사명, 교재명 등을 출력하고, 해당 개설 과목을 수강한 모든 교육생의 성적 정보(교육생 이름, 주민번호 뒷자리, 필기, 실기)를 같이 출력한다.
CREATE OR REPLACE PROCEDURE procSubjectInfo(
    psubjectNum VARCHAR2
)
AS
BEGIN
    FOR subjectInfo IN (
        SELECT
            cg.courseName  "과정명",
            cg.courseStartDate || ' ~ ' || cg.courseEndDate  "과정기간",
            cd.lectureRoomNum  "강의실명",
            cg.subjectName  "과목명",
            cg.teacherName  "교사이름",
            cg.textBookName  "교재명",
            vs.studentName  "교육생 이름",
            SUBSTR(vs.studentssn,instr(vs.studentssn,'-')+1)  "주민번호 뒷자리",
            ts.writtenScore  "필기",
            ts.practicalScore  "실기"
        FROM
            vwCourseGather cg
            INNER JOIN TBLTEST t 
                on cg.subjectDetailNum = t.subjectDetailNum
                    INNER JOIN tbltestScore ts 
                        on t.testNum = ts.testNum
                            INNER JOIN tblstudent s 
                                on ts.studentNum = s.studentNum
                                    INNER JOIN vwStudent vs 
                                        on s.studentNum = vs.studentNum
                                            INNER JOIN tblCourseDetail cd 
                                                on cg.courseDetailNum = cd.courseDetailNum
                                    WHERE cg.subjectNum = psubjectNum
    ) LOOP
        --출력
        DBMS_OUTPUT.PUT_LINE('과정명: ' || subjectInfo."과정명");
        DBMS_OUTPUT.PUT_LINE('과정기간: ' || subjectInfo."과정기간");
        DBMS_OUTPUT.PUT_LINE('강의실명: ' || subjectInfo."강의실명");
        DBMS_OUTPUT.PUT_LINE('과목명: ' || subjectInfo."과목명");
        DBMS_OUTPUT.PUT_LINE('교사이름: ' || subjectInfo."교사이름");
        DBMS_OUTPUT.PUT_LINE('교재명: ' || subjectInfo."교재명");
        DBMS_OUTPUT.PUT_LINE('교육생 이름: ' || subjectInfo."교육생 이름");
        DBMS_OUTPUT.PUT_LINE('주민번호 뒷자리: ' || subjectInfo."주민번호 뒷자리");
        DBMS_OUTPUT.PUT_LINE('필기: ' || subjectInfo."필기");
        DBMS_OUTPUT.PUT_LINE('실기: ' || subjectInfo."실기");
        DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────────');
    END LOOP;
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('조회에 실패했습니다.');
END procSubjectInfo;

BEGIN
    DBMS_OUTPUT.PUT_LINE('────────────────────── 교육생 점수 조회 ──────────────────────');
    procSubjectInfo(2);
END;


--3. 교육생 개인별 출력시) 교육생 이름, 주민번호 뒷자리, 개설 과정명, 개설 과정기간, 강의실명 등을 출력하고, 교육생 개인이 수강한 모든 개설 과목에 대한 성적 정보(개설 과목명, 개설 과목 기간, 교사명, 필기, 실기)를 같이 출력한다.
CREATE OR REPLACE PROCEDURE procStudentPersonalInfo(
    pstudentName VARCHAR2
)
AS
BEGIN
    FOR studentinfo IN (
        SELECT
            vs.studentName  "교육생 이름",
            SUBSTR(vs.studentssn,instr(vs.studentssn,'-')+1)  "주민번호",
            cg.courseName  "과정명",
            cg.courseStartDate || ' ~ ' || cg.courseEndDate  "과정기간",
            cd.lectureRoomNum  "강의실명",
            cg.subjectName  "과목명",
            cg.subjectStartDate || ' ~ ' || cg.subjectEndDate  "과목기간",
            cg.teacherName  "교사이름",
            ts.writtenScore  "필기",
            ts.practicalScore  "실기"
        FROM
            vwCourseGather cg
            INNER JOIN TBLTEST t 
                on cg.subjectDetailNum = t.subjectDetailNum
                    INNER JOIN tbltestScore ts 
                        on t.testNum = ts.testNum
                            INNER JOIN tblstudent s 
                                on ts.studentNum = s.studentNum
                                    INNER JOIN vwStudent vs    
                                        on s.studentNum = vs.studentNum
                                            INNER JOIN tblCourseDetail cd 
                                                on cg.courseDetailNum = cd.courseDetailNum
                        WHERE vs.studentName = pstudentName
    ) LOOP
        --출력
        DBMS_OUTPUT.PUT_LINE('교육생 이름: ' || studentinfo."교육생 이름");
        DBMS_OUTPUT.PUT_LINE('주민번호: ' || studentinfo."주민번호");
        DBMS_OUTPUT.PUT_LINE('과정명: ' || studentinfo."과정명");
        DBMS_OUTPUT.PUT_LINE('과정기간: ' || studentinfo."과정기간");
        DBMS_OUTPUT.PUT_LINE('강의실명: ' || studentinfo."강의실명");
        DBMS_OUTPUT.PUT_LINE('과목명: ' || studentinfo."과목명");
        DBMS_OUTPUT.PUT_LINE('과목기간: ' || studentinfo."과목기간");
        DBMS_OUTPUT.PUT_LINE('교사이름: ' || studentinfo."교사이름");
        DBMS_OUTPUT.PUT_LINE('필기: ' || studentinfo."필기");
        DBMS_OUTPUT.PUT_LINE('실기: ' || studentinfo."실기");
        DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────────');
    END LOOP;
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('조회에 실패했습니다.');
END procStudentPersonalInfo;

BEGIN
    DBMS_OUTPUT.PUT_LINE('────────────────────── 교육생 점수 조회 ──────────────────────');
    procStudentPersonalInfo('최성빈');
END;



-------------------------------B04-01. 교육생 출결관리 및 출결조회
--특정 과정 출결 현황 조회
CREATE OR REPLACE PROCEDURE procCourseAttendance (
    pCourseDetailNum IN VARCHAR2,
    pCursor OUT SYS_REFCURSOR
)
IS
    vStartDate tblCourseDetail.courseStartDate%TYPE;
    vEndDate tblCourseDetail.courseEndDate%TYPE;
BEGIN
    SELECT courseStartDate, courseEndDate INTO vStartDate, vEndDate FROM tblCourseDetail
        WHERE courseDetailNum = pCourseDetailNum;
        
    DBMS_OUTPUT.PUT_LINE(vStartDate);
       DBMS_OUTPUT.PUT_LINE(vEndDate); 
    OPEN pCursor
    FOR
    SELECT
    attendanceDate AS attendanceDate,
    studentNum AS studentNum,
    CASE
        WHEN IsTrady = 0 THEN '정상'
        WHEN IsTrady = 1 THEN '지각'
    END AS state
FROM vwCourseAttendance
    WHERE courseDetailNum = 1

UNION

SELECT
    applyDate AS attendanceDate,
    studentNum AS studentNum,
    applyAttendance AS state
FROM vwCourseAttendanceApply
    WHERE courseDetailNum = pCourseDetailNum

UNION

SELECT
    regDate AS attendanceDate,
    NULL AS studentNum,
    CASE
        WHEN TO_CHAR(regdate, 'd') in ('1') THEN '일요일'
        WHEN TO_CHAR(regdate, 'd') in ('7') THEN '토요일'
    END AS state
FROM vwDate
    WHERE regDate Between vStartDate AND vEndDate AND TO_CHAR(regDate, 'd') IN ('1', '7')
    
UNION

SELECT
    holiday AS attendanceDate,
    NULL AS studentNum,
    holidayName AS state
FROM tblHoliday
    WHERE holiday Between vStartDate AND vEndDate
        ORDER BY attendanceDate ASC;
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('특정 과정 출결 조회 실패');
END procCourseAttendance;
/

DECLARE
    vCourseDetailNum VARCHAR2(30) := 1;
    vCursor SYS_REFCURSOR;
    vAttendanceDate DATE;
    vStudentNum VARCHAR2(255) := 2;
    vState VARCHAR2(255);
    vStudentName VARCHAR2(255);
BEGIN
    procCourseAttendance(vCourseDetailNum, vCursor);
    DBMS_OUTPUT.PUT_LINE('────────────────────── 교육생 출결 조회 ──────────────────────');
    LOOP
        FETCH vCursor INTO vAttendanceDate, vStudentNum, vState;
        EXIT WHEN vCursor%NOTFOUND;
        
        vStudentName := fnStudentName(vStudentNum);
        DBMS_OUTPUT.PUT_LINE('출결일: ' || vAttendanceDate);
        DBMS_OUTPUT.PUT_LINE('학생이름: ' || vStudentName);
        DBMS_OUTPUT.PUT_LINE('상태: ' || vState);
        DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────────');
    END LOOP;
END;
/

--한 학생 출결 데이터 뽑기
CREATE OR REPLACE PROCEDURE procStudentAttendance (
    pStudentNum IN VARCHAR2,
    pCursor OUT SYS_REFCURSOR
)
IS
    vStartDate DATE;
    vEndDate DATE;
BEGIN
    SELECT cd.courseStartDate, cd.courseEndDate INTO vStartDate, vEndDate FROM tblCourseDetail cd
        INNER JOIN tblStudent s
            ON cd.courseDetailNum = s.courseDetailNum
                WHERE studentNum = pStudentNum;

    OPEN pCursor
    FOR
    SELECT
        attendanceDate AS attendanceDate,
        CASE
            WHEN IsTrady = 0 THEN '정상'
            WHEN IsTrady = 1 THEN '지각'
        END AS state
    FROM tblStudentAttendance
        WHERE studentNum = pStudentNum
        
    UNION
    
    SELECT
        applyDate AS attendanceDate,
        applyAttendance AS state
    FROM tblAttendanceApply
        WHERE studentNum = pStudentNum
    
    UNION
    
    SELECT
        regDate AS attendanceDate,
        CASE
            WHEN TO_CHAR(regdate, 'd') in ('1') THEN '일요일'
            WHEN TO_CHAR(regdate, 'd') in ('7') THEN '토요일'
        END AS state
    FROM vwDate
        WHERE regDate Between vStartDate AND vEndDate AND TO_CHAR(regDate, 'd') IN ('1', '7')
        
    UNION
    
    SELECT
        holiday AS attendanceDate,
        holidayName AS state
    FROM tblHoliday
        WHERE holiday Between vStartDate AND vEndDate;
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('특정  학생 출결 조회 실패');
END procStudentAttendance;
/

DECLARE
    vStudentNum VARCHAR2(30) := 2;
    vCursor SYS_REFCURSOR;
    vAttendanceDate DATE;
    vState VARCHAR2(255);
    vStudentName VARCHAR2(255);
BEGIN
    procStudentAttendance(vStudentNum, vCursor);
    vStudentName := fnStudentName(vStudentNum);
    
    DBMS_OUTPUT.PUT_LINE('────────────────────── ' || vStudentName|| ' 출결 상황 ──────────────────────');
    LOOP
        FETCH vCursor INTO vAttendanceDate, vState;
        EXIT WHEN vCursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('출결일: ' || vAttendanceDate);
        DBMS_OUTPUT.PUT_LINE('상태: ' || vState);
        DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────────');
    END LOOP;
END;
/

--기간별 출결 현황 조회
CREATE OR REPLACE PROCEDURE procPeriodAttendance (
    pStartDate IN DATE,
    pEndDate IN DATE,
    pCursor OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN pCursor
    FOR
    SELECT
        attendanceDate AS attendanceDate,
        studentNum AS studentNum,
        CASE
            WHEN IsTrady = 0 THEN '정상'
            WHEN IsTrady = 1 THEN '지각'
        END AS state
    FROM tblStudentAttendance WHERE attendanceDate BETWEEN pStartDate AND pEndDate
        
    UNION
    
    SELECT
        applyDate AS attendanceDate,
        studentNum AS studentNum,
        applyAttendance AS state
    FROM tblAttendanceApply WHERE applyDate BETWEEN pStartDate AND pEndDate
    
    UNION
    
    SELECT
        regDate AS attendanceDate,
        NULL AS studentNum,
        CASE
            WHEN TO_CHAR(regdate, 'd') in ('1') THEN '일요일'
            WHEN TO_CHAR(regdate, 'd') in ('7') THEN '토요일'
        END AS state
    FROM vwDate
        WHERE regDate Between pStartDate AND pEndDate AND TO_CHAR(regDate, 'd') IN ('1', '7')
        
    UNION
    
    SELECT
        holiday AS attendanceDate,
        NULL AS studentNum,
        holidayName AS state
    FROM tblHoliday
        WHERE holiday Between pStartDate AND pEndDate;
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('기간 출결 조회 실패');
END procPeriodAttendance;
/

DECLARE
    vStartDate DATE := '2022-03-01';
    vEndDate DATE := '2022-03-31';
    vCursor SYS_REFCURSOR;
    vAttendanceDate DATE;
    vStudentNum VARCHAR2(255);
    vState VARCHAR2(255);
    vStudentName VARCHAR2(255);
BEGIN
    procPeriodAttendance(vStartDate, vEndDate, vCursor);
    
    DBMS_OUTPUT.PUT_LINE('────────────────── ' || vStartDate || ' ~ ' || vEndDate || ' 출결 ──────────────────');
    LOOP
        FETCH vCursor INTO vAttendanceDate, vStudentNum, vState;
        EXIT WHEN vCursor%NOTFOUND;
        
        vStudentName := fnStudentName(vStudentNum);
        DBMS_OUTPUT.PUT_LINE('출결일: ' || vAttendanceDate);
        DBMS_OUTPUT.PUT_LINE('학생이름: ' || vStudentName);
        DBMS_OUTPUT.PUT_LINE('상태: ' || vState);
        DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────────');
    END LOOP;
END;
/

SELECT * FROM tblItem;
-------------------------------B05-01. 비품 등록 및 관리
--1. 현재 있는 비품 리스트(컴퓨터, 모니터, 키보드 등)을 조회한다.
--조회
DECLARE
BEGIN
    DBMS_OUTPUT.PUT_LINE('───────────────────────── 비품 정보 ──────────────────────────');
    FOR item in (
        
       SELECT
            id.itemdetailnum AS 비품번호,
            i.itemcategory AS 비품분류,
            id.itemname AS 비품명,
            id.itemcondition AS 비품상태,
            id.lectureroomnum AS 소속강의실
        FROM tblitem i
            INNER JOIN tblitemdetail id
                ON i.itemnum = id.itemnum
    
    )
    LOOP
    DBMS_OUTPUT.PUT_LINE('비품번호: ' || item.비품번호);
    DBMS_OUTPUT.PUT_LINE('비품분류: ' || item.비품분류);
    DBMS_OUTPUT.PUT_LINE('비품명: ' || item.비품명);
    DBMS_OUTPUT.PUT_LINE('비품상태: ' || item.비품상태);
    DBMS_OUTPUT.PUT_LINE('비품위치(강의실번호): ' || item.소속강의실);
    DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────────');
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('조회 실패했습니다.');
END;
/


--2. 비품이 새로 들어오면 추가한다.
--추가
CREATE OR REPLACE PROCEDURE procAddItem(
    pitemNum VARCHAR2,
    pitemName VARCHAR2,
    pitemCondition VARCHAR2,
    plectureRoomNum VARCHAR2,
    presult OUT VARCHAR2      --피드백
)
IS 
BEGIN  
    INSERT INTO tblItemDetail (itemDetailNum, itemNum, itemName, itemCondition, lectureRoomNum)
			VALUES ((SELECT NVL(MAX(LPAD(itemDetailNum, 5, '0')), 0) + 1 FROM tblItemDetail), pitemnum, pitemname, pitemCondition, plectureRoomNum);
    
    presult := '생성 성공했습니다.';   --성공
EXCEPTION
    WHEN OTHERS THEN
        presult := '생성 실패했습니다.';   --실패
END procAddItem;
/

DECLARE
    vresult VARCHAR2(30);
BEGIN
    procAddItem('1', 'Aimecca AM-205LE', '상', '1', vresult);
    DBMS_OUTPUT.PUT_LINE(vresult);
END;
/


--3. 비품 수리 신청이 들어오면 확인 후 수리여부를 수정한다.
--수정(수리여부)
CREATE OR REPLACE PROCEDURE procRepair (
    pitemchangenum VARCHAR2,
    presult OUT VARCHAR2
)
IS
BEGIN
    UPDATE tblitemchange 
        SET ISreplacement = '1'
            WHERE itemchangenum = pitemchangenum;
    presult := '수리여부 갱신 성공했습니다.';   --성공
EXCEPTION
    WHEN OTHERS THEN
        presult := '수리여부 갱신 실패했습니다.';   --실패
END procRepair;
/


DECLARE
    vresult VARCHAR2(30);
BEGIN
    procRepair('24', vresult);
    DBMS_OUTPUT.PUT_LINE(vresult);
END;
/


--4. 비품 삭제
--삭제
CREATE OR REPLACE PROCEDURE procDeleteitem(
    pseq VARCHAR2,
    presult OUT VARCHAR2
)
IS
BEGIN
    DELETE FROM tblitemdetail WHERE itemdetailnum = pseq;
        presult := '비품 삭제 성공했습니다.';   --성공
EXCEPTION
    WHEN OTHERS THEN
        presult := '비품 삭제 실패했습니다.';   --실패
END procDeleteitem;
/

DECLARE
    vresult VARCHAR2(30);
BEGIN
    procDeleteitem('1', vresult);
    DBMS_OUTPUT.PUT_LINE(vresult);
END;



-------------------------------B06-01. 출입 카드 등록 및 관리
--1. 새로 교육생을 등록할 시, 새로운 출입카드를 등록하고 교육생에게 배부한다.
--교육생명단에 INSERT 발생 시, 출입카드리스트에 교육생을 추가하는 트리거 필요
--등록
create or replace trigger trgCard
    AFTER
    INSERT
    ON tblstudent
    FOR each row
DECLARE
    tstudentnum VARCHAR2(30);
BEGIN
    tstudentnum := :new.studentNum;
    INSERT INTO tblAccessCard VALUES ((SELECT NVL(MAX(LPAD(accessCardNum, 5, '0')), 0) + 1 FROM tblAccessCard), tstudentnum , 0);
     DBMS_OUTPUT.PUT_LINE('교육생 출입카드 등록에 성공했습니다.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('교육생 출입카드 등록에 실패했습니다.');
END trgCard;
/

INSERT INTO tblStudent (studentNum,interviewRegiNum,regIStrationDate,signUpCnt,courseDetailNum)
			VALUES ('517','1','2022-03-02',1,'1');
 

--조회
DECLARE
BEGIN
    DBMS_OUTPUT.PUT_LINE('─────────────────────── 출입카드 정보 ────────────────────────');
    FOR cards in (
        
       SELECT
            c.accessCardNum AS 출입카드번호,
            v.studentname AS 교육생이름,
            c.ISAccessCard AS 배부여부
        FROM tblAccessCard c
            INNER JOIN vwstudent v	
                ON c.studentnum = v.studentnum
        ORDER BY TO_NUMBER(c.accessCardNum)
    
    )
    LOOP
    DBMS_OUTPUT.PUT_LINE('출입카드번호: ' || cards.출입카드번호);
    DBMS_OUTPUT.PUT_LINE('교육생이름: ' || cards.교육생이름);
    DBMS_OUTPUT.PUT_LINE('배부여부: ' || cards.배부여부);
    DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────────');
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('출입카드 정보 조회에 실패했습니다.');
END;


--2. 교육생에게 배부한 출입카드에 대해 재발급 신청이 들어올 시, 재발급 신청 사유를 확인할 수 있다.(SELECT)
--조회(출입카드 재발급 정보)
DECLARE
BEGIN
    DBMS_OUTPUT.PUT_LINE('──────────────────── 출입카드 재발급 정보 ────────────────────');
    FOR card in (
        
       SELECT
            c.accesscardreISsuenum AS 출입카드재발급번호,
            v.studentname AS 교육생이름,
            c.ISreISsue AS 배부여부,
            c.reISsuereason AS 분실사유
        FROM tblaccesscardreISsue c
            INNER JOIN vwstudent v	
                ON c.studentnum = v.studentnum
        ORDER BY TO_NUMBER(c.accesscardreISsuenum)
    
    )
    LOOP
    DBMS_OUTPUT.PUT_LINE('출입카드재발급번호: ' || card.출입카드재발급번호);
    DBMS_OUTPUT.PUT_LINE('교육생이름: ' || card.교육생이름);
    DBMS_OUTPUT.PUT_LINE('배부여부: ' || card.배부여부);
    DBMS_OUTPUT.PUT_LINE('분실사유: ' || card.분실사유);
    DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────────');
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('출입카드 재발급 정보 조회에 실패했습니다.');
END;
/

--수정(출입카드 배부여부)
CREATE OR REPLACE PROCEDURE procUpdateCard(
    paccessCardNum VARCHAR2,
    presult OUT VARCHAR2
)
IS
BEGIN
    
    UPDATE tblaccessCard 
	SET ISAccessCard = '1'
	WHERE accessCardNum = paccessCardNum;
    presult := '출입카드 배부여부 갱신 성공했습니다.';   --성공
EXCEPTION
    WHEN OTHERS THEN
        presult := '출입카드 배부여부 갱신 실패했습니다.';   --실패
END procUpdateCard;
/

DECLARE
    vresult VARCHAR2(100);
BEGIN
    procUpdateCard('515', vresult);
    DBMS_OUTPUT.PUT_LINE(vresult);
END;
/


--3. 재발급 신청이 들어온 교육생에 한해, 새로운 출입카드를 등록하고 배부한다.(UPDATE)
--수정(출입카드 재발급 배부여부)
CREATE OR REPLACE PROCEDURE procUpdateReCard(
    paccesscardreISsuenum VARCHAR2,
    presult OUT VARCHAR2
)
IS
BEGIN
    
    UPDATE tblaccesscardreISsue 
	SET ISreISsue = '1'
	WHERE accesscardreISsuenum = paccesscardreISsuenum;
    presult := '출입카드 재발급 배부여부 갱신 성공했습니다.';   --성공
EXCEPTION
    WHEN OTHERS THEN
        presult := '출입카드 재발급 배부여부 갱신 실패했습니다.';   --실패
END procUpdateReCard;
/

DECLARE
    vresult VARCHAR2(100);
BEGIN
    procUpdateReCard('515', vresult);
    DBMS_OUTPUT.PUT_LINE(vresult);
END;
/



-------------------------------B07-01. 기관 연계회사 등록 및 관리
--조회
CREATE OR REPLACE PROCEDURE procCom(
    pcompany VARCHAR2,
    presult OUT VARCHAR2
)
IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('─────────────────────── 회사 정보 조회 ───────────────────────');
    FOR company in (
        
        SELECT 
            c.companyname AS 회사명,
            c.averagesalary AS 평균급여,
            c.companylocation AS 회사위치,
            c.companysize AS 회사규모,
            t.subjectname AS 요구과목,
            r.score AS 요구성적
        FROM TBLCOMPANY c
            INNER JOIN tblrequirement r
            ON c.companynum = r.companynum
                RIGHT OUTER JOIN tblsubject t
                    ON t.subjectnum = r.subjectnum
        WHERE c.COMPANYNAME = pcompany
    
    )
    LOOP
    --회사 정보 출력
    DBMS_OUTPUT.PUT_LINE('회사명: ' || company.회사명);
    DBMS_OUTPUT.PUT_LINE('평균급여: ' || company.평균급여);
    DBMS_OUTPUT.PUT_LINE('회사위치: ' || company.회사위치);
    DBMS_OUTPUT.PUT_LINE('회사규모: ' || company.회사규모);
    DBMS_OUTPUT.PUT_LINE('요구과목: ' || company.요구과목);
    DBMS_OUTPUT.PUT_LINE('요구성적: ' || company.요구성적);
    DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────────');
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        presult := '회사 정보 조회 실패했습니다.';
END procCom;
/

DECLARE
    vcompany tblcompany.companyname%TYPE := '노스스타컨설팅';
    vresult VARCHAR(30);
BEGIN
    procCom(vcompany, vresult);
    DBMS_OUTPUT.PUT_LINE(vresult);
END;
/


--2. 연계 회사가 요구하는 과목 및 요구 성적을 만족하는 교육생을 조회하는 경우 조건에 만족하는 교육생을 성적과 출결 정보를 기준으로 내림차순 정렬한다.
CREATE OR REPLACE PROCEDURE procRequirementStudent(
    pcompany VARCHAR2
)
IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('───────────────── 요구 조건 만족 교육생 정보 ─────────────────');
    FOR company in (
        
        SELECT 
            c.companyname AS 회사명,
            t.subjectname AS 회사요구과목,
            r.score AS 회사요구성적,
            s.studentname AS 교육생이름,
            (ts.attENDancescore+ts.writtenscore+ts.practicalscore) AS 교육생성적
        FROM TBLCOMPANY c
            INNER JOIN tblrequirement r
            ON c.companynum = r.companynum
                INNER JOIN tblsubject t
                    on t.subjectnum = r.subjectnum
                        INNER JOIN tblsubjectdetail sd
                            ON sd.subjectnum = r.subjectnum
                                INNER JOIN tbltest test
                                    ON test.subjectdetailnum = sd.subjectdetailnum
                                        INNER JOIN tbltestscore ts
                                            ON ts.testnum = test.testnum
                                                INNER JOIN vwstudent s
                                                    ON s.studentNum = ts.studentnum
        WHERE c.COMPANYNAME = pcompany AND (ts.attENDancescore+ts.writtenscore+ts.practicalscore) >= r.score
        ORDER BY 교육생성적 desc
    
    )
    LOOP
    --회사 정보 출력
    DBMS_OUTPUT.PUT_LINE('회사명: ' || company.회사명);
    DBMS_OUTPUT.PUT_LINE('회사요구과목: ' || company.회사요구과목);
    DBMS_OUTPUT.PUT_LINE('회사요구성적: ' || company.회사요구성적);
    DBMS_OUTPUT.PUT_LINE('교육생이름: ' || company.교육생이름);
    DBMS_OUTPUT.PUT_LINE('교육생성적: ' || company.교육생성적);
    DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────────');
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('요구 조건 만족 교육생 정보 조회 실패했습니다.');
END procRequirementStudent;
/

DECLARE
    vcompany tblcompany.companyname%TYPE := '노스스타컨설팅';
BEGIN
    procRequirementStudent(vcompany);
END;
/


--3. 연계 회사에 재직중인 교육생을 조회하는 경우 회사에 재직중인 교육생이 이전에 수료한 과정명을 출력한다.
--조회(연계 회사에 재직중인 교육생 조회)
DECLARE
BEGIN
    DBMS_OUTPUT.PUT_LINE('────────────── 연계 회사 재직 중인 교육생 정보 ───────────────');
    FOR company in (
        
       SELECT
            c.companyname AS 연계회사명,
            j.jobdate AS 취업일,
            student.studentname AS 교육생이름,
            course.coursename AS 수료과정명
        FROM tblcompany c
            INNER JOIN tbljob j
             ON c.companynum = j.companynum
                INNER JOIN tblstudent s
                ON s.studentnum = j.studentnum
                    INNER JOIN tblcoursedetail cd
                    ON cd.coursedetailnum = s.coursedetailnum
                        INNER JOIN vwstudent student
                        ON student.studentnum = s.studentnum
                            INNER JOIN tblcourse course
                            ON course.coursenum = cd.coursenum
        WHERE c.ISconnection = 1
        ORDER BY 취업일 DESC
    
    )
    LOOP
    DBMS_OUTPUT.PUT_LINE('연계회사명: ' || company.연계회사명);
    DBMS_OUTPUT.PUT_LINE('취업일: ' || company.취업일);
    DBMS_OUTPUT.PUT_LINE('교육생이름: ' || company.교육생이름);
    DBMS_OUTPUT.PUT_LINE('수료과정명: ' || company.수료과정명);
    DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────────');
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('연계 회사 재직 중인 교육생 조회에 실패했습니다.');
END;
/


--4. 연계 회사 등록 및 조건을 입력한다.
--등록(연계 회사)
CREATE OR REPLACE PROCEDURE procAddCom(
    pcompanyname VARCHAR2,
    pcompanyTYPE VARCHAR2,
    pcompanysize VARCHAR2,
    psalary NUMBER,
    plocation VARCHAR2,
    pISconnection NUMBER,
    presult OUT VARCHAR2      --피드백
)
IS 
BEGIN
    INSERT INTO tblcompany (companyNum, companyName, companyType, companySize, averageSalary, companyLocation, ISConnection)
        values ((SELECT NVL(MAX(LPAD(companyNum, 5, '0')), 0) + 1 FROM tblcompany), pcompanyname, pcompanyTYPE, pcompanysize, psalary, plocation, pISconnection);
        
    presult := '등록에 성공했습니다.'   --성공
EXCEPTION
    WHEN OTHERS THEN
        presult := '등록에 실패했습니다.';   --실패
END procAddCom;


DECLARE
    vresult VARCHAR2(30);
BEGIN
    procAddCom('쌍용','si','대기업','12345','서울시 강남구', 1, vresult);
    DBMS_OUTPUT.PUT_LINE(vresult);
END;


--등록(연계 회사 조건)
CREATE OR REPLACE PROCEDURE procAddrequirement(
    pcompanyNum VARCHAR2,
    psubjectNum VARCHAR2,
    pscore NUMBER,
    presult OUT VARCHAR2      --피드백
)
IS 
BEGIN
    INSERT INTO tblrequirement (requirementNum, companyNum, subjectNum, score)
        values ((SELECT NVL(MAX(LPAD(requirementNum, 5, '0')), 0) + 1 FROM tblrequirement), pcompanyNum, psubjectNum, pscore);
        
    presult := '등록 성공했습니다.';   --성공
EXCEPTION
    WHEN OTHERS THEN
        presult := '등록 실패했습니다.';   --실패
END procAddrequirement;
/

DECLARE
    vresult VARCHAR2(30);
BEGIN
    procAddrequirement('1','999',100, vresult);
    DBMS_OUTPUT.PUT_LINE(vresult);
END;
/


--요구조건 삭제
CREATE OR REPLACE PROCEDURE procDeleteReq (
    pname in VARCHAR2,
    presult OUT VARCHAR2
)
IS
BEGIN
    DELETE FROM tblrequirement WHERE companynum =  
                                                    (SELECT 
                                                        r.companynum
                                                        FROM tblrequirement r
                                                            INNER JOIN tblcompany c
                                                             ON r.companynum = c.companynum
                                                    WHERE c.companyname=pname);
    
    presult := '삭제 성공했습니다.';  
EXCEPTION
    WHEN OTHERS THEN
        presult := '삭제 실패했습니다.';  
END procDeleteReq;
/

DECLARE
    vresult VARCHAR2(30);
BEGIN
    procDeleteReq('지티플러스', vresult);    --회사명
    DBMS_OUTPUT.PUT_LINE(vresult);
END;
/
SELECT * FROM tblcompany WHERE compnayname = '삼성';

--회사 수정 / 조건 수정
--수정(회사 정보)
CREATE OR REPLACE PROCEDURE procUpdateCom (
    pseq NUMBER,        --수정할 항목
    pnum VARCHAR2,       --수정할 회사번호
    pdata VARCHAR2,     --수정할 정보
    presult OUT VARCHAR2      --피드백
)
IS 
BEGIN
    DBMS_OUTPUT.PUT_LINE('────────────────────── 회사 정보 수정 ──────────────────────');
    IF pseq = 1 THEN
        UPDATE tblcompany
        SET companyname = pdata
        WHERE companyNum = pnum;
    ELSIF pseq = 2 THEN
        UPDATE tblcompany
        SET companyType = pdata
        WHERE companyNum = pnum;
    ELSIF pseq = 3 THEN
        UPDATE tblcompany
        SET companySize = pdata
        WHERE companyNum = pnum;
    ELSIF pseq = 4 THEN
        UPDATE tblcompany
        SET averageSalary = TO_NUMBER(pdata)
        WHERE companyNum = pnum;
    ELSIF pseq = 5 THEN
        UPDATE tblcompany
        SET companyLocation = pdata
        WHERE companyNum = pnum;
    ELSIF pseq = 6 THEN
        UPDATE tblcompany
        SET ISConnection = TO_NUMBER(pdata)
        WHERE companyNum = pnum;
    ELSE
        raISe_application_error(-20001, '올바른 수정항목을 선택해주세요.');
    END IF;

    presult := '수정 성공했습니다.';   --성공
EXCEPTION
    WHEN OTHERS THEN
        presult := '수정 실패했습니다.';   --실패
END procUpdateCom;
/

DECLARE
    vresult VARCHAR2(30);
BEGIN
    --procUpdateCom(<수정할 항목>, <수정할 회사번호>, <수정할 내용>);
    --1. 회사명 2. 회사형태 3. 회사규모 4. 평균급여 5. 회사위치 6. 연계회사여부
    procUpdateCom(2, '43', '대기업', vresult);
    DBMS_OUTPUT.PUT_LINE(vresult);
END;
/


--수정(연계 회사 조건)
CREATE OR REPLACE PROCEDURE procUpdaterequirement(
    prequirementNum VARCHAR2,
    pscore NUMBER,
    psubjectnum VARCHAR2, 
    presult OUT VARCHAR2      --피드백
)
IS 
BEGIN
    
    UPDATE tblrequirement
    set score = pscore , subjectnum = psubjectnum
    WHERE requirementNum = prequirementNum;
    
    presult := '수정 성공했습니다.';   --성공
EXCEPTION
    WHEN OTHERS THEN
        presult := '수정 실패했습니다.';   --실패
END procUpdaterequirement;
/

DECLARE
    vresult VARCHAR2(30);
BEGIN
    procUpdaterequirement('10',100,'10', vresult);
    DBMS_OUTPUT.PUT_LINE(vresult);
END;
/



-------------------------------B08-01. 교육생 면접 및 선발 관리
--1. 면접에 지원한 지원생들의 이름, 주민등록번호, 전화번호, 면접 예정일을 등록한다.
--[프로시저 생성]
CREATE OR REPLACE PROCEDURE procAddInterviewer(
	pname VARCHAR2,
	pssn VARCHAR2,
	ptel VARCHAR2,
	pdate DATE
)
IS
BEGIN
	INSERT INTO tblInterviewer (interviewerNum,interviewerName,interviewerSsn,interviewerTel,interviewerDate,isPass)
			VALUES ((SELECT NVL(MAX(LPAD(interviewerNum, 5, '0')), 0) + 1 FROM tblInterviewer), pname, pssn, ptel, pdate, null);
EXCEPTION
	WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('생성에 실패했습니다.');
END procAddInterviewer;

--[프로시저 실행]
﻿BEGIN
	procAddInterviewer('테스트','201225-2030405','010-1234-5678', '2023-09-17');
END;

--[실행 확인]
SELECT * FROM tblinterviewer;


--2. 면접 진행 후, 지원생들의 면접 합격 여부를 입력하여 교육생을 선발한다.
--• 면접에 합격한 학생에 한하여 교육생 등록 여부 리스트에 등록된다.
--[프로시저 생성]
CREATE OR REPLACE PROCEDURE procInterviewResult(
    pnum NUMBER, --교육생 면접번호
    pisPass NUMBER --합격여부
)
IS
BEGIN
	IF pisPass = 0 OR pisPass = 1 THEN 
        UPDATE tblInterviewer SET isPass = pisPass WHERE interviewerNum = pnum;
        
        IF pisPass = 1 THEN
            INSERT INTO tblInterviewRegister (interviewRegiNum,interviewerNum,isEnrollment)
                        VALUES ((SELECT NVL(MAX(LPAD(interviewRegiNum, 5, '0')), 0) + 1 FROM tblInterviewRegister),pnum,default);
        END IF;
	ELSE
		DBMS_OUTPUT.PUT_LINE('합불여부는 1(합격) 또는 0(불합격)으로만 입력 가능합니다.');
	END IF;
EXCEPTION
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('등록에 실패했습니다.');
END;

--[프로시저 실행] 1
BEGIN
--	procInterviewResult(657,1); --657, 1
    procInterviewResult(655,0); --655, 0
END;

--[실행 확인]
SELECT * FROM tblInterviewer; --657 면접번호(테스트), 655
SELECT * FROM tblInterviewRegister; --515 교육생등록여부번호

--[프로시저 실행] 2
﻿BEGIN
--	procInterviewResult(656,3); -- 면접번호: 656, PASS여부: 3(→ 오입력)
    procInterviewResult(656,1); --656, 1
END;

﻿SELECT * FROM tblinterviewer; --656 면접번호
SELECT * FROM tblInterviewRegister; --면접 합격 처리 시 교육생 등록여부 테이블에 입력됨을 확인 가능


﻿-- [프로시저내에서 사용할 저장 함수 생성 > ‘교육생 면접번호’를 입력받아 ‘교육생 등록여부 번호’를 반환]
CREATE OR REPLACE FUNCTION fnGetInterviewRegiNum(
	pnum NUMBER --교육생 면접번호
) RETURN number --교육생 등록여부번호 반환
IS
	vnum NUMBER;
BEGIN
	SELECT interviewRegiNum INTO vnum FROM tblInterviewRegister WHERE interviewerNum = pnum;
	RETURN vnum;
END fnGetInterviewRegiNum;

-- [프로시저 생성]
CREATE OR REPLACE PROCEDURE procAddStudent(
	pnum NUMBER, --교육생 면접번호
	pcnum NUMBER --과정상세번호
)
IS
BEGIN
	UPDATE tblInterviewRegister set isEnrollment = 1 WHERE interviewerNum = pnum;
	INSERT INTO tblStudent (studentNum,interviewRegiNum,registrationDate,signUpCnt,courseDetailNum)
			VALUES (seqStudent.nextVal,fnGetInterviewRegiNum(pnum), sysdate, 1, pcnum);
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('등록에 실패했습니다.');
END;

﻿BEGIN
	procAddStudent(656, 20); --교육생 면접번호(656), 과정 상세번호(20)
END;

﻿SELECT * FROM tblStudent;
SELECT * FROM tblInterviewRegister; --등록여부 변경 확인 가능



-------------------------------B09-01. 교사 평가 항목 등록 및 관리
--관리자 (평가 항목 등록)
CREATE OR REPLACE PROCEDURE procAddEstimateItem(
	pestimateIndex VARCHAR2,
    presult OUT VARCHAR2
)
IS
BEGIN
    
    INSERT INTO tblEstimate(estimateNum, estimateIndex) 
        VALUES ((SELECT NVL(MAX(LPAD(estimateNum, 5, '0')), 0) + 1 FROM tblEstimate), pestimateIndex);
    
	presult := '정상적으로 등록하였습니다.';
    
EXCEPTION
	WHEN OTHERS THEN
		presult := '등록을 실패하였습니다.'; --실패    

END procAddEstimateItem;

--실행
DECLARE
	vresult VARCHAR2(300);
BEGIN
	procAddEstimateItem('교사는 교육생을 올바르게 지도하였다.', vresult);
	DBMS_OUTPUT.PUT_LINE(vresult);
END;

													
--관리자 (평가 항목 수정)
CREATE OR REPLACE PROCEDURE procUpdateEstimateItem(
	pestimateIndex VARCHAR2,
    pestimateNum VARCHAR2,
    presult OUT VARCHAR2
)
IS
BEGIN
    
	UPDATE tblEstimate SET estimateIndex = pestimateIndex WHERE estimateNum = pestimateNum;    
    
	presult := '정상적으로 수정하였습니다.';
    
EXCEPTION
	WHEN OTHERS THEN
		presult := '수정을 실패하였습니다.'; --실패    

END procUpdateEstimateItem;

--실행
DECLARE
	vresult VARCHAR2(300);
BEGIN
	procUpdateEstimateItem('교사는 교육생을 올바르게 지도했다.', '16', vresult);
	DBMS_OUTPUT.PUT_LINE(vresult);
END;


--관리자 (평가 항목 삭제)
CREATE OR REPLACE PROCEDURE procDeleteEstimateItem(
    pestimateNum VARCHAR2,
    presult OUT VARCHAR2
)
IS
BEGIN
    
	DELETE FROM tblEstimate WHERE estimateNum = pestimateNum;    
    
	presult := '정상적으로 삭제하였습니다.';
    
EXCEPTION
	WHEN OTHERS THEN
		presult := '삭제를 실패하였습니다.'; --실패    

END procDeleteEstimateItem;

--실행
DECLARE
	vresult VARCHAR2(300);
BEGIN
	procDeleteEstimateItem('16', vresult);
	DBMS_OUTPUT.PUT_LINE(vresult);
END;


--관리자 (평가 항목 조회)
CREATE OR REPLACE PROCEDURE procSelectEstimateItem
IS
pestimateNum tblEstimate.estimateNum%TYPE;
pestimateIndex tblEstimate.estimateIndex%TYPE;
CURSOR vcursor IS

    SELECT estimateNum AS "평가 번호",
           estimateIndex AS "평가 항목"
    FROM tblEstimate;
 
BEGIN
    OPEN vcursor;
        LOOP
            FETCH vcursor INTO pestimateNum, pestimateIndex;
        EXIT WHEN vcursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(pestimateNum || '. ' || pestimateIndex);     

        END LOOP;
    CLOSE vcursor;

END;

--실행
BEGIN
    procSelectEstimateItem;
END;


--관리자 (교사 평가 삭제)
CREATE OR REPLACE PROCEDURE procDeleteTeacherEstimateItem(
    pteacherEstiNum VARCHAR2,
    presult OUT VARCHAR2
)
IS
BEGIN
    
	DELETE FROM tblTeacherEstimate WHERE teacherEstiNum = pteacherEstiNum;    
    
	presult := '정상적으로 삭제하였습니다.';
    
EXCEPTION
	WHEN OTHERS THEN
		presult := '삭제를 실패하였습니다.'; --실패    

END procDeleteTeacherEstimateItem;

--실행
DECLARE
	vresult VARCHAR2(300);
BEGIN
	procDeleteTeacherEstimateItem('1', vresult);
	DBMS_OUTPUT.PUT_LINE(vresult);
END;


--관리자 (교사 평가 조회(교사 별))
CREATE OR REPLACE PROCEDURE procAdminSelectByTeacher
IS

pcourseName tblCourse.courseName%TYPE;
pteacherName tblTeacher.teacherName%TYPE;
pestimateIndex tblEstimate.estimateIndex%TYPE;
pestimateScore tblTeacherEstimate.estimateScore%TYPE;

CURSOR vcursor IS

	SELECT c.courseName AS "과정명",
		   t.teacherName AS "교사이름",
		   e.estimateIndex AS "평가항목",
		   sum(te.estimateScore) AS "총 점수" 
	FROM tblTeacherEstimate te
		INNER JOIN tblEstimate e
			ON e.estimateNum = te.estimateNum
				INNER JOIN tblStudent s
					ON s.studentNum = te.studentNum
						INNER JOIN tblCourseDetail cd
							ON cd.courseDetailNum = s.courseDetailNum
								INNER JOIN tblTeacher t
									ON t.teacherNum = cd.teacherNum
										INNER JOIN tblCourse c
											ON c.courseNum = cd.courseNum
												GROUP BY c.courseName, t.teacherName, e.estimateIndex
													ORDER BY t.teacherName;

BEGIN
    DBMS_OUTPUT.PUT_LINE('────────────────────── 교사별 평가 조회 ──────────────────────');
    OPEN vcursor;
        LOOP
            FETCH vcursor INTO pcourseName, pteacherName, pestimateIndex, pestimateScore;
        EXIT WHEN vcursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('과정명: ' || pcourseName);
        DBMS_OUTPUT.PUT_LINE('교사이름: ' || pteacherName);        
        DBMS_OUTPUT.PUT_LINE('평가항목: ' || pestimateIndex);
        DBMS_OUTPUT.PUT_LINE('총 점수: ' || pestimateScore);        
        DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────────');
        END LOOP;
    CLOSE vcursor;

END;
										
BEGIN
    procAdminSelectByTeacher;
END;


--관리자 (교사 평가 조회(특정 교육생))
CREATE OR REPLACE PROCEDURE procAdminSelectPickStudent(
    vstudentNum VARCHAR2
)
IS

pcourseName tblCourse.courseName%TYPE;
pteacherName tblTeacher.teacherName%TYPE;
pestimateIndex tblEstimate.estimateIndex%TYPE;
pestimateScore tblTeacherEstimate.estimateScore%TYPE;

CURSOR vcursor IS

	SELECT c.courseName AS "과정명",
		   t.teacherName AS "교사이름",
		   e.estimateIndex AS "평가항목",
		   te.estimateScore AS "평가점수" 
	FROM tblTeacherEstimate te
		INNER JOIN tblStudent s
			ON s.studentNum = te.studentNum
				INNER JOIN tblCourseDetail cd
					ON cd.courseDetailNum = s.courseDetailNum
						INNER JOIN tblTeacher t
							ON t.teacherNum = cd.teacherNum
								INNER JOIN tblEstimate e
									ON e.estimateNum = te.estimateNum
										INNER JOIN tblCourse c
											ON c.courseNum = cd.courseNum
												WHERE te.studentNum = vstudentNum;	

BEGIN
    OPEN vcursor;
   		DBMS_OUTPUT.PUT_LINE('──────────────── 특정 교육생의 교사 평가 조회 ────────────────');
        LOOP
            FETCH vcursor INTO pcourseName, pteacherName, pestimateIndex, pestimateScore;
        EXIT WHEN vcursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('과정명: ' || pcourseName);
        DBMS_OUTPUT.PUT_LINE('교사이름: ' || pteacherName);        
        DBMS_OUTPUT.PUT_LINE('평가항목: ' || pestimateIndex);
        DBMS_OUTPUT.PUT_LINE('총 점수: ' || pestimateScore);        
        DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────────');
        END LOOP;
    CLOSE vcursor;

END;
					
BEGIN
    procAdminSelectPickStudent('1');
END;



-------------------------------B10-01. 질의응답 관리
--질의 관리 (수정)
CREATE OR REPLACE PROCEDURE procAdminUpdateQuestion(
	pquestionContent VARCHAR2,
    pquestionNum VARCHAR2,
    presult OUT VARCHAR2
)
IS
BEGIN

    UPDATE tblQuestion SET questionContent = pquestionContent WHERE questionNum = pquestionNum;
    
	presult := '정상적으로 수정하였습니다.';
    
EXCEPTION
	WHEN OTHERS THEN
		presult := '수정을 실패하였습니다.'; --실패    

END procAdminUpdateQuestion;

--실행
DECLARE
	vresult VARCHAR2(300);
BEGIN
	procAdminUpdateQuestion('잘 모르겠어요.', '30', vresult);
	DBMS_OUTPUT.PUT_LINE(vresult);
END;

					
--질의 관리 (삭제)
CREATE OR REPLACE PROCEDURE procAdminDeleteQuestion(
	pquestionNum VARCHAR2,
    presult OUT VARCHAR2
)
IS
BEGIN

    DELETE FROM tblAnswer WHERE questionNum = pquestionNum;
	DELETE FROM tblQuestion WHERE questionNum = pquestionNum;
    
	presult := '정상적으로 삭제하였습니다.';
    
EXCEPTION
	WHEN OTHERS THEN
		presult := '삭제를 실패하였습니다.'; --실패    

END procAdminDeleteQuestion;

--실행
DECLARE
	vresult VARCHAR2(300);
BEGIN
	procAdminDeleteQuestion('31', vresult);
	DBMS_OUTPUT.PUT_LINE(vresult);
END;								

	
--응답 관리 (수정)
CREATE OR REPLACE PROCEDURE procAdminUpdateAnswer(
	panswerContent VARCHAR2,
    panswerNum VARCHAR2,
    presult OUT VARCHAR2
)
IS
BEGIN

    UPDATE tblAnswer SET answerContent = panswerContent WHERE answerNum = panswerNum;
	presult := '정상적으로 수정하였습니다.';
    
EXCEPTION
	WHEN OTHERS THEN
		presult := '수정을 실패하였습니다.'; --실패    

END procAdminUpdateAnswer;

--실행
DECLARE
	vresult VARCHAR2(300);
BEGIN
	procAdminUpdateAnswer('잘 모르겠어요;;', '30', vresult);
	DBMS_OUTPUT.PUT_LINE(vresult);
END;


--응답 관리 (삭제)
CREATE OR REPLACE PROCEDURE procAdminDeleteAnswer(
	panswerNum VARCHAR2,
    presult OUT VARCHAR2
)
IS
BEGIN

	DELETE FROM tblAnswer WHERE answerNum = panswerNum;    
    presult := '정상적으로 삭제하였습니다.';
    
EXCEPTION
	WHEN OTHERS THEN
		presult := '삭제를 실패하였습니다.'; --실패    

END procAdminDeleteAnswer;

--실행
DECLARE
	vresult VARCHAR2(300);
BEGIN
	procAdminDeleteAnswer('30', vresult);
	DBMS_OUTPUT.PUT_LINE(vresult);
END;



-------------------------------B11-01. 우수 교육생 조회
--1. 성적이 우수한 학생은 성적 우수 학생으로 선정한다.
--﻿• 우수 교육생 및 개근 학생의 선정은 과정의 모든 과목이 끝나고 수료 여부가 결정된 후 선정한다.
--• 우수 교육생은 과정별로 선정한다.
--• 성적이 우수한 학생은 과정에 속한 각 과목의 시험 점수 합계가 가장 높은 학생으로 정의한다.
----------------------------------------------------- [특정 과정의 성적 우수 학생 선정] ------------------------------------------------------------------------------
-- [프로시저 생성]
/
CREATE OR REPLACE PROCEDURE procAddToSPrize(
    pnum NUMBER --과정 상세 번호
)
IS
    vcursor sys_refcursor; --SELECT절에서 나온 1명 이상의 교육생 번호를 담을 커서
    vnum NUMBER; --커서에서 나온 성적 우수 교육생 번호를 담을 변수
    vcnt NUMBER; --기생성 내역을 확인할 카운트 변수
BEGIN
    OPEN vcursor
    FOR
    SELECT
        studentNum 
      FROM (SELECT 
                A.*, RANK() OVER(ORDER BY totalScore DESC) AS RK
              FROM (SELECT 
                        ts.studentNum,
                        SUM((ts.attendanceScore * (t.attendancePoint / 100)) + (ts.writtenScore * (t.writtenPoint / 100)) + (ts.practicalScore * (t.practicalPoint / 100))) AS totalScore,
                        COUNT(*) AS subjectCnt
                      FROM tblCourseDetail cd
                           INNER JOIN tblSubjectDetail sd 
                                   ON cd.courseDetailNum = sd.courseDetailNum
                           INNER JOIN tblTest t 
                                   ON sd.subjectDetailNum = t.subjectDetailNum
                           INNER JOIN tblTestScore ts 
                                   ON t.testNum = ts.testNum
                      WHERE cd.courseDetailNum = pnum
                        AND EXISTS (SELECT 'Y' FROM tblComplete c WHERE ts.studentNum = c.studentNum)
                        AND NOT EXISTS (SELECT 'Y' FROM tblFail f WHERE ts.studentNum = f.studentNum)
--                        AND NOT EXISTS (SELECT 'Y' FROM tblPrize p WHERE ts.studentNum = p.studentNum AND p.prizeCategory = '성적우수')
                    GROUP BY ts.studentNum)A)
    WHERE RK = 1
      AND subjectCnt = (SELECT subjectAmount FROM tblCourseDetail WHERE courseDetailNum = pnum);
     LOOP
        FETCH vcursor INTO vnum;
        EXIT WHEN vcursor%NOTFOUND;
        
        -- 이미 생성된 과정의 우수 교육생은 중복으로 들어가지 않도록 하는 장치 만들기
        SELECT COUNT(*) INTO vcnt FROM tblPrize WHERE studentNum = vnum AND prizeCategory = '성적우수';
        
        IF vcnt > 0 THEN
            DBMS_OUTPUT.PUT_LINE('해당 과정의 우수 교육생 생성 내역이 이미 존재합니다.');
            
        ELSE
            INSERT INTO tblPrize (prizeNum, studentNum, prizeCategory)  VALUES ((select nvl(max(lpad(prizeNum, 5, '0')), 0) + 1 from tblPrize), vnum, '성적우수');
        END IF;
      END LOOP;
    CLOSE vcursor;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('생성에 실패했습니다.');
END procAddToSPrize; --과정 상세 번호
/

-- [프로시저 실행]
/
BEGIN
    procAddToSPrize(1);
END;
/


-- [프로시저 실행 확인]
SELECT * FROM tblPrize order by TO_NUMBER(prizeNum);
DELETE FROM tblPrize;
SET SERVEROUTPUT ON;

		
--2. 출결이 우수한 학생은 개근 학생으로 선정한다.
--• 출결이 우수한 학생은 주말, 공휴일을 제외한 정상 수업일에 모두 출석하고, 지각, 조퇴, 외출 등의 이력이 없는 학생으로 정의한다.  
--• 우수 교육생 및 개근 학생의 선정은 과정의 모든 과목이 끝나고 수료 여부가 결정된 후 선정한다.
--• 우수 교육생은 과정별로 선정한다.
----------------------------------------------------- [특정 과정의 개근 학생 선정] ------------------------------------------------------------------------------
-- [프로시저 생성]
/
CREATE OR REPLACE PROCEDURE procAddToAPrize(
    pnum NUMBER --과정 상세 번호
)
IS
    vcursor sys_refcursor;
    vnum NUMBER;
    vcnt NUMBER; --기생성 내역을 확인할 카운트 변수
    vflag NUMBER := 0; --다수의 기생성 내역 에러 메세지를 1번만 출력하게끔 만드는 장치 역할 변수
BEGIN
    OPEN vcursor
    FOR
    SELECT studentNum
      FROM (SELECT s.studentNum
                  , COUNT(*) AS cnt
                  , RANK() OVER(ORDER BY COUNT(*) DESC) AS RK
              FROM tblStudent s
                   INNER JOIN tblStudentAttendance sa
                           ON s.studentNum = sa.studentNum
             WHERE s.courseDetailNum = pnum
               AND EXISTS (
                        SELECT 'Y'
                        FROM tblComplete c
                        WHERE s.studentNum = c.studentNum
                    )
                    AND NOT EXISTS (
                        SELECT 'Y'
                        FROM tblFail f
                        WHERE s.studentNum = f.studentNum
                    )
                    AND NOT EXISTS (
                        SELECT 'Y'
                        FROM tblAttendanceApply aa
                        WHERE s.studentNum = aa.STUDENTNUM
                        AND sa.attendanceDate = aa.applyDate
                    )
                    AND NOT EXISTS (
                        SELECT 'Y'
                        FROM tblHoliday h
                        WHERE h.holiday = sa.attendanceDate
                    )
        GROUP BY s.studentNum)
    WHERE RK = 1;
    
    LOOP
        FETCH vcursor INTO vnum;
        EXIT WHEN vcursor%NOTFOUND;
        
        -- 이미 생성된 과정의 우수 교육생은 중복으로 들어가지 않도록 하는 장치 만들기
        SELECT COUNT(*) INTO vcnt FROM tblPrize WHERE studentNum = vnum AND prizeCategory = '개근';
        
        IF vcnt > 0 THEN
            
            IF vflag = 0 THEN
                DBMS_OUTPUT.PUT_LINE('해당 과정의 우수 교육생 생성 내역이 이미 존재합니다.');
                vflag := 1;
            END IF;
        ELSE
            INSERT INTO tblPrize (prizeNum, studentNum, prizeCategory)  VALUES ((select nvl(max(lpad(prizeNum, 5, '0')), 0) + 1 from tblPrize), vnum, '개근');
        END IF;

    END LOOP;
    CLOSE vcursor;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('생성에 실패했습니다.');
END procAddToAPrize;
/

-- [프로시저 실행]
/
BEGIN
    procAddToAPrize(1);
END;
/

-- [프로시저 실행 확인]
SELECT * FROM tblPrize order by TO_NUMBER(prizeNum);
DELETE FROM tblPrize;

--3. 성적 우수 학생, 개근 학생 각 항목별로 과정 상세 번호를 입력 시 우수 교육생 명단 및 해당 교육생의 정보(교육생 번호, 교육생 이름, 수강 과정) 조회가 가능하다.                                       
--관리자 기능
----------------------------------------------------- [특정 과정의 성적 우수 학생 조회] ------------------------------------------------------------------------------
-- [프로시저 생성]
/
CREATE OR REPLACE PROCEDURE procReadBestS(
    pnum NUMBER --과정 상세 번호
)
IS
    vcnt NUMBER; --해당 개설 과정의 번호가 '상' 테이블에 존재하는 개수를 담는 변수
BEGIN

     SELECT
        count(*) 
       INTO vcnt
       FROM tblPrize p
            INNER JOIN tblStudent s
                    ON s.studentNum = p.studentNum
      WHERE s.courseDetailNum = pnum;
        
    DBMS_OUTPUT.PUT_LINE('──────────────────── 우수 교육생 조회 ─────────────────────');
    
    IF vcnt > 0 THEN --입력한 과정 상세 번호와 일치하는 레코드가 '상' 테이블에 있을 경우 내역 출력
        
        FOR best IN (
          SELECT
                vs.studentNum AS "교육생 번호",
                vs.studentName AS "교육생 이름",
                cs.courseName AS 과정명,
                cs.courseStartDate AS "과정 시작일",
                cs.courseEndDate AS "과정 종료일",
                p.prizeCategory AS 부문
            FROM tblPrize p
                INNER JOIN vwStudent vs
                    ON vs.studentNum = p.studentNum
                INNER JOIN vwCompletionStatus cs
                    ON cs.studentNum = vs.studentNum
           WHERE cs.courseDetailNum = pnum
             AND p.prizeCategory = '성적우수'
           ORDER BY TO_NUMBER("교육생 번호") ASC
        )
        LOOP
            DBMS_OUTPUT.PUT_LINE('부문: ' || best.부문);
            DBMS_OUTPUT.PUT_LINE('교육생 번호: ' || best."교육생 번호");
            DBMS_OUTPUT.PUT_LINE('교육생 이름: ' || best."교육생 이름");
            DBMS_OUTPUT.PUT_LINE('과정명: ' || best.과정명);
            DBMS_OUTPUT.PUT_LINE('과정 시작일: ' || best."과정 시작일");
            DBMS_OUTPUT.PUT_LINE('과정 종료일: ' || best."과정 종료일");
            DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────');
        END LOOP;
    ELSE --'상' 테이블에 입력한 과정 상세 번호와 일치하는 레코드가 존재하지 않을 경우 하기 문구 출력
        DBMS_OUTPUT.PUT_LINE('해당 내역이 존재하지 않습니다.');
        DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('우수 교육생 조회에 실패했습니다.');
--        RAISE_APPLICATION_ERROR(-10001, '우수 교육생 조회에 실패했습니다.');
END procReadBestS;
/

-- [프로시저 실행]
/
BEGIN
    procReadBestS(4); --과정 상세 번호
END;
/

----------------------------------------------------- [특정 과정의 개근 학생 조회] ------------------------------------------------------------------------------
-- [프로시저 생성]
/
CREATE OR REPLACE PROCEDURE procReadBestA(
    pnum NUMBER --과정 상세 번호
)
IS
    vcnt NUMBER; --해당 개설 과정의 번호가 '상' 테이블에 존재하는 개수를 담는 변수
BEGIN

     SELECT
        count(*) 
       INTO vcnt
       FROM tblPrize p
            INNER JOIN tblStudent s
                    ON s.studentNum = p.studentNum
      WHERE s.courseDetailNum = pnum;
        
    DBMS_OUTPUT.PUT_LINE('──────────────────── 우수 교육생 조회 ─────────────────────');
    
    IF vcnt > 0 THEN --입력한 과정 상세 번호와 일치하는 레코드가 '상' 테이블에 있을 경우 내역 출력
        
        FOR best IN (
          SELECT
                vs.studentNum AS "교육생 번호",
                vs.studentName AS "교육생 이름",
                cs.courseName AS 과정명,
                cs.courseStartDate AS "과정 시작일",
                cs.courseEndDate AS "과정 종료일",
                p.prizeCategory AS 부문
            FROM tblPrize p
                INNER JOIN vwStudent vs
                    ON vs.studentNum = p.studentNum
                INNER JOIN vwCompletionStatus cs
                    ON cs.studentNum = vs.studentNum
           WHERE cs.courseDetailNum = pnum
             AND p.prizeCategory = '개근'
           ORDER BY TO_NUMBER("교육생 번호") ASC
        )
        LOOP
            DBMS_OUTPUT.PUT_LINE('부문: ' || best.부문);
            DBMS_OUTPUT.PUT_LINE('교육생 번호: ' || best."교육생 번호");
            DBMS_OUTPUT.PUT_LINE('교육생 이름: ' || best."교육생 이름");
            DBMS_OUTPUT.PUT_LINE('과정명: ' || best.과정명);
            DBMS_OUTPUT.PUT_LINE('과정 시작일: ' || best."과정 시작일");
            DBMS_OUTPUT.PUT_LINE('과정 종료일: ' || best."과정 종료일");
            DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────');
        END LOOP;
    ELSE --'상' 테이블에 입력한 과정 상세 번호와 일치하는 레코드가 존재하지 않을 경우 하기 문구 출력
        DBMS_OUTPUT.PUT_LINE('해당 내역이 존재하지 않습니다.');
        DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('우수 교육생 조회에 실패했습니다.');
--        RAISE_APPLICATION_ERROR(-10001, '우수 교육생 조회에 실패했습니다.');
END procReadBestA;
/

-- [프로시저 실행]
/
BEGIN
    procReadBestA(1); --과정 상세 번호
END;
/



-------------------------------B12-01. 취업명단 관리
--취업명단 관리 (등록)
CREATE OR REPLACE PROCEDURE procAddJob(
    pstudentNum VARCHAR2,
    pcompanyNum VARCHAR2,
    pjobDate VARCHAR2,
    psalary VARCHAR2,
    presult OUT VARCHAR2
)
IS
BEGIN

	INSERT INTO tblJob(jobNum, studentNum, companyNum, jobDate, salary)
		VALUES ((SELECT NVL(MAX(LPAD(jobNum, 5, '0')), 0) + 1 FROM tblJob), pstudentNum, pcompanyNum, pjobDate, psalary);    
    
	presult := '정상적으로 등록하였습니다.';
    
EXCEPTION
	WHEN OTHERS THEN
		presult := '등록을 실패하였습니다.'; --실패    

END procAddJob;

--실행
DECLARE
	vresult VARCHAR2(300);
BEGIN
	procAddJob('323', '10', '2023-09-16', '33000000', vresult);
	DBMS_OUTPUT.PUT_LINE(vresult);
END;


--취업명단 관리 (수정)
CREATE OR REPLACE PROCEDURE procUpdateJob(
    psel VARCHAR2,
	pjobNum VARCHAR2,
    pchangeJob VARCHAR2,
    presult OUT VARCHAR2
)
IS
BEGIN
    
    IF psel = 1 THEN
        UPDATE tblJob SET companyNum = pchangeJob WHERE jobNum = pjobNum;
    ELSIF psel = 2 THEN    
        UPDATE tblJob SET jobDate = pchangeJob WHERE jobNum = pjobNum;
    ELSIF psel = 3 THEN
        UPDATE tblJob SET salary = pchangeJob WHERE jobNum = pjobNum;
    END IF;
    
	presult := '정상적으로 수정하였습니다.';
    
EXCEPTION
	WHEN OTHERS THEN
		presult := '수정을 실패하였습니다.'; --실패    

END procUpdateJob;

--실행
DECLARE
	vresult VARCHAR2(300);
BEGIN
	procUpdateJob(1, '634', '11', vresult);
	DBMS_OUTPUT.PUT_LINE(vresult);
END;

--실행
DECLARE
	vresult VARCHAR2(300);
BEGIN
	procUpdateJob(2, '634', '2023-09-17', vresult);
	DBMS_OUTPUT.PUT_LINE(vresult);
END;

--실행
DECLARE
	vresult VARCHAR2(300);
BEGIN
	procUpdateJob(3, '634', '34000000', vresult);
	DBMS_OUTPUT.PUT_LINE(vresult);
END;


--취업명단 관리 (삭제)
CREATE OR REPLACE PROCEDURE procDeleteJob(
	pjobNum VARCHAR2,
    presult OUT VARCHAR2
)
IS
BEGIN
    
	DELETE FROM tblJob WHERE jobNum = pjobNum;
    
	presult := '정상적으로 삭제하였습니다.';
    
EXCEPTION
	WHEN OTHERS THEN
		presult := '삭제를 실패하였습니다.'; --실패    

END procDeleteJob;

--실행
DECLARE
	vresult VARCHAR2(300);
BEGIN
	procDeleteJob('634', vresult);
	DBMS_OUTPUT.PUT_LINE(vresult);
END;


--취업명단 관리 (조회)
CREATE OR REPLACE PROCEDURE procSelectJob
IS

pinterviewerName tblInterviewer.interviewerName%TYPE;
pcourseName tblCourse.courseName%TYPE;
pteacherName tblTeacher.teacherName%TYPE;
pinterviewerSsn tblInterviewer.interviewerSsn%TYPE;
pcompanyName tblCompany.companyName%TYPE;
psalary tblJob.salary%TYPE;
pjobDate tblJob.jobDate%TYPE;
pcompanyLocation tblCompany.companyLocation%TYPE;
pcompanyType tblCompany.companyType%TYPE;
pcompanySize tblCompany.companySize%TYPE;

CURSOR vcursor IS

	SELECT i.interviewerName AS "교육생 이름",
		   c.courseName AS "과정명",
		   t.teacherName AS "교사명",
		   i.interviewerSsn AS "주민등록번호",
		   co.companyName AS "회사명",
		   j.salary AS "연봉",
		   j.jobDate AS "취업일",
		   co.companyLocation AS "회사 주소",
		   co.companyType AS "회사형태",
		   co.companySize AS "회사규모"
	FROM tblJob j
		INNER JOIN tblStudent s
			ON s.studentNum = j.studentNum
				INNER JOIN tblInterviewRegISter ir
					ON ir.interviewReginum = s.interviewReginum
						INNER JOIN tblInterviewer i
							ON i.interviewerNum = ir.interviewerNum
								INNER JOIN tblCourseDetail cd
									ON cd.courseDetailNum = s.courseDetailNum
										INNER JOIN tblCourse c
											ON c.courseNum = cd.courseNum
												INNER JOIN tblTeacher t
													ON t.teacherNum = cd.teacherNum
														INNER JOIN tblCompany co
															ON co.companyNum = j.companyNum
																ORDER BY i.interviewerName ASC;

BEGIN
    OPEN vcursor;
		DBMS_OUTPUT.PUT_LINE('─────────────────────── 취업 명단 조회 ───────────────────────');
        LOOP
            FETCH vcursor INTO pinterviewerName, pcourseName, pteacherName, pinterviewerSsn, pcompanyName, psalary, pjobDate, pcompanyLocation, pcompanyType, pcompanySize;
        EXIT WHEN vcursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('교육생 이름: ' || pinterviewerName);
        DBMS_OUTPUT.PUT_LINE('과정명: ' || pcourseName);        
        DBMS_OUTPUT.PUT_LINE('교사명: ' || pteacherName);
        DBMS_OUTPUT.PUT_LINE('주민등록번호: ' || pinterviewerSsn);  
        DBMS_OUTPUT.PUT_LINE('회사명: ' || pcompanyName);  
        DBMS_OUTPUT.PUT_LINE('연봉: ' || psalary);  
        DBMS_OUTPUT.PUT_LINE('취업일: ' || pjobDate);  
        DBMS_OUTPUT.PUT_LINE('회사 주소: ' || pcompanyLocation);  
        DBMS_OUTPUT.PUT_LINE('회사형태: ' || pcompanyType);  
        DBMS_OUTPUT.PUT_LINE('회사규모: ' || pcompanySize);  
        DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────────');
        END LOOP;
    CLOSE vcursor;

END;

BEGIN
    procSelectJob;
END;


--취업명단 관리 (특정 교육생 조회)
CREATE OR REPLACE PROCEDURE procSelectJobPickStudent(
    vstudentNum VARCHAR2
)
IS

pinterviewerName tblInterviewer.interviewerName%TYPE;
pcourseName tblCourse.courseName%TYPE;
pteacherName tblTeacher.teacherName%TYPE;
pinterviewerSsn tblInterviewer.interviewerSsn%TYPE;
pcompanyName tblCompany.companyName%TYPE;
psalary tblJob.salary%TYPE;
pjobDate tblJob.jobDate%TYPE;
pcompanyLocation tblCompany.companyLocation%TYPE;
pcompanyType tblCompany.companyType%TYPE;
pcompanySize tblCompany.companySize%TYPE;

CURSOR vcursor IS


	SELECT i.interviewerName AS "교육생 이름",
		   c.courseName AS "과정명",
		   t.teacherName AS "교사명",
		   i.interviewerSsn AS "주민등록번호",
		   co.companyName AS "회사명",
		   j.salary AS "연봉",
		   j.jobdate AS "취업일",
		   co.companylocation AS "회사 주소",
		   co.companyTYPE AS "회사형태",
		   co.companysize AS "회사규모"
	FROM tblJob j
		INNER JOIN tblStudent s
			ON s.studentNum = j.studentNum
				INNER JOIN tblInterviewRegISter ir
					ON ir.interviewReginum = s.interviewReginum
						INNER JOIN tblInterviewer i
							ON i.interviewerNum = ir.interviewerNum
								INNER JOIN tblCourseDetail cd
									ON cd.courseDetailNum = s.courseDetailNum
										INNER JOIN tblCourse c
											ON c.courseNum = cd.courseNum
												INNER JOIN tblTeacher t
													ON t.teacherNum = cd.teacherNum
														INNER JOIN tblCompany co
															ON co.companyNum = j.companyNum
																WHERE s.studentnum = vstudentNum
																ORDER BY i.interviewerName ASC;		

BEGIN
    OPEN vcursor;
        LOOP
            FETCH vcursor INTO pinterviewerName, pcourseName, pteacherName, pinterviewerSsn, pcompanyName, psalary, pjobDate, pcompanyLocation, pcompanyType, pcompanySize;
        EXIT WHEN vcursor%NOTFOUND;
   		DBMS_OUTPUT.PUT_LINE('───────────────────── ' || pinterviewerName || ' 교육생 조회 ─────────────────────');
        DBMS_OUTPUT.PUT_LINE('교육생 이름: ' || pinterviewerName);
        DBMS_OUTPUT.PUT_LINE('과정명: ' || pcourseName);        
        DBMS_OUTPUT.PUT_LINE('교사명: ' || pteacherName);
        DBMS_OUTPUT.PUT_LINE('주민등록번호: ' || pinterviewerSsn);  
        DBMS_OUTPUT.PUT_LINE('회사명: ' || pcompanyName);  
        DBMS_OUTPUT.PUT_LINE('연봉: ' || psalary);  
        DBMS_OUTPUT.PUT_LINE('취업일: ' || pjobDate);  
        DBMS_OUTPUT.PUT_LINE('회사 주소: ' || pcompanyLocation);  
        DBMS_OUTPUT.PUT_LINE('회사형태: ' || pcompanyType);  
        DBMS_OUTPUT.PUT_LINE('회사규모: ' || pcompanySize);  
		DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────────');

        END LOOP;
    CLOSE vcursor;

END;

BEGIN
    procSelectJobPickStudent('1');
END;


--사후관리 (6달 이내 미취업 교육생 조회) 
CREATE OR REPLACE PROCEDURE procSelectNonJob
IS

pcourseName tblCourse.courseName%TYPE;
pinterviewerName tblInterviewer.interviewerName%TYPE;
pinterviewerTel tblInterviewer.interviewerTel%TYPE;

CURSOR vcursor IS

	SELECT c.courseName,
		   i.interviewerName,
		   i.interviewerTel 
	FROM tblJob j
		RIGHT OUTER JOIN tblStudent s
			ON s.studentnum = j.studentnum
				INNER JOIN tblCourseDetail cd
					ON cd.coursedetailnum = s.coursedetailnum
						INNER JOIN tblInterviewRegISter ir
							ON ir.interviewReginum = s.interviewReginum
								INNER JOIN tblInterviewer i
									ON i.interviewerNum = ir.interviewerNum
										INNER JOIN tblCourse c
											ON c.courseNum = cd.courseNum
												WHERE j.jobnum IS NULL 
													  AND ADD_MONTHS(TO_CHAR(cd.courseEndDate, 'YYYY-MM-DD'), 6) >= SYSDATE
													  AND TO_CHAR(cd.courseEndDate, 'YYYY-MM-DD') <= SYSDATE;

BEGIN
    OPEN vcursor;
   		DBMS_OUTPUT.PUT_LINE('───────────────── 6달 이내 미취업 교육생 조회 ────────────────');
        LOOP
            FETCH vcursor INTO pcourseName, pinterviewerName, pinterviewerTel;
        EXIT WHEN vcursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('과정명: ' || pcourseName);
        DBMS_OUTPUT.PUT_LINE('교육생 이름: ' || pinterviewerName);        
        DBMS_OUTPUT.PUT_LINE('교육생 전화번호: ' || pinterviewerTel);
        DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────────');
        END LOOP;
    CLOSE vcursor;

END;

BEGIN
    procSelectNonJob;
END;




-------------------------------C. 교사 기능
-------------------------------C01-01. 강의 스케줄 조회
--특정 교사의 강의 스케줄 출력 프로시저
CREATE OR REPLACE PROCEDURE procLectureSchedule (
    pTeacherNum IN VARCHAR2,
    pLectureScheduleCursor OUT SYS_REFCURSOR
)
IS
    vCount NUMBER;
BEGIN
    --타입 유효성 검사 (NUMBER)
    IF pTeacherNum IS NULL OR NOT REGEXP_LIKE(pTeacherNum, '^[0-9]+$') THEN
        DBMS_OUTPUT.PUT_LINE('유효하지 않은 교사 번호입니다.');
        RAISE_APPLICATION_ERROR(-20000, '유효하지 않은 교사 번호');
    END IF;

    --범위 유효성 검사
    SELECT COUNT(*) INTO vCount FROM tblTeacher WHERE teacherNum = pTeacherNum;
    IF vCount = 0 THEN
        DBMS_OUTPUT.PUT_LINE('해당 교사 번호의 강의 스케줄이 없습니다.');
        RAISE_APPLICATION_ERROR(-20001, '해당 교사 번호의 강의 스케줄 데이터 없음');
    END IF;

    --OUT parameter에 cursor 할당
    OPEN pLectureScheduleCursor FOR
    SELECT
        *
    FROM vwLectureSchedule
    WHERE teacherNum = pTeacherNum
    ORDER BY courseStartDate ASC;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('생성에 실패했습니다.');
END procLectureSchedule;
/

--특정 교사의 강의 스케줄 출력 프로시저 호출
DECLARE
    vLectureScheduleCursor SYS_REFCURSOR;
	vTeacherNum tblTeacher.teacherNum%TYPE := <교사번호>; --1 (체제투)
    vRow vwLectureSchedule%ROWTYPE;
BEGIN
    procLectureSchedule(vTeacherNum, vLectureScheduleCursor); --procLectureSchedule 호출

    DBMS_OUTPUT.PUT_LINE('────────────────────── 강의 스케줄 정보 ──────────────────────');
    LOOP
        FETCH vLectureScheduleCursor INTO vRow;
		EXIT WHEN vLectureScheduleCursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('교사이름: ' || vRow.teacherName);
        DBMS_OUTPUT.PUT_LINE('과목번호: ' || vRow.subjectNum);
        DBMS_OUTPUT.PUT_LINE('과정명: ' || vRow.courseName);
        DBMS_OUTPUT.PUT_LINE('강의진행여부: ' || vRow.progress);
        DBMS_OUTPUT.PUT_LINE('과정기간(시작 년월일): ' || vROw.courseStartDate);
        DBMS_OUTPUT.PUT_LINE('과정기간(끝 년월일): ' || vROw.courseEndDate);
        DBMS_OUTPUT.PUT_LINE('강의실: ' || vRow.lectureRoomNum);
        DBMS_OUTPUT.PUT_LINE('과목명: ' || vRow.subjectName);
        DBMS_OUTPUT.PUT_LINE('과목기간(시작 년월일): ' || vRow.subjectStartDate);
        DBMS_OUTPUT.PUT_LINE('과목기간(끝 년월일): ' || vRow.subjectEndDate);
        DBMS_OUTPUT.PUT_LINE('교재명: ' || vROw.textBookName);
        DBMS_OUTPUT.PUT_LINE('교육생 등록 인원: ' || vRow.regISter);
		DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────────');
    END LOOP;
    CLOSE vLectureScheduleCursor;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('조회에 실패했습니다.');
END;
/


--교육중인 과정에 등록된 교육생의 정보 출력 프로시저
CREATE OR REPLACE PROCEDURE procStudentCourseStatus (
    pCourseNum IN VARCHAR2,
    pCourseCursor OUT SYS_REFCURSOR
)
IS
BEGIN
	OPEN pCourseCursor FOR
    SELECT
    	*
    FROM vwStudentCourseStatus
    WHERE courseNum = pCourseNum
	ORDER BY courseName, interviewerName;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('생성에 실패했습니다.');
END procStudentCourseStatus;
/


--교육중인 과정에 등록된 교육생의 정보 출력 프로시저 호출
DECLARE
    vCourseCursor SYS_REFCURSOR;
	vCourseNum tblCourse.courseNum%TYPE := <과정번호>; --1 (AWS를 활용한 클라우드 자바 웹기반 풀스텍 개발자 과정)
    vRow vwStudentCourseStatus%ROWTYPE;
BEGIN
    procStudentCourseStatus(vCourseNum, vCourseCursor); --procStudentCourseStatus 호출

    DBMS_OUTPUT.PUT_LINE('────────────────────── 등록 교육생 정보 ──────────────────────');
    LOOP
        FETCH vCourseCursor INTO vRow;
		EXIT WHEN vCourseCursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('과정명: ' || vRow.courseName);
        DBMS_OUTPUT.PUT_LINE('교육생이름: ' || vRow.interviewerName);
        DBMS_OUTPUT.PUT_LINE('전화번호: ' || vRow.interviewerTel);
        DBMS_OUTPUT.PUT_LINE('등록일: ' || vRow.regIStrationDate);
        DBMS_OUTPUT.PUT_LINE('수료여부: ' || vRow.completionStatus);
		DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────────');
    END LOOP;
    CLOSE vCourseCursor;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('교육생 조회에 실패했습니다.');
END;
/


--강의가 종료된 강의의 진행 상태를 강의 종료로 갱신하는 프로시저
CREATE OR REPLACE PROCEDURE procUpdateCourseProgress AS
    CURSOR courseData IS
        SELECT cd.courseDetailNum, cd.courseEndDate, l.progress
        FROM tblCourseDetail cd
        	INNER JOIN tblLectureSchedule l
        		ON cd.courseDetailNum = l.subjectDetailNum;

    course courseData%ROWTYPE;
BEGIN
    OPEN courseData;
    LOOP
        FETCH courseData INTO course;
        EXIT WHEN courseData%NOTFOUND;

        IF course.courseEndDate <= SYSDATE AND course.progress <> '강의종료' THEN
            UPDATE tblLectureSchedule
            SET progress = '강의종료'
            WHERE subjectDetailNum = course.courseDetailNum;
            DBMS_OUTPUT.PUT_LINE('과정상세번호: ' || course.courseDetailNum || ' 강의종료로 갱신');
        END IF;
    END LOOP;
    CLOSE courseData;
END procUpdateCourseProgress;
/




-------------------------------C02-01. 배점 입출력
--1. 자신이 강의를 마친 과목의 목록 중에서 특정 과목을 선택하고 해당 배점 정보를 등록한다. 시험 날짜, 시험 문제를 추가한다. 특정 과목을 과목번호로 선택 시 출결 배점, 필기 배점, 실기 배점, 시험 날짜, 시험 문제를 입력할 수 있는 화면으로 연결되어야 한다.													
--2. 출결, 필기, 실기의 배점 비중은 담당 교사가 과목별로 결정한다.	
--• 출결은 최소 20점 이상이어야 한다.
--• 출결, 필기, 실기의 합은 100점이 되어야 한다.														
														
--[배점 정보 등록 및 시험 날짜, 시험 문제 추가]
--[프로시저 생성]
CREATE OR REPLACE PROCEDURE procAddPoint(
	psubjectDetailNum NUMBER, --과목 상세번호
	paPoint NUMBER, --출석 배점
	pwPoint NUMBER, --필기 배점
	ppPoint NUMBER, --실기 배점
	ptestDate DATE, --시험일
	pisRegistration NUMBER --시험문제 등록 여부
)
IS
    vtotal NUMBER;
BEGIN
    
    vtotal := paPoint + pwPoint + ppPoint;

	IF fnCheckProgress(psubjectDetailNum) <> '강의종료' THEN
        dbms_OUTput.put_line('강의를 마친 과목에 한해 배점 입력이 가능합니다.');
    ELSE
    
        IF vtotal <> 100 THEN
            dbms_OUTput.put_line('출결, 필기, 실기의 합은 100점이 되어야 합니다.');
        ELSE
        
            IF paPoint < 20 THEN
                dbms_OUTput.put_line('출결은 최소 20점 이상이어야 합니다.');
            ELSE
                INSERT INTO tblTest (testNum, subjectDetailNum, attendancePoint, writtenPoint, practicalPoint, testDate, isRegistration)
                    VALUES ((SELECT NVL(MAX(LPAD(testNum, 5, '0')), 0) + 1 FROM tblTest), psubjectDetailNum, paPoint, pwPoint, ppPoint, ptestDate, pisRegistration);
            END IF;
            
        END IF;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('생성에 실패했습니다.');
END procAddPoint;

--[프로시저용 저장함수 생성]
CREATE OR REPLACE FUNCTION fnCheckProgress(
	fnum NUMBER --subjectDetailNum
) RETURN VARCHAR2
IS 
	vprogress VARCHAR2(30);
BEGIN 
	SELECT progress INTO vprogress FROM tblLectureSchedule WHERE subjectDetailNum = fnum;
    return vprogress;
END fnCheckProgress;

--[프로시저 실행]
BEGIN
    procAddPoint(1,20,40,40,'2023-09-14',1); --과목 상세 번호, 출석 배점, 필기 배점, 실기 배점, 시험일, 시험문제 등록 여부
END;

--[실행 확인]
SELECT * FROM tblTest;

													
--[시험 문제 등록(시험 문제 등록 안했을 경우)]
--> 아래 수정문에서 통합

--[배점 수정, 시험일 및 시험문제 등록여부 수정]
--[프로시저 생성]
CREATE OR REPLACE PROCEDURE procUpdatePoint(
    pnum NUMBER, --과목 상세번호
    paPoint NUMBER, --출석 배점
	pwPoint NUMBER, --필기 배점
	ppPoint NUMBER, --실기 배점
	ptestDate DATE, --시험일
	pisRegistration NUMBER --시험문제 등록 여부
)
IS
    vtotal NUMBER;
BEGIN
    
    vtotal := paPoint + pwPoint + ppPoint;

	IF fnCheckProgress(pnum) <> '강의종료' THEN
        dbms_OUTput.put_line('강의를 마친 과목에 한해 배점 수정이 가능합니다.');
    ELSE
--       IF EXISTS (SELECT 'Y' FROM tblTestScore ts INNER JOIN tblTest t ON t.testNum = ts.testNum WHERE t.testNum = ts.testNum) THEN
--           dbms_OUTput.put_line('시험 점수가 입력된 과목의 배점 수정은 불가능합니다.');
--       ELSE
                
            IF vtotal <> 100 THEN
                dbms_OUTput.put_line('출결, 필기, 실기의 합은 100점이 되어야 합니다.');
            ELSE
            
                IF paPoint < 20 THEN
                    dbms_OUTput.put_line('출결은 최소 20점 이상이어야 합니다.');
                ELSE
                    UPDATE tblTest SET attendancePoint = paPoint, writtenPoint = pwPoint, practicalPoint = ppPoint, testDate = ptestDate, isRegistration = pisRegistration WHERE subjectDetailNum = pnum;
                END IF;
                
            END IF;
--       END IF;        
    END IF;
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('갱신에 실패했습니다.');
END procUpdatePoint;

--[프로시저 실행]
BEGIN
    procUpdatePoint(1,25,35,40,'2023-09-14',1); --과목 상세 번호, 출석 배점, 필기 배점, 실기 배점, 시험일, 시험문제 등록 여부
END;

--[실행 확인]
SELECT * FROM tblTest;

--3. 배점을 입력한 과목 목록 출력 시 과목상세번호, 과정명, 과정기간(시작 년월일, 끝 년월일), 강의실, 과목명, 과목기간(시작 년월일, 끝 년월일), 교재명, 출결, 필기, 실기 배점 등이 출력된다.
--[프로시저 생성]
CREATE OR REPLACE PROCEDURE procReadPoint
IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('────────────────────── 과목별 배점 조회 ──────────────────────');
    FOR subject IN (
        SELECT
            sd.subjectDetailNum AS "과목 상세 번호",
            s.subjectName AS 과목명,
            sd.subjectStartDate AS "과목 시작일",
            sd.subjectEndDate AS "과목 종료일",
            c.courseName AS 과정명,
            cd.courseStartDate AS "과정 시작일",
            cd.courseEndDate AS "과정 종료일",
            cd.lectureRoomNum AS 강의실,
            tb.textBookName AS 교재명,
            t.attendancePoint AS "출결 배점",
            t.writtenPoint AS "필기 배점",
            t.practicalPoint AS "실기 배점"
          FROM tblSubjectDetail sd
              INNER JOIN tblSubject s
                     ON s.subjectNum = sd.subjectNum
              INNER JOIN tblTextBook tb
                     ON s.subjectNum = tb.subjectNum
              INNER JOIN tblCourseDetail cd
                     ON cd.courseDetailNum = sd.courseDetailNum
              INNER JOIN tblTest t
                     ON sd.subjectDetailNum = t.subjectDetailNum
              INNER JOIN tblCourse c
                     ON c.courseNum = cd.courseNum
          ORDER BY TO_NUMBER("과목 상세 번호")
    )
    LOOP
    DBMS_OUTPUT.PUT_LINE('과목 상세 번호: ' || subject."과목 상세 번호");
    DBMS_OUTPUT.PUT_LINE('과목명: ' || subject.과목명);
    DBMS_OUTPUT.PUT_LINE('과목 시작일: ' || subject."과목 시작일");
    DBMS_OUTPUT.PUT_LINE('과목 종료일: ' || subject."과목 종료일");
    DBMS_OUTPUT.PUT_LINE('과정명: ' || subject.과정명);
    DBMS_OUTPUT.PUT_LINE('과정 시작일: ' || subject."과정 시작일");
    DBMS_OUTPUT.PUT_LINE('과정 종료일: ' || subject."과정 종료일");
    DBMS_OUTPUT.PUT_LINE('강의실: ' || subject.강의실);
    DBMS_OUTPUT.PUT_LINE('교재명: ' || subject.교재명);
    DBMS_OUTPUT.PUT_LINE('출결 배점: ' || subject."출결 배점");
    DBMS_OUTPUT.PUT_LINE('필기 배점: ' || subject."필기 배점");
    DBMS_OUTPUT.PUT_LINE('실기 배점: ' || subject."실기 배점");
    DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────────');
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('과목별 배점 조회에 실패했습니다.');
END procReadPoint;

--[프로시저 실행]
BEGIN
	procReadPoint;
END;



-------------------------------C03-01. 시험 관리 및 성적 조회
--1. 자신이 강의를 마친 과목의 목록 중에서 특정 과목을 선택하면, 교육생 정보가 출력되고, 특정 교육생 정보를 선택하면, 해당 교육생의 시험 점수를 입력할 수 있다. 이때, 출결, 필기, 실기 점수를 구분해서 입력한다.
CREATE OR REPLACE PROCEDURE procEnterScore(
    psubjectName VARCHAR2,
    pstudentname VARCHAR2,
    pattendanceScore NUMBER,
    pwrittenScore NUMBER,
    ppracticalScore NUMBER
)
AS
    vstudentnum NUMBER;
BEGIN
    --선택한 과목을 수강한 교육생 목록을 출력
    FOR studentinfo IN (
        SELECT
            s.studentNum,
            vs.studentName  "교육생 이름"
        FROM
            tblCourseDetail cd
                INNER JOIN tblSubjectDetail sd
                    ON cd.courseDetailNum = sd.courseDetailNum
                        INNER JOIN tblSubject ss 
                            ON sd.subjectNum = ss.subjectNum
                                INNER JOIN tblTeacher t 
                                    ON cd.teacherNum = t.teacherNum
                                        INNER JOIN tblLectureSchedule ls 
                                            ON sd.subjectDetailNum = ls.subjectDetailNum
                                                INNER JOIN tblStudent s 
                                                    ON cd.courseDetailNum = s.courseDetailNum
                                                        INNER JOIN vwStudent vs 
                                                            ON s.studentNum = vs.studentNum
        WHERE
            t.teacherName = '곽우갓'  --교사 이름 
            AND ls.progress = '강의종료'
            AND ss.subjectName = psubjectname
            AND vs.studentName = pstudentname
            
            
    ) LOOP
        --교육생 정보 출력
        DBMS_OUTPUT.PUT_LINE('교육생 이름: ' || studentinfo."교육생 이름");
        
        --시험 점수 입력
        vstudentnum := studentinfo.studentNum;
        
        --출결 점수 업데이트
        UPDATE tblTestScore
        SET 
            attendanceScore = pattendanceScore
        WHERE 
            studentNum = vstudentnum;

        --필기 점수 업데이트
        UPDATE tblTestScore
        SET 
            writtenScore = pwrittenScore
        WHERE 
            studentNum = vstudentNum;

        --실기 점수 업데이트
        UPDATE tblTestScore
        SET 
            practicalScore = pPracticalScore
        WHERE 
            studentNum = vstudentNum;
        
        DBMS_OUTPUT.PUT_LINE('시험 점수가 업데이트 되었습니다.');
        DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────────');
    END LOOP;
    
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('점수 입력에 실패했습니다.');
END procEnterScore;

BEGIN
    procEnterScore('자바', '임승성', 20, 40 , 38);
END;


--업데이트 되었는지 확인
SELECT 
    distinct
    vs.studentName  "교육생 이름",
    ts.attendanceScore  "출결 점수",
    ts.writtenScore  "필기 점수",
    ts.practicalScore  "실기 점수"
FROM 
    tblStudent s
        INNER JOIN vwStudent vs 
            ON s.studentNum = vs.studentNum
                INNER JOIN tblTestScore ts 
                    ON s.studentNum = ts.studentNum
WHERE 
    vs.studentName = '임승성';
    
    
--2. 과목 목록 출력시) 과목번호, 과정명, 과정기간(시작 년월일, 끝 년월일), 강의실, 과목명, 과목기간(시작 년월일, 끝 년월일), 교재명, (출결, 필기, 실기) 배점, 성적 등록 여부 등이 출력되고, 
-- 특정 과목을 과목번호로 선택시 교육생 정보(이름, 전화번호, 수료 또는 중도탈락) 및 성적이 출결, 필기, 실기 점수로 구분되어서 출력한다.
--overflow
CREATE OR REPLACE PROCEDURE procSubjectListInfo(
    psubjectNum NUMBER
)
AS
BEGIN
    --1. 과목 목록 출력
	DBMS_OUTPUT.PUT_LINE('─────────────────────── 과목 목록 조회 ───────────────────────');
        FOR subjectInfo IN (
            SELECT
                sd.subjectNum  "과목번호",
                c.courseName  "과정명",
                TO_CHAR(cd.courseStartDate, 'YYYY-MM-DD')  "과정시작일",
                TO_CHAR(cd.courseEndDate, 'YYYY-MM-DD')  "과정종료일",
                cd.lectureRoomNum  "강의실",
                s.subjectName  "과목명",
                TO_CHAR(sd.subjectStartDate, 'YYYY-MM-DD')  "과목시작일",
                TO_CHAR(sd.subjectEndDate, 'YYYY-MM-DD')  "과목종료일",
                tb.textBookName  "교재명",
                t.attendancePoint  "출결배점",
                t.writtenPoint  "필기배점",
                t.practicalPoint  "실기배점",
                CASE 
                    WHEN ts.attendanceScore IS NOT NULL 
                        AND ts.writtenScore IS NOT NULL 
                        AND ts.practicalScore IS NOT NULL 
                        THEN 'O'
                    ELSE 'X'
                END  "성적등록여부"
            FROM tblSubjectDetail sd
                INNER JOIN tblCourseDetail cd 
                    ON sd.courseDetailNum = cd.courseDetailNum
                        INNER JOIN tblCourse c 
                            ON cd.courseNum = c.courseNum
                                INNER JOIN tblSubject s 
                                    ON sd.subjectNum = s.subjectNum
                                        INNER JOIN tblTextBook tb
                                            on s.subjectNum = tb.subjectNum
                                                INNER JOIN tblTest t 
                                                    ON sd.subjectDetailNum = t.subjectDetailNum
                                                        LEFT JOIN tblTestScore ts 
                                                            ON t.testNum = ts.testNum
                                                 ORDER BY sd.subjectNum
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('과목번호: ' || subjectInfo."과목번호");
            DBMS_OUTPUT.PUT_LINE('과정명: ' || subjectInfo."과정명");
            DBMS_OUTPUT.PUT_LINE('과정기간: ' || subjectInfo."과정시작일" || ' ~ ' || subjectInfo."과정종료일");
            DBMS_OUTPUT.PUT_LINE('강의실: ' || subjectInfo."강의실");
            DBMS_OUTPUT.PUT_LINE('과목명: ' || subjectInfo."과목명");
            DBMS_OUTPUT.PUT_LINE('과목기간: ' || subjectInfo."과목시작일" || ' ~ ' || subjectInfo."과목종료일");
            DBMS_OUTPUT.PUT_LINE('교재명: ' || subjectInfo."교재명");
            DBMS_OUTPUT.PUT_LINE('출결배점: ' || subjectInfo."출결배점");
            DBMS_OUTPUT.PUT_LINE('필기배점: ' || subjectInfo."필기배점");
            DBMS_OUTPUT.PUT_LINE('실기배점: ' || subjectInfo."실기배점");
            DBMS_OUTPUT.PUT_LINE('성적등록여부: ' || subjectInfo."성적등록여부");
            DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────────');
        END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('조회에 실패했습니다.');
END procSubjectListInfo;

BEGIN
    procSubjectListInfo(1);
END;


--2. 특정 과목 선택 시 교육생 정보 및 성적 출력
CREATE OR REPLACE PROCEDURE procSpecIFicSubjectListInfo(
    psubjectNum NUMBER
)
AS
BEGIN
        FOR studentInfo IN (
            SELECT
                vs.studentName  "이름",
                vs.studentTel  "전화번호",
                CASE 
                    WHEN ts.attendanceScore IS NOT NULL 
                        AND ts.writtenScore IS NOT NULL 
                        AND ts.practicalScore IS NOT NULL 
                        THEN '수료'
                    ELSE '중도탈락'
                END  "상태",
                ts.attendanceScore  "출결점수",
                ts.writtenScore  "필기점수",
                ts.practicalScore  "실기점수"
            FROM tblStudent s
                INNER JOIN vwStudent vs 
                    ON s.studentNum = vs.studentNum
                        INNER JOIN tblTestScore ts 
                             ON s.studentNum = ts.studentNum
                WHERE s.courseDetailNum = psubjectnum
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('교육생 이름: ' || studentInfo."이름");
            DBMS_OUTPUT.PUT_LINE('전화번호: ' || studentInfo."전화번호");
            DBMS_OUTPUT.PUT_LINE('상태: ' || studentInfo."상태");
            DBMS_OUTPUT.PUT_LINE('출결점수: ' || studentInfo."출결점수");
            DBMS_OUTPUT.PUT_LINE('필기점수: ' || studentInfo."필기점수");
            DBMS_OUTPUT.PUT_LINE('실기점수: ' ||studentInfo."실기점수");
            DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────────');
        END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('조회에 실패했습니다.');
END procSpecIFicSubjectListInfo;

BEGIN
    DBMS_OUTPUT.PUT_LINE('────────────────────── 교육생 성적 조회 ──────────────────────');
	procSpecIFicSubjectListInfo(12); 
END;


--특정 과목을 과목번호로 선택시 교육생 정보(이름, 전화번호, 수료 또는 중도탈락) 및 성적이 출결, 필기, 실기 점수로 구분되어서 출력한다.
--5. 중도 탈락인 경우 중도탈락 날짜가 출력되도록 한다.
CREATE OR REPLACE PROCEDURE procStudentInfo(
    psubjectNum NUMBER
)
AS
BEGIN
    FOR studentInfo IN (
        SELECT
            DISTINCT vs.studentName  "교육생이름",
            vs.studentTel  "전화번호",
            CASE
                WHEN c.studentNum IS NOT NULL THEN '수료'
                WHEN f.studentNum IS NOT NULL THEN '중도 탈락 ' || TO_CHAR(f.failDate, 'YYYY-MM-DD')
                WHEN TO_CHAR(cd.courseStartDate, 'YYYY-MM-DD') > TO_CHAR(SYSDATE, 'YYYY-MM-DD') THEN '진행 예정'
                ELSE '진행중'
            END  "수료",
            ts.attendanceScore  "출결점수",
            ts.writtenScore  "필기점수",
            ts.practicalScore  "실기점수"
        FROM vwStudent vs
            FULL JOIN tblFail f 
                ON vs.studentNum = f.studentNum
                    FULL JOIN tblComplete c 
                        ON vs.studentNum = c.studentNum
                            INNER JOIN tblStudent s 
                                ON vs.studentNum = s.studentNum
                                    INNER JOIN tblCourseDetail cd
                                        ON cd.courseDetailNum = s.courseDetailNum
                                            INNER JOIN tblTestScore ts 
                                                ON vs.studentNum = ts.studentNum
                                                    INNER JOIN tblSubjectDetail sd 
                                                        ON cd.courseDetailNum = sd.courseDetailNum
                     WHERE sd.subjectNum = psubjectNum
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('교육생 이름: ' || studentInfo."교육생이름");
        DBMS_OUTPUT.PUT_LINE('전화번호: ' || studentInfo."전화번호");
        DBMS_OUTPUT.PUT_LINE('수료: ' || studentInfo."수료");
        DBMS_OUTPUT.PUT_LINE('출결점수: ' || studentInfo."출결점수");
        DBMS_OUTPUT.PUT_LINE('필기점수: ' || studentInfo."필기점수");
        DBMS_OUTPUT.PUT_LINE('실기점수: ' || studentInfo."실기점수");
        DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────────');
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('조회에 실패했습니다.');
END procStudentInfo;

BEGIN
    DBMS_OUTPUT.PUT_LINE('────────────────────── 교육생 성적 조회 ──────────────────────');
    procStudentInfo(1);
END;



-------------------------------C04-01. 출결 관리 및 출결 조회
--관리자 기능 > 과정 선택 시 조회
--> B의 조회 기능과 동일



-------------------------------C05-01. 추천도서 입력 및 관리
/*
1. 도서명, 난이도를 입력한다.
2. 교사 별 추천 도서 조회가 가능하다.
3. 도서 별 추천한 교사가 조회 가능하다.
*/
--1. 도서 추가
CREATE OR REPLACE PROCEDURE procAddBook (
    pbookNum VARCHAR2,
    pbookName VARCHAR2,
    pbookLevel NUMBER
)
AS
BEGIN
    INSERT INTO tblBook (bookNum, bookName, bookLevel)
        VALUES ((SELECT NVL(MAX(LPAD(bookNum, 5, '0')), 0) + 1 FROM tblBook), pbookName, pbookLevel);
    DBMS_OUTPUT.PUT_LINE('도서가 추가되었습니다.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('등록에 실패했습니다.');
END;

--호출
DECLARE
    vbookName VARCHAR2(100) := '새로운 책'; 
    vbookLevel NUMBER := 2; 
Begin   
    procAddBook(null, vbookName, vbookLevel);
END;


--1.1 교사추천 도서리스트에 도서 번호와 교사번호 추가
CREATE OR REPLACE PROCEDURE procAddRecommendBook (
    pbookNum VARCHAR2,
    pteacherNum VARCHAR2
)
AS
BEGIN
    INSERT INTO tblRecommendBook (recommendBookNum, bookNum, teacherNum)
    VALUES (
        (SELECT NVL(MAX(LPAD(recommendBookNum, 5, '0')), 0) + 1 FROM tblRecommendBook),
        pbookNum,
        pteacherNum
    );

    DBMS_OUTPUT.PUT_LINE('교사 추천 도서가 추가되었습니다.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('등록에 실패했습니다.');
END procAddRecommendBook;

/*
BEGIN
    procAddRecommendBook(<도서번호>, <교사번호> );
END;
*/
BEGIN
    procAddRecommendBook(87, 1);
END;


--2. 교사 별 추천 도서 조회가 가능하다.
CREATE OR REPLACE PROCEDURE procTeacherRetrieve (
    pteacherNum VARCHAR2
)
AS
    vteacherName tblTeacher.teacherName%TYPE;
BEGIN
    SELECT 
        t.teacherName
    INTO
        vteacherName
    FROM tblTeacher t
    WHERE t.teacherNum = pteacherNum;
    
    DBMS_OUTPUT.PUT_LINE('────────────────── ' || vteacherName || ' 추천 도서 리스트 ────────────────────');

    FOR bookInfo IN (
        SELECT 
            b.bookNum, 
            b.bookName, 
            b.bookLevel
        FROM tblRecommendBook rb
            INNER JOIN tblBook b 
                ON rb.bookNum = b.bookNum
        WHERE rb.teacherNum = pteacherNum
    ) 
    LOOP
        DBMS_OUTPUT.PUT_LINE('도서번호: ' || bookInfo.bookNum);
        DBMS_OUTPUT.PUT_LINE('도서명: ' || bookInfo.bookName);
        DBMS_OUTPUT.PUT_LINE('난이도: ' || bookInfo.bookLevel);
        DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────────');
    END LOOP;
END procTeacherRetrieve;

/*
BEGIN
    procTeacherRetrieve(<교사번호>);
END;
*/
BEGIN
    procTeacherRetrieve(1);
END;


--3. 도서 별 추천한 교사가 조회 가능하다.
CREATE OR REPLACE PROCEDURE procBookRetrieve (
    pbookNum VARCHAR2
)
AS
BEGIN
    --도서명과 교사 이름 조회 쿼리
    FOR rec IN (
        SELECT 
            b.bookName,
            t.teacherName
        FROM tblTeacher t
            JOIN tblRecommendBook rb 
                ON t.teacherNum = rb.teacherNum
                    JOIN tblBook b 
                        ON rb.bookNum = b.bookNum
        WHERE rb.bookNum = pbookNum
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('도서명: ' || rec.bookName);
        DBMS_OUTPUT.PUT_LINE('교사이름: ' || rec.teacherName);
		DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────────');
    END LOOP;
END procBookRetrieve;

/*
BEGIN
    DBMS_OUTPUT.PUT_LINE('───────────────────── 도서 추천 교사 조회 ────────────────────');
    procBookRetrieve(<도서번호>);
END;
*/
BEGIN
    DBMS_OUTPUT.PUT_LINE('───────────────────── 도서 추천 교사 조회 ────────────────────');
    procBookRetrieve(15);
END;



-------------------------------C06-01. 교사 평가 조회
--교사 (교사 평가 조회)
CREATE OR REPLACE PROCEDURE procTeacherSelectEstimate (
    vteacherNum VARCHAR2
)
IS

pcourseName tblCourse.courseName%TYPE;
pteacherName tblTeacher.teacherName%TYPE;
pestimateIndex tblEstimate.estimateIndex%TYPE;
pestimateScore tblTeacherEstimate.estimateScore%TYPE;

CURSOR vcursor IS
	SELECT c.courseName AS "과정명",
		   t.teacherName AS "교사이름",
		   e.estimateIndex AS "평가항목",
		   sum(te.estimateScore) AS "총 점수"
	FROM tblTeacherEstimate te
		INNER JOIN tblStudent s
			ON s.studentNum = te.studentNum
				INNER JOIN tblCourseDetail cd
					ON cd.courseDetailNum = s.courseDetailNum
						INNER JOIN tblTeacher t
							ON t.teacherNum = cd.teacherNum
								INNER JOIN tblEstimate e
									ON e.estimateNum = te.estimateNum
										INNER JOIN tblCourse c
											ON c.courseNum = cd.courseNum
												WHERE t.teacherNum = vteacherNum
													GROUP BY c.courseName, t.teacherName, e.estimateIndex
														ORDER BY c.courseName ASC;

BEGIN
	DBMS_OUTPUT.PUT_LINE('─────────────────────── 교사 평가 조회 ───────────────────────');
    OPEN vcursor;
        LOOP
            FETCH vcursor INTO pcourseName, pteacherName, pestimateIndex, pestimateScore;
        EXIT WHEN vcursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('과정명: ' || pcourseName);
        DBMS_OUTPUT.PUT_LINE('교사이름: ' || pteacherName);        
        DBMS_OUTPUT.PUT_LINE('평가항목: ' || pestimateIndex);
        DBMS_OUTPUT.PUT_LINE('총 점수: ' || pestimateScore);        
		DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────────');
        END LOOP;
    CLOSE vcursor;

END;

--실행
BEGIN
    procTeacherSelectEstimate('1');
END;



-------------------------------C07-01. 과제 등록 및 관리
--입력 (과제 등록)
CREATE OR REPLACE PROCEDURE procInsertAssignmentTeacher (
    pSubjectDetailNum IN VARCHAR2,
    pAssignmentContent IN VARCHAR2
)
IS
BEGIN
    INSERT INTO tblAssignment (assignmentNum, subjectDetailNum, assignmentContent)
    VALUES ((SELECT NVL(MAX(LPAD(assignmentNum, 8, '0')), 0) + 1 FROM tblAssignment), pSubjectDetailNum, pAssignmentContent);	
	DBMS_OUTPUT.PUT_LINE(pAssignmentContent || ' 과제를 등록했습니다.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('생성에 실패했습니다.');
END procInsertAssignmentTeacher;
/

--입력 프로시저 실행
DECLARE
    vSubjectDetailNum VARCHAR2(30) := 3; --<과목상세번호>
    vAssignmentContent VARCHAR2(2048) := '자바과제4'; --과제내용
BEGIN
	procInsertAssignmentTeacher(vSubjectDetailNum, vAssignmentContent);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('등록에 실패했습니다.');
END;
/

--출력 (교육생 과제 제출 명단 출력)
--특정 과정의 교육생 과제 제출 명단 프로시저
CREATE OR REPLACE PROCEDURE procGetAssignmentLISt (
    pCourseDetailNum IN VARCHAR2,
    pAssignmentCursor OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN pAssignmentCursor FOR
    SELECT
       *
   	FROM vwAssignmentSubmitStudentLISt
    WHERE courseDetailNum = pCourseDetailNum; --과정상세번호
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('생성에 실패했습니다.');
END procGetAssignmentLISt;
/

--특정 과정의 교육생 과제 제출 명단 프로시저 호출
DECLARE
    vAssignmentCursor SYS_REFCURSOR; --cursor
	vCourseDetailNum tblCourseDetail.courseDetailNum%TYPE := 1; --<과정상세번호>
	vRow vwAssignmentSubmitStudentLISt%ROWTYPE;
BEGIN
    procGetAssignmentLISt(vCourseDetailNum, vAssignmentCursor); --procGetAssignmentLISt 호출

    DBMS_OUTPUT.PUT_LINE('──────────────────── 교육생 과제 제출 명단 ───────────────────');
    LOOP
        FETCH vAssignmentCursor INTO vRow;
        EXIT WHEN vAssignmentCursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('과정명: ' || vRow.CourseName);
        DBMS_OUTPUT.PUT_LINE('과목명: ' || vRow.SubjectName);
        DBMS_OUTPUT.PUT_LINE('과제내용: ' || vRow.AssignmentContent);
        DBMS_OUTPUT.PUT_LINE('과제제출번호: ' || vRow.AssignmentSubmitNum);
        DBMS_OUTPUT.PUT_LINE('교육생이름: ' || vRow.StudentName);
        DBMS_OUTPUT.PUT_LINE('과제풀이: ' || vRow.AssignmentExplain);
       	DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────────');
    END LOOP;
    CLOSE vAssignmentCursor;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('교육생 과제 제출 명단 조회에 실패했습니다.');
END;
/

--수정 (과제 수정)
CREATE OR REPLACE PROCEDURE procUpdateAssignmentTeacher (
    pAssignmentNum IN VARCHAR2,
    pSubjectDetailNum IN VARCHAR2,
    pAssignmentContent IN VARCHAR2
)
IS
BEGIN
    UPDATE tblAssignment
    SET subjectDetailNum = pSubjectDetailNum, assignmentContent = pAssignmentContent
    WHERE assignmentNum = pAssignmentNum;
   	DBMS_OUTPUT.PUT_LINE(pAssignmentContent || ' 과제를 수정했습니다.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('생성에 실패했습니다.');
END procUpdateAssignmentTeacher;
/

--수정 프로시저 실행
DECLARE
	vAssignmentNum VARCHAR2(30) := 1; --<과제번호>
    vSubjectDetailNum VARCHAR2(30) := 1; --<과목상세번호>
    vAssignmentContent VARCHAR2(2048) := '자바과제 심화'; --<과제내용>
BEGIN
	procUpdateAssignmentTeacher(vAssignmentNum, vSubjectDetailNum, vAssignmentContent);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('갱신에 실패했습니다.');
END;
/

--삭제 (과제 삭제)
CREATE OR REPLACE PROCEDURE procDeleteAssignmentTeacher (
    pAssignmentNum IN VARCHAR2
)
IS
BEGIN
    DELETE FROM tblAssignment WHERE assignmentNum = pAssignmentNum;
   	DBMS_OUTPUT.PUT_LINE(pAssignmentNum || '번 과제를 삭제했습니다.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('생성에 실패했습니다.');
END procDeleteAssignmentTeacher;
/

--삭제 프로시저 실행
DECLARE
	vAssignmentNum VARCHAR2(30) := <과제번호>; --326
BEGIN
	procDeleteAssignmentTeacher(vAssignmentNum);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('삭제에 실패했습니다.');
END;
/



-------------------------------C08-01. 질의응답 응답
--응답 (응답 등록)
CREATE OR REPLACE PROCEDURE procAddAnswer(
	pquestionNum VARCHAR2,
    pteacherNum VARCHAR2,
    panswerContent VARCHAR2,
    presult OUT VARCHAR2
)
IS
BEGIN
	INSERT INTO tblAnswer(answerNum, questionNum, teacherNum, answerContent, answerDate)
		VALUES ((SELECT NVL(MAX(LPAD(answerNum, 5, '0')), 0) + 1 FROM tblAnswer), pquestionNum, pteacherNum, panswerContent, SYSDATE);
    
	presult := '정상적으로 등록하였습니다.';
    
EXCEPTION
	WHEN OTHERS THEN
		presult := '등록을 실패하였습니다.'; --실패    

END procAddAnswer;

--실행
DECLARE
	vresult VARCHAR2(300);
BEGIN
	procAddAnswer('31', '9', '힘을내요 슈퍼파월', vresult);
	DBMS_OUTPUT.PUT_LINE(vresult);
END;

SELECT * FROM tblAnswer;


--응답 (응답 수정)
CREATE OR REPLACE PROCEDURE procChangeAnswer(
	pchangeContent VARCHAR2,
    panswerNum VARCHAR2,
    presult OUT VARCHAR2
)
IS
BEGIN

    UPDATE tblAnswer SET answerContent = pchangeContent WHERE answerNum = panswerNum;
    
	presult := '정상적으로 수정하였습니다.';
    
EXCEPTION
	WHEN OTHERS THEN
		presult := '수정을 실패하였습니다.'; --실패    

END procChangeAnswer;

--실행
DECLARE
	vresult VARCHAR2(300);
BEGIN
	procChangeAnswer('힘을내요 슈퍼파월월월', '31', vresult);
	DBMS_OUTPUT.PUT_LINE(vresult);
END;

SELECT * FROM tblAnswer;


--응답 (응답 삭제)
CREATE OR REPLACE PROCEDURE procDeleteAnswer(
	pteacherNum VARCHAR2,
    panswerNum VARCHAR2,
    presult OUT VARCHAR2
)
IS
BEGIN

    DELETE FROM tblAnswer WHERE teacherNum = pteacherNum AND answerNum = panswerNum;
    
	presult := '정상적으로 삭제하였습니다.';
    
EXCEPTION
	WHEN OTHERS THEN
		presult := '삭제를 실패하였습니다.'; --실패    

END procDeleteAnswer;

--실행
DECLARE
	vresult VARCHAR2(300);
BEGIN
	procDeleteAnswer('9', '31', vresult);
	DBMS_OUTPUT.PUT_LINE(vresult);
END;	

--응답 조회
CREATE OR REPLACE PROCEDURE procSelectAnswer (
    vanswerNum VARCHAR2
)
IS

pinterviewername tblInterviewer.interviewerName%TYPE;
pquestionContent tblQuestion.questionContent%TYPE;
pquestionDate tblQuestion.questionDate%TYPE;
panswerContent tblAnswer.answerContent%TYPE;
pteacherName tblTeacher.teacherName%TYPE;
panswerDate tblAnswer.answerDate%TYPE;


CURSOR vcursor IS

	SELECT i.interviewername AS "질문 교육생 이름",
           q.questionContent AS "질문내용",
		   q.questionDate AS "질문 날짜",
           a.answerContent AS "답변내용",
           t.teacherName AS "답변 교사 이름",
           a.answerDate AS "답변 날짜"
	FROM tblAnswer a
		INNER JOIN tblQuestion q
			ON q.questionNum = a.answerNum
				INNER JOIN tblStudent s
					ON s.studentNum = q.studentNum
						INNER JOIN tblInterviewRegISter ir
							ON ir.interviewReginum = s.interviewReginum
								INNER JOIN tblInterviewer i
									ON i.interviewerNum = ir.interviewerNum
										INNER JOIN tblTeacher t
											ON t.teacherNum = a.teacherNum
												WHERE answerNum = vanswerNum;
 
BEGIN
    OPEN vcursor;
        LOOP
            FETCH vcursor INTO pinterviewername, pquestionContent, pquestionDate, panswerContent, pteacherName, panswerDate;
        EXIT WHEN vcursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('질문 교육생 이름: ' || pinterviewername);
        DBMS_OUTPUT.PUT_LINE('답변 교사 이름: ' || pteacherName);        
        DBMS_OUTPUT.PUT_LINE('질문 내용: ' || pquestionContent);
        DBMS_OUTPUT.PUT_LINE('답변 내용: ' || panswerContent);        
        DBMS_OUTPUT.PUT_LINE('질문 날짜: ' || pquestionDate);
        DBMS_OUTPUT.PUT_LINE('답변 날짜: ' || panswerDate);
        DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────────');
        END LOOP;
    CLOSE vcursor;

END;

--실행
BEGIN
    procSelectAnswer('31');
END;



-------------------------------C09-01. 비품 교체 신청
--1. 교사는 비품에 대해 교체 신청 사유를 기재하여 교체 신청을 할 수 있다.
--등록
CREATE OR REPLACE PROCEDURE procApplyChangeItem(
    pitemDetailNum VARCHAR2,
    pitemChangeReason VARCHAR,
    presult OUT VARCHAR2
)
IS
BEGIN
    INSERT INTO tblitemChange (itemChangeNum, itemDetailNum, itemChangeReason, ISReplacement, itemChangeDate)
			VALUES ((SELECT NVL(MAX(LPAD(itemChangeNum, 5, '0')), 0) + 1 FROM tblitemChange), pitemDetailNum, pitemChangeReason, 0, SYSDATE);
    presult := '비품 교체 신청 등록 성공했습니다.'; --성공
EXCEPTION
    WHEN OTHERS THEN
        presult := '비품 교체 신청 등록 실패했습니다.'; --실패    
END procApplyChangeItem; 
/

DECLARE
    vresult VARCHAR2(100);
BEGIN
    procApplyChangeItem('806', '허수경 뿌심', vresult);
    DBMS_OUTPUT.PUT_LINE(vresult);
END;
/



-------------------------------C10-01. 우수 교육생 조회
--교사 기능 > 과정 선택 시 조회
----------------------------------------------------- [특정 과정의 성적 우수 학생 조회] ------------------------------------------------------------------------------
-- [프로시저 생성]
/
CREATE OR REPLACE PROCEDURE procReadBestS(
    pnum NUMBER --과정 상세 번호
)
IS
    vcnt NUMBER; --해당 개설 과정의 번호가 '상' 테이블에 존재하는 개수를 담는 변수
BEGIN

     SELECT
        count(*) 
       INTO vcnt
       FROM tblPrize p
            INNER JOIN tblStudent s
                    ON s.studentNum = p.studentNum
      WHERE s.courseDetailNum = pnum;
        
    DBMS_OUTPUT.PUT_LINE('──────────────────── 우수 교육생 조회 ─────────────────────');
    
    IF vcnt > 0 THEN --입력한 과정 상세 번호와 일치하는 레코드가 '상' 테이블에 있을 경우 내역 출력
        
        FOR best IN (
          SELECT
                vs.studentNum AS "교육생 번호",
                vs.studentName AS "교육생 이름",
                cs.courseName AS 과정명,
                cs.courseStartDate AS "과정 시작일",
                cs.courseEndDate AS "과정 종료일",
                p.prizeCategory AS 부문
            FROM tblPrize p
                INNER JOIN vwStudent vs
                    ON vs.studentNum = p.studentNum
                INNER JOIN vwCompletionStatus cs
                    ON cs.studentNum = vs.studentNum
           WHERE cs.courseDetailNum = pnum
             AND p.prizeCategory = '성적우수'
           ORDER BY TO_NUMBER("교육생 번호") ASC
        )
        LOOP
            DBMS_OUTPUT.PUT_LINE('부문: ' || best.부문);
            DBMS_OUTPUT.PUT_LINE('교육생 번호: ' || best."교육생 번호");
            DBMS_OUTPUT.PUT_LINE('교육생 이름: ' || best."교육생 이름");
            DBMS_OUTPUT.PUT_LINE('과정명: ' || best.과정명);
            DBMS_OUTPUT.PUT_LINE('과정 시작일: ' || best."과정 시작일");
            DBMS_OUTPUT.PUT_LINE('과정 종료일: ' || best."과정 종료일");
            DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────');
        END LOOP;
    ELSE --'상' 테이블에 입력한 과정 상세 번호와 일치하는 레코드가 존재하지 않을 경우 하기 문구 출력
        DBMS_OUTPUT.PUT_LINE('해당 내역이 존재하지 않습니다.');
        DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('우수 교육생 조회에 실패했습니다.');
--        RAISE_APPLICATION_ERROR(-10001, '우수 교육생 조회에 실패했습니다.');
END procReadBestS;
/

-- [프로시저 실행]
/
BEGIN
    procReadBestS(4); --과정 상세 번호
END;
/

----------------------------------------------------- [특정 과정의 개근 학생 조회] ------------------------------------------------------------------------------
-- [프로시저 생성]
/
CREATE OR REPLACE PROCEDURE procReadBestA(
    pnum NUMBER --과정 상세 번호
)
IS
    vcnt NUMBER; --해당 개설 과정의 번호가 '상' 테이블에 존재하는 개수를 담는 변수
BEGIN

     SELECT
        count(*) 
       INTO vcnt
       FROM tblPrize p
            INNER JOIN tblStudent s
                    ON s.studentNum = p.studentNum
      WHERE s.courseDetailNum = pnum;
        
    DBMS_OUTPUT.PUT_LINE('──────────────────── 우수 교육생 조회 ─────────────────────');
    
    IF vcnt > 0 THEN --입력한 과정 상세 번호와 일치하는 레코드가 '상' 테이블에 있을 경우 내역 출력
        
        FOR best IN (
          SELECT
                vs.studentNum AS "교육생 번호",
                vs.studentName AS "교육생 이름",
                cs.courseName AS 과정명,
                cs.courseStartDate AS "과정 시작일",
                cs.courseEndDate AS "과정 종료일",
                p.prizeCategory AS 부문
            FROM tblPrize p
                INNER JOIN vwStudent vs
                    ON vs.studentNum = p.studentNum
                INNER JOIN vwCompletionStatus cs
                    ON cs.studentNum = vs.studentNum
           WHERE cs.courseDetailNum = pnum
             AND p.prizeCategory = '개근'
           ORDER BY TO_NUMBER("교육생 번호") ASC
        )
        LOOP
            DBMS_OUTPUT.PUT_LINE('부문: ' || best.부문);
            DBMS_OUTPUT.PUT_LINE('교육생 번호: ' || best."교육생 번호");
            DBMS_OUTPUT.PUT_LINE('교육생 이름: ' || best."교육생 이름");
            DBMS_OUTPUT.PUT_LINE('과정명: ' || best.과정명);
            DBMS_OUTPUT.PUT_LINE('과정 시작일: ' || best."과정 시작일");
            DBMS_OUTPUT.PUT_LINE('과정 종료일: ' || best."과정 종료일");
            DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────');
        END LOOP;
    ELSE --'상' 테이블에 입력한 과정 상세 번호와 일치하는 레코드가 존재하지 않을 경우 하기 문구 출력
        DBMS_OUTPUT.PUT_LINE('해당 내역이 존재하지 않습니다.');
        DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('우수 교육생 조회에 실패했습니다.');
--        RAISE_APPLICATION_ERROR(-10001, '우수 교육생 조회에 실패했습니다.');
END procReadBestA;
/

-- [프로시저 실행]
/
BEGIN
    procReadBestA(1); --과정 상세 번호
END;
/



-------------------------------D. 교육생 기능
-------------------------------D01-01. 교육생 성적 조회
--학생 시험 성적 조회                    
--출력될 정보는 과목번호, 과목명, 과목기간(시작 년월일, 끝 년월일), 교재명, 교사명, 
--과목별 배점 정보(출결, 필기, 실기 배점), 
--과목별 성적 정보(출결, 필기, 실기 점수), 과목별 시험날짜가 출력되어야 한다.
CREATE OR REPLACE PROCEDURE procStudentExamScores(
    pStudentNum VARCHAR2
)
AS
BEGIN
    FOR examInfo IN (
        SELECT 
            vw.subjectNum AS "과목번호",
            vw.subjectName AS "과목명",
            vw.subjectStartDate AS "과목시작일",
            vw.subjectEndDate AS "과목종료일",
            vw.textBookName AS "교재명",
            vw.teacherName AS "교사명",
            t.attendancePoint AS "출결배점",
            t.writtenPoint AS "필기배점",
            t.practicalPoint AS "실기배점",
            ts.attendanceScore AS "출결점수",
            ts.writtenScore AS "필기점수",
            ts.practicalScore AS "실기점수",
            t.testDate AS "시험날짜"
        FROM vwCourseGather vw
            INNER JOIN tblTest t
                ON vw.subjectDetailNum = t.subjectDetailNum
            INNER JOIN tblTestScore ts
                ON t.testNum = ts.testNum
                    INNER JOIN tblTest t
                        on ts.testNum = t.testNum
        WHERE ts.studentNum = pStudentNum
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('과목번호: ' || examInfo."과목번호");
        DBMS_OUTPUT.PUT_LINE('과목명: ' || examInfo."과목명");
        DBMS_OUTPUT.PUT_LINE('과목시작일: ' || examInfo."과목시작일");
        DBMS_OUTPUT.PUT_LINE('과목종료일: ' || examInfo."과목종료일");
        DBMS_OUTPUT.PUT_LINE('교재명: ' || examInfo."교재명");
        DBMS_OUTPUT.PUT_LINE('교사명: ' || examInfo."교사명");
        DBMS_OUTPUT.PUT_LINE('출결배점: ' || examInfo."출결배점");
        DBMS_OUTPUT.PUT_LINE('필기배점: ' || examInfo."필기배점");
        DBMS_OUTPUT.PUT_LINE('실기배점: ' || examInfo."실기배점");
        DBMS_OUTPUT.PUT_LINE('출결점수: ' || examInfo."출결점수");
        DBMS_OUTPUT.PUT_LINE('필기점수: ' || examInfo."필기점수");
        DBMS_OUTPUT.PUT_LINE('실기점수: ' || examInfo."실기점수");
        DBMS_OUTPUT.PUT_LINE('시험날짜: ' || examInfo."시험날짜");
        DBMS_OUTPUT.PUT_LINE('――――――――――――――――――――――――――――――――――――――――――');
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('조회에 실패했습니다.');
END procStudentExamScores;

BEGIN
    DBMS_OUTPUT.PUT_LINE('―――――――――――――――― 시험 성적 조회 ――――――――――――――――――――――');
    procStudentExamScores(1); --학생번호 
END;



-------------------------------D02-01. 교육생 출결관리 및 출결조회
--입실/퇴실
--입실
CREATE OR REPLACE PROCEDURE procInsertStudentAttendance (
    pStudentNum VARCHAR2
)
IS
    vIsTrady NUMBER := 0;
    vDate DATE := SYSDATE;
BEGIN

    IF TO_date(vDate, 'HH24:MI:SS') > TO_date('09:00:00', 'HH24:MI:SS') THEN
        vIsTrady := 1;
    END IF;
    
    INSERT INTO tblStudentAttendance (attENDanceNum, studentNum, attendanceDate, checkInTime, checkOutTime, IsTrady)
                VALUES ((SELECT NVL(MAX(LPAD(attENDanceNum, 5, '0')), 0) + 1 FROM tblStudentAttendance), pStudentNum, DEFAULT, DEFAULT, NULL, vIsTrady);
    
    DBMS_OUTPUT.PUT_LINE('삐빅 인증 되었습니다!!');
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(vDate, 'HH24:MI:SS'));
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('출석 실패');
END procInsertStudentAttendance;
/
ROLLBACK;
BEGIN
    procInsertStudentAttendance(1);
END;
/
Select * FROM tblStudentAttendance WHERE studentNum = 1;

--퇴실
CREATE OR REPLACE PROCEDURE procUpdateStudentAttendance (
    pStudentNum VARCHAR2
)
IS
BEGIN
    UPDATE tblStudentAttendance SET checkOutTime = SYSDATE WHERE studentNum = pStudentNum AND TO_CHAR(attendanceDate, 'YYMMDD') = TO_CHAR(SYSDate, 'YYMMDD');
    
    DBMS_OUTPUT.PUT_LINE('퇴실 처리 되었습니다~');
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('퇴실 실패');
END procUpdateStudentAttendance;
/

BEGIN
    procUpdateStudentAttendance(1);
END;
/

--출결 신청 리스트
--출결 입력 시, 학생출결 리스트에서 삭제
CREATE OR REPLACE TRIGGER trgInsertAttendanceApply
    AFTER
    INSERT
    ON tblAttendanceApply
    FOR EACH ROW
BEGIN
    DELETE FROM tblStudentAttendance
                WHERE studentNum = :new.studentNum AND TO_CHAR(attendanceDate, 'YYMMDD') = TO_CHAR(:new.applyDate, 'YYMMDD');
END trgInsertAttendanceApply;


--입력
CREATE OR REPLACE PROCEDURE procInsertAttendanceApply (
    vStudentNum VARCHAR2,
    vTeacherNum VARCHAR2,
    vApplyAttendance VARCHAR2,
    vApplyReason VARCHAR2
)
IS
BEGIN
    INSERT INTO tblAttendanceApply (attENDanceApplyNum, studentNum, teacherNum, applyAttendance, applyReason, applyDate)
                VALUES ((SELECT NVL(MAX(LPAD(attENDanceApplyNum, 5, '0')), 0) + 1 FROM tblAttendanceApply), vStudentNum, vTeacherNum, vApplyAttendance, vApplyReason, DEFAULT);
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('출결 신청 실패');
END procInsertAttendanceApply;
/

BEGIN
    procInsertAttendanceApply(1, 1, '병가', '아파요');
END;
/

--출력
CREATE OR REPLACE PROCEDURE procReadAttendanceApply (
    pStudentNum IN VARCHAR2,
    pCursor OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN pCursor
    FOR
    SELECT * FROM tblAttendanceApply WHERE studentNum = pStudentNum;
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('출결 목록 출력 실패');
END procReadAttendanceApply;
/

DECLARE
    vCursor SYS_REFCURSOR;
    vRow tblAttendanceApply%ROWTYPE;
    vStudentName VARCHAR2(255);
    vTeacherName VARCHAR2(255);
BEGIN
    procReadAttendanceApply(2, vCursor);
    
    LOOP
        FETCH vCursor INTO vRow;
        EXIT WHEN vCursor%NOTFOUND;
        
        vStudentName := fnStudentName(vRow.studentNum);
        vTeacherName := fnTeacherName(vRow.teacherNum);
        
        DBMS_OUTPUT.PUT_LINE('학생이름: ' || vStudentName);
        DBMS_OUTPUT.PUT_LINE('교사이름: ' || vTeacherName);
        DBMS_OUTPUT.PUT_LINE('신청출결: ' || vRow.applyAttendance);
        DBMS_OUTPUT.PUT_LINE('신청사유: ' || vRow.applyReason);
        DBMS_OUTPUT.PUT_LINE('신청일: ' || vRow.applyDate);
        DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────────');
    END LOOP;
END;
/

--수정
CREATE OR REPLACE PROCEDURE procUpdateAttendanceApply (
    pStudentNum VARCHAR2,
    pApplyAttendance VARCHAR2,
    pApplyReason VARCHAR2
)
IS
BEGIN
    UPDATE tblAttendanceApply SET applyAttendance = pApplyAttendance, applyReason = pApplyReason WHERE studentNum = pStudentNum AND TO_CHAR(applyDate, 'YYMMDD') = TO_CHAR(SYSDATE, 'YYMMDD');
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('출결 목록 수정 실패');
END procUpdateAttendanceApply;
/

BEGIN
    procUpdateAttendanceApply(1, '조퇴', '급격히 피곤함');
END;
/



-------------------------------D03-01. 교육생 출입카드 조회 및 재신청
--1. 본인에게 배부된 출입카드를 분실하였을 경우, 분실사유를 기재하여 새 출입카드를 신청한다.
--수료 및 탈락된 교육생은 재발급 신청할 수 없다.
--등록
CREATE OR REPLACE PROCEDURE procCardReISsue(
    pstudentNum VARCHAR2,
    preISsueReason VARCHAR,
    presult OUT VARCHAR2
)
IS
    pcount NUMBER;
BEGIN

    SELECT count(*) INTO pcount FROM tblComplete WHERE studentnum = pstudentNum;
    
    IF pcount > 0 THEN
        raISe_application_error(-20001, '수료한 학생은 신청이 불가합니다.');
    END IF;
    
    SELECT count(*) INTO pcount FROM tblfail WHERE studentnum = pstudentNum;
    IF pcount > 0 THEN
        raISe_application_error(-20001, '탈락한 학생은 신청이 불가합니다.');
    END IF;
    
    INSERT INTO tblAccessCardReISsue (accessCardReISsueNum, studentNum, ISReISsue, reISsueReason)
			VALUES ((SELECT NVL(MAX(LPAD(accessCardReISsueNum, 5, '0')), 0) + 1 FROM tblAccessCardReISsue), pstudentNum, 0, preISsueReason);

    presult := '출입카드 재발급 신청 등록 성공했습니다.';   --성공
EXCEPTION
    WHEN OTHERS THEN
        presult := '출입카드 재발급 신청 등록 실패했습니다.';   --실패    
END procCardReISsue; 
/

declare
    vresult varchar2(100);
begin
    procCardReissue('486', '허수경 뿌심', vresult);
    dbms_output.put_line(vresult);
end;
/



-------------------------------D04-01. 교육생 교사 평가
--교육생 (교사 평가 등록)
CREATE OR REPLACE PROCEDURE procAddEstimate(
	pestimateNum VARCHAR2,
    pstudentNum VARCHAR2,
    pestimateScore VARCHAR2,
    presult OUT VARCHAR2
)
IS
    minValue NUMBER;
    MAXValue NUMBER;
BEGIN

	SELECT DISTINCT 
           MIN(LPAD(s.studentnum, 3, '0')) AS "끝난 학생의 시작번호",
           MAX(LPAD(s.studentnum, 3, '0')) AS "끝난 학생의 끝번호"
    INTO minValue, MAXValue                
	FROM tblTeacherEstimate te
		INNER JOIN tblStudent s
			ON s.studentNum = te.studentNum
				INNER JOIN tblCourseDetail cd
					ON cd.courseDetailNum = s.courseDetailNum
						WHERE cd.courseEndDate < SYSDATE
							ORDER BY LPAD(s.studentnum, 3, '0') ASC;	
	
	IF pstudentNum >= minValue AND pstudentNum <= MAXValue THEN					
						
        INSERT INTO tblTeacherEstimate(teacherEstiNum, estimateNum, studentNum, estimateScore)
            VALUES ((SELECT NVL(MAX(LPAD(teacherEstiNum, 5, '0')), 0) + 1 FROM tblTeacherEstimate), pestimateNum, pstudentNum, pestimateScore);
	
	ELSE
        DBMS_OUTPUT.PUT_LINE('평가 기간이 아닙니다.');
    END IF;
    
	presult := '정상적으로 등록하였습니다.';
    
EXCEPTION
	WHEN OTHERS THEN
		presult := '등록을 실패하였습니다.'; --실패    

END procAddEstimate;

--실행
DECLARE
	vresult VARCHAR2(300);
BEGIN
	procAddEstimate('1', '15', '5', vresult);
	DBMS_OUTPUT.PUT_LINE(vresult);
END;


--교육생 (교사 평가 조회)
CREATE OR REPLACE PROCEDURE procStudentSelectEstimate (
    vstudentNum VARCHAR2
)
IS

pcourseName tblCourse.courseName%TYPE;
pteacherName tblTeacher.teacherName%TYPE;
pestimateIndex tblEstimate.estimateIndex%TYPE;
pestimateScore tblTeacherEstimate.estimateScore%TYPE;

CURSOR vcursor IS

	SELECT c.courseName AS "과정명",
		   t.teacherName AS "교사이름",
		   e.estimateIndex AS "평가항목",
		   te.estimateScore AS "평가점수" 
	FROM tblTeacherEstimate te
		INNER JOIN tblStudent s
			ON s.studentNum = te.studentNum
				INNER JOIN tblCourseDetail cd
					ON cd.courseDetailNum = s.courseDetailNum
						INNER JOIN tblTeacher t
							ON t.teacherNum = cd.teacherNum
								INNER JOIN tblEstimate e
									ON e.estimateNum = te.estimateNum
										INNER JOIN tblCourse c
											ON c.courseNum = cd.courseNum
												WHERE te.studentNum = vstudentNum;

BEGIN
	DBMS_OUTPUT.PUT_LINE('─────────────────────── 교사 평가 조회 ───────────────────────');
    OPEN vcursor;
        LOOP
            FETCH vcursor INTO pcourseName, pteacherName, pestimateIndex, pestimateScore;
        EXIT WHEN vcursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('과정명: ' || pcourseName);
        DBMS_OUTPUT.PUT_LINE('교사이름: ' || pteacherName);        
        DBMS_OUTPUT.PUT_LINE('평가항목: ' || pestimateIndex);
        DBMS_OUTPUT.PUT_LINE('평가점수: ' || pestimateScore);        
		DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────────');
        END LOOP;
    CLOSE vcursor;

END procStudentSelectEstimate;

--실행
BEGIN
    procStudentSelectEstimate('1');
END;



-------------------------------D05-01. 질의응답 질의
--질의 (질문 등록)
CREATE OR REPLACE PROCEDURE procAddQuestion(
	psubjectNum VARCHAR2,
    pstudentNum VARCHAR2,
    pquestionContent VARCHAR2,
    presult OUT VARCHAR2
)
IS
BEGIN
    INSERT INTO tblQuestion(questionNum, subjectNum, studentNum, questionContent, questionDate)
    VALUES ((SELECT NVL(MAX(LPAD(questionNum, 5, '0')), 0) + 1 FROM tblQuestion), psubjectNum, pstudentNum, pquestionContent, SYSDATE);
    
	presult := '정상적으로 등록하였습니다.';
    
EXCEPTION
	WHEN OTHERS THEN
		presult := '등록을 실패하였습니다.'; --실패    

END procAddQuestion;

--실행
DECLARE
	vresult VARCHAR2(300);
BEGIN
	procAddQuestion('31', '190', '겁나게 어려워부렁', vresult);
	DBMS_OUTPUT.PUT_LINE(vresult);
END;

SELECT * FROM tblQuestion;


--질의 (질문 수정)
CREATE OR REPLACE PROCEDURE procUpdateQuestion(
	psel NUMBER,
    pquestionNum VARCHAR2,
    pchangeQuestion VARCHAR2,
    presult OUT VARCHAR2
)
IS
BEGIN

    IF psel = 1 THEN
        UPDATE tblQuestion SET subjectNum = pchangeQuestion WHERE questionNum = pquestionNum;
    ELSIF psel = 2 THEN
        UPDATE tblQuestion SET questionContent = pchangeQuestion WHERE questionNum = pquestionNum;
    END IF;
    
	presult := '정상적으로 수정하였습니다.';
    
EXCEPTION
	WHEN OTHERS THEN
		presult := '수정을 실패하였습니다.'; --실패    

END procUpdateQuestion;

--실행
DECLARE
	vresult VARCHAR2(300);
BEGIN
	procUpdateQuestion(1, '31', '프로시저 생성 문제 질문', vresult);
	DBMS_OUTPUT.PUT_LINE(vresult);
END;

--실행
DECLARE
	vresult VARCHAR2(300);
BEGIN
	procUpdateQuestion(2, '31', '겁나게 어려워부러잉~~~', vresult);
	DBMS_OUTPUT.PUT_LINE(vresult);
END;

SELECT * FROM tblQuestion;


--질의 (질문 삭제)
CREATE OR REPLACE PROCEDURE procDeleteQuestion(
    pstudentNum VARCHAR2,
    pquestionNum VARCHAR2,
    presult OUT VARCHAR2
)
IS
BEGIN

    DELETE FROM tblQuestion WHERE studentNum = pstudentNum AND questionNum = pquestionNum;
    
	presult := '정상적으로 삭제하였습니다.';
    
EXCEPTION
	WHEN OTHERS THEN
		presult := '삭제를 실패하였습니다.'; --실패    

END procDeleteQuestion;

--실행
DECLARE
	vresult VARCHAR2(300);
BEGIN
	procDeleteQuestion('190', '31', vresult);
	DBMS_OUTPUT.PUT_LINE(vresult);
END;


--질문 조회
CREATE OR REPLACE PROCEDURE procSelectQuestion (
    vquestionNum varchar2
)
IS

pinterviewername tblInterviewer.interviewerName%type;
pquestionContent tblQuestion.questionContent%type;
pquestionDate tblQuestion.questionDate%type;
panswerContent tblAnswer.answerContent%type;
pteacherName tblTeacher.teacherName%type;
panswerDate tblAnswer.answerDate%type;


CURSOR vcursor IS

	SELECT i.interviewerName AS "질문 교육생 이름",
		   q.questionContent AS "질문내용",
		   q.questionDate AS "질문 날짜",
		   a.answerContent AS "답변내용",
           t.teacherName AS "답변 교사 이름",
		   a.answerDate AS "답변 날짜"
	FROM tblQuestion q
		LEFT OUTER JOIN tblAnswer a
			ON a.questionNum = q.questionNum
				INNER JOIN tblStudent s
					ON s.studentNum = q.studentNum
						INNER JOIN tblInterviewRegister ir
							ON ir.interviewReginum = s.interviewReginum
								INNER JOIN tblInterviewer i
									ON i.interviewerNum = ir.interviewerNum
										LEFT OUTER JOIN tblTeacher t
											ON t.teacherNum = a.teacherNum
												WHERE q.questionNum = vquestionNum
													ORDER BY lpad(a.questionNum, 5, '0') ASC;
 
BEGIN
    OPEN vcursor;
        LOOP
            FETCH vcursor INTO pinterviewername, pquestionContent, pquestionDate, panswerContent, pteacherName, panswerDate;
        EXIT WHEN vcursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('질문 교육생 이름: ' || pinterviewername);
        IF pteacherName IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE('답변 교사 이름: ' || pteacherName);
        ELSE
            DBMS_OUTPUT.PUT_LINE('답변 교사 이름: X');
        END IF;    
        DBMS_OUTPUT.PUT_LINE('질문 내용: ' || pquestionContent);
        IF panswerContent IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE('답변 내용: ' || panswerContent);
        ELSE
            DBMS_OUTPUT.PUT_LINE('답변 내용: X');
        END IF;        
        DBMS_OUTPUT.PUT_LINE('질문 날짜: ' || pquestionDate);
        IF panswerDate IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE('답변 날짜: ' || panswerDate);
        ELSE
            DBMS_OUTPUT.PUT_LINE('답변 날짜: X');
        END IF;        
        
		DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────────');

        END LOOP;
    CLOSE vcursor;

END procSelectQuestion;

--실행
BEGIN
    procSelectQuestion('30');
END;



-------------------------------D06-01. 과제 제출 및 조회
--입력 (과제 제출)
CREATE OR REPLACE PROCEDURE procInsertAssignmentStudent (
    pAssignmentNum IN VARCHAR2,
    pStudentNum IN VARCHAR2,
    pAssignmentExplain IN VARCHAR2
)
IS
BEGIN
    INSERT INTO tblAssignmentSubmit (assignmentSubmitNum, assignmentNum, studentNum, assignmentExplain)
    VALUES ((SELECT NVL(MAX(LPAD(assignmentSubmitNum, 8, '0')), 0) + 1 FROM tblAssignmentSubmit), pAssignmentNum, pStudentNum, pAssignmentExplain);
	DBMS_OUTPUT.PUT_LINE(pAssignmentExplain || ' 과제를 제출했습니다.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('생성에 실패했습니다.');
END procInsertAssignmentStudent;
/

--입력 프로시저 실행
DECLARE
	vAssignmentNum VARCHAR2(30) := 1; --<과제번호>
    vStudentNum VARCHAR2(30) := 1; --<교육생번호>
    vAssignmentExplain VARCHAR2(2048) := '자바과제 4풀이'; --<과제풀이>
BEGIN
	procInsertAssignmentStudent(vAssignmentNum, vStudentNum, vAssignmentExplain);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('등록에 실패했습니다.');
END;
/


--출력 (과제를 제출한 학생 명단 출력)
--학생 본인과 동일한 과정을 수강하는 학생의 과제 명단 프로시저
CREATE OR REPLACE PROCEDURE procReadAssignmentStudent (
    pStudentNum IN VARCHAR2,
    pSubjectName IN VARCHAR2,
    pAssignmentCursor OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN pAssignmentCursor FOR
    SELECT
        c.courseName AS 과정명,
        s.subjectName AS 과목명,
        a.assignmentContent AS 과제명,
        sb.assignmentSubmitNum AS 과제제출번호,
        st.studentName AS 교육생이름,
        sb.assignmentExplain AS 과제풀이
    FROM tblAssignmentSubmit sb
        INNER JOIN tblAssignment a
            ON a.assignmentNum = sb.assignmentNum
                INNER JOIN tblSubjectDetail sd
                    ON a.subjectDetailNum = sd.subjectDetailNum
                        INNER JOIN tblSubject s
                            ON s.subjectNum = sd.subjectNum
                                INNER JOIN tblCourseDetail cd
                                    ON cd.courseDetailNum = sd.courseDetailNum
                                        INNER JOIN tblCourse c
                                            ON c.courseNum = cd.courseNum
                                                INNER JOIN vwStudent st
                                                    ON st.studentNum = sb.studentNum
    WHERE (c.courseName, s.subjectName)
    IN (
        SELECT
            c2.courseName,
            s2.subjectName
        FROM tblAssignmentSubmit sb2
            INNER JOIN tblAssignment a2
                ON a2.assignmentNum = sb2.assignmentNum
                    INNER JOIN tblSubjectDetail sd2
                        ON a2.subjectDetailNum = sd2.subjectDetailNum
                            INNER JOIN tblSubject s2
                                ON s2.subjectNum = sd2.subjectNum
                                    INNER JOIN tblCourseDetail cd2
                                        ON cd2.courseDetailNum = sd2.courseDetailNum
                                            INNER JOIN tblCourse c2
                                                ON c2.courseNum = cd2.courseNum
                                                    INNER JOIN vwStudent st2
                                                        ON st2.studentNum = sb2.studentNum
        WHERE sb2.studentNum = pStudentNum --교육생번호
        AND s.subjectName = pSubjectName --과목명
    )
    ORDER BY c.courseName, s.subjectName, sb.studentNum, sb.assignmentSubmitNum;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('생성에 실패했습니다.');
END procReadAssignmentStudent;
/


--학생 본인과 동일한 과정을 수강하는 학생의 과제 명단 프로시저 호출
DECLARE
	vStudentNum tblStudent.studentNum%TYPE := 1; --<교육생번호>
    vSubjectName tblSubject.subjectName%TYPE := 'CSS'; --<과목명>
    vAssignmentCursor SYS_REFCURSOR;
    vCourseName tblCourse.courseName%TYPE;
    vAssignmentName tblAssignment.assignmentContent%TYPE;
    vAssignmentSubmitNum tblAssignmentSubmit.assignmentSubmitNum%TYPE;
    vStudentName tblInterviewer.interviewerName%TYPE;
    vAssignmentExplanation tblAssignmentSubmit.assignmentExplain%TYPE;
BEGIN
    procReadAssignmentStudent(vStudentNum, vSubjectName, vAssignmentCursor); --과제를 제출한 학생 명단을 가져옴

    DBMS_OUTPUT.PUT_LINE('──────────────────── 교육생 제출 과제 조회 ────────────────────');
    LOOP
        FETCH vAssignmentCursor INTO
            vCourseName,
            vSubjectName,
            vAssignmentName,
            vAssignmentSubmitNum,
            vStudentName,
            vAssignmentExplanation;
        EXIT WHEN vAssignmentCursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('과정명: ' || vCourseName);
        DBMS_OUTPUT.PUT_LINE('과목명: ' || vSubjectName);
        DBMS_OUTPUT.PUT_LINE('과제명: ' || vAssignmentName);
        DBMS_OUTPUT.PUT_LINE('과제제출번호: ' || vAssignmentSubmitNum);
        DBMS_OUTPUT.PUT_LINE('교육생이름: ' || vStudentName);
        DBMS_OUTPUT.PUT_LINE('과제풀이: ' || vAssignmentExplanation);
        DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────────');
    END LOOP;
    CLOSE vAssignmentCursor;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('과제 명단 조회에 실패했습니다.');
END;
/


--수정 (과제 제출 수정)
CREATE OR REPLACE PROCEDURE procUpdateAssignmentStudent (
    pAssignmentSubmitNum IN VARCHAR2,
    pAssignmentNum IN VARCHAR2,
    pStudentNum IN VARCHAR2,
    pAssignmentExplain IN VARCHAR2
)
IS
BEGIN
    UPDATE tblAssignmentSubmit
    SET assignmentNum = pAssignmentNum, studentNum = pStudentNum, assignmentExplain = pAssignmentExplain
    WHERE assignmentSubmitNum = pAssignmentSubmitNum;
   	DBMS_OUTPUT.PUT_LINE(pAssignmentExplain || ' 제출 과제를 수정했습니다.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('생성에 실패했습니다.');
END procUpdateAssignmentStudent;
/

--수정 프로시저 실행
DECLARE
	vAssignmentSubmitNum VARCHAR(30) := 2639; --<과제제출번호>
	vAssignmentNum VARCHAR2(30) := 1; --<과제번호>
    vStudentNum VARCHAR2(30) := 1; --<교육생번호>
    vAssignmentExplain VARCHAR2(2048) := '자바과제 4풀이 심화'; --<과제풀이>
BEGIN
	procUpdateAssignmentStudent(vAssignmentSubmitNum, vAssignmentNum, vStudentNum, vAssignmentExplain);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('갱신에 실패했습니다.');
END;
/
select * FROM tblAssignmentSubmit;

--삭제 (과제 제출 삭제)
CREATE OR REPLACE PROCEDURE procDeleteAssignmentStudent (
    pAssignmentSubmitNum IN VARCHAR2
)
IS
BEGIN
    DELETE FROM tblAssignmentSubmit WHERE assignmentSubmitNum = pAssignmentSubmitNum;
   	DBMS_OUTPUT.PUT_LINE(pAssignmentSubmitNum || ' 번 제출 과제를 삭제했습니다.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('생성에 실패했습니다.');
END procDeleteAssignmentStudent;
/

--삭제 프로시저 실행
DECLARE
	vAssignmentSubmitNum VARCHAR2(30) := 9078; --<과제제출번호>
BEGIN
	procDeleteAssignmentStudent(vAssignmentSubmitNum);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('삭제에 실패했습니다.');
END;
/


-------------------------------D07-01. 비품 교체 신청
--1. 교육생은 비품에 대해 교체 신청 사유를 기재하여 교체 신청을 할 수 있다.
--교사 쪽 비품 교체 신청 프로시저 동일(procApplyChangeItem)
CREATE OR REPLACE PROCEDURE procApplyChangeItem(
    pitemDetailNum VARCHAR2,
    pitemChangeReason VARCHAR2,
    presult OUT VARCHAR2
)
IS
BEGIN
    INSERT INTO tblitemChange (itemChangeNum, itemDetailNum, itemChangeReason, ISReplacement, itemChangeDate)
			VALUES ((SELECT NVL(MAX(LPAD(itemChangeNum, 5, '0')), 0) + 1 FROM tblitemChange), pitemDetailNum, pitemChangeReason, 0, SYSDATE);
    presult := '비품 교체 신청 등록 성공했습니다.';   --성공
EXCEPTION
    WHEN OTHERS THEN
        presult := '비품 교체 신청 등록 실패했습니다.';   --실패    
END procApplyChangeItem; 
/

DECLARE
    vresult VARCHAR2(100);
BEGIN
    procApplyChangeItem('806', '허수경 뿌심', vresult);
    DBMS_OUTPUT.PUT_LINE(vresult);
END;
/


--조회(출입카드)
CREATE OR REPLACE PROCEDURE procCard(
    pstudentnum VARCHAR2
)
IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('──────────────────── 출입카드 정보 ─────────────────────');
    FOR cards in (
        
       SELECT
            c.accessCardNum AS 출입카드번호,
            v.studentname AS 교육생이름,
            c.ISAccessCard AS 배부여부
        FROM tblAccessCard c
            INNER JOIN vwstudent v	
                ON c.studentnum = v.studentnum
         WHERE v.studentnum = pstudentnum
        ORDER BY TO_NUMBER(c.accessCardNum)
       
    
    )
    LOOP
    DBMS_OUTPUT.PUT_LINE('출입카드번호: ' || cards.출입카드번호);
    DBMS_OUTPUT.PUT_LINE('교육생이름: ' || cards.교육생이름);
    DBMS_OUTPUT.PUT_LINE('배부여부: ' || cards.배부여부);
    DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────────');
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('출입카드 정보 조회에 실패했습니다.');
END procCard;
/
 
DECLARE
BEGIN
    procCard('1');
END;
/



-------------------------------D08-01. 우수 교육생 수상
--학생 기능 > 과정 선택 시 조회 > 관리자 & 교사 조회 화면과 문구 상이
-- ****************************************************** 로그인 시, 사용자의 정보가 tblLogin에 들어간다는 가정 하 **************************************************************
-- ****************************************************** 매개변수 없이 tblLogin에 담긴 정보를 가지고 확인하는 쿼리 *************************************************************
----------------------------------------------------- [로그인한 사용자의 우수 교육생 내역 조회] ------------------------------------------------------------------------------
-- [매개변수 없는 Ver. 프로시저 생성]
/
CREATE OR REPLACE PROCEDURE procMyPrize
IS
    vnum NUMBER; --로그인한 사용자의 교육생 번호를 담는 변수
    vcnt NUMBER; --사용자의 교육생 번호가 '상' 테이블에 존재하는 개수를 담는 변수 
BEGIN
    -- 로그인한 상태(로그인 테이블에 id, pw가 들어가 있다는 가정 하에 해당 로그인한 학생의 우수 교육생 내역 조회)
    SELECT
        studentNum 
      INTO vnum
      FROM vwStudent vs
            INNER JOIN tblLogin l
                ON l.pw = substr(vs.studentSsn,8,7)
     WHERE vs.studentName = l.id;
     
     SELECT
        count(*) 
       INTO vcnt
       FROM tblPrize
      WHERE studentNum = vnum;
        
    DBMS_OUTPUT.PUT_LINE('─────────────── 우수 교육생 수상 내역 조회 ───────────────');
    
    IF vcnt > 0 THEN --로그인한 사용자의 교육생 번호와 일치하는 레코드가 '상' 테이블에 있을 경우 내역 출력
        
        FOR best IN (
          SELECT
                vs.studentNum AS "교육생 번호",
                vs.studentName AS "교육생 이름",
                cs.courseName AS 과정명,
                cs.courseStartDate AS "과정 시작일",
                cs.courseEndDate AS "과정 종료일",
                p.prizeCategory AS 부문
            FROM tblPrize p
                INNER JOIN vwStudent vs
                    ON vs.studentNum = p.studentNum
                INNER JOIN vwCompletionStatus cs
                    ON cs.studentNum = vs.studentNum
           WHERE p.studentNum = vnum
           ORDER BY 부문 DESC
        )
        LOOP
            DBMS_OUTPUT.PUT_LINE('' || best."교육생 이름" || '님, ' || best.부문 || ' 학생 선정을 축하합니다!');
            DBMS_OUTPUT.PUT_LINE(' ');
            DBMS_OUTPUT.PUT_LINE('부문: ' || best.부문);
            DBMS_OUTPUT.PUT_LINE('교육생 번호: ' || best."교육생 번호");
            DBMS_OUTPUT.PUT_LINE('교육생 이름: ' || best."교육생 이름");
            DBMS_OUTPUT.PUT_LINE('과정명: ' || best.과정명);
            DBMS_OUTPUT.PUT_LINE('과정 시작일: ' || best."과정 시작일");
            DBMS_OUTPUT.PUT_LINE('과정 종료일: ' || best."과정 종료일");
            DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────');
        END LOOP;
    ELSE --'상' 테이블에 로그인한 사용자의 교육생 번호 레코드가 존재하지 않을 경우 하기 문구 출력
        DBMS_OUTPUT.PUT_LINE('해당 내역이 존재하지 않습니다.');
            DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('우수 교육생 수상 내역 조회에 실패했습니다.');
--    RAISE_APPLICATION_ERROR(-10001, '우수 교육생 수상 내역 조회에 실패했습니다.');
END procMyPrize;
/

-- [매개변수 없는 Ver. 프로시저 실행]
/
BEGIN
    procMyPrize;
END;
/

----------------------------------------------------- [본인이 수강한 과정의 우수 교육생 조회] ------------------------------------------------------------------------------
-- [매개변수 없는 Ver. 프로시저 생성]
/
CREATE OR REPLACE PROCEDURE proc_My_Cs_Prize
IS
    vnum NUMBER; --로그인한 사용자의 과정 상세 번호를 담는 변수
    vcnt NUMBER; --해당 개설 과정의 번호가 '상' 테이블에 존재하는 개수를 담는 변수
BEGIN
    -- 로그인한 상태(로그인 테이블에 id, pw가 들어가 있다는 가정 하에 해당 로그인한 학생이 수강중인 과정의 우수 교육생 내역 조회)
    SELECT
        s.courseDetailNum
      INTO vnum
      FROM vwStudent vs
           INNER JOIN tblStudent s
                   ON s.studentNum = vs.studentNum
           INNER JOIN tblLogin l
                   ON l.pw = substr(vs.studentSsn,8,7)
     WHERE vs.studentName = l.id;
     
     SELECT
        count(*) 
       INTO vcnt
       FROM tblPrize p
            INNER JOIN tblStudent s
                    ON s.studentNum = p.studentNum
      WHERE s.courseDetailNum = vnum;
        
    DBMS_OUTPUT.PUT_LINE('──────────────────── 우수 교육생 조회 ─────────────────────');
    
    IF vcnt > 0 THEN --로그인한 사용자의 과정 상세 번호와 일치하는 레코드가 '상' 테이블에 있을 경우 내역 출력
        
        FOR best IN (
          SELECT
                vs.studentNum AS "교육생 번호",
                vs.studentName AS "교육생 이름",
                cs.courseName AS 과정명,
                cs.courseStartDate AS "과정 시작일",
                cs.courseEndDate AS "과정 종료일",
                p.prizeCategory AS 부문
            FROM tblPrize p
                INNER JOIN vwStudent vs
                    ON vs.studentNum = p.studentNum
                INNER JOIN vwCompletionStatus cs
                    ON cs.studentNum = vs.studentNum
           WHERE cs.courseDetailNum = vnum
           ORDER BY 부문 DESC, TO_NUMBER("교육생 번호") ASC
        )
        LOOP
            DBMS_OUTPUT.PUT_LINE('부문: ' || best.부문);
            DBMS_OUTPUT.PUT_LINE('교육생 번호: ' || best."교육생 번호");
            DBMS_OUTPUT.PUT_LINE('교육생 이름: ' || best."교육생 이름");
            DBMS_OUTPUT.PUT_LINE('과정명: ' || best.과정명);
            DBMS_OUTPUT.PUT_LINE('과정 시작일: ' || best."과정 시작일");
            DBMS_OUTPUT.PUT_LINE('과정 종료일: ' || best."과정 종료일");
            DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────');
        END LOOP;
    ELSE --'상' 테이블에 로그인한 사용자의 과정 상세 번호와 일치하는 레코드가 존재하지 않을 경우 하기 문구 출력
        DBMS_OUTPUT.PUT_LINE('해당 내역이 존재하지 않습니다.');
    DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('우수 교육생 조회에 실패했습니다.');
--        RAISE_APPLICATION_ERROR(-10001, '우수 교육생 조회에 실패했습니다.');
END proc_My_Cs_Prize;
/

-- [매개변수 없는 Ver. 프로시저 실행]
/
BEGIN
    proc_My_Cs_Prize;
END;
/






-- ****************************************************** tblLogin 테이블 사용 없이 ID, PW를 입력받는다는 가정 하 *************************************************************
-- ****************************************************** 매개변수가 있는, 입력받은 값을 기준으로 확인하는 쿼리    *************************************************************
----------------------------------------------------- [로그인한 사용자의 우수 교육생 내역 조회] ------------------------------------------------------------------------------
-- [매개변수 있는 Ver. 프로시저 생성]
/
CREATE OR REPLACE PROCEDURE procMyPrize(
    pid VARCHAR2, --로그인 id
    ppw VARCHAR2 --로그인 pw
)
IS
    vnum NUMBER; --로그인한 사용자의 교육생 번호를 담는 변수
    vcnt NUMBER; --사용자의 교육생 번호가 '상' 테이블에 존재하는 개수를 담는 변수 
BEGIN
    -- 로그인한 상태(프로시저 파라미터로 id, pw를 받아서 해당 로그인한 학생의 우수 교육생 내역 조회)
    SELECT
        studentNum 
      INTO vnum
      FROM vwStudent
     WHERE studentName = pid
       AND substr(studentSsn,8,7) = ppw;
     
     SELECT
        count(*) 
       INTO vcnt
       FROM tblPrize
      WHERE studentNum = vnum;
        
    DBMS_OUTPUT.PUT_LINE('───────────────── 우수 교육생 수상 내역 조회 ────────────────');
    
    IF vcnt > 0 THEN --로그인한 사용자의 교육생 번호와 일치하는 레코드가 '상' 테이블에 있을 경우 내역 출력
        
        FOR best IN (
          SELECT
                vs.studentNum AS "교육생 번호",
                vs.studentName AS "교육생 이름",
                cs.courseName AS 과정명,
                cs.courseStartDate AS "과정 시작일",
                cs.courseEndDate AS "과정 종료일",
                p.prizeCategory AS 부문
            FROM tblPrize p
                INNER JOIN vwStudent vs
                    ON vs.studentNum = p.studentNum
                INNER JOIN vwCompletionStatus cs
                    ON cs.studentNum = vs.studentNum
           WHERE p.studentNum = vnum
           ORDER BY 부문 DESC
        )
        LOOP
            DBMS_OUTPUT.PUT_LINE('' || best."교육생 이름" || '님, ' || best.부문 || ' 학생 선정을 축하합니다!');
            DBMS_OUTPUT.PUT_LINE(' ');
            DBMS_OUTPUT.PUT_LINE('부문: ' || best.부문);
            DBMS_OUTPUT.PUT_LINE('교육생 번호: ' || best."교육생 번호");
            DBMS_OUTPUT.PUT_LINE('교육생 이름: ' || best."교육생 이름");
            DBMS_OUTPUT.PUT_LINE('과정명: ' || best.과정명);
            DBMS_OUTPUT.PUT_LINE('과정 시작일: ' || best."과정 시작일");
            DBMS_OUTPUT.PUT_LINE('과정 종료일: ' || best."과정 종료일");
            DBMS_OUTPUT.PUT_LINE('─────────────────────────────────────────────────────────────');
        END LOOP;
    ELSE --'상' 테이블에 로그인한 사용자의 교육생 번호 레코드가 존재하지 않을 경우 하기 문구 출력
        DBMS_OUTPUT.PUT_LINE('해당 내역이 존재하지 않습니다.');
        DBMS_OUTPUT.PUT_LINE('─────────────────────────────────────────────────────────────');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('우수 교육생 수상 내역 조회에 실패했습니다.');
--    RAISE_APPLICATION_ERROR(-10001, '우수 교육생 수상 내역 조회에 실패했습니다.');
END procMyPrize;
/
-- [매개변수 있는 Ver. 프로시저 실행]
--- 1. 내역이 존재하는 Case
/
BEGIN
	procMyPrize('최빈수', '1808966'); -- 로그인 사용자 id, pw 입력
END;
/
--- 2. 내역이 존재하지 않는 Case
/
BEGIN
	procMyPrize('이우현', '1427956'); -- 로그인 사용자 id, pw 입력
END;
/

----------------------------------------------------- [본인이 수강한 과정의 우수 교육생 조회] ------------------------------------------------------------------------------
-- [매개 변수 있는 ver. 프로시저 생성]
/
CREATE OR REPLACE PROCEDURE proc_My_Cs_Prize(
    pid VARCHAR2, --로그인 id
    ppw VARCHAR2 --로그인 pw
)
IS
    vnum NUMBER; --로그인한 사용자의 과정 상세 번호를 담는 변수
    vcnt NUMBER; --해당 개설 과정의 번호가 '상' 테이블에 존재하는 개수를 담는 변수
BEGIN
    -- 로그인한 상태(프로시저 파라미터로 id, pw를 받아서 해당 로그인한 학생이 수강한 과정의 우수 교육생 조회)
    SELECT
        s.courseDetailNum
      INTO vnum
      FROM vwStudent vs
           INNER JOIN tblStudent s
                   ON s.studentNum = vs.studentNum
     WHERE vs.studentName = pid
       AND substr(vs.studentSsn,8,7) = ppw;
     
     SELECT
        count(*) 
       INTO vcnt
       FROM tblPrize p
            INNER JOIN tblStudent s
                    ON s.studentNum = p.studentNum
      WHERE s.courseDetailNum = vnum;
        
    DBMS_OUTPUT.PUT_LINE('───────────────────── 우수 교육생 조회 ──────────────────────');
    
    IF vcnt > 0 THEN --로그인한 사용자의 과정 상세 번호와 일치하는 레코드가 '상' 테이블에 있을 경우 내역 출력
        
        FOR best IN (
          SELECT
                vs.studentNum AS "교육생 번호",
                vs.studentName AS "교육생 이름",
                cs.courseName AS 과정명,
                cs.courseStartDate AS "과정 시작일",
                cs.courseEndDate AS "과정 종료일",
                p.prizeCategory AS 부문
            FROM tblPrize p
                INNER JOIN vwStudent vs
                    ON vs.studentNum = p.studentNum
                INNER JOIN vwCompletionStatus cs
                    ON cs.studentNum = vs.studentNum
           WHERE cs.courseDetailNum = vnum
           ORDER BY 부문 DESC, TO_NUMBER("교육생 번호") ASC
        )
        LOOP
            DBMS_OUTPUT.PUT_LINE('부문: ' || best.부문);
            DBMS_OUTPUT.PUT_LINE('교육생 번호: ' || best."교육생 번호");
            DBMS_OUTPUT.PUT_LINE('교육생 이름: ' || best."교육생 이름");
            DBMS_OUTPUT.PUT_LINE('과정명: ' || best.과정명);
            DBMS_OUTPUT.PUT_LINE('과정 시작일: ' || best."과정 시작일");
            DBMS_OUTPUT.PUT_LINE('과정 종료일: ' || best."과정 종료일");
            DBMS_OUTPUT.PUT_LINE('─────────────────────────────────────────────────────────────');
        END LOOP;
    ELSE --'상' 테이블에 로그인한 사용자의 과정 상세 번호와 일치하는 레코드가 존재하지 않을 경우 하기 문구 출력
        DBMS_OUTPUT.PUT_LINE('해당 내역이 존재하지 않습니다.');
        DBMS_OUTPUT.PUT_LINE('─────────────────────────────────────────────────────────────');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('우수 교육생 조회에 실패했습니다.');
--        RAISE_APPLICATION_ERROR(-10001, '우수 교육생 조회에 실패했습니다.');
END proc_My_Cs_Prize;
/
-- [매개변수 있는 Ver. 프로시저 실행]
--- 1. 내역이 존재하는 Case
/
BEGIN
	proc_My_Cs_Prize('최빈수', '1808966'); -- 로그인 사용자 id, pw 입력
END;
/
--- 2. 내역이 존재하지 않는 Case
/
BEGIN
	proc_My_Cs_Prize('최혜소', '2170817'); -- 로그인 사용자 id, pw 입력
END;
/


-------------------------------D09-01. 교육생 지원금 수급
CREATE OR REPLACE PROCEDURE procStudentSupply (
    pCourseNum IN VARCHAR2,
    pSupplyCursor OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN pSupplyCursor FOR
    SELECT
		*
    FROM vwStudentSupply
    WHERE courseNum = pCourseNum; --과정번호
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('생성에 실패했습니다.');
END procStudentSupply;
/

--교육생 수급 내역 프로시저 호출
DECLARE
    vSupplyCursor SYS_REFCURSOR; --cursor
    vCourseNum tblCourse.courseNum%TYPE := 1; --<과정번호>
    vRow vwStudentSupply%ROWTYPE;
BEGIN
    procStudentSupply(vCourseNum, vSupplyCursor); --procStudentSupply 호출

    DBMS_OUTPUT.PUT_LINE('────────────────────── 교육생 수급 내역 ──────────────────────');
    LOOP
        FETCH vSupplyCursor INTO vRow;
        EXIT WHEN vSupplyCursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('과정명: ' || vRow.courseName);
        DBMS_OUTPUT.PUT_LINE('교육생이름: ' || vRow.interviewerName);
        DBMS_OUTPUT.PUT_LINE('전화번호: ' || vRow.interviewerTel);
        DBMS_OUTPUT.PUT_LINE('수급일: ' || vRow.supplyDate);
        DBMS_OUTPUT.PUT_LINE('수급액: ' || vRow.supplySum);
        DBMS_OUTPUT.PUT_LINE('──────────────────────────────────────────────────────────────');
    END LOOP;
    CLOSE vSupplyCursor;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('교육생 수급 내역 조회에 실패했습니다.');
END;
/
