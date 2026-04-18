-- datacleaning

SELECT * FROM layoffs;


-- 1.remove duplicates (using partition by row_number >1 method)
-- 2. standardize data
-- 3. null values and blank space
-- 4. remove any columns

-- copy of raw data
create table layoffs_staging
like layoffs;
 insert  layoffs_staging 
select * from layoffs;

select* from layoffs_staging;
