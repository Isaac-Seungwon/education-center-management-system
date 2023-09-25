--DropTable.sql

/* 시퀀스 드롭 */
DROP SEQUENCE seqLogin;
DROP SEQUENCE seqAdmin;
DROP SEQUENCE seqInterviewer;
DROP SEQUENCE seqInterviewRegister;
DROP SEQUENCE seqCourse;
DROP SEQUENCE seqEstimate;
DROP SEQUENCE seqLectureRoom;
DROP SEQUENCE seqSubject;
DROP SEQUENCE seqTextBook;
DROP SEQUENCE seqTeacher;
DROP SEQUENCE seqCourseDetail;
DROP SEQUENCE seqSubjectDetail;
DROP SEQUENCE seqLectureSchedule;
DROP SEQUENCE seqStudent;
DROP SEQUENCE seqAccessCard;
DROP SEQUENCE seqAccessCardReissue;
DROP SEQUENCE seqPrize;
DROP SEQUENCE seqComplete;
DROP SEQUENCE seqFail;
DROP SEQUENCE seqStudentAttendance;
DROP SEQUENCE seqAttendanceApply;
DROP SEQUENCE seqStudentSupply;
DROP SEQUENCE seqItem;
DROP SEQUENCE seqItemDetail;
DROP SEQUENCE seqItemChange;
DROP SEQUENCE seqTest;
DROP SEQUENCE seqTestScore;
DROP SEQUENCE seqTextBookDetail;
DROP SEQUENCE seqConsulting;
DROP SEQUENCE seqCompany;
DROP SEQUENCE seqRequirement;
DROP SEQUENCE seqJob;
DROP SEQUENCE seqAssignment;
DROP SEQUENCE seqAssignmentSubmit;
DROP SEQUENCE seqAvailableLecture;
DROP SEQUENCE seqBook;
DROP SEQUENCE seqRecommendBook;
DROP SEQUENCE seqTeacherEstimate;
DROP SEQUENCE seqQuestion;
DROP SEQUENCE seqAnswer;
DROP SEQUENCE seqHoliday;

/* 로그인 */
DROP TABLE tblLogin CASCADE CONSTRAINTS;

/* 관리자명단 */
DROP TABLE tblAdmin CASCADE CONSTRAINTS;

/* 교육생면접리스트 */
DROP TABLE tblInterviewer CASCADE CONSTRAINTS;

/* 교육생등록여부리스트 */
DROP TABLE tblInterviewRegister CASCADE CONSTRAINTS;

/* 과정리스트 */
DROP TABLE tblCourse CASCADE CONSTRAINTS;

/* 평가리스트 */
DROP TABLE tblEstimate CASCADE CONSTRAINTS;

/* 강의실리스트 */
DROP TABLE tblLectureRoom CASCADE CONSTRAINTS;

/* 과목리스트 */
DROP TABLE tblSubject CASCADE CONSTRAINTS;

/* 교재리스트 */
DROP TABLE tblTextBook CASCADE CONSTRAINTS;

/* 교사명단 */
DROP TABLE tblTeacher CASCADE CONSTRAINTS;

/* 과정상세리스트 */
DROP TABLE tblCourseDetail CASCADE CONSTRAINTS;

/* 과목상세리스트 */
DROP TABLE tblSubjectDetail CASCADE CONSTRAINTS;

/* 강의스케줄 */
DROP TABLE tblLectureSchedule CASCADE CONSTRAINTS;

/* 교육생명단 */
DROP TABLE tblStudent CASCADE CONSTRAINTS;

/* 출입카드리스트 */
DROP TABLE tblAccessCard CASCADE CONSTRAINTS;

/* 출입카드재발급리스트 */
DROP TABLE tblAccessCardReissue CASCADE CONSTRAINTS;

/* 상 */
DROP TABLE tblPrize CASCADE CONSTRAINTS;

/* 교육생수료명단 */
DROP TABLE tblComplete CASCADE CONSTRAINTS;

/* 교육생탈락명단 */
DROP TABLE tblFail CASCADE CONSTRAINTS;

/* 교육생출결 */
DROP TABLE tblStudentAttendance CASCADE CONSTRAINTS;

/* 출결신청리스트 */
DROP TABLE tblAttendanceApply CASCADE CONSTRAINTS;

/* 교육생수급내역 */
DROP TABLE tblStudentSupply CASCADE CONSTRAINTS;

/* 비품목록 */
DROP TABLE tblItem CASCADE CONSTRAINTS;

/* 비품상세목록 */
DROP TABLE tblItemDetail CASCADE CONSTRAINTS;

/* 비품교체신청리스트 */
DROP TABLE tblItemChange CASCADE CONSTRAINTS;

/* 시험리스트 */
DROP TABLE tblTest CASCADE CONSTRAINTS;

/* 시험성적 */
DROP TABLE tblTestScore CASCADE CONSTRAINTS;

/* 교재상세리스트 */
DROP TABLE tblTextBookDetail CASCADE CONSTRAINTS;

/* 상담리스트 */
DROP TABLE tblConsulting CASCADE CONSTRAINTS;

/* 회사관리 */
DROP TABLE tblCompany CASCADE CONSTRAINTS;

/* 회사요구조건 */
DROP TABLE tblRequirement CASCADE CONSTRAINTS;

/* 취업명단 */
DROP TABLE tblJob CASCADE CONSTRAINTS;

/* 과제리스트 */
DROP TABLE tblAssignment CASCADE CONSTRAINTS;

/* 과제제출리스트 */
DROP TABLE tblAssignmentSubmit CASCADE CONSTRAINTS;

/* 강의가능과목리스트 */
DROP TABLE tblAvailableLecture CASCADE CONSTRAINTS;

/* 도서리스트 */
DROP TABLE tblBook CASCADE CONSTRAINTS;

/* 교사추천도서리스트 */
DROP TABLE tblRecommendBook CASCADE CONSTRAINTS;

/* 교사평가리스트 */
DROP TABLE tblTeacherEstimate CASCADE CONSTRAINTS;

/* 질의 */
DROP TABLE tblQuestion CASCADE CONSTRAINTS;

/* 응답 */
DROP TABLE tblAnswer CASCADE CONSTRAINTS;

/* 공휴일 */
DROP TABLE TblHoliday CASCADE CONSTRAINTS;