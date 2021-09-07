/* 
Qn - Samantha interviews many candidates from different colleges using coding challenges and contests. Write a query to print the contest_id, hacker_id, name, and the 
sums of total_submissions, total_accepted_submissions, total_views, and total_unique_views for each contest sorted by contest_id. Exclude the contest from the 
result if all four sums are 0
*/

-- 

SELECT con.CONTEST_ID,
       con.HACKER_ID,
       con.NAME,
       Sum(TOTAL_SUBMISSIONS),
       Sum(TOTAL_ACCEPTED_SUBMISSIONS),
       Sum(TOTAL_VIEWS),
       Sum(TOTAL_UNIQUE_VIEWS)
FROM   CONTESTS con
       JOIN COLLEGES col
         ON con.CONTEST_ID = col.CONTEST_ID
       JOIN CHALLENGES cha
         ON col.COLLEGE_ID = cha.COLLEGE_ID
       LEFT JOIN (SELECT CHALLENGE_ID,
                         Sum(TOTAL_VIEWS)        AS total_views,
                         Sum(TOTAL_UNIQUE_VIEWS) AS total_unique_views
                  FROM   VIEW_STATS
                  GROUP  BY CHALLENGE_ID) vs
              ON cha.CHALLENGE_ID = vs.CHALLENGE_ID
       LEFT JOIN (SELECT CHALLENGE_ID,
                         Sum(TOTAL_SUBMISSIONS)          AS total_submissions,
                         Sum(TOTAL_ACCEPTED_SUBMISSIONS) AS
                         total_accepted_submissions
                  FROM   SUBMISSION_STATS
                  GROUP  BY CHALLENGE_ID) ss
              ON cha.CHALLENGE_ID = ss.CHALLENGE_ID
GROUP  BY con.CONTEST_ID,
          con.HACKER_ID,
          con.NAME
HAVING Sum(TOTAL_SUBMISSIONS) != 0
        OR Sum(TOTAL_ACCEPTED_SUBMISSIONS) != 0
        OR Sum(TOTAL_VIEWS) != 0
        OR Sum(TOTAL_UNIQUE_VIEWS) != 0
ORDER  BY CONTEST_ID; 
