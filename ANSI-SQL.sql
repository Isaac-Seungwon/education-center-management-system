--ANSI-SQL.sql

-------------------------------A. 공통 기능
-------------------------------A01-01. 로그인
INSERT INTO tblLogin (col, id, pw) VALUES (1,'차민재', '3333332');

SELECT 
    l.id AS "아이디",
    l.pw AS "비밀번호"
FROM tblLogin l 
    INNER JOIN tblAdmin a 
        ON l.id = a.adminName 
            INNER JOIN tblTeacher t 
                ON l.id = t.teacherName 
                    INNER JOIN tblInterviewer i
                        ON l.id = i.interviewerName
                            INNER JOIN tblInterviewRegister r
                                ON i.interviewerNum = r.interviewerNum
                                    INNER JOIN tblStudent s
                                        ON r.interviewRegiNum = s.interviewRegiNum;



-------------------------------A01-02. 로그아웃




-------------------------------A01-03. 학생 생일 조회
/*
SELECT
    i.interviewerName AS "학생 이름",
    SUBSTR(i.interviewerSsn, 3, 2) || '월 ' || SUBSTR(i.interviewerSsn, 5, 2) || '일' AS "생일"
FROM tblInterviewer i
    INNER JOIN tblInterviewRegister r
        ON i.interviewerNum = r.interviewerNum
            INNER JOIN tblStudent s
                ON r.interviewRegiNum = s.interviewRegiNum
                    WHERE SUBSTR(i.interviewerssn, 3, 2) = <원하는 달>
                        ORDER BY "생일" ASC;
*/                       
SELECT
    i.interviewerName AS "학생 이름",
    SUBSTR(i.interviewerSsn, 3, 2) || '월 ' || SUBSTR(i.interviewerSsn, 5, 2) || '일' AS "생일"
FROM tblInterviewer i
    INNER JOIN tblInterviewRegister r
        ON i.interviewerNum = r.interviewerNum
            INNER JOIN tblStudent s
                ON r.interviewRegiNum = s.interviewRegiNum
                    WHERE SUBSTR(i.interviewerssn, 3, 2) = '09'
                        ORDER BY "생일" ASC;




-------------------------------B. 관리자 기능
-------------------------------B01-01. 기초 정보 등록 및 관리
--과정
--기초 정보 관리 (과정 등록)
--INSERT INTO tblCourse (courseNum, courseName) VALUES (<과정 번호>, <추가할 과정명>);
INSERT INTO tblCourse (courseNum, courseName) VALUES (seqCourse.nextVal, 'Java와 함께하는 개발');

--기초 정보 관리 (과정 수정)
--UPDATE tblCourse SET courseName = <바꿀 과정명> WHERE courseNum = <입력 받은 과정 번호>;
UPDATE tblCourse SET courseName = 'C와 함께하는 개발' WHERE courseNum = 20;

--기초 정보 관리 (과정 삭제)
--DELETE FROM tblCourse WHERE courseNum = <삭제할 과정 번호>;
UPDATE tblCourse SET courseName = '-1' WHERE courseNum = 20;

--기초 정보 관리 (과정 조회)
SELECT courseNum AS "과정번호", courseName AS "과정명" FROM tblCourse;


--과목
--기초 정보 관리 (과목 등록)
INSERT INTO tblSubject (subjectNum, subjectName) VALUES (seqSubject.nextVal, 'Unity');
--INSERT INTO tblSubject (SubjectNum, SubjectName) VALUES (<과목 번호>, <추가할 과목명>);

--기초 정보 관리 (과목 수정)
UPDATE tblSubject SET subjectName = 'Unreal Engine' WHERE subjectName = 'Unity';
--UPDATE tblSubject SET subjectName = <바꿀 과목명> WHERE subjectNum = <입력 받은 과목 번호>;

--기초 정보 관리 (과목 삭제)
--DELETE FROM tblSubject WHERE subjectNum = <삭제할 과목 번호>;
UPDATE tblSubject SET subjectName = '-1' WHERE subjectName = 'Unreal Engine';

--기초 정보 관리 (과목 조회)
SELECT subjectNum AS "과목 번호", subjectName AS "과목명" FROM tblSubject;


--강의실
--기초 정보 관리 (강의실 등록)
--INSERT INTO tblLectureRoom (lectureroomnum, capacity) VALUES (<강의실 번호>, <인원 수>);
INSERT INTO tblLectureRoom (lecutreRoomNum, capacity) VALUES (seqLectureRoom.nextVal, 30);
		
--기초 정보 관리 (강의실 수정)
--UPDATE tblLectureRoom SET capacity = <수정할 인원수> WHERE lectureroomnum = <입력 받은 강의실 번호>;
UPDATE tblLectureRoom SET capacity = 26 WHERE tblLectureRoom = '7';
   
--기초 정보 관리 (강의실 삭제)   
--DELETE FROM tblLectureRoom WHERE lectureRoomNum = <삭제할 강의실 번호>; 
UPDATE tblLectureRoom SET capacity = -1 WHERE lectureRoomNum = 7;

--기초 정보 관리 (강의실 조회)   
SELECT lectureRoomNum AS "강의실 번호", capacity AS "인원 수" FROM tblLectureRoom;


--교재
--기초 정보 관리 (교재 등록)
INSERT INTO tblTextBook(textBookNum, textBookName, textBookWriter, textBookPublisher, textBookPrice, subjectNum) 
	VALUES (<교재 번호>, <교재명>, <저자>, <출판사>, <가격>, <과목 번호>);

--기초 정보 관리 (교재 수정)
UPDATE tblTextBook SET textBookName = <수정할 교재명> WHERE textBookNum = <수정할 교재번호>;
UPDATE tblTextBook SET textBookWriter = <수정할 저자> WHERE textBookNum = <수정할 교재번호>;
UPDATE tblTextBook SET textBookPublisher = <수정할 출판사> WHERE textBookNum = <수정할 교재번호>;
UPDATE tblTextBook SET textBookPrice = <수정할 가격> WHERE textBookNum = <수정할 교재번호>;
UPDATE tblTextBook SET subjectNum = <수정할 과목번호> WHERE textBookNum = <수정할 교재번호>;

--기초 정보 관리 (교재 삭제)   
DELETE FROM tblTextBook WHERE textBookNum = <삭제할 교재번호>;

--기초 정보 관리 (교재 조회)   
SELECT textBookNum AS "교재번호",
	   textBookName AS "교재명",
	   textBookWriter AS "저자",
	   textBookPublisher AS "출판사",
	   textBookPrice AS "가격",
	   s.subjectname AS "과목명" 
FROM tblTextBook tb
	INNER JOIN tblSubject s
		ON tb.subjectnum = s.subjectnum;


--도서리스트
SELECT * FROM tblBook;

--도서 추가 (도서번호 , 도서명, 난이도 // bookNum, bookName, bookLevel)
--INSERT INTO tblBook (bookNum, bookName, bookLevel) VALUES (seqBook.nextVal, '혼자 공부하는 SQL',3);
INSERT INTO tblBook (bookNum, bookName, bookLevel) VALUES (seqBook.nextVal,<도서명>,<난이도>);

--도서 수정
/*sss
UPDATE tblBook SET 
    bookName = '혼자 공부하는 파이썬 2',
    bookLevel = 2
        Where bookNum = 77;
*/      
UPDATE tblBook SET 
    bookName = <도서명>,
    bookLevel = <난이도>
        Where bookNum = <수정할 도서 번호>;
 
--도서 삭제(강의교재와 연결되어 있으면 삭제 불가)
--DELETE FROM tblBook WHERE bookNum = 77;
DELETE FROM tblBook WHERE bookNum = <삭제 도서번호>;
 
--도서 조회
SELECT
    bookNum AS "도서번호",
    bookName AS "도서명",
    bookLevel AS "난이도"
FROM tblBook;



-------------------------------B01-02. 교사 정보 등록 및 관리

-- 관리자 (교사 등록)
														
	INSERT INTO tblTeacher(teacherNum, teacherName, teacherSsn, teacherTel, status, workingStartDate, workingEndDate)
		VALUES (<교사 번호>, <교사 이름>, <교사 주민등록번호>, <교사 전화번호>, <상태>, <입사일>, <퇴사일>);
	
	INSERT INTO tblAvilableLecture (availableLectureNum, subjectNum, teacherNum)
		VALUES (<강의가능과목번호>, <과목번호>, <교사번호>);
	
-- 관리자 (교사 수정)
	
	UPDATE tblTeacher SET teacherName = <바꿀 교사 이름> WHERE teacherNum = <바꿀 교사 번호>;
	UPDATE tblTeacher SET teacherSsn = <바꿀 교사 주민등록번호> WHERE teacherNum = <바꿀 교사 번호>;
	UPDATE tblTeacher SET teacherTel = <바꿀 교사 전화번호> WHERE teacherNum = <바꿀 교사 번호>;
	UPDATE tblTeacher SET status = <바꿀 교사 상태> WHERE teacherNum = <바꿀 교사 번호>;
	UPDATE tblTeacher SET workingStartDate = <바꿀 교사 입사일> WHERE teacherNum = <바꿀 교사 번호>;
	UPDATE tblTeacher SET workingEndDate = <바꿀 교사 퇴사일> WHERE teacherNum = <바꿀 교사 번호>;
	
-- 관리자 (교사 삭제)

    DELETE FROM tblAvailableLecture WHERE teacherNum = <삭제할 교사 번호>;
	DELETE FROM tblTeacher WHERE teacherNum = <삭제할 교사 번호>;

-- 관리자 (교사 조회)
														
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
														

--특정 교사 선택 시
SELECT
	s.subjectName AS "과목명",
	sd.subjectStartDate AS "과목시작일",
	sd.subjectEndDate AS "과목종료일",
	tb.textBookName AS "교재명",
	c.courseName AS "과정명",
	cd.courseStartDate AS "과정시작일",
	cd.courseEndDate AS "과정종료일",
	CASE
		WHEN SYSDATE < cd.courseStartDate THEN '강의 예정'
		WHEN SYSDATE BETWEEN cd.courseStartDate AND cd.courseEndDate THEN '강의중'
		WHEN SYSDATE > cd.courseEndDate THEN '강의 종료'
	END AS "강의진행여부"
FROM tblCourseDetail cd
	INNER JOIN tblSubjectDetail sd
		ON cd.courseDetailNum = sd.coursedetailnum
			INNER JOIN tblCourse c
				ON cd.courseNum = c.courseNum
					INNER JOIN tblSubject s
						ON sd.subjectNum = s.subjectNum
							INNER JOIN tblTextBook tb
								ON s.subjectNum = tb.subjectNum
									INNER JOIN tblTeacher t
										ON cd.teacherNum = t.teacherNum
											WHERE t.teacherNum = 1;



-------------------------------B01-03. 개설 과정 등록 및 관리
--개설 과정 관리
--개설 과정 관리 (등록)
INSERT INTO tblCourseDetail (courseDetailNum, courseNum, courseStartDate, courseEndDate, lectureRoomNum, isCourseRun, teacherNum, subjectAmount)
			VALUES (<과정상세번호>, <과정번호(FK)>, <과정시작일>, <과정종료일>, <강의실번호(FK)>, <개설 과정 등록 여부>, <교사번호(FK)>, <과목수>);

--개설 과정 관리 (수정)
UPDATE tblCourseDetail SET courseNum = <변경할 과정번호> WHERE courseDetailNum = <과정 상세번호>;
UPDATE tblCourseDetail SET courseStartDate = <변경할 시작일> WHERE courseDetailNum = <과정 상세번호>;
UPDATE tblCourseDetail SET courseEndDate = <변경할 종료일> WHERE courseDetailNum = <과정 상세번호>;
UPDATE tblCourseDetail SET lectureRoomNum = <변경할 강의실> WHERE courseDetailNum = <과정 상세번호>;
UPDATE tblCourseDetail SET isCourseRun = <변경할 강의진행여부> WHERE courseDetailNum = <과정 상세번호>;
UPDATE tblCourseDetail SET teacherNum = <변경할 강사번호> WHERE courseDetailNum = <과정 상세번호>;
UPDATE tblCourseDetail SET subjectAmount = <변경할 과목수> WHERE courseDetailNum = <과정 상세번호>;
UPDATE tblCourseDetail SET courseNum = 2 WHERE courseDetailNum = 20;

--개설 과정 관리 (삭제)
DELETE FROM tblCourseDetail WHERE courseDetailNum = <과정 상세번호>; 

--개설 과정 관리 (조회)
SELECT
	c.courseName AS "과정명",
	cd.courseStartDate AS "과정시작일",
	cd.courseEndDate AS "과정종료일",
	cd.lectureRoomNum AS "강의실번호",
	CASE
		WHEN cd.isCourseRun = 0 THEN '등록 안됨'
		WHEN cd.isCourseRun = 1 THEN '등록'
	END AS "개설 과정 등록 여부",
	count(c.courseName) AS "교육생 등록 인원"
FROM tblCourseDetail cd
	INNER JOIN tblCourse c
		ON cd.courseNum = c.courseNum
			INNER JOIN tblStudent s
				ON cd.courseDetailNum = s.courseDetailNum
					GROUP BY c.courseName, cd.courseStartDate, cd.courseEndDate, cd.lectureRoomNum, cd.isCourseRun;

--특정 개설 과정 조회
SELECT s.subjectName AS "과목명",
	   sd.subjectStartDate AS "과목 시작일",
	   sd.subjectEndDate AS "과목 종료일",
	   tb.textbookName AS "교재명",
	   t.teacherName AS "교사이름",
	   i.interviewername AS "교육생이름",
	   i.interviewerssn AS "교육생 주민등록번호",
	   i.interviewertel AS "교육생 전화번호",
	   i.interviewerdate AS "교육생 등록일"
FROM tblCourseDetail cd
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
											INNER JOIN tblInterviewRegister ir
												ON ir.interviewReginum = st.interviewReginum
													INNER JOIN tblInterviewer i
														ON i.interviewerNum = ir.interviewerNum
															WHERE cd.coursedetailnum = <조회할 과정상세번호>
																ORDER BY s.subjectname ASC;

--삭제
/*
UPDATE tblCourseDetail SET courseStartDate = '01-01-01', courseEndDate = '01-01-01',subjectAmount = -1 WHERE courseDetailNum = <삭제할 과정 상세리스트 번호>;
*/
UPDATE tblCourseDetail SET courseStartDate = '01-01-01', courseEndDate = '01-01-01',subjectAmount = -1 WHERE courseDetailNum = 20;


--특정 개설 과정 선택
/*
SELECT
	s.subjectName AS "과목명",
	sd.subjectStartDate AS "과목시작일",
	sd.subjectEndDate AS "과목종료일",
	tb.textBookName AS "교재명",
	t.teacherName AS "교사이름"
FROM tblCourseDetail cd
	INNER JOIN tblSubjectDetail sd
		ON cd.courseDetailNum = sd.coursedetailnum
			INNER JOIN tblSubject s
				ON sd.subjectNum = s.subjectNum
					INNER JOIN tblTextBook tb
						ON s.subjectNum = tb.subjectNum
							INNER JOIN tblTeacher t
								ON cd.teacherNum = t.teacherNum
									WHERE cd.courseDetailNum = <특정 과정상세리스트 번호>;
*/
SELECT
	s.subjectName AS "과목명",
	sd.subjectStartDate AS "과목시작일",
	sd.subjectEndDate AS "과목종료일",
	tb.textBookName AS "교재명",
	t.teacherName AS "교사이름"
FROM tblCourseDetail cd
	INNER JOIN tblSubjectDetail sd
		ON cd.courseDetailNum = sd.coursedetailnum
			INNER JOIN tblSubject s
				ON sd.subjectNum = s.subjectNum
					INNER JOIN tblTextBook tb
						ON s.subjectNum = tb.subjectNum
							INNER JOIN tblTeacher t
								ON cd.teacherNum = t.teacherNum
									WHERE cd.courseDetailNum = 1;


--강의 수료 시, 수료 날짜 지정
SELECT * FROM vwCoursecomplete WHERE courseDetailNum = 17;



-------------------------------B01-04. 개설 과목 등록 및 관리
--개설 과목 관리
--개설 과목 관리 (등록)
INSERT INTO tblSubjectDetail (subjectDetailNum, subjectNum, courseDetailNum, subjectStartDate, subjectEndDate)
			VALUES (<과목상세번호>, <과목번호>, <과정상세번호>, <과목시작일>, <과정종료일>);

--개설 과목 관리 (수정)
UPDATE tblSubjectDetail SET subjectNum = <변경할 과목번호> WHERE subjectDetailNum = <과목 상세번호>;
UPDATE tblSubjectDetail SET courseDetailNum = <변경할 과정 상세번호> WHERE subjectDetailNum = <과목 상세번호>;
UPDATE tblSubjectDetail SET subjectStartDate = <변경할 과목 시작일> WHERE subjectDetailNum = <과목 상세번호>;
UPDATE tblSubjectDetail SET subjectEndDate = <변경할 과목 종료일> WHERE subjectDetailNum = <과목 상세번호>;
UPDATE tblSubjectDetail SET subectNum = 2 WHERE subjectDetailNum = 109;

--개설 과목 관리 (삭제)
DELETE FROM tblSubjectDetail WHERE courseDetailNum = <과목 상세번호>; 
DELETE FROM tblSubjectDetail WHERE subjectDetailNum = 109;

--개설 과목 관리 (조회)
SELECT c.coursename AS "과정명",
	   cd.coursestartdate AS "과정 시작일",
	   cd.courseenddate AS "과정 종료일",
	   cd.lectureroomnum AS "강의실",
	   s.subjectname AS "과목명",
	   sd.subjectstartdate AS "과목 시작일",
	   sd.subjectenddate AS "과목 종료일",
	   tb.textbookname AS "교재명",
	   t.teachername AS "교사이름"
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

--특정 개설과정 선택 조회
SELECT c.coursename AS "과정명",
	   cd.coursestartdate AS "과정 시작일",
	   cd.courseenddate AS "과정 종료일",
	   cd.lectureroomnum AS "강의실",
	   s.subjectname AS "과목명",
	   sd.subjectstartdate AS "과목 시작일",
	   sd.subjectenddate AS "과목 종료일",
	   tb.textbookname AS "교재명",
	   t.teachername AS "교사이름"
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
													WHERE cd.teachernum = al.teachernum AND cd.coursedetailnum = '14'
														ORDER BY c.coursename;


--교사명단 & 강의 가능 과목 비교
/*
SELECT
	s.subjectName AS "과목명",
	t.teacherName AS "강의 가능 교사"
FROM tblAvailableLecture al
	INNER JOIN tblSubject s
		ON al.subjectNum = s.subjectNum
			INNER JOIN tblTeacher t
				ON al.teacherNum = t.teacherNum
					WHERE s.subjectNum = <선택한 과목 번호>;
*/
SELECT
	s.subjectName AS "과목명",
	t.teacherName AS "강의 가능 교사"
FROM tblAvailableLecture al
	INNER JOIN tblSubject s
		ON al.subjectNum = s.subjectNum
			INNER JOIN tblTeacher t
				ON al.teacherNum = t.teacherNum
					WHERE s.subjectNum = 1;
				


-------------------------------B02-01. 교육생 정보 등록 및 명단 조회
--1. 면접에 합격한 지원생은 과정 등록 여부에 따라 교육생 정보가 생성된다. 관리자가 교육생 등록일 및 과정 상세 번호를 입력한다. 주민등록번호 뒷자리는 교육생 본인이 로그인시 패스워드로 사용된다.
--• 교육생 등록일은 등록한 날짜가 자동으로 입력되도록 한다.
--﻿• 교육생 등록 여부 리스트에서 교육생이 등록을 하지 않을 경우 교육생 정보가 생성되지 않는다.
--• 교육생 정보 생성 시, 면접 지원 당시 입력한 정보를 사용한다.
--• 교육생은 하나의 과정만 등록하여 수강이 가능하다.

--[교육생 등록 및 등록 여부 리스트 '등록여부' 변경]
/*
UPDATE tblInterviewRegister SET isEnrollment = 1 WHERE interviewerNum = <교육생 면접번호>;
INSERT INTO tblStudent (studentNum,interviewRegiNum,registrationDate,signUpCnt,courseDetailNum)
			VALUES (seqStudent.nextVal, <교육생 등록여부 번호>, SYSDATE, 1, <과정 상세 번호>);
*/
UPDATE tblInterviewRegister SET isEnrollment = 1 WHERE interviewerNum = 656;
INSERT INTO tblStudent (studentNum,interviewRegiNum,registrationDate,signUpCnt,courseDetailNum)
			VALUES (seqStudent.nextVal, 524, SYSDATE, 1, '16');

--[교육생 미등록]
--> 교육생 등록 여부 리스트에 DEFAULT값으로 '0'이 입력되므로 추가 업무 불요.

--2. 교육생 정보에 대한 입력, 출력, 수정, 삭제 기능을 사용할 수 있어야 한다.
--[입력]
--> 위 1번에서 구현

--[출력]
--> 아래 3번에서 구현

--[수정]
/*
UPDATE tblInterviewer SET interviewerName = <교육생 이름>, interviewerSsn = <주민등록번호>, interviewerTel = <전화번호> WHERE interviewerNum = <교육생 면접 번호>;
*/
UPDATE tblInterviewer SET interviewerName = '박쿼리', interviewerSsn = '200101-1020304', interviewerTel = '010-5555-6666' WHERE interviewerNum = 664;

--[삭제]
/*
UPDATE tblStudent SET registrationDate = '01-01-01', signUpCnt = -1 WHERE studentNum = <교육생 번호>;
*/
UPDATE tblStudent SET registrationDate = '01-01-01', signUpCnt = -1 WHERE studentNum = 526;

--3. 교육생 정보 출력시 교육생 번호, 이름, 주민등록번호, 전화번호, 등록일, 수강(신청) 횟수를 출력한다.
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
				ON r.interviewRegiNum = s.interviewRegiNum;
		

--4. 특정 교육생 선택시 교육생 번호, 교육생 이름, 교육생이 수강 신청한 또는 수강중인, 수강했던 개설 과정 정보(과정명, 과정기간(시작 년월일, 끝 년월일), 강의실, 수료 및 중도탈락 여부, 수료 및 중도탈락 날짜)를 출력한다.
--﻿• 교육생 정보를 쉽게 확인하기 위한 검색 기능을 사용할 수 있어야 한다.

--[VIEW 생성]			
CREATE OR REPLACE VIEW vwCompletionStatus
AS
SELECT
    s.studentNum AS studentNum,
    vs.studentName AS studentName,
    cd.courseDetailNum AS courseDetailNum,
    cs.courseNum AS courseNum,
   cs.courseName AS courseName,
   TO_CHAR(cd.courseStartDate,'YYYY-MM-DD') AS courseStartDate,
   TO_CHAR(cd.courseEndDate,'YYYY-MM-DD') AS courseEndDate,
   cd.lectureRoomNum AS lectureRoomNum,
   CASE 
      WHEN c.studentNum IS NOT NULL THEN '수료'
      WHEN f.studentNum IS NOT NULL THEN '중도 탈락'
      WHEN TO_CHAR(cd.courseStartDate,'YYYY-MM-DD') > TO_CHAR(SYSDATE,'YYYY-MM-DD') THEN '진행 예정'
      ELSE '진행중'
   END AS completionStatus,
   CASE
      WHEN c.studentNum IS NOT NULL THEN TO_CHAR(c.completeDate,'YYYY-MM-DD')
      WHEN f.studentNum IS NOT NULL THEN TO_CHAR(f.failDate,'YYYY-MM-DD')
      ELSE NULL
   END AS completionDate
FROM tblStudent s
   INNER JOIN tblCourseDetail cd
      ON s.courseDetailNum = cd.courseDetailNum
         INNER JOIN tblCourse cs
            ON cs.courseNum = cd.courseNum
               FULL OUTER JOIN tblComplete c
                  ON s.studentNum = c.studentNum
                     FULL OUTER JOIN tblFail f
                        ON s.studentNum = f.studentNum
                                    INNER JOIN vwStudent vs
                                        ON s.studentNum = vs.studentNum;			

--[VIEW 사용]
/*
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
	WHERE studentNum = <교육생 번호>;
*/
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
  WHERE studentNum = 514;
                                                            
--5. 교육생에 대한 수료 및 중도 탈락 처리를 할 수 있어야 한다. 수료 또는 중도탈락 날짜를 입력할 수 있어야 한다.

--[수료 처리]
/*
INSERT INTO tblComplete (completeNum, studentNum, completeDate) VALUES (seqComplete.nextVal, <교육생번호>, <수료일>);
*/
INSERT INTO tblComplete (completeNum, studentNum, completeDate) VALUES (seqComplete.nextVal, 528, '2023-09-14');

--[중도 탈락 처리]
/*
INSERT INTO tblFail (failNum, studentNum, failDate, failReason) VALUES (seqFail.nextVal, <교육생 번호>, <탈락일>, <탈락 사유>);
*/
INSERT INTO tblFail (failNum, studentNum, failDate, failReason) VALUES (seqFail.nextVal, 529, '2023-09-14', '개인 사정');

--6. 강의 예정인 과정, 강의 중인 과정, 강의 종료된 과정 중에서 선택한 과정을 신청한 교육생 정보를 확인할 수 있어야 한다.
--교육생 번호, 이름, 주민등록번호, 전화번호, 등록일, 수강(신청) 횟수
--[강의 예정인 과정 > 교육생 정보 조회]
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
 ORDER BY TO_NUMBER("교육생 번호");

--[강의 중인 과정 > 교육생 정보 조회]
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
  ORDER BY TO_NUMBER("교육생 번호");

/
--[강의 종료된 과정 > 교육생 정보 조회]
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
  ORDER BY TO_NUMBER("교육생 번호");



-------------------------------B02-02. 기간별 교육생 상담일지 관리
--1. 교사가 교육생과 상담을 진행한 후 작성한 상담일지를 조회 및 관리한다.
--4. 상담일지에 관한 입력, 출력, 수정, 삭제할 수 있다.
--• 상담일자는 상담일을 기준으로 자동으로 입력되도록 한다.

--[입력]
/*
INSERT INTO tblConsulting (consultingNum, consultingDate, studentNum, teacherNum, consultingContent, isComplete)
			VALUES (seqConsulting.nextVal, <상담 날짜>, <교육생 번호>, <교사 번호>, <상담 내용>, <상담완료여부>);
*/
INSERT INTO tblConsulting (consultingNum, consultingDate, studentNum, teacherNum, consultingContent, isComplete)
			VALUES (seqConsulting.nextVal, SYSDATE, '100', '7', '진로상담', 1);
--[출력]
--> 아래 2,3번에서 구현

--[수정]
/*
UPDATE tblConsulting SET studentNum = <교육생 번호>, teacherNum = <교사 번호>, consultingContent = <상담 내용> WHERE consultingNum = <상담 번호>; 
*/
UPDATE tblConsulting SET studentNum = '1', teacherNum = '5', consultingContent = '기타 상담' WHERE consultingNum = 43; 
--[삭제]
/*
DELETE FROM tblConsulting WHERE consultingNum = <상담 번호>;
*/
DELETE FROM tblConsulting WHERE consultingNum = 31;


--2. 전체 상담일지 출력 시 교육생 번호, 교육생 이름, 상담날짜, 상담 교사, 상담 내용을 출력한다.
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
  ORDER BY "상담 날짜";

--3. 특정 상담일지 선택 시 교육생이 수강 신청한 또는 수강중인, 수강했던 개설 과정 정보(과정명, 과정기간(시작 년월일, 끝 년월일), 강의실, 수료 및 중도탈락 여부, 수료 및 중도탈락 날짜)를 출력하고, 상담일지의 정보(교사명, 상담일자, 상담내용)를 출력한다.
/*
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
		WHEN TO_CHAR(cd.courseStartDate,'YYYY-MM-DD') > TO_CHAR(SYSDATE,'YYYY-MM-DD') THEN '진행 예정'
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
															WHERE cst.consultingNum = <상담 번호>;

*/
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
		WHEN TO_CHAR(cd.courseStartDate,'YYYY-MM-DD') > TO_CHAR(SYSDATE,'YYYY-MM-DD') THEN '진행 예정'
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
															WHERE cst.consultingNum = 6;



-------------------------------B03-01. 교육생 시험관리 및 성적조회
--시험리스트
--1. 특정 개설 과정을 선택하는 경우) 등록된 개설 과목 정보를 출력하고, 개설 과목 별로 성적 등록 여부, 시험 문제 파일 등록 여부를 확인할 수 있어야 한다.
/*
SELECT
   DISTINCT cg.coursename AS "과정명",
    cg.subjectname AS "개설 과목",
    CASE 
        WHEN writtenscore is null THEN '입력안함'
        ELSE '입력함'
    END AS "성적 등록 여부",
    t.isregistration AS "시험 문제 등록 여부"
FROM vwCourseGather cg
    left outer join tbltest t
        ON t.subjectDetailNum = cg.subjectDetailNum
            left outer join tbltestscore ts
                ON ts.testnum = t.testnum
                    WHERE cg.coursedetailnum = <과정번호>;
*/
SELECT
   DISTINCT cg.coursename AS "과정명",
    cg.subjectname AS "개설 과목",
    CASE 
        WHEN writtenscore is null THEN '입력안함'
        ELSE '입력함'
    END AS "성적 등록 여부",
    t.isregistration AS "시험 문제 등록 여부"
FROM vwCourseGather cg
    left outer join tbltest t
        ON t.subjectDetailNum = cg.subjectDetailNum
            left outer join tbltestscore ts
                ON ts.testnum = t.testnum
                    WHERE cg.coursedetailnum = 1;


--2. 과목별 출력시) 개설 과정명, 개설 과정기간, 강의실명, 개설 과목명, 교사명, 교재명 등을 출력하고, 해당 개설 과목을 수강한 모든 교육생의 성적 정보(교육생 이름, 주민번호 뒷자리, 필기, 실기)를 같이 출력한다.
/*
SELECT
    cg.courseName AS "과정명",
    cg.courseStartDate || ' ~ ' || cg.courseEndDate AS "과정기간",
    cd.lectureRoomNum AS "강의실명",
    cg.subjectName AS "과목명",
    cg.teacherName AS "교사이름",
    cg.textBookName AS "교재명",
    vs.studentName AS "교육생 이름",
    substr(vs.studentssn,instr(vs.studentssn,'-')+1) AS "주민번호",
    ts.writtenScore AS "필기",
    ts.practicalScore AS "실기"
FROM vwCourseGather cg
    INNER JOIN TBLTEST t
        ON cg.subjectDetailNum = t.subjectDetailNum
            INNER JOIN tbltestScore ts
                ON t.testNum = ts.testNum
                    INNER JOIN tblstudent s
                        ON ts.studentNum = s.studentNum
                            INNER JOIN vwStudent vs
                                ON s.studentNum = vs.studentNum
                                    INNER JOIN tblCourseDetail cd
                                        ON cg.courseDetailNum = cd.courseDetailNum
                                            WHERE cg.subjectName = <과목명>;
*/ 
SELECT
    cg.courseName AS "과정명",
    cg.courseStartDate || ' ~ ' || cg.courseEndDate AS "과정기간",
    cd.lectureRoomNum AS "강의실명",
    cg.subjectName AS "과목명",
    cg.teacherName AS "교사이름",
    cg.textBookName AS "교재명",
    vs.studentName AS "교육생 이름",
    substr(vs.studentssn,instr(vs.studentssn,'-')+1) AS "주민번호",
    ts.writtenScore AS "필기",
    ts.practicalScore AS "실기"
FROM vwCourseGather cg
    INNER JOIN TBLTEST t
        ON cg.subjectDetailNum = t.subjectDetailNum
            INNER JOIN tbltestScore ts
                ON t.testNum = ts.testNum
                    INNER JOIN tblstudent s
                        ON ts.studentNum = s.studentNum
                            INNER JOIN vwStudent vs
                                ON s.studentNum = vs.studentNum
                                    INNER JOIN tblCourseDetail cd
                                        ON cg.courseDetailNum = cd.courseDetailNum
                                            WHERE cg.subjectName = '오라클';
                                            
                                            
--3. 교육생 개인별 출력시) 교육생 이름, 주민번호 뒷자리, 개설 과정명, 개설 과정기간, 강의실명 등을 출력하고, 교육생 개인이 수강한 모든 개설 과목에 대한 성적 정보(개설 과목명, 개설 과목 기간, 교사명, 필기, 실기)를 같이 출력한다.
/*
SELECT
    vs.studentName AS "교육생 이름",
    substr(vs.studentssn,instr(vs.studentssn,'-')+1) AS "주민번호",
    cg.courseName AS "과정명",
    cg.courseStartDate || ' ~ ' || cg.courseEndDate AS "과정기간",
    cd.lectureRoomNum AS "강의실명",
    cg.subjectName AS "과목명",
    cg.subjectStartDate || ' ~ ' || cg.subjectEndDate AS "과목기간",
    cg.teacherName AS "교사이름",
    ts.writtenScore AS "필기",
    ts.practicalScore AS "실기"
FROM vwCourseGather cg
    INNER JOIN TBLTEST t
        ON cg.subjectDetailNum = t.subjectDetailNum
            INNER JOIN tbltestScore ts
                ON t.testNum = ts.testNum
                    INNER JOIN tblstudent s
                        ON ts.studentNum = s.studentNum
                            INNER JOIN vwStudent vs
                                ON s.studentNum = vs.studentNum
                                    INNER JOIN tblCourseDetail cd
                                        ON cg.courseDetailNum = cd.courseDetailNum
                                            WHERE vs.studentName = <교육생이름>;
*/
SELECT
    vs.studentName AS "교육생 이름",
    substr(vs.studentssn,instr(vs.studentssn,'-')+1) AS "주민번호",
    cg.courseName AS "과정명",
    cg.courseStartDate || ' ~ ' || cg.courseEndDate AS "과정기간",
    cd.lectureRoomNum AS "강의실명",
    cg.subjectName AS "과목명",
    cg.subjectStartDate || ' ~ ' || cg.subjectEndDate AS "과목기간",
    cg.teacherName AS "교사이름",
    ts.writtenScore AS "필기",
    ts.practicalScore AS "실기"
FROM vwCourseGather cg
    INNER JOIN TBLTEST t
        ON cg.subjectDetailNum = t.subjectDetailNum
            INNER JOIN tbltestScore ts
                ON t.testNum = ts.testNum
                    INNER JOIN tblstudent s
                        ON ts.studentNum = s.studentNum
                            INNER JOIN vwStudent vs
                                ON s.studentNum = vs.studentNum
                                    INNER JOIN tblCourseDetail cd
                                        ON cg.courseDetailNum = cd.courseDetailNum
                                            WHERE vs.studentName = '최성빈';



-------------------------------B04-01. 교육생 출결관리 및 출결조회
SELECT * FROM tblStudentAttendance;

--특정 과정 출결 현황 조회
SELECT
    attendanceDate AS "날짜",
    studentNum AS "학생 번호",
    CASE
        WHEN isTrady = 0 THEN '정상'
        WHEN isTrady = 1 THEN '지각'
    END AS "상태"
FROM vwCourseAttendance
    WHERE courseDetailNum = 1

UNION

SELECT
    applyDate AS "날짜",
    studentNum AS "학생 번호",
    applyAttendance AS "상태"
FROM vwCourseAttendanceApply
    WHERE courseDetailNum = 1

UNION

SELECT
    regDate AS "날짜",
    NULL AS "학생 번호",
    CASE
        WHEN TO_CHAR(regdate, 'd') IN ('1') THEN '일요일'
        WHEN TO_CHAR(regdate, 'd') IN ('7') THEN '토요일'
    END AS "상태"
FROM vwDate
    WHERE regDate BETWEEN ('22-03-02') AND ('22-08-19') AND TO_CHAR(regDate, 'd') IN ('1', '7')
    
UNION

SELECT
    holiday AS "날짜",
    NULL AS "학생 번호",
    holidayName AS "상태"
FROM tblHoliday
    WHERE holiday BETWEEN ('22-03-02') AND ('22-08-19')
        ORDER BY "날짜" ASC;

    
--한 학생 출결 데이터
SELECT
    attendanceDate AS "날짜",
    CASE
        WHEN isTrady = 0 THEN '정상'
        WHEN isTrady = 1 THEN '지각'
    END AS "상태"
FROM tblStudentAttendance
    WHERE studentNum = 2
    
UNION

SELECT
    applyDate AS "날짜",
    applyAttendance AS "상태"
FROM tblAttendanceApply
    WHERE studentNum = 2

UNION

SELECT
    regDate AS "날짜",
    CASE
        WHEN TO_CHAR(regdate, 'd') IN ('1') THEN '일요일'
        WHEN TO_CHAR(regdate, 'd') IN ('7') THEN '토요일'
    END AS "상태"
FROM vwDate
    WHERE regDate BETWEEN ('22-03-02') AND ('22-08-19') AND TO_CHAR(regDate, 'd') IN ('1', '7')
    
UNION

SELECT
    holiday AS "날짜",
    holidayName AS "상태"
FROM tblHoliday
    WHERE holiday BETWEEN ('22-03-02') AND ('22-08-19');


--기간별 출결 현황 조회
SELECT
    attendanceDate AS "날짜",
    studentNum AS "학생번호",
    CASE
        WHEN isTrady = 0 THEN '정상'
        WHEN isTrady = 1 THEN '지각'
    END AS "상태"
FROM tblStudentAttendance WHERE attendanceDate BETWEEN ('22-03-01') AND ('22-03-31')
    
UNION

SELECT
    applyDate AS "날짜",
    studentNum AS "학생번호",
    applyAttendance AS "상태"
FROM tblAttendanceApply WHERE applyDate BETWEEN ('22-03-01') AND ('22-03-31')

UNION

SELECT
    regDate AS "날짜",
    NULL AS "학생번호",
    CASE
        WHEN TO_CHAR(regdate, 'd') IN ('1') THEN '일요일'
        WHEN TO_CHAR(regdate, 'd') IN ('7') THEN '토요일'
    END AS "상태"
FROM vwDate
    WHERE regDate BETWEEN ('22-03-01') AND ('22-03-31')
    	AND TO_CHAR(regDate, 'd') IN ('1', '7')
    
UNION

SELECT
    holiday AS "날짜",
    NULL AS "학생번호",
    holidayName AS "상태"
FROM tblHoliday
    WHERE holiday BETWEEN ('22-03-01') AND ('22-03-31');



-------------------------------B05-01. 비품 등록 및 관리
--1. 현재 있는 비품 리스트(컴퓨터, 모니터, 키보드 등)을 조회한다.
SELECT
	id.itemdetailnum AS 비품번호,
	i.itemcategory AS 비품분류,
	id.itemname AS 비품명,
	id.itemcondition AS 비품상태,
	id.lectureroomnum AS "비품위치(강의실번호)"
FROM tblitem i
	INNER JOIN tblitemdetail id
		ON i.itemnum = id.itemnum;


--2. 비품이 새로 들어오면 추가한다.
/*
INSERT INTO tblItemDetail (itemDetailNum, itemNum, itemName, itemCondition, lectureRoomNum)
			VALUES (seqItemDetail.nextVal, <비품분류번호>, <비품명>, <비품상태>, <강의실번호>);
*/
INSERT INTO tblItemDetail (itemDetailNum, itemNum, itemName, itemCondition, lectureRoomNum)
			VALUES (seqItemDetail.nextVal, '1', 'Aimecca AM-205LE', '상', '5');	


--3. 비품 수리 신청이 들어오면 확인 후 수리여부를 수정한다.
/*
UPDATE tblitemchange 
	SET isreplacement = '1'
		WHERE itemchangenum = <비품교체신청번호>;
*/
UPDATE tblitemchange 
	SET isreplacement = '1'
		WHERE itemchangenum = '24';


--비품 삭제
--DELETE FROM tblitemdetail WHERE itemdetailnum = <비품상세번호>;
DELETE FROM tblitemdetail WHERE itemdetailnum = '1';



-------------------------------B06-01. 출입 카드 등록 및 관리
--1. 새로 교육생을 등록할 시, 새로운 출입카드를 등록하고 교육생에게 배부한다.
--교육생명단에 INSERT 발생 시, 출입카드리스트에 교육생을 추가하는 프로시저 필요

--INSERT INTO tblAccessCard (accessCardNum, studentNum, isAccessCard) VALUES (seqAccessCard.nextVal, <교육생번호>, <지급여부>);
INSERT INTO tblAccessCard (accessCardNum, studentNum, isAccessCard) VALUES (seqAccessCard.nextVal, '7777', 0);	


--2. 교육생에게 배부한 출입카드에 대해 재발급 신청이 들어올 시, 재발급 신청 사유를 확인할 수 있다.(SELECT)
SELECT
	c.accesscardreissuenum AS 출입카드재발급번호,
	v.studentname AS 교육생이름,
	c.isreissue AS 배부여부,
	c.reissuereason AS 분실사유
FROM tblaccesscardreissue c
	INNER JOIN vwstudent v	
		ON c.studentnum = v.studentnum
ORDER BY to_number(c.accesscardreissuenum);


--3. 재발급 신청이 들어온 교육생에 한해, 새로운 출입카드를 등록하고 배부한다.(update)
/*
UPDATE tblaccesscardreissue
	SET isreissue = '1'
		WHERE accesscardreissuenum = <출입카드재발급번호>;
*/
UPDATE tblaccesscardreissue
	SET isreissue = '1'
		WHERE accesscardreissuenum = '14';



-------------------------------B07-01. 기관 연계회사 등록 및 관리
--1. 연계 회사를 조회하는 경우 기관과 연계된 회사의 이름을 입력하여 회사 정보(회사명, 급여, 회사 위치, 회사 규모), 연계 시작 날짜, 요구하는 과목, 요구 성적을 출력한다.
/*
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
		INNER JOIN tblsubject t
			ON t.subjectnum = r.subjectnum
WHERE c.COMPANYNAME = <회사명>;
 */

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
WHERE c.COMPANYNAME = '삼성';


--2. 연계 회사가 요구하는 과목 및 요구 성적을 만족하는 교육생을 조회하는 경우 조건에 만족하는 교육생을 성적과 출결 정보를 기준으로 내림차순 정렬한다.
/*        
SELECT 
	c.companyname AS 회사명,
	t.subjectname AS 회사요구과목,
	r.score AS 회사요구성적,
	s.studentname AS 교육생이름,
	(ts.attendancescore+ts.writtenscore+ts.practicalscore) AS 교육생성적
FROM TBLCOMPANY c
	INNER JOIN tblrequirement r
	ON c.companynum = r.companynum
		INNER JOIN tblsubject t
			ON t.subjectnum = r.subjectnum
				INNER JOIN tblsubjectdetail sd
					ON sd.subjectnum = r.subjectnum
						INNER JOIN tbltest test
							ON test.subjectdetailnum = sd.subjectdetailnum
								INNER JOIN tbltestscore ts
									ON ts.testnum = test.testnum
										INNER JOIN vwstudent s
											ON s.studentNum = ts.studentnum
WHERE c.COMPANYNAME = <회사명> AND (ts.attendancescore+ts.writtenscore+ts.practicalscore) >= r.score
ORDER BY 교육생성적 desc;
*/                     
SELECT 
	c.companyname AS 회사명,
	t.subjectname AS 회사요구과목,
	r.score AS 회사요구성적,
	s.studentname AS 교육생이름,
	(ts.attendancescore+ts.writtenscore+ts.practicalscore) AS 교육생성적
FROM TBLCOMPANY c
	INNER JOIN tblrequirement r
	ON c.companynum = r.companynum
		INNER JOIN tblsubject t
			ON t.subjectnum = r.subjectnum
				INNER JOIN tblsubjectdetail sd
					ON sd.subjectnum = r.subjectnum
						INNER JOIN tbltest test
							ON test.subjectdetailnum = sd.subjectdetailnum
								INNER JOIN tbltestscore ts
									ON ts.testnum = test.testnum
										INNER JOIN vwstudent s
											ON s.studentNum = ts.studentnum
WHERE c.COMPANYNAME = '와치텍' AND (ts.attendancescore+ts.writtenscore+ts.practicalscore) >= r.score
ORDER BY 교육생성적 desc;


--3. 연계 회사에 재직중인 교육생을 조회하는 경우 회사에 재직중인 교육생이 이전에 수료한 과정명을 출력한다.
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
WHERE c.isconnection = 1
ORDER BY 취업일 DESC;


--4. 연계 회사 등록 및 조건을 입력한다.
--연계 회사 등록
/*
INSERT INTO tblcompany (companyNum, companyName, companyType, companySize, averageSalary, companyLocation, isConnection) 
			VALUES (seqCompany.nextVal, <회사명>, <회사형태>, <회사규모>, <평균급여>, <회사위치>, <연계회사여부>);
*/
INSERT INTO tblcompany (companyNum, companyName, companyType, companySize, averageSalary, companyLocation, isConnection) 
			VALUES (seqCompany.nextVal, '위버로프트', 'IT리더', '스타트업', 3854, '경기 이천시', 0);

--연계 회사 조건 등록
/*		
INSERT INTO tblrequirement (requirementNum, companyNum, subjectNum, score) VALUES (seqRequirement.nextVal, <회사번호>, <과목번호>, <요구성적>);	
*/		
INSERT INTO tblrequirement (requirementNum, companyNum, subjectNum, score) VALUES (seqRequirement.nextVal, 1, 10, 92);

--조건 삭제
/*
DELETE FROM tblrequirement WHERE requirementnum = (SELECT 
													r.companynum
													FROM tblrequirement r
														INNER JOIN tblcompany c
														 ON r.companynum = c.companynum
													WHERE c.companyname=<회사명>);
*/
DELETE FROM tblrequirement WHERE requirementnum = (SELECT 
													r.companynum
													FROM tblrequirement r
														INNER JOIN tblcompany c
														 ON r.companynum = c.companynum
													WHERE c.companyname='지티플러스');


--연계 회사 수정 / 조건 수정
UPDATE tblcompany SET companysize = '대기업' WHERE companynum = '44';

UPDATE tblrequirement 
	SET score = 80 , subjectnum = 30
	WHERE requirementnum ='10';



-------------------------------B08-01. 교육생 면접 및 선발 관리
--1. 면접에 지원한 지원생들의 이름, 주민등록번호, 전화번호, 면접 예정일을 등록한다.

/*
INSERT INTO tblInterviewer (interviewerNum,interviewerName,interviewerSsn,interviewerTel,interviewerDate,isPass)
			VALUES (seqInterviewer.nextVal, <이름>, <주민등록번호>, <전화번호>, <면접일>, <합격여부>);
*/
INSERT INTO tblInterviewer (interviewerNum,interviewerName,interviewerSsn,interviewerTel,interviewerDate,isPass)
			VALUES (seqInterviewer.nextVal, '테스트', '201225-2030405', '010-1234-5678', '2023-09-13' ,null);

--2. 면접 진행 후, 지원생들의 면접 합격 여부를 입력하여 교육생을 선발한다.
--• 면접에 합격한 학생에 한하여 교육생 등록 여부 리스트에 등록된다.

--[합격 처리]
/*
UPDATE tblInterviewer SET isPass = 1 WHERE interviewerNum = <교육생 면접번호>;
INSERT INTO tblInterviewRegister (interviewRegiNum,interviewerNum,isEnrollment) VALUES (seqInterviewRegister.nextVal,<교육생면접번호>,<교육생등록여부>);
*/
UPDATE tblInterviewer SET isPass = 1 WHERE interviewerNum = 656;
INSERT INTO tblInterviewRegister (interviewRegiNum,interviewerNum,isEnrollment)
			VALUES (seqInterviewRegister.nextVal,656,default);	
		
--[불합격 처리]		
/*
UPDATE tblInterviewer SET isPass = 0 WHERE interviewerNum = <교육생 면접번호>;
*/
UPDATE tblInterviewer SET isPass = 0 WHERE interviewerNum = 657;




-------------------------------B09-01. 교사 평가 항목 등록 및 관리
--관리자 (평가 항목 등록)
INSERT INTO tblEstimate(estimateNum, estimateIndex) VALUES (<평가 항목번호>, <추가할 평가 항목>);
												
--관리자 (평가 항목 수정)
UPDATE tblEstimate SET estimateIndex = <수정할 평가 항목> WHERE estimateNum = <수정할 평가 항목번호>;

--관리자 (평가 항목 삭제)
DELETE FROM tblEstimate WHERE estimateNum = <삭제할 평가 항목번호>;

--관리자 (평가 항목 조회)
SELECT estimateNum AS "평가 번호",
	   estimateIndex AS "평가 항목"
FROM tblEstimate;

--관리자 (교사 평가 삭제)
DELETE FROM tblTeacherEstimate WHERE teacherEstiNum = <삭제할 교사 평가번호>;

--관리자 (교사 평가 조회(교사 별))
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
									

--관리자 (교사 평가 조회(특정 교육생))
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
											WHERE te.studentNum = '1';



-------------------------------B10-01. 질의응답 관리
--관리자 (질의 수정)
UPDATE tblQuestion SET questionContent = <바꿀 질문내용> WHERE questionNum = <질문 번호>; 						
										
--관리자 (질의 삭제)
DELETE FROM tblQuestion WHERE questionNum = <삭제할 질문 번호>;
DELETE FROM tblAnswer WHERE questionNum = <삭제할 질문 번호>;

--관리자 (응답 수정)
UPDATE tblAnswer SET answerContent = <바꿀 답변내용> WHERE answerNum = <답변 번호>;

--관리자 (응답 삭제)
DELETE FROM tblAnswer WHERE answerNum = <삭제할 답변 번호>;



-------------------------------B11-01. 우수 교육생 조회
--1. 성적이 우수한 학생은 성적 우수 학생으로 선정한다.
--﻿ • 우수 교육생 및 개근 학생의 선정은 과정의 모든 과목이 끝나고 수료 여부가 결정된 후 선정한다.
--• 우수 교육생은 과정별로 선정한다.
--• 성적이 우수한 학생은 과정에 속한 각 과목의 시험 점수 합계가 가장 높은 학생으로 정의한다.
--> PL/SQL
		
--2. 출결이 우수한 학생은 개근 학생으로 선정한다.
--• 출결이 우수한 학생은 주말, 공휴일을 제외한 정상 수업일에 모두 출석하고, 지각, 조퇴, 외출 등의 이력이 없는 학생으로 정의한다.  
--• 우수 교육생 및 개근 학생의 선정은 과정의 모든 과목이 끝나고 수료 여부가 결정된 후 선정한다.
--• 우수 교육생은 과정별로 선정한다.
--> PL/SQL

--3. 성적 우수 학생, 개근 학생 각 항목별로 과정 상세 번호를 입력 시 우수 교육생 명단 및 해당 교육생의 정보(교육생 번호, 교육생 이름, 수강 과정) 조회가 가능하다.                                       
--관리자 기능
--[특정 과정의 우수 교육생 조회]
/*
SELECT
    vs.studentName,
    p.prizeCategory,
    cs.courseName
FROM tblPrize p
    INNER JOIN vwStudent vs
        ON vs.studentNum = p.studentNum
    INNER JOIN vwCompletionStatus cs
        ON cs.studentNum = vs.studentNum
WHERE cs.courseDetailNum = <과정 상세 번호>
AND p.prizeCategory = '성적우수';
*/
SELECT
    vs.studentNum AS "교육생 번호",
    vs.studentName AS "교육생 이름",
    p.prizeCategory AS "수강 과정",
    cs.courseName AS "부문"
FROM tblPrize p
    INNER JOIN vwStudent vs
        ON vs.studentNum = p.studentNum
    INNER JOIN vwCompletionStatus cs
        ON cs.studentNum = vs.studentNum
WHERE cs.courseDetailNum = 1
AND p.prizeCategory = '성적우수';

--[특정 과정의 개근 학생 조회]
/*
SELECT
    vs.studentNum AS "교육생 번호",
    vs.studentName AS "교육생 이름",
    p.prizeCategory AS "수강 과정",
    cs.courseName AS "부문"
FROM tblPrize p
    INNER JOIN vwStudent vs
        ON vs.studentNum = p.studentNum
    INNER JOIN vwCompletionStatus cs
        ON cs.studentNum = vs.studentNum
WHERE cs.courseDetailNum = <과정 상세 번호>
AND p.prizeCategory = '개근'; 
*/


SELECT
    vs.studentNum AS "교육생 번호",
    vs.studentName AS "교육생 이름",
    p.prizeCategory AS "수강 과정",
    cs.courseName AS "부문"
FROM tblPrize p
    INNER JOIN vwStudent vs
        ON vs.studentNum = p.studentNum
    INNER JOIN vwCompletionStatus cs
        ON cs.studentNum = vs.studentNum
WHERE cs.courseDetailNum = 1
AND p.prizeCategory = '개근';



-------------------------------B12-01. 취업명단 관리
--취업명단 관리 (등록)
INSERT INTO tblJob(jobNum, studentNum, companyNum, jobDate, salary)
	VALUES (<취업 번호>, <교육생 번호>, <회사 번호>, <취업일>, <연봉>);

--취업명단 관리 (수정)
UPDATE tblJob SET companyNum = <수정할 회사 번호> WHERE jobNum = <수정할 취업 번호>;
UPDATE tblJob SET jobDate = <수정할 취업일> WHERE jobNum = <수정할 취업 번호>;
UPDATE tblJob SET salary = <수정할 연봉> WHERE jobNum = <수정할 취업 번호>;
	
--취업명단 관리 (삭제)
DELETE FROM tblJob WHERE jobNum = <삭제할 취업 번호>;

--취업명단 관리 (전체 조회)
SELECT i.interviewerName AS "교육생 이름",
	   c.courseName AS "과정명",
	   t.teacherName AS "교사명",
	   i.interviewerSsn AS "주민등록번호",
	   co.companyName AS "회사명",
	   j.salary AS "연봉",
	   j.jobdate AS "취업일",
	   co.companylocation AS "회사 주소",
	   co.companytype AS "회사형태",
	   co.companysize AS "회사규모"
FROM tblJob j
	INNER JOIN tblStudent s
		ON s.studentNum = j.studentNum
			INNER JOIN tblInterviewRegister ir
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

--취업명단 관리 (특정 회원 조회)
SELECT i.interviewerName AS "교육생 이름",
	   c.courseName AS "과정명",
	   t.teacherName AS "교사명",
	   i.interviewerSsn AS "주민등록번호",
	   co.companyName AS "회사명",
	   j.salary AS "연봉",
	   j.jobdate AS "취업일",
	   co.companylocation AS "회사 주소",
	   co.companytype AS "회사형태",
	   co.companysize AS "회사규모"
FROM tblJob j
	INNER JOIN tblStudent s
		ON s.studentNum = j.studentNum
			INNER JOIN tblInterviewRegister ir
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
															WHERE s.studentnum = <회원 번호>
															ORDER BY i.interviewerName ASC;

--사후관리 (조회) 
SELECT c.courseName,
	   i.interviewerName,
	   i.interviewerTel
FROM tblJob j
	RIGHT OUTER JOIN tblStudent s
		ON s.studentnum = j.studentnum
			INNER JOIN tblCourseDetail cd
				ON cd.coursedetailnum = s.coursedetailnum
					INNER JOIN tblInterviewRegister ir
						ON ir.interviewReginum = s.interviewReginum
							INNER JOIN tblInterviewer i
								ON i.interviewerNum = ir.interviewerNum
									INNER JOIN tblCourse c
										ON c.courseNum = cd.courseNum
											WHERE j.jobnum IS NULL 
												  AND ADD_MONTHS(TO_CHAR(cd.courseEndDate, 'YYYY-MM-DD'), 6) >= SYSDATE
												  AND TO_CHAR(cd.courseEndDate, 'YYYY-MM-DD') <= SYSDATE;




-------------------------------C. 교사 기능
-------------------------------C01-01. 강의 스케줄 조회
--특정 교사의 강의 스케줄을 출력
SELECT
	t.teacherName AS 교사이름,
    c.courseName AS 과정명,
    CASE
      WHEN SYSDATE < cd.courseStartDate THEN '강의예정'
      WHEN SYSDATE BETWEEN cd.courseStartDate AND cd.courseEndDate THEN '강의중'
      WHEN SYSDATE > cd.courseEndDate THEN '강의종료'
	END AS "강의진행여부",
    TO_CHAR(cd.courseStartDate, 'YYYY-MM-DD') AS "과정기간(시작 년월일)",
    TO_CHAR(cd.courseEndDate, 'YYYY-MM-DD') AS "과정기간(끝 년월일)",
    cd.lectureRoomNum AS 강의실,
    s.subjectName AS 과목명,
    TO_CHAR(sd.subjectStartDate, 'YYYY-MM-DD') AS "과목기간(시작 년월일)",
    TO_CHAR(sd.subjectEndDate, 'YYYY-MM-DD') AS "과목기간(끝 년월일)",
    tb.textBookName AS 교재명,
    (
    SELECT
    	COUNT(*)
    FROM tblStudent u
    	WHERE u.courseDetailNum = cd.courseDetailNum
    ) AS "교육생 등록 인원"
FROM tblLectureSchedule l
	INNER JOIN tblSubjectDetail sd
		ON l.subjectDetailNum = sd.subjectDetailNum
			INNER JOIN tblCourseDetail cd
				ON cd.courseDetailNum = sd.courseDetailNum
					INNER JOIN tblCourse c
						ON cd.courseNum = c.courseNum
							INNER JOIN tblSubject s
								ON s.subjectNum = sd.subjectNum
									INNER JOIN tblAvailableLecture al
										ON al.subjectNum = s.subjectNum
											INNER JOIN tblTeacher t
												ON t.teacherNum = al.teacherNum
													LEFT OUTER JOIN tblTextBook tb
														ON s.subjectNum = tb.subjectNum
															WHERE t.teacherNum = 1 --<교사번호>
																ORDER BY 
																    CASE
																        WHEN SYSDATE BETWEEN cd.courseStartDate AND cd.courseEndDate THEN 1
																        WHEN SYSDATE < cd.courseStartDate THEN 2
																        WHEN SYSDATE > cd.courseEndDate THEN 3
																    END,
																    cd.courseStartDate ASC;


--교육중인 과정에 등록된 교육생의 정보 출력
SELECT DISTINCT
	o.courseName AS 과정명,
	i.interviewerName AS 교육생이름,
	i.interviewerTel AS 전화번호,
	TO_CHAR(s.registrationDate, 'YYYY-MM-DD') AS 등록일,
	NVL (
		(SELECT f.failReason
			FROM tblFail f
				WHERE f.studentNum = s.studentNum AND ROWNUM = 1
			), '수료'
	)AS 수료여부
FROM tblLectureSchedule l
	INNER JOIN tblSubjectDetail sd
		ON l.subjectDetailNum = sd.subjectDetailNum
			INNER JOIN tblCourseDetail cd
				ON cd.courseDetailNum = sd.courseDetailNum
					INNER JOIN tblStudent s
						ON cd.courseDetailNum = s.courseDetailNum
							INNER JOIN tblInterviewRegister r
								ON s.interviewRegiNum = r.interviewRegiNum
									INNER JOIN tblInterviewer i
										ON i.interviewerNum = r.interviewerNum
											LEFT OUTER JOIN tblComplete c
												ON c.studentNum = s.studentNum
													LEFT OUTER JOIN tblFail f
														ON c.studentNum = f.studentNum
															INNER JOIN tblCourseDetail cd
																ON s.courseDetailNum = cd.courseDetailNum
																	INNER JOIN tblCourse o
																		ON o.courseNum = cd.courseNum
WHERE cd.courseStartDate <= SYSDATE AND cd.courseEndDate >= SYSDATE --교육중인 과정
ORDER BY o.courseName, i.interviewerName;


--과정기간(끝 년월일)이 현재일 이후면서 '강의 종료'로 전환되지 않는 과정 조회
SELECT
	t.teacherName AS 교사이름,
    c.courseName AS 과정명,
	l.progress AS 강의진행여부,
    TO_CHAR(cd.courseStartDate, 'YYYY-MM-DD') AS "과정기간(시작 년월일)",
    TO_CHAR(cd.courseEndDate, 'YYYY-MM-DD') AS "과정기간(끝 년월일)",
    cd.lectureRoomNum AS 강의실,
    s.subjectName AS 과목명,
    TO_CHAR(sd.subjectStartDate, 'YYYY-MM-DD') AS "과목기간(시작 년월일)",
    TO_CHAR(sd.subjectEndDate, 'YYYY-MM-DD') AS "과목기간(끝 년월일)",
    tb.textBookName AS 교재명,
    (
    SELECT
    	COUNT(*)
    FROM tblStudent u
    	WHERE u.courseDetailNum = cd.courseDetailNum
    ) AS "교육생 등록 인원"
FROM tblLectureSchedule l
	INNER JOIN tblSubjectDetail sd
		ON l.subjectDetailNum = sd.subjectDetailNum
			INNER JOIN tblCourseDetail cd
				ON cd.courseDetailNum = sd.courseDetailNum
					INNER JOIN tblCourse c
						ON cd.courseNum = c.courseNum
							INNER JOIN tblSubject s
								ON s.subjectNum = sd.subjectNum
									INNER JOIN tblAvailableLecture al
										ON al.subjectNum = s.subjectNum
											INNER JOIN tblTeacher t
												ON t.teacherNum = al.teacherNum
													LEFT OUTER JOIN tblTextBook tb
														ON s.subjectNum = tb.subjectNum
															WHERE cd.courseEndDate <= SYSDATE AND l.progress <> '강의종료'
																ORDER BY cd.courseStartDate ASC;



-------------------------------C02-01. 배점 입출력
--1. 자신이 강의를 마친 과목의 목록 중에서 특정 과목을 선택하고 해당 배점 정보를 등록한다. 시험 날짜, 시험 문제를 추가한다. 특정 과목을 과목번호로 선택 시 출결 배점, 필기 배점, 실기 배점, 시험 날짜, 시험 문제를 입력할 수 있는 화면으로 연결되어야 한다.													
--2. 출결, 필기, 실기의 배점 비중은 담당 교사가 과목별로 결정한다.	
--• 출결은 최소 20점 이상이어야 한다.
--• 출결, 필기, 실기의 합은 100점이 되어야 한다.														
														
--[배점 정보 등록 및 시험 날짜, 시험 문제 추가]
--> PL/SQL
														
--[시험 문제 등록(시험 문제 등록 안했을 경우)]
/*
UPDATE tblTest SET isRegistration(시험문제파일등록여부) = 1(등록) WHERE subjectDetailNum = <과목 상세 번호>;
*/
UPDATE tblTest SET isRegistration = 1 WHERE subjectDetailNum = 5;

--[배점 수정]
--> PL/SQL

--3. 배점을 입력한 과목 목록 출력 시 과목상세번호, 과정명, 과정기간(시작 년월일, 끝 년월일), 강의실, 과목명, 과목기간(시작 년월일, 끝 년월일), 교재명, 출결, 필기, 실기 배점 등이 출력된다.
SELECT
    sd.subjectDetailNum AS "과목 상세 번호",
    c.courseName AS 과정명,
    cd.courseStartDate AS "과정 시작일",
    cd.courseEndDate AS "과정 종료일",
    cd.lectureRoomNum AS 강의실,
    s.subjectName AS 과목명,
    sd.subjectStartDate AS "과목 시작일",
    sd.subjectEndDate AS "과목 종료일",
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
  ORDER BY TO_NUMBER("과목 상세 번호");


-------------------------------C03-01. 시험 관리 및 성적 조회
--시험 관리 및 성적 조회(교사)
--1. 자신이 강의를 마친 과목의 목록 중에서 특정 과목을 선택하면, 교육생 정보가 출력되고, 특정 교육생 정보를 선택하면, 해당 교육생의 시험 점수를 입력할 수 있다. 이때, 출결, 필기, 실기 점수를 구분해서 입력한다.
SELECT
    vs.studentNum AS "교육생번호",
    vs.studentName AS "교육생이름",
    vs.studentSsn AS "주민번호",
    vs.studentTel AS "전화번호",
    c.courseName AS "과정명",
    ss.subjectName AS "과목명",
    ls.progress AS "과목진행상태"
FROM tblCourseDetail cd
    INNER JOIN tblCourse c
        ON cd.courseNum = c.courseNum
            INNER JOIN tblTeacher t
                ON cd.teacherNum = t.teacherNum
                    INNER JOIN tblSubjectDetail sd
                        ON cd.courseDetailNum = sd.courseDetailNum
                            INNER JOIN tblSubject ss
                                ON sd.subjectNum = ss.subjectNum
                                    INNER JOIN tblLectureSchedule ls
                                        ON sd.subjectDetailNum = ls.subjectDetailNum
                                            INNER JOIN tblStudent s
                                                ON cd.courseDetailNum = s.courseDetailNum
                                                    INNER JOIN vwStudent vs
                                                        ON s.studentNum = vs.studentNum
                                                            INNER JOIN tblTestScore ts
                                                                ON s.studentNum = ts.studentNum
                                                                    WHERE ls.progress = '강의종료' and ss.subjectName = '자바' and t.teacherName = '곽우갓';


--해당 교육생의 시험 점수를 입력할 수 있다. 이때, 출결, 필기, 실기 점수를 구분해서 입력한다.(프로시저)
/*
INSERT INTO tblTestScore(testScoreNum, testNum, studentNum, attendanceScore, writtenScore, practicalScore) 
            VALUES ((SELECT nvl(max(lpad(testScoreNum, 5, '0')), 0) + 1 FROM tblTestScore), 17, 453, 20, 38, 40);

(SELECT nvl(max(lpad(testScoreNum, 5, '0')), 0) + 1 FROM tblTestScore)
*/


--2. 과목 목록 출력시) 과목번호, 과정명, 과정기간(시작 년월일, 끝 년월일), 강의실, 과목명, 과목기간(시작 년월일, 끝 년월일), 교재명, (출결, 필기, 실기) 배점, 성적 등록 여부 등이 출력되고, 
-- 특정 과목을 과목번호로 선택시 교육생 정보(이름, 전화번호, 수료 또는 중도탈락) 및 성적이 출결, 필기, 실기 점수로 구분되어서 출력한다.
SELECT
    DISTINCT cg.subjectdetailnum "과목번호",
    cg.subjectName AS "과목명",
    cg.courseStartDate || ' ~ ' || cg.courseEndDate AS "과정기간",
    cg.lectureRoomNum AS "강의실",
    cg.courseName AS "과정명",
    cg.subjectStartDate || ' ~ ' || cg.subjectEndDate AS "과목기간",
    cg.textBookName AS "교재명",
    t.attendancePoint AS "출결배점",
    t.writtenPoint AS "필기배점",
    t.practicalPoint AS "실기배점",
    CASE 
        WHEN attendanceScore is null THEN 'X'
        ELSE 'O'
    END AS "출결 등록 여부",
    CASE 
        WHEN writtenScore is null THEN 'X'
        ELSE 'O'
    END AS "필기성적등록여부",
    CASE 
        WHEN practicalScore is null THEN 'X'
        ELSE 'O'
    END AS "실기성적등록여부"
FROM vwCourseGather cg
    INNER JOIN tblTest t
        ON cg.subjectDetailNum = t.subjectDetailNum
            INNER JOIN tblTestScore ts
                ON t.testNum = ts.testNum 
ORDER BY to_number(cg.subjectdetailnum);


--특정 과목을 과목번호로 선택시 교육생 정보(이름, 전화번호, 수료 또는 중도탈락) 및 성적이 출결, 필기, 실기 점수로 구분되어서 출력한다.
--5. 중도 탈락인 경우 중도탈락 날짜가 출력되도록 한다.
SELECT
    DISTINCT vs.studentName AS "교육생이름",
    vs.studentTel AS "전화번호",
    CASE
        WHEN c.studentNum IS NOT NULL THEN '수료'
        WHEN f.studentNum IS NOT NULL THEN '중도 탈락' || ' ' || f.failDate
        WHEN TO_CHAR(cd.courseStartDate, 'YYYY-MM-DD') > TO_CHAR(SYSDATE,'YYYY-MM-DD') THEN '진행 예정'
        ELSE '진행중'
    END AS "수료",
    ts.attendanceScore AS "출결점수",
    ts.writtenScore AS "필기점수",
    ts.practicalScore AS "실기점수"
FROM vwStudent vs
    FULL JOIN tblFail f
        ON vs.studentNum = f.studentNum
            full join tblComplete c
                ON vs.studentNum = c.studentNum
                    INNER JOIN tblStudent s
                        ON vs.studentNum = s.studentNum
                            INNER JOIN tblCourseDetail cd
                                ON cd.courseDetailNum = s.courseDetailNum
                                    INNER JOIN tblTestScore ts
                                        ON vs.studentNum = ts.studentNum
                                            INNER JOIN tblSubjectDetail sd
                                                ON cd.courseDetailNum = sd.courseDetailNum
                                                     WHERE sd.subjectNum = 4;



-------------------------------C04-01. 출결 관리 및 출결 조회
--관리자 기능 > 과정 선택 시 조회
--> B의 조회 기능과 동일



-------------------------------C05-01. 추천도서 입력 및 관리
--교사 추천도서리스트
SELECT * FROM tblrecommendbook;
SELECT * FROM tblteacher;

--교사가 추천 도서 입력(이름, 난이도 입력)
--INSERT INTO tblBook (bookNum, bookName, bookLevel) VALUES (seqBook.nextVal, '한 번에 붙는 SQLD', 3);
INSERT INTO tblBook (bookNum, bookName, bookLevel) VALUES (seqBook.nextVal, <도서명>, <난이도>);

--추천도서 조회(추천 전체 목록 조회)
SELECT
    b.booknum AS "도서번호",
    b.bookname AS "도서명",
    b.booklevel AS "난이도",
    t.teachername AS "교사이름"
FROM tblrecommendbook  r
    INNER JOIN tblBook b
        ON r.bookNum = b.bookNum
            INNER JOIN tblteacher t
                ON r.teacherNum = t.teacherNum
                    ORDER BY b.booknum;


--교사별 추천 도서 조회
/*
SELECT
    b.booknum AS "도서번호",
    b.bookname AS "도서명",
    b.booklevel AS "난이도"
FROM tblrecommendbook r
    INNER JOIN tblBook b
        ON r.bookNum = b.bookNum
            INNER JOIN tblTeacher t
                ON r.teachernum = t.teachernum
                    WHERE teacherName = <교사이름>;
*/
SELECT
    b.booknum AS "도서번호",
    b.bookname AS "도서명",
    b.booklevel AS "난이도"
FROM tblrecommendbook r
    INNER JOIN tblBook b
        ON r.bookNum = b.bookNum
            INNER JOIN tblTeacher t
                ON r.teachernum = t.teachernum
                    WHERE teacherName = '곽우갓';


--도서별 추천한 교사 조회가 가능하다.
/*
SELECT
    b.booknum AS "도서번호",
    b.bookname AS "도서명",
    b.booklevel AS "난이도",
    t.teachername AS "교사이름"
FROM tblrecommendbook r
    INNER JOIN tblBook b
        ON r.bookNum = b.bookNum
            INNER JOIN tblTeacher t
                ON r.teachernum = t.teachernum
                    WHERE bookName = <도서명>;
*/
SELECT
    b.booknum AS "도서번호",
    b.bookname AS "도서명",
    b.booklevel AS "난이도",
    t.teachername AS "교사이름"
FROM tblrecommendbook r
    INNER JOIN tblBook b
        ON r.bookNum = b.bookNum
            INNER JOIN tblTeacher t
                ON r.teachernum = t.teachernum
                    WHERE bookName = 'Git 교과서';




-------------------------------C06-01. 교사 평가 조회
--교사 (교사 평가 조회)
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
											WHERE t.teacherNum = '1'
												GROUP BY c.courseName, t.teacherName, e.estimateIndex
													ORDER BY c.courseName ASC;



-------------------------------C07-01. 과제 등록 및 관리
--입력
/*															
INSERT INTO tblAssignment (assignmentNum, subjectDetailNum, assignmentContent)
			VALUES <seqAssignmentNum.nextVal, <과목상세번호>, <과제내용>);
*/
INSERT INTO tblAssignment (assignmentNum, subjectDetailNum, assignmentContent)
			VALUES <seqAssignmentNum.nextVal, 1, '자바과제4');

--출력
--과제를 제출한 학생 명단 출력
SELECT
	c.courseName AS 과정명,
	s.subjectName AS 과목명,
	a.assignmentContent AS 과제명,
	sb.assignmentSubmitNum AS 과제제출번호,
	v.studentName AS 교육생이름,
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
											INNER JOIN vwStudent v
												ON v.studentNum = sb.studentNum
													WHERE cd.courseDetailNum = 1 --<과정상세번호>
														ORDER BY s.subjectName ASC;

--수정
/*
UPDATE tblAssignment
	SET subjectDetailNum = <과목상세번호>, assignmentContent = <과제내용>
		WHERE assignmentNum = <수정하려는 과제번호>;
*/
UPDATE tblAssignment
	SET subjectDetailNum = 1, assignmentContent = '자바심화과제1'
		WHERE assignmentNum = 1;

--삭제
/*
DELETE FROM tblAssignment WHERE assignmentNum = <삭제하려는 과제번호>;
*/
DELETE FROM tblAssignment WHERE assignmentNum = 1;



-------------------------------C08-01. 질의응답 응답
--교사 (응답 등록)
SELECT * FROM tblAnswer;
INSERT INTO tblAnswer(answerNum, questionNum, teacherNum, answerContent, answerDate)
	VALUES (<응답 번호>, <질문 번호>, <교사 번호>, <응답 내용>, <응답 등록일>);

--교사 (응답 수정)
UPDATE tblAnswer SET answerContent = <바꿀 응답 내용> WHERE answerNum = <응답 번호>;

--교사 (응답 삭제)
DELETE FROM tblAnswer WHERE teacherNum = <교사 번호> AND answerNum = <질문 번호>;

--교사 (응답 조회)
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
					INNER JOIN tblInterviewRegister ir
						ON ir.interviewReginum = s.interviewReginum
							INNER JOIN tblInterviewer i
								ON i.interviewerNum = ir.interviewerNum
									INNER JOIN tblTeacher t
										ON t.teacherNum = a.teacherNum
											WHERE answerNum = '30';



-------------------------------C09-01. 비품 교체 신청
--1. 교사는 비품에 대해 교체 신청 사유를 기재하여 교체 신청을 할 수 있다.
/*
INSERT INTO tblitemChange (itemChangeNum, itemDetailNum, itemChangeReason, isReplacement, itemChangeDate)
			VALUES (seqItemChange.nextVal, <비품상세번호>, <교체사유>, <교체여부>, <교체신청일-금일자동입력>);
*/	
INSERT INTO tblitemChange (itemChangeNum, itemDetailNum, itemChangeReason, isReplacement, itemChangeDate)
			VALUES (seqItemChange.nextVal, '806', '작동 고장', 0, SYSDATE);


-------------------------------C10-01. 우수 교육생 조회
--교사 기능 > 과정 선택 시 조회
--> B의 조회 기능과 동일




-------------------------------D. 교육생 기능
-------------------------------D01-01. 교육생 성적 조회
--학생 시험 성적 조회                    
--출력될 정보는 과목번호, 과목명, 과목기간(시작 년월일, 끝 년월일), 교재명, 교사명, 
--과목별 배점 정보(출결, 필기, 실기 배점), 
--과목별 성적 정보(출결, 필기, 실기 점수), 과목별 시험날짜가 출력되어야 한다.
SELECT 
    s.subjectNum AS "과목번호",
    s.subjectName AS "과목명",
    sd.subjectStartDate || ' ~ ' || sd.subjectEndDate AS "과목기간",
    tb.textBookName AS "교재명",
    tt.teacherName AS "교사이름",
    t.attendancePoint AS "출결배점",
    t.writtenPoint AS "필기배점",
    t.practicalPoint AS "실기배점",
    ts.attendanceScore AS "출결점수",
    ts.writtenScore AS "필기점수",
    ts.practicalScore AS "실기점수",
    t.testDate AS "시험날짜"
FROM tblCourseDetail cd
    INNER JOIN vwStudent vs
        ON cd.courseDetailNum = vs.courseDetailNum
            INNER JOIN tblSubjectDetail sd
                ON sd.courseDetailNum = cd.courseDetailNum
                    INNER JOIN tblTest t
                        ON sd.subjectDetailNum = t.subjectDetailNum
                            INNER JOIN tblTestScore ts
                                ON t.testNum = ts.testNum
                                    INNER JOIN tblSubject s
                                        ON sd.subjectNum = s.subjectNum
                                            INNER JOIN tblTeacher tt
                                                ON cd.teacherNum = tt.teacherNum
                                                     INNER JOIN tblTextBook tb
                                                        ON s.subjectNum = tb.subjectNum
                                                            WHERE ts.studentNum = 44 AND vs.studentNum = 44;



-------------------------------D02-01. 교육생 출결관리 및 출결조회
--입실 퇴실
--1. 입실
/*
INSERT INTO tblStudentAttendance (attendanceNum, studentNum, attendanceDate, checkInTime, checkOutTime, isTrady)
            VALUES (seqStudentAttendance.nextVal, <학생번호>, <출석일>, <입실 시간>, <퇴실 시간>, <지각 여부>); 
*/
INSERT INTO tblStudentAttendance (attendanceNum, studentNum, attendanceDate, checkInTime, checkOutTime, isTrady)
            VALUES (seqStudentAttendance.nextVal, 1, DEFAULT, DEFAULT, NULL, 0); 

--퇴실
UPDATE tblStudentAttendance SET checkOutTime = SYSDATE WHERE studentNum = 1 AND TO_CHAR(attendanceDate, 'YYMMDD') = TO_CHAR(SYSDATE, 'YYMMDD');

--출결 확인
SELECT TO_CHAR(attendanceDate, 'HH24:MI:SS'), TO_CHAR(checkOutTime, 'HH24:MI:SS') FROM tblStudentAttendance WHERE studentNum = 1;

--출결 신청 리스트
--입력
/*
INSERT INTO tblAttendanceApply (attendanceApplyNum, studentNum, teacherNum, applyAttendance, ApplyReason, ApplyDate)
            VALUES (<seq>, <학생번호>, <선생번호>, <신청출결>, <신청사유>, <신청일>);
*/
INSERT INTO tblAttendanceApply (attendanceApplyNum, studentNum, teacherNum, applyAttendance, ApplyReason, ApplyDate)
            VALUES (seqAttendanceApply.nextVal, 1, 1, '외출', '병원 진료', '2022-03-16');
            
--출력
SELECT 
    studentNum AS 학생번호,
    teacherNum AS 교사번호,
    applyAttendance AS 신청출결,
    applyReason AS 신청사유,
    applyDate AS 신청일
FROM tblAttendanceApply;

--수정
/*
UPDATE tblAttendanceApply SET applyAttendance = <신청출결>, ApplyReason = <신청사유> WHERE studentNum = <학생번호> AND applyDate = <신청일>;
*/
UPDATE tblAttendanceApply SET applyAttendance = '병가', ApplyReason = '배탈' WHERE studentNum = 1 AND applyDate = '2022-03-16';



-------------------------------D03-01. 교육생 출입카드 조회 및 재신청
--1. 본인에게 배부된 출입카드를 분실하였을 경우, 분실사유를 기재하여 새 출입카드를 신청한다.
--수료 및 탈락된 교육생은 재발급 신청할 수 없다. > 프로시저로 구현
		
INSERT INTO tblAccessCardReissue (accessCardReissueNum, studentNum, isReissue, reissueReason)
			VALUES (seqAccessCardReissue.nextVal, '503', 0, '분실');



-------------------------------D04-01. 교육생 교사 평가
--교육생 (교사 평가 등록)
SELECT DISTINCT MIN(LPAD(s.studentnum, 3, '0')) AS "끝난 학생의 시작번호",
				MAX(LPAD(s.studentnum, 3, '0')) AS "끝난 학생의 끝번호"
FROM tblTeacherEstimate te
	INNER JOIN tblStudent s
		ON s.studentNum = te.studentNum
			INNER JOIN tblCourseDetail cd
				ON cd.courseDetailNum = s.courseDetailNum
					WHERE cd.courseEndDate < SYSDATE
						ORDER BY lpad(s.studentnum, 3, '0') ASC;	
	
				
						
	INSERT INTO tblTeacherEstimate(teacherEstiNum, estimateNum, studentNum, estimateScore)
		VALUES (<교사평가 번호>, <평가항목 번호>, <교육생 번호>, <평가 점수>);
	

--교육생 (교사 평가 조회)
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
											WHERE te.studentNum = <평가할 학생의 번호>;



-------------------------------D05-01. 질의응답 질의
--교육생 (질문 등록)
SELECT * FROM tblAnswer;
INSERT INTO tblQuestion(questionNum, subjectNum, studentNum, questionContent, questionDate)
	VALUES (<질문 번호>, <과목 번호>, <교육생 번호>, <질문 내용>, <질문 등록일>);

--교육생 (질문 수정)
UPDATE tblQuestion SET subjectNum = <바꿀 과목 번호> WHERE questionNum = <질문 번호>;
UPDATE tblQuestion SET questionContent = <바꿀 질문 내용> WHERE questionNum = <질문 번호>;

--교육생 (질문 삭제)
DELETE FROM tblQuestion WHERE subjectNum = <교육생 번호> AND questionNum = <질문 번호>;

-- 교육생 (질문 조회)
SELECT i.interviewerName,
	   q.questionContent,
	   q.questionDate,
	   t.teacherName,
	   a.answerContent,
	   a.answerDate
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
											WHERE q.questionNum= <조회할 질문번호>
												ORDER BY lpad(a.questionNum, 5, '0') ASC;	

-------------------------------D06-01. 과제 제출 및 조회
--입력
/*
INSERT INTO tblAssignmentSubmit (assignmentSubmitNum, assignmentNum, studentNum, assignmentExplain)
			VALUES (seqAssignmentSubmit.nextVal, <과제번호>, <교육생번호>, <과제풀이>);
*/
INSERT INTO tblAssignmentSubmit (AssignmentSubmitNum, AssignmentNum, studentNum, assignmentExplain)
			VALUES (seqAssignmentSubmit.nextVal, 660, 27, CSS과제3 풀이);

--출력
--본인을 포함한 같은 과정을 수강중인 학생들의 과제 명단 출력
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
	IN(
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
	    WHERE sb2.studentNum = 1 --<교육생번호>
	    	AND s.subjectName = '오라클' --<과목명>
);

--수정
/*
UPDATE tblAssignmentSubmit
	SET assignmentNum = <과제번호>, studentNum = <교육생번호>, assignmentExplain = <과제풀이>
		WHERE assignmentSubmitNum = <수정하려는 과제제출번호>;
UPDATE tblAssignmentSubmit
*/
	SET assignmentNum = 5, studentNum = 25, assignmentExplain = '오라클과제1 풀이'
		WHERE assignmentSubmitNum = 437;

--삭제
/*
DELETE FROM tblAssignmentSubmit WHERE assignmentSubmitNum = <삭제하려는 과제제출번호>;
*/
DELETE FROM tblAssignmentSubmit WHERE assignmentSubmitNum = 2584;



-------------------------------D07-01. 비품 교체 신청
--1. 교육생은 비품에 대해 교체 신청 사유를 기재하여 교체 신청을 할 수 있다.
/*
INSERT INTO tblitemChange (itemChangeNum, itemDetailNum, itemChangeReason, isReplacement, itemChangeDate)
			VALUES (seqItemChange.nextVal, <비품상세번호>, <교체사유>, <교체여부>, <교체신청일-금일자동입력>);
*/	
INSERT INTO tblitemChange (itemChangeNum, itemDetailNum, itemChangeReason, isReplacement, itemChangeDate)
			VALUES (seqItemChange.nextVal, '806', '작동 고장', 0, SYSDATE);



-------------------------------D08-01. 우수 교육생 수상
--학생 기능 > 과정 선택 시 조회
--> B의 조회 기능과 동일



-------------------------------D09-01. 교육생 지원금 수급
SELECT
	o.courseName AS 과정명,
	i.interviewerName AS 교육생이름,
	i.interviewerTel AS 전화번호,
	TO_CHAR(p.supplyDate, 'YYYY-MM-DD') AS 수급일,
	p.supplySum AS 수급액
FROM tblStudentSupply p
	INNER JOIN tblStudent s
		ON p.studentNum = s.studentNum
			INNER JOIN tblInterviewRegister r
				ON s.interviewRegiNum = r.interviewRegiNum
					INNER JOIN tblInterviewer i
						ON i.interviewerNum = r.interviewerNum
							INNER JOIN tblCourseDetail cd
								ON s.courseDetailNum = cd.courseDetailNum
									INNER JOIN tblCourse o
										ON o.courseNum = cd.courseNum;
