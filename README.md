# SuperMarket-Database
This project demonstrates the creation and management of a synthetic database for a hypothetical mart, using Python and SQL. The process includes generating synthetic data, cleaning and processing the data, creating tables and establishing relationships in SQL, loading the data into a SQL database using Python, and solving various SQL queries.

### Project Workflow**

**1. Data Generation**
Synthetic data for the mart was generated using Python. This included data for the following tables:

Customers
Transactions
Feedback
Redemptions
Categories
Products
Suppliers
Coupons
Employees
Python libraries such as Faker were used to create realistic data for each table

**2. Data Cleaning and Processing**
The generated data was cleaned and processed to ensure consistency and accuracy. This included:

Removing duplicates
Ensuring valid foreign key references
Normalizing text fields

**3. Creating Tables in SQL**
Tables were created in SQL to store the cleaned data. The table schemas were designed with appropriate data types and primary/foreign key relationships

**4. Loading Data into the Database**
The cleaned data was loaded into the SQL database using Python. The pandas library was used to handle DataFrame operations, and SQLAlchemy or pymysql were used to interact with the database

**5. Solving Queries in SQL**
Various SQL queries were written and executed to analyze the data. This included basic queries to retrieve data, as well as more complex queries involving joins, aggregations, and subqueries.

### Conclusion
This project showcases the entire process of generating synthetic data, cleaning and processing it, creating tables and establishing relationships in SQL, loading the data into a SQL database using Python, and solving various SQL queries to derive meaningful insights. The approach ensures a comprehensive understanding of data handling and SQL operations in a real-world scenario.
