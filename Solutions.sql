
-- Query 1 Get the id values of the first 5 clients from district_id with a value equals to 1.

SELECT client_id
FROM bank.client
WHERE district_id = 1
ORDER BY client_id ASC
LIMIT 5;

-- Query 2 In the client table, get an id value of the last client where the district_id equals to 72.

SELECT client_id
FROM bank.client
WHERE district_id = 72
ORDER BY client_id DESC
LIMIT 1;

-- Query 3 Get the 3 lowest amounts in the loan table. ORDER BY

SELECT amount
FROM bank.loan
ORDER BY amount
LIMIT 3;

-- Query 4 What are the possible values for status, ordered alphabetically in ascending order in the loan table? Distinct

SELECT DISTINCT status
FROM bank.loan
ORDER BY status ASC;

-- Query 5 What is the loan_id of the highest payment received in the loan table?

SELECT *
FROM bank.loan
WHERE loan_id IN (6312, 6415);

SELECT loan_id
FROM bank.loan
ORDER BY payments DESC
LIMIT 1;

-- Query 6 What is the loan amount of the lowest 5 account_ids in the loan table? Show the account_id and the corresponding amount

SELECT account_id, amount
FROM bank.loan
ORDER BY account_id
LIMIT 5;

-- Query 7 What are the account_ids with the lowest loan amount that have a loan duration of 60 in the loan table?

SELECT account_id
FROM bank.loan
WHERE duration = 60
ORDER BY amount
LIMIT 5;

-- Query 8 What are the unique values of k_symbol in the order table? Note: There shouldn't be a table name order, since order is reserved from the ORDER BY clause. You have to use backticks to escape the order table name.

SELECT DISTINCT k_symbol
FROM bank.order;

-- Query 9 In the order table, what are the order_ids of the client with the account_id 34?

SELECT order_id
FROM bank.`order`
WHERE account_id = 34;

-- Query 10 In the order table, which account_ids were responsible for orders between order_id 29540 and order_id 29560 (inclusive)?

SELECT DISTINCT account_id
FROM bank.`order`
WHERE order_id BETWEEN 29540 AND 29560;

-- Query 11 In the order table, what are the individual amounts that were sent to (account_to) id 30067122?

SELECT amount
FROM bank.`order`
WHERE account_to = 30067122;

-- Query 12 In the trans table, show the trans_id, date, type and amount of the 10 first transactions from account_id 793 in chronological order, from newest to oldest.

SELECT trans_id, date, type, amount
FROM trans
WHERE account_id = 793
ORDER BY date DESC
LIMIT 10;

-- Query 13 

SELECT district_id, COUNT(*) AS num_clients
FROM client
WHERE district_id < 10
GROUP BY district_id
ORDER BY district_id ASC;

-- Query 14

SELECT type, COUNT(*) AS type_count
FROM card
GROUP BY type
ORDER BY count(type) desc;

-- Query 15  

SELECT account_id, SUM(amount) AS total_loan_amount
FROM loan
GROUP BY account_id
ORDER BY total_loan_amount DESC
LIMIT 10;

-- Query 16

SELECT date, COUNT(*) AS num_loans
FROM loan
WHERE date < 930907
GROUP BY date
ORDER BY date DESC;

-- Query 17

SELECT date, duration, COUNT(*) AS num_loans
FROM loan
WHERE date >= 971201 AND date < 980101
GROUP BY date, duration
ORDER BY date ASC, duration ASC;

-- Query 18

SELECT account_id, type, SUM(amount) AS total_amount
FROM trans
WHERE account_id = 396 AND type IN ('VYDAJ', 'PRIJEM')
GROUP BY account_id, type
ORDER BY type ASC;

-- Query 19

SELECT account_id,
CASE WHEN type = 'VYDAJ' THEN 'Outgoing' WHEN type = 'PRIJEM' THEN 'Incoming' 
END AS transaction_type,
FLOOR(SUM(amount)) AS total_amount
FROM trans
WHERE account_id = 396 AND type IN ('VYDAJ', 'PRIJEM')
GROUP BY account_id, type
ORDER BY transaction_type ASC;

-- query 20

SELECT
    account_id,
    FLOOR(SUM(CASE WHEN type = 'PRIJEM' THEN amount ELSE 0 END)) AS incoming_amount,
    FLOOR(SUM(CASE WHEN type = 'VYDAJ' THEN amount ELSE 0 END)) AS outgoing_amount,
    FLOOR(SUM(CASE WHEN type = 'PRIJEM' THEN amount ELSE -amount END)) AS difference
FROM trans
WHERE account_id = 396 AND type IN ('VYDAJ', 'PRIJEM')
GROUP BY account_id;

-- Query 21 

WITH RankedAccounts AS (
    SELECT
        account_id,
        FLOOR(SUM(CASE WHEN type = 'PRIJEM' THEN amount ELSE 0 END)) AS incoming_amount,
        FLOOR(SUM(CASE WHEN type = 'VYDAJ' THEN amount ELSE 0 END)) AS outgoing_amount,
        FLOOR(SUM(CASE WHEN type = 'PRIJEM' THEN amount ELSE -amount END)) AS difference,
        RANK() OVER (ORDER BY FLOOR(SUM(CASE WHEN type = 'PRIJEM' THEN amount ELSE -amount END)) DESC) AS rank_order
    FROM trans
    WHERE type IN ('VYDAJ', 'PRIJEM')
    GROUP BY account_id
)
SELECT account_id, incoming_amount, outgoing_amount, difference
FROM RankedAccounts
WHERE rank_order <= 10;
