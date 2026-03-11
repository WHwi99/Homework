-- Active: 1773042770346@@127.0.0.1@3306@employeedb
-- 연봉 계산법 : 월급 * (1 + 보너스) * 12 로 수행하시면 됩니다.

-- 참고로 보너스 컬럼 값이 null인 경우 연산 결과도 null이 나옵니다.

-- null 처리 함수 → 내장 함수 챕터에서 학습할 예정이지만 적용해보려면

-- IFNULL(보너스, 0) 또는 NVL(보너스, 0) 과 같이 적용하면 null 인 경우 0 으로 취급되어 보너스 없이 계산이 수행 됩니다.

SELECT * FROM employee

-- 1. 이름에 '형'자가 들어가는 직원들의 사번, 사원명, 부서명을 조회하시오.(1행)
SELECT
    a.emp_id as 사번,
    a.emp_name as 사원명,
    b.dept_title as 부서명
FROM
    employee a
JOIN
    department b ON a.dept_code = b.dept_ID
WHERE
    emp_name LIKE "%형%";

-- 2. 해외영업팀에 근무하는 사원명, 직급명, 부서코드, 부서명을 조회하시오.(9행)
SELECT
    a.emp_name as 사원명,
    c.job_name as 직급명,
    a.dept_code as 부서코드,
    b.dept_title as 부서명
FROM
    employee a
JOIN
    department b ON a.dept_code = b.dept_ID
JOIN
    job c ON a.job_code = c.job_code
WHERE
    dept_code IN ('D5','D6','D7');

-- 3. 보너스포인트를 받는 직원들의 사원명, 보너스포인트, 부서명, 근무지역명을 조회하시오.(8행)
-- (INNER JOIN 결과)
SELECT
    a.emp_name as 사원명,
    a.bonus as 보너스포인트,
    b.dept_title as 부서명,
    d.national_name as 근무지역명
FROM
    employee a
JOIN
    department b ON a.dept_code = b.dept_id
JOIN
    location c ON b.location_id = c.local_code
JOIN
    national d ON c.national_code = d.national_code
WHERE bonus IS NOT NULL;

-- 4. 부서코드가 D2인 직원들의 사원명, 직급명, 부서명, 근무지역명을 조회하시오.(3행)
SELECT
    a.emp_name as 사원명,
    j.job_name as 직급명,
    b.dept_title as 부서명,
    c.local_name as 근무지역명
FROM
    employee a
JOIN
    job j ON a.job_code = j.job_code
JOIN
    department b ON a.dept_code = b.dept_id
JOIN
    location c ON b.location_id = c.local_code
WHERE 
    dept_code = 'D2';

-- 5. 급여 테이블의 등급별 최소급여(MIN_SAL)보다 많이 받는 직원들의
-- 사원명, 직급명, 급여, 연봉을 조회하시오.
-- 연봉에 보너스포인트를 적용하시오.(20행)
SELECT
    a.emp_name as 사원명,
    b.job_name as 직급명,
    a.salary as 급여,
    a.salary * (1 + IFNULL(a.bonus,0)) * 12 as 연봉
FROM
    employee a
JOIN
    job b ON a.job_code = b.job_code
JOIN
    sal_grade c ON a.sal_level = c.sal_level
WHERE
   (a.salary > c.min_sal);

-- 6. 한국(KO)과 일본(JP)에 근무하는 직원들의 
-- 사원명, 부서명, 지역명, 국가명을 조회하시오.(15행)
SELECT
    a.emp_name as 사원명,
    b.dept_title as 부서명,
    c.local_name as 지역명,
    d.national_name as 국가명
FROM
    employee a
JOIN
    department b ON a.dept_code = b.dept_id
JOIN
    location c ON b.location_id = c.local_code
JOIN
    national d ON c.national_code = d.national_code
WHERE
    c.national_code IN ("KO","JP");


-- 7. 보너스포인트가 없는 직원들 중에서 직급코드가 J4와 J7인 직원들의 사원명, 직급명, 급여를 조회하시오.
-- 단, join과 IN 사용할 것(8행)
SELECT
    a.emp_name as 사원명,
    b.job_name as 직급명,
    a.salary as 급여
FROM
    employee a
JOIN
    job b ON a.job_code = b.job_code

WHERE (a.bonus IS NULL) AND (a.job_code IN ("J4","J7"));


-- 8. 직급이 대리이면서 아시아 지역(ASIA1, ASIA2, ASIA3 모두 해당)에 근무하는 직원 조회(2행)
-- 사번(EMPLOYEE.EMP_ID), 이름(EMPLOYEE.EMP_NAME), 직급명(JOB.JOB_NAME), 부서명(DEPARTMENT.DEPT_TITLE),
-- 근무지역명(LOCATION.LOCAL_NAME), 급여(EMPLOYEE.SALARY)를 조회하시오.
SELECT
    a.emp_id as '사번(EMPLOYEE.EMP_ID)',
    a.emp_name as '이름(EMPLOYEE.EMP_NAME)',
    b.job_name as '직급명(JOB.JOB_NAME)',
    c.dept_title as '부서명(DEPARTMENT.DEPT_TITLE)',
    d.local_name as '근무지역명(LOCATION.LOCAL_NAME)',
    a.salary as '급여(EMPLOYEE.SALARY)'
FROM
    employee a
JOIN
    job b ON a.job_code = b.job_code
JOIN
    department c ON a.dept_code = c.dept_ID
JOIN
    location d on c.location_id = d.local_code
WHERE
    (b.job_name = "대리") AND (d.local_name IN ('ASIA1','ASIA2','ASIA3'));

-- 9. 각 부서별 평균 급여와 직원 수를 조회하시오. (NULL 급여는 제외) 
-- 평균 급여가 높은 순으로 정렬하시오. (6행)
SELECT
    b.dept_title as 직급,
    AVG(a.salary) as avg_salary,
    COUNT(a.dept_code) as dept_count
FROM
    employee a
JOIN
    department b ON a.dept_code = b.dept_id 
GROUP BY
    a.dept_code;
 
-- 10. 직원 중 보너스를 받는 직원들의 연봉 총합이 1억 원을 
-- 초과하는 부서의 부서명과 연봉 총합을 조회하시오. (1행)
SELECT
    b.dept_title as 부서명,
    SUM(a.salary * (1 + IFNULL(a.bonus,0)) * 12) as 연봉총합
FROM
    employee a
JOIN
    department b ON a.dept_code = b.dept_id
GROUP BY
    a.dept_code
HAVING
    SUM(a.salary * (1 + a.bonus) * 12) > 100000000;
 
-- 11. 국내 근무하는 직원들 중 평균 급여 이상을 받는 
-- 직원들의 사원명, 급여, 부서명을 조회하시오. (서브쿼리 사용) (4행)

SELECT
    
-- 12. 모든 부서의 부서명과 해당 부서에 소속된 직원 수를 조회하시오. 
-- 직원이 없는 부서도 함께 표시하시오. (9행)

-- 13. 차장(J4) 이상 직급을 가진 직원과 사원(J7) 직급을 가진 
-- 직원들의 급여 합계를 비교하여 결과를 출력하시오. (SET OPERATOR 사용) (2행)
