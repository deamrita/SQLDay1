-----------CREATE TABLE---------------
CREATE TABLE COURSE(
	COURSE_ID NUMERIC(10) NOT NULL,
	COURSE_NAME VARCHAR(500),
	COURSE_START_DATE DATE,
	CONSTRAINT COURSE_PK PRIMARY KEY (COURSE_ID),
);

-----------INSERT VALUES-------------------
INSERT INTO COURSE (COURSE_ID,COURSE_NAME,COURSE_START_DATE) VALUES (101, 'MATH', '01-DEC-2021');
INSERT INTO COURSE (COURSE_ID,COURSE_NAME,COURSE_START_DATE) VALUES (102, 'STAT', '08-DEC-2021');
INSERT INTO COURSE (COURSE_ID,COURSE_NAME,COURSE_START_DATE) VALUES (103, 'PYTHON','15-DEC-2021');

--------------SELECTION--------------
SELECT * FROM COURSE

------------DROP TABLE---------------
--DROP TABLE COURSE

CREATE TABLE STUDENT(
	STU_ID NUMERIC(10) NOT NULL,
	STU_NAME VARCHAR(500),
	STU_AGE NUMERIC(10),
	COURSE_ID NUMERIC(10),
	CONSTRAINT STU_PK PRIMARY KEY (STU_ID),
	CONSTRAINT COURSE_FK FOREIGN KEY(COURSE_ID) REFERENCES COURSE(COURSE_ID)
);

INSERT INTO STUDENT (STU_ID,STU_NAME,STU_AGE,COURSE_ID) VALUES (001, 'abc', 23,101);
INSERT INTO STUDENT (STU_ID,STU_NAME,STU_AGE,COURSE_ID) VALUES (002, 'ghj', 29,103);
INSERT INTO STUDENT (STU_ID,STU_NAME,STU_AGE,COURSE_ID) VALUES (003, 'uio', 21,103);
INSERT INTO STUDENT (STU_ID,STU_NAME,STU_AGE,COURSE_ID) VALUES (004, 'asd', 28,102);
INSERT INTO STUDENT (STU_ID,STU_NAME,STU_AGE,COURSE_ID) VALUES (005, 'hjt', 25,101);
INSERT INTO STUDENT (STU_ID,STU_NAME,STU_AGE,COURSE_ID) VALUES (006, 'qwe', 22,101);

SELECT * FROM STUDENT

--DROP TABLE STUDENT

-----UPDATE---------------
UPDATE COURSE 
SET COURSE_START_DATE = '09-DEC-2021', COURSE_NAME = 'STATISTICS'
WHERE COURSE_ID = 102;

-----ALTER----------------
ALTER TABLE STUDENT 
ADD STU_PH_NO NUMERIC(10);

UPDATE STUDENT SET STU_PH_NO = 90563412 WHERE STU_ID = 001
UPDATE STUDENT SET STU_PH_NO = 90563456 WHERE STU_ID = 002
UPDATE STUDENT SET STU_PH_NO = 90563498 WHERE STU_ID = 003
UPDATE STUDENT SET STU_PH_NO = 90563434 WHERE STU_ID = 004
UPDATE STUDENT SET STU_PH_NO = 90563400 WHERE STU_ID = 005
UPDATE STUDENT SET STU_PH_NO = 90563478 WHERE STU_ID = 006

-----------DELETE-----------
DELETE FROM STUDENT WHERE STU_ID = 006

-----------RENAME--------------
SP_RENAME 'STUDENT' ,'STUDENT_DET'

--------ORDER BY--------------
SELECT * FROM STUDENT_DET WHERE STU_NAME LIKE 'a%'
SELECT * FROM STUDENT_DET WHERE STU_AGE > 22 
ORDER BY STU_NAME DESC
-------------GROUP BY----------------
SELECT COUNT(STU_ID), COURSE_ID
FROM STUDENT_DET
GROUP BY COURSE_ID
ORDER BY COUNT(STU_ID) DESC

------------UNION JOIN-------------
SELECT COURSE_ID 
FROM COURSE
UNION
SELECT COURSE_ID 
FROM STUDENT_DET

-----------INNER JOIN---------------
SELECT * FROM COURSE C
INNER JOIN STUDENT_DET S
ON C.COURSE_ID = S.COURSE_ID

-------LEFT JOIN---------
SELECT * FROM COURSE C
LEFT JOIN STUDENT_DET S
ON C.COURSE_ID = S.COURSE_ID

------------RIGHT JOIN---------
SELECT * FROM COURSE C
RIGHT JOIN STUDENT_DET S
ON C.COURSE_ID = S.COURSE_ID

------full outer----------
SELECT * FROM COURSE C
FULL OUTER JOIN STUDENT_DET S
ON C.COURSE_ID = S.COURSE_ID

--------pivot (FOR CONVERTING DATA FROM ROW TO COLUMN)-------
SELECT * FROM 
(
SELECT C.COURSE_ID, S.STU_NAME, C.COURSE_NAME FROM 
COURSE C INNER JOIN STUDENT_DET S
ON C.COURSE_ID = S.COURSE_ID
) AS SOURCETABLE
PIVOT
(
COUNT(COURSE_ID)
FOR COURSE_NAME IN ([MATH] ,[STATISTICS] , [PYTHON])
) AS PIVOTTABLE

-------ROW NUMBER TO GET THE MOST RECENT DATA FROM DUPLICATE DATA-------------

SELECT STU_NAME, STU_AGE, ROW_ID FROM
(
SELECT S.*,
ROW_NUMBER() OVER (PARTITION BY S.STU_NAME,S.STU_AGE ORDER BY C.COURSE_START_DATE DESC) ROW_ID
FROM 
COURSE C INNER JOIN
STUDENT_DET S
ON C.COURSE_ID = S.COURSE_ID
)TABLE1
WHERE ROW_ID = 1

