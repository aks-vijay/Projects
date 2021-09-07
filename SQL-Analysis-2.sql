/*
Julia conducted a  days of learning SQL contest. The start date of the contest was March 01, 2016 and the end date was March 15, 2016.
Write a query to print total number of unique hackers who made at least  submission each day (starting on the first day of the contest), and find the hacker_id 
and name of the hacker who made maximum number of submissions each day. If more than one such hacker has a maximum number of submissions, 
print the lowest hacker_id. The query should print this information for each day of the contest, sorted by the date.
*/

;WITH ctedata
     AS (SELECT *,
                Ranking = DENSE_RANK()
                            OVER(
                              ORDER BY SUBMISSION_DATE ASC),
                Hackers = Count(1)
                            OVER(
                              partition BY SUBMISSION_DATE, HACKER_ID)
         FROM   SUBMISSIONS AS S
                CROSS apply (SELECT StartDate = Min(SUBMISSION_DATE),
                                    End_Date = Max(SUBMISSION_DATE)
                             FROM   SUBMISSIONS) MS
                OUTER apply (SELECT PastCount = Count(DISTINCT
                                                S1.SUBMISSION_DATE)
                             FROM   SUBMISSIONS AS S1
                             WHERE  S1.HACKER_ID = S.HACKER_ID
                                    AND S1.SUBMISSION_DATE BETWEEN
                                        MS.STARTDATE AND S.SUBMISSION_DATE) SC
                OUTER apply (SELECT TotalCount = Count(DISTINCT
                                                 S1.SUBMISSION_DATE)
                             FROM   SUBMISSIONS AS S1
                             WHERE  S1.HACKER_ID = S.HACKER_ID) SC1
         WHERE  1 = 1),
     cteresult
     AS (SELECT *,
                RID = ROW_NUMBER()
                        OVER(
                          partition BY SUBMISSION_DATE
                          ORDER BY HACKERS DESC, TOTALCOUNT DESC)
         FROM   ctedata
         WHERE  1 = 1 --AND PastCoount = Ranking
        )
SELECT A.SUBMISSION_DATE,
       A.CNT,
       A.HACKER_ID,
       H.NAME
FROM   (SELECT R.SUBMISSION_DATE,
               Cnt = Count(DISTINCT IIF(PASTCOUNT = RANKING, R.HACKER_ID, NULL))
               ,
               Hacker_ID = Max(IIF(RID = 1, R.HACKER_ID, NULL))
        FROM   cteresult AS R
        GROUP  BY R.SUBMISSION_DATE)A
       INNER JOIN HACKERS AS H
               ON H.HACKER_ID = A.HACKER_ID
ORDER  BY SUBMISSION_DATE 
