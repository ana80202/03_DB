--1번
SELECT EMP_ID, EMP_NAME,PHONE,HIRE_DATE,DEPT_TITLE
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
WHERE DEPT_CODE = (SELECT DEPT_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME = '전지연')
AND EMP_NAME != '전지연'; 


--2번
SELECT EMP_NAME,SALARY,HIRE_DATE
FROM EMPLOYEE
WHERE EXTRACT(YEAR FROM HIRE_DATE ) > 2000; --2000년도 이후 사원 급여

SELECT EMP_ID,EMP_NAME,PHONE,SALARY,JOB_NAME
FROM EMPLOYEE
NATURAL JOIN JOB  --JOIN JOB USING(JOB_CODE)   --같은 컬럼값 가지고 있으면 NATURAL JOIN/ USING
                                               --컬럼값이 다르면 ON
WHERE SALARY = (SELECT MAX(SALARY)             -- WHERE절 / SELECT절 컬럼 갯수는 같아야한다!
                     FROM EMPLOYEE
                     WHERE EXTRACT(YEAR FROM HIRE_DATE ) > 2000); 

--3번
SELECT DEPT_CODE,JOB_CODE,EMP_NAME 
FROM EMPLOYEE
WHERE EMP_NAME = '노옹철'; --D9	J2 노옹철

SELECT EMP_ID,EMP_NAME,DEPT_CODE,JOB_CODE,DEPT_TITLE,JOB_NAME
FROM EMPLOYEE
NATURAL JOIN JOB
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE (DEPT_CODE,JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE
                              FROM EMPLOYEE
                              WHERE EMP_NAME = '노옹철')
AND EMP_NAME != '노옹철';

--4번
SELECT EMP_ID,EMP_NAME,DEPT_CODE,JOB_CODE 
FROM EMPLOYEE
WHERE EXTRACT(YEAR FROM HIRE_DATE ) = 2000;  --2000년도에 입사한 사원 --204	유재식	D6	J3

SELECT EMP_ID,EMP_NAME,DEPT_CODE,JOB_CODE,HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE,JOB_CODE) = (SELECT DEPT_CODE,JOB_CODE 
                              FROM EMPLOYEE
                              WHERE EXTRACT(YEAR FROM HIRE_DATE ) = 2000);

--5번
SELECT EMP_ID,EMP_NAME,DEPT_CODE,MANAGER_ID,EMP_NO,HIRE_DATE 
FROM EMPLOYEE
WHERE (DEPT_CODE,MANAGER_ID) = (SELECT DEPT_CODE,MANAGER_ID
                                 FROM EMPLOYEE
                                 WHERE SUBSTR(EMP_NO,8,1)='2'
                                 AND SUBSTR(EMP_NO,1,2)='77');
                                
--6번
SELECT EMP_ID,EMP_NAME,NVL(DEPT_TITLE,'소속없음'),JOB_NAME,HIRE_DATE  
FROM EMPLOYEE
NATURAL JOIN JOB  -- JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE HIRE_DATE IN (SELECT MIN(HIRE_DATE)
                   FROM EMPLOYEE 
                   WHERE ENT_YN = 'N'
                   GROUP BY DEPT_CODE )  --GROUP BY 절은 항상 제일 마지막에 작성해주기
ORDER BY HIRE_DATE;
--부서별로 그룹을 묶을 때 퇴사한 직원을 서브쿼리에서 제외해야함
--왜? 부서별로 가장 빠른 입사자 구했을 때 D8 부서는 이태림임(이태림은 퇴사자)
--문제점 : 부서별로 가장 빠른 입사자 구해놓고, 메인쿼리에서 퇴사자 제외해버리면
--D8 부서는 퇴사자인 이태림이 가장 빠른 입사자이기 때문에
--전제 부서중 D8 부서가 아예 제외되어 버린다.
--부서별 가장 빠른 입사자 구할때(서브쿼리) 퇴사한 직원을 뺀 상태에서 그룹으로 묶으면
-- D8부서의 가장 빠른 입사자는 이태림 제외 후 전형돈이 된다.



--7번
SELECT EMP_ID,EMP_NAME,JOB_NAME,나이,보너스포함연봉  --컬럼

FROM --테이블
(SELECT EMP_ID,EMP_NAME,JOB_NAME,JOB_CODE,TRUNC(MONTHS_BETWEEN(TRUNC(SYSDATE), (19 || SUBSTR(EMP_NO,1,6))) /12) 나이, 
'￦' || TO_CHAR( (SALARY * (NVL(BONUS,0) + 1)) *12, 'FM999,999,999') 보너스포함연봉
FROM EMPLOYEE
NATURAL JOIN JOB)

WHERE (나이,JOB_CODE) IN (SELECT MIN(TRUNC(MONTHS_BETWEEN(TRUNC(SYSDATE), (19 || SUBSTR(EMP_NO,1,6))) /12)),JOB_CODE
                         FROM EMPLOYEE
                         GROUP BY JOB_CODE)
               
ORDER BY 나이 DESC;  --TO_CHAR(컬럼값,'패턴') --> FM작성하면 사이에 공백 없어짐
                     -- EX)   TO_CHAR( (SALARY * (NVL(BONUS,0) + 1)) *12, '999,999,999') = ￦ 123,456,789
                     -- EX)   TO_CHAR( (SALARY * (NVL(BONUS,0) + 1)) *12, 'FM999,999,999') = ￦123,456,789


--SELECT SYSDATE FROM DUAL; --2024-03-08 10:00:12.000
--SELECT TRUNC(SYSDATE) FROM DUAL; --2024-03-08 00:00:00.000  ->시간 자름



--7번 풀이

--서브쿼리
SELECT MAX(EMP_NO) FROM EMPLOYEE
GROUP BY JOB_CODE;

--메인쿼리
SELECT EMP_ID,EMP_NAME,JOB_NAME,
FLOOR(MONTHS_BETWEEN(SYSDATE ,TO_DATE(SUBSTR(EMP_NO,1,6), 'RRMMDD') ) /12) "나이", --FLOOR : 소수점 첫쨰자리에서 버림
     TO_CHAR(SALARY * (1+ NVL(BONUS,0)) *12, 'L999,999,999') "보너스 포함 연봉" -- L :그 나라 화폐단위로 찍힘
FROM EMPLOYEE
NATURAL JOIN JOB
WHERE EMP_NO IN (SELECT MAX(EMP_NO) FROM EMPLOYEE
                 GROUP BY JOB_CODE) --직급별 나이가 가장 어린 직원이기때문에 JOB_CODE로 묶음
ORDER BY "나이" DESC;

--TO_DATE(SUBSTR(EMP_NO,1,6), 'RRMMDD') EX ) 1997/12/23 이렇게 뜸
--TO_DATE(SUBSTR(EMP_NO,1,6), 'YYMMDD') EX ) 2010/12/23 이렇게 뜸









