-- 학과이름과 계열 표시하기/ 출력 헤더는 "학과명", "계열"로 표시

/*
 * 학과명 : CLASS_NAME
 * 전공: CLASS_TYPE
 * 과목 번호 :CLASS_NO
 * 학과번호 : DEPARTREMT_NO
 * 학과이름 : DEPARTREMT_NAME
 * 계열: CATEGORY
 * 개설여부: OPEN_YN
 * 정원:CAPACITY
 * 학생번호 : STUDENT_NO
 * 학점: POINT
 * 선수 과목 번호 : PREATTENDING_CLASS_NO
 * 교수: PROFESSOR_NO
 * 교수주민번호: PROFESSOR_SSN
 * 교수주소: PROFESSOR_ADDRESS
 * */

--1번 
SELECT DEPARTMENT_NAME 학과명, CATEGORY 계열
FROM TB_DEPARTMENT;

--2번
SELECT DEPARTMENT_NAME || '의 정원은 '|| CAPACITY ||
'명 입니다' AS "학과별 정원"  --AS 별칭 지정 ""안에 작성
FROM TB_DEPARTMENT;

--3번
SELECT STUDENT_NAME
FROM TB_STUDENT
WHERE SUBSTR(STUDENT_SSN, 8, 1) = '2'
AND ABSENCE_YN ='Y'
AND DEPARTMENT_NO ='001';

--4번
SELECT STUDENT_NO,STUDENT_NAME
FROM  TB_STUDENT
WHERE STUDENT_NO IN('A513079','A513090','A513091','A513110','A513119')
ORDER BY STUDENT_NAME DESC; --내림차순으로

--5번
SELECT DEPARTMENT_NAME,CATEGORY
FROM TB_DEPARTMENT
WHERE  CAPACITY BETWEEN 20 AND 30; --사이 값 구하는거니까 BETWEEN으로 작성하기!

--6번
SELECT PROFESSOR_NAME
FROM TB_PROFESSOR
WHERE DEPARTMENT_NO IS NULL;

--7번
SELECT * 
FROM TB_STUDENT
WHERE DEPARTMENT_NO IS NULL; --조회 결과 없음! 0행

--8번
SELECT CLASS_NO
FROM TB_CLASS
WHERE PREATTENDING_CLASS_NO IS NOT NULL;

--9번
SELECT DISTINCT CATEGORY
FROM TB_DEPARTMENT
ORDER BY 1;



--10번
SELECT STUDENT_NO, STUDENT_NAME,STUDENT_SSN
FROM TB_STUDENT
WHERE EXTRACT(YEAR FROM ENTRANCE_DATE) =2002
AND STUDENT_ADDRESS LIKE '전주%'
AND ABSENCE_YN = 'N';












