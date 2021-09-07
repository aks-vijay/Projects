Samantha interviews many candidates from different colleges using coding challenges and contests. Write a query to print the contest_id, hacker_id, name, and the sums of total_submissions, total_accepted_submissions, total_views, and total_unique_views for each contest sorted by contest_id. Exclude the contest from the result if all four sums are 0

SELECT  B.college_id, 
        A.name, 
        A.hacker_id, 
        A.Contest_ID 
INTO #College
FROM Contests A
INNER JOIN Colleges B ON A.contest_id = B.Contest_Id

SELECT  B.Challenge_ID, 
        A.name, 
        A.hacker_id, 
        A.Contest_ID 
INTO #Challenge 
FROM #College A
INNER JOIN Challenges B ON A.College_ID = B.College_ID

SELECT  B.challenge_id, 
        B.total_views, 
        B.total_unique_Views,
        A.name, 
        A.hacker_id,
        A.Contest_ID
INTO #Stats
FROM #Challenge A
INNER JOIN View_Stats B ON A.Challenge_id = B.Challenge_Id

SELECT  A.Contest_ID, 
        A.Hacker_ID, 
        A.Name, 
        SUM(B.Total_Submissions),
        B.total_accepted_submissions,
        A.total_views,
        A.total_unique_views
FROM #Stats A
INNER JOIN Submission_Stats B
ON A.Challenge_ID = B.Challenge_ID
GROUP BY A.Contest_ID, 
        A.Hacker_ID, 
        A.Name, 
        B.Total_Submissions,
        B.total_accepted_submissions,
        A.total_views,
        A.total_unique_views
HAVING (SUM(B.Total_Submissions) <> 0 
OR SUM(B.total_accepted_submissions) <> 0 
OR SUM(A.total_views) <> 0
OR SUM(A.total_unique_views) <> 0)
ORDER BY A.Contest_ID

