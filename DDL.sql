--DDL.sql

/* 시퀀스 생성 */
CREATE SEQUENCE seqLogin;
CREATE SEQUENCE seqAdmin;
CREATE SEQUENCE seqInterviewer;
CREATE SEQUENCE seqInterviewRegister;
CREATE SEQUENCE seqCourse;
CREATE SEQUENCE seqEstimate;
CREATE SEQUENCE seqLectureRoom;
CREATE SEQUENCE seqSubject;
CREATE SEQUENCE seqTextBook;
CREATE SEQUENCE seqTeacher;
CREATE SEQUENCE seqCourseDetail;
CREATE SEQUENCE seqSubjectDetail;
CREATE SEQUENCE seqLectureSchedule;
CREATE SEQUENCE seqStudent;
CREATE SEQUENCE seqAccessCard;
CREATE SEQUENCE seqAccessCardReissue;
CREATE SEQUENCE seqPrize;
CREATE SEQUENCE seqComplete;
CREATE SEQUENCE seqFail;
CREATE SEQUENCE seqStudentAttendance;
CREATE SEQUENCE seqAttendanceApply;
CREATE SEQUENCE seqStudentSupply;
CREATE SEQUENCE seqItem;
CREATE SEQUENCE seqItemDetail;
CREATE SEQUENCE seqItemChange;
CREATE SEQUENCE seqTest;
CREATE SEQUENCE seqTestScore;
CREATE SEQUENCE seqTextBookDetail;
CREATE SEQUENCE seqConsulting;
CREATE SEQUENCE seqCompany;
CREATE SEQUENCE seqRequirement;
CREATE SEQUENCE seqJob;
CREATE SEQUENCE seqAssignment;
CREATE SEQUENCE seqAssignmentSubmit;
CREATE SEQUENCE seqAvailableLecture;
CREATE SEQUENCE seqBook;
CREATE SEQUENCE seqRecommendBook;
CREATE SEQUENCE seqTeacherEstimate;
CREATE SEQUENCE seqQuestion;
CREATE SEQUENCE seqAnswer;
CREATE SEQUENCE seqHoliday;

/* 로그인 */
CREATE TABLE tblLogin (
	COL varchar2(30) PRIMARY KEY, /* 로그인정보번호 */
	id varchar2(255), /* 아이디 */
	pw varchar2(255) /* 비밀번호 */
);

/* 관리자명단 */
CREATE TABLE tblAdmin (
	adminNum varchar2(30) PRIMARY KEY, /* 관리자번호 */
	adminName varchar2(255) NOT NULL, /* 관리자 이름 */
	adminSSN varchar2(255) NOT NULL /* 관리자 주민번호 */
);

/* 교육생면접리스트 */
CREATE TABLE tblInterviewer (
   interviewerNum varchar2(30) PRIMARY KEY, /* 교육생면접번호 */
   interviewerName varchar2(255) NOT NULL, /* 이름 */
   interviewerSsn varchar2(255) NOT NULL, /* 주민번호 */
   interviewerTel varchar2(255) NOT NULL, /* 전화번호 */
   interviewerDate DATE NOT NULL, /* 면접일 */
   isPass NUMBER DEFAULT 0 NULL /* 합불여부 */
);

/* 교육생등록여부리스트 */
CREATE TABLE tblInterviewRegister (
	interviewRegiNum varchar2(30) PRIMARY KEY, /* 교육생등록여부번호 */
	interviewerNum varchar2(30) REFERENCES tblInterviewer(interviewerNum) NOT NULL, /* 교육생면접번호 */
	isEnrollment NUMBER DEFAULT 0 NOT NULL /* 교육생등록여부 */
);

/* 과정리스트 */
CREATE TABLE tblCourse (
	courseNum varchar2(30) PRIMARY KEY, /* 과정번호 */
	courseName varchar2(2048) NOT NULL /* 과정명 */
);

/* 평가리스트 */
CREATE TABLE tblEstimate (
	estimateNum varchar2(30) PRIMARY KEY, /* 평가번호 */
	estimateIndex varchar2(255) NOT NULL /* 평가항목 */
);

/* 강의실리스트 */
CREATE TABLE tblLectureRoom (
	lectureRoomNum varchar2(30) PRIMARY KEY, /* 강의실번호 */
	capacity NUMBER NOT NULL /* 정원 */
);

/* 과목리스트 */
CREATE TABLE tblSubject (
	subjectNum varchar2(30) PRIMARY KEY, /* 과목번호 */
	subjectName varchar2(255) NOT NULL /* 과목명 */
);

/* 교재리스트 */
CREATE TABLE tblTextBook (
	textBookNum varchar2(30) PRIMARY KEY, /* 교재번호 */
	textBookName varchar2(255) NOT NULL, /* 교재명 */
	textBookWriter varchar2(255) NOT NULL, /* 저자 */
	textBookPublisher varchar2(255) NOT NULL, /* 출판사 */
	textBookPrice NUMBER NOT NULL, /* 가격 */
	subjectNum varchar2(30) REFERENCES tblSubject (subjectNum) NOT NULL /* 과목번호 */
);

/* 교사명단 */
CREATE TABLE tblTeacher (
	teacherNum varchar2(30) PRIMARY KEY, /* 교사번호 */
	teacherName varchar2(255) NOT NULL, /* 이름 */
	teacherSSN varchar2(255) NOT NULL, /* 주민번호 */
	teacherTel varchar2(255) NOT NULL, /* 전화번호 */
	status varchar2(255) NOT NULL, /* 상태 */
	workingStartDate DATE NOT NULL, /* 입사일 */
	workingEndDate DATE /* 퇴사일 */
);

/* 과정상세리스트 */
CREATE TABLE tblCourseDetail (
	courseDetailNum varchar2(30) PRIMARY KEY, /* 과정상세번호 */
	courseNum varchar2(30) REFERENCES tblCourse(courseNum) NOT NULL, /* 과정번호 */
	courseStartDate DATE NOT NULL, /* 과정시작일 */
	courseEndDate date NOT NULL, /* 과정종료일 */
	lectureRoomNum varchar2(30) REFERENCES tblLectureRoom(lectureRoomNum) NOT NULL, /* 강의실번호 */
	isCourseRun NUMBER NOT NULL, /* 강의진행여부 */
	teacherNum varchar2(30) REFERENCES tblTeacher(teacherNum) NOT NULL, /* 교사번호 */
	subjectAmount NUMBER NOT NULL /* 과목수 */
);

/* 과목상세리스트 */
CREATE TABLE tblSubjectDetail (
	subjectDetailNum varchar2(30) PRIMARY KEY, /* 과목상세번호 */
	subjectNum varchar2(30) REFERENCES tblSubject(subjectNum) NOT NULL, /* 과목번호 */
	courseDetailNum varchar2(30) REFERENCES tblCourseDetail(courseDetailNum) NOT NULL, /* 과정상세번호 */
	subjectStartDate DATE NOT NULL, /* 과목시작일 */
	subjectEndDate DATE NOT NULL /* 과목종료일 */
);

/* 강의스케줄 */
CREATE TABLE tblLectureSchedule (
	lectureScheduleNum varchar2(30) PRIMARY KEY, /* 강의스케줄번호 */
	subjectDetailNum varchar2(30) REFERENCES tblSubjectDetail(subjectDetailNum) NOT NULL, /* 과목상세번호 */
	progress varchar2(255) NOT NULL /* 강의진행상태 */
);

/* 교육생명단 */
CREATE TABLE tblStudent (
	studentNum varchar2(30) PRIMARY KEY, /* 교육생번호 */
	interviewRegiNum varchar2(30) REFERENCES tblInterviewRegister (interviewRegiNum) NOT NULL, /* 교육생등록여부번호 */
	registrationDate DATE NOT NULL, /* 등록일 */
	signUpCnt NUMBER DEFAULT 1 NOT NULL, /* 수강횟수 */
	courseDetailNum varchar2(30) REFERENCES tblCourseDetail (courseDetailNum) NOT NULL /* 과정상세번호 */
);

/* 출입카드리스트 */
CREATE TABLE tblAccessCard (
	accessCardNum varchar2(30) PRIMARY KEY, /* 출입카드번호 */
	studentNum varchar2(30) REFERENCES tblStudent(studentNum) NOT NULL, /* 교육생번호 */
	isAccessCard NUMBER DEFAULT 0 NOT NULL /* 배부여부 */
);

/* 출입카드재발급리스트 */
CREATE TABLE tblAccessCardReissue (
	accessCardReissueNum varchar2(30) PRIMARY KEY, /* 출입카드재발급번호 */
	studentNum varchar2(30) REFERENCES tblStudent(studentNum) NOT NULL, /* 교육생번호 */
	isReissue NUMBER DEFAULT 0 NOT NULL, /* 재발급배부여부 */
	reissueReason varchar2(255) NOT NULL /* 재발급사유 */
);

/* 상 */
CREATE TABLE tblPrize (
	prizeNum varchar2(30) PRIMARY KEY, /* 상번호 */
	studentNum varchar2(30) REFERENCES tblStudent(studentNum) NOT NULL, /* 교육생번호 */
	prizeCategory varchar2(255) NOT NULL /* 부문 */
);

/* 교육생수료명단 */
CREATE TABLE tblComplete (
	completeNum varchar2(30) PRIMARY KEY, /* 수료번호 */
	studentNum varchar2(30) REFERENCES tblStudent(studentNum) NOT NULL, /* 교육생번호 */
	completeDate DATE NOT NULL /* 수료일 */
);

/* 교육생탈락명단 */
CREATE TABLE tblFail (
	failNum varchar2(30) PRIMARY KEY, /* 탈락번호 */
	studentNum varchar2(30) REFERENCES tblStudent(studentNum) NOT NULL, /* 교육생번호 */
	failDate DATE NOT NULL, /* 탈락일 */
	failReason varchar2(255) NOT NULL /* 탈락사유 */
);

/* 교육생출결 */
CREATE TABLE tblStudentAttendance (
	attendanceNum varchar2(30) PRIMARY KEY, /* 출결번호 */
	studentNum varchar2(30) REFERENCES tblStudent(studentNum) NOT NULL, /* 교육생번호 */
	attendanceDate DATE DEFAULT sysdate NOT NULL, /* 출결일 */
	checkInTime DATE DEFAULT sysdate, /* 입실시간 */
	checkOutTime DATE DEFAULT sysdate, /* 퇴실시간 */
	isTrady NUMBER /* 지각여부 */
);

/* 출결신청리스트 */
CREATE TABLE tblAttendanceApply (
	attendanceApplyNum varchar2(30) PRIMARY KEY, /* 출결신청번호 */
	studentNum varchar2(30) REFERENCES tblStudent(studentNum) NOT NULL, /* 교육생번호 */
	teacherNum varchar2(30) REFERENCES tblTeacher(teacherNum) NOT NULL, /* 교사번호 */
	applyAttendance varchar2(255) NOT NULL, /* 출결신청 */
	applyReason varchar2(255) NOT NULL, /* 신청사유 */
	applyDate DATE DEFAULT sysdate NOT NULL /* 신청일 */
);

/* 교육생수급내역 */
CREATE TABLE tblStudentSupply (
	studentSupply varchar2(30) PRIMARY KEY, /* 수급번호 */
	studentNum varchar2(30) REFERENCES tblStudent(studentNum) NOT NULL, /* 교육생번호 */
	supplyDate DATE NOT NULL, /* 수급일 */
	supplySum NUMBER NOT NULL /* 수급액 */
);

/* 비품목록 */
CREATE TABLE tblItem (
	itemNum varchar2(30) PRIMARY KEY, /* 비품번호 */
	itemCategory varchar2(255) NOT NULL /* 비품분류 */
);

/* 비품상세목록 */
CREATE TABLE tblItemDetail (
	itemDetailNum varchar2(30) PRIMARY KEY, /* 비품상세번호 */
	itemNum varchar2(30) REFERENCES tblItem(itemNum) NOT NULL, /* 비품번호 */
	itemName varchar2(255) NOT NULL, /* 비품명 */
	itemCondition varchar2(255), /* 상태 */
	lectureRoomNum varchar2(30) REFERENCES tblLectureRoom(lectureRoomNum) /* 강의실번호 */
);

/* 비품교체신청리스트 */
CREATE TABLE tblItemChange (
	itemChangeNum varchar2(30) PRIMARY KEY, /* 비품교체신청번호 */
	itemDetailNum varchar2(30) REFERENCES tblItemDetail(itemDetailNum) NOT NULL, /* 비품상세번호 */
	itemChangeReason varchar2(255) NOT NULL, /* 교체사유 */
	isReplacement NUMBER DEFAULT 0 NOT NULL, /* 교체여부 */
	itemChangeDate DATE DEFAULT sysdate NOT NULL /* 교체신청일 */
);

/* 시험리스트 */
CREATE TABLE tblTest (
	testNum varchar2(30) PRIMARY KEY, /* 시험번호 */
	subjectDetailNum varchar2(30) REFERENCES tblSubjectDetail(subjectDetailNum) NOT NULL, /* 과목상세번호 */
	attendancePoint NUMBER DEFAULT 20 NOT NULL, /* 출결배점 */
	writtenPoint NUMBER DEFAULT 40 NOT NULL, /* 필기배점 */
	practicalPoint NUMBER DEFAULT 40 NOT NULL, /* 실기배점 */
	testDate DATE NOT NULL, /* 시험일 */
	isRegistration NUMBER DEFAULT 0 NOT NULL /* 시험문제파일등록여부 */
);

/* 시험성적 */
CREATE TABLE tblTestScore (
	testScoreNum varchar2(30) PRIMARY KEY, /* 시험성적번호 */
	testNum varchar2(30) REFERENCES tblTest(testNum) NOT NULL, /* 시험번호 */
	studentNum varchar2(30) REFERENCES tblStudent(studentNum) NOT NULL, /* 교육생번호 */
	attendanceScore NUMBER DEFAULT 0 NOT NULL, /* 출결점수 */
	writtenScore NUMBER DEFAULT 0 NOT NULL, /* 필기점수 */
	practicalScore NUMBER DEFAULT 0 NOT NULL /* 실기점수 */
);

/* 교재상세리스트 */
CREATE TABLE tblTextBookDetail (
	textBookDetailNum varchar2(30) PRIMARY KEY, /* 교재관리번호 */
	textBookNum varchar2(30) REFERENCES tblTextBook(textBookNum) NOT NULL, /* 교재번호 */
	studentNum varchar2(30) REFERENCES tblStudent(studentNum) NOT NULL, /* 교육생번호 */
	isDistribute NUMBER DEFAULT 0 NOT NULL /* 배부여부 */
);

/* 상담리스트 */
CREATE TABLE tblConsulting (
	consultingNum varchar2(30) PRIMARY KEY, /* 상담번호 */
	consultingDate DATE, /* 상담일자 */
	studentNum varchar2(30) REFERENCES tblStudent(studentNum) NOT NULL, /* 교육생번호 */
	teacherNum varchar2(30) REFERENCES tblTeacher(teacherNum) NOT NULL, /* 교사번호 */
	consultingContent varchar2(2048) NOT NULL, /* 상담내용 */
	isComplete NUMBER DEFAULT 0 NOT NULL /* 상담완료여부 */
);

/* 회사관리 */
CREATE TABLE tblCompany (
	companyNum varchar2(30) PRIMARY KEY, /* 회사번호 */
	companyName varchar2(255) NOT NULL, /* 회사명 */
	companyType varchar2(255), /* 회사형태 */
	companySize varchar2(255), /* 회사규모 */
	averageSalary NUMBER, /* 평균급여 */
	companyLocation varchar2(255), /* 회사위치 */
	isConnection NUMBER DEFAULT 0 NOT NULL /* 연계회사여부 */
);

/* 회사요구조건 */
CREATE TABLE tblRequirement (
	requirementNum varchar2(30) PRIMARY KEY, /* 요구조건번호 */
	companyNum varchar2(30) REFERENCES tblCompany(companyNum) NOT NULL, /* 회사번호 */
	subjectNum varchar2(30) REFERENCES tblSubject(subjectNum) NOT NULL, /* 과목번호 */
	score NUMBER DEFAULT 0 NOT NULL /* 점수 */
);

/* 취업명단 */
CREATE TABLE tblJob (
	jobNum varchar2(30) PRIMARY KEY, /* 취업번호 */
	studentNum varchar2(30) REFERENCES tblStudent(studentNum) NOT NULL, /* 교육생번호 */
	companyNum varchar2(30) REFERENCES tblCompany(companyNum) NOT NULL, /* 회사번호 */
	jobDate DATE, /* 취업일 */
	salary NUMBER /* 연봉 */
);

/* 과제리스트 */
CREATE TABLE tblAssignment (
   assignmentNum varchar2(30) PRIMARY KEY, /* 과제번호 */
   subjectDetailNum varchar2(30) REFERENCES tblSubjectDetail(subjectDetailNum) NOT NULL, /* 과목상세번호 */
   assignmentContent varchar2(2048) NOT NULL /* 과제내용 */
);

/* 과제제출리스트 */
CREATE TABLE tblAssignmentSubmit (
	assignmentSubmitNum varchar2(30) PRIMARY KEY, /* 과제제출번호 */
	assignmentNum varchar2(30) REFERENCES tblAssignment(assignmentNum) NOT NULL, /* 과제번호 */
	studentNum varchar2(30) REFERENCES tblStudent(studentNum) NOT NULL, /* 교육생번호 */
	assignmentExplain varchar2(2048) /* 과제풀이 */
);

/* 강의가능과목리스트 */
CREATE TABLE tblAvailableLecture (
	availableLectureNum varchar2(30) PRIMARY KEY, /* 강의가능과목번호 */
	subjectNum varchar2(30) REFERENCES tblSubject(subjectNum) NOT NULL, /* 과목번호 */
	teacherNum varchar2(30) REFERENCES tblTeacher(teacherNum) NOT NULL /* 교사번호 */
);

/* 도서리스트 */
CREATE TABLE tblBook (
	bookNum varchar2(30) PRIMARY KEY, /* 도서번호 */
	bookName varchar2(255) NOT NULL, /* 도서명 */
	bookLevel NUMBER /* 난이도 */
);

/* 교사추천도서리스트 */
CREATE TABLE tblRecommendBook (
	recommendBookNum varchar2(30) PRIMARY KEY, /* 교사추천도서번호 */
	bookNum varchar2(30) REFERENCES tblBook(bookNum) NOT NULL, /* 도서번호 */
	teacherNum varchar2(30) REFERENCES tblTeacher(teacherNum) NOT NULL /* 교사번호 */
);

/* 교사평가리스트 */
CREATE TABLE tblTeacherEstimate (
	teacherEstiNum varchar2(30) PRIMARY KEY, /* 교사평가번호 */
	estimateNum varchar2(30) REFERENCES tblEstimate(estimateNum) NOT NULL, /* 평가번호 */
	studentNum varchar2(30) REFERENCES tblStudent(studentNum) NOT NULL, /* 교육생번호 */
	estimateScore NUMBER DEFAULT 0 NOT NULL /* 평가점수 */
);

/* 질의 */
CREATE TABLE tblQuestion (
	questionNum varchar2(30) PRIMARY KEY, /* 질의번호 */
	subjectNum varchar2(30) REFERENCES tblSubject(subjectNum) NOT NULL, /* 과목번호 */
	studentNum varchar2(30) REFERENCES tblStudent(studentNum) NOT NULL, /* 교육생번호 */
	questionContent varchar2(2048) NOT NULL, /* 질의내용 */
	questionDate DATE DEFAULT sysdate NOT NULL /* 질의일 */
);

/* 응답 */
CREATE TABLE tblAnswer (
	answerNum varchar2(30) PRIMARY KEY, /* 응답번호 */
	questionNum varchar2(30) REFERENCES tblQuestion(questionNum) NOT NULL, /* 질의번호 */
	teacherNum varchar2(30) REFERENCES tblTeacher(teacherNum) NOT NULL, /* 교사번호 */
	answerContent varchar2(2048) NOT NULL, /* 응답내용 */
	answerDate DATE DEFAULT sysdate NOT NULL /* 응답일 */
);

/* 공휴일 */
CREATE TABLE TblHoliday (
	holidayNum varchar2(30) PRIMARY KEY, /* 공휴일번호 */
	holiday DATE NOT NULL, /* 공휴일날짜 */
	holidayName varchar2(255) NOT NULL /* 공휴일명 */
);