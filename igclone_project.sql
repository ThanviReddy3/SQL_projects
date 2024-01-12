
use ig_clone;

-- 1. Find the 5 oldest users.
select * from users
order by created_at asc
limit 5;

-- 2. What day of the week do most users register on? We need to figure out when to schedule an ad campaign.
SELECT DAYNAME(created_at) AS registerday, COUNT(created_at) AS registercount
FROM users
GROUP BY registerday 
ORDER BY registercount desc
limit 2; 

-- 3. We want to target our inactive users with an email campaign.Find the users who have never posted a photo
SELECT users.username FROM users
left JOIN photos ON users.id = photos.user_id
WHERE photos.user_id IS NULL;

 -- 4.  We're running a new contest to see who can get the most likes on a single photo.WHO WON??!!
SELECT u.username, l.photo_id, COUNT(l.user_id) AS like_count
FROM likes AS l
JOIN photos AS p ON p.id = l.photo_id
JOIN users AS u ON u.id = p.user_id
GROUP BY photo_id
ORDER BY like_count DESC, photo_id ASC
limit 2; 
﻿
 -- 5. Our Investors want to know… How many times does the average user post?HINT - *total number of photos/total number of users*
SELECT ROUND((SELECT COUNT(*)FROM photos)/(SELECT COUNT(*) FROM users),2) as ave;

-- 6. user ranking by postings higher to lower
SELECT 
    users.username, COUNT(photos.image_url) AS userrank
FROM
    users
        JOIN
    photos ON users.id = photos.user_id
GROUP BY users.id
ORDER BY 2 DESC;


-- 7. total numbers of users who have posted at least one time.
select count(distinct(users.id)) as total
from users
join photos on users.id=photos.user_id;


-- 8. A brand wants to know which hashtags to use in a post
select tag_name from tags;

-- 9. What are the top 5 most commonly used hashtags?
select tags.tag_name, count(tag_id) as tagcount from tags
join photo_tags on tags.id = photo_tags.tag_id
group by tags.tag_name, photo_tags.tag_id
order by tagcount desc
limit 5;

-- 10. We have a small problem with bots on our site. Find users who have liked every single photo on the site.
select username,user_id, count(photo_id) as cnt
from likes
inner join users on id = likes.user_id
group by user_id
having cnt = 257
order by cnt desc;

-- 11. Find users who have never commented on a photo.
SELECT users.username
FROM users
LEFT JOIN comments ON users.id = comments.user_id
WHERE comments.user_id IS NULL;
