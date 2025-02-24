## ERROR CODES ##

HTTP status codes convey the result of a request and are divided into several classes:

1xx (Informational): Request received, continuing process.
2xx (Successful): The action was successfully received, understood, and accepted.
3xx (Redirection): Further action needs to be taken in order to complete the request.
4xx (Client Error): The request contains bad syntax or cannot be fulfilled.
5xx (Server Error): The server failed to fulfill a valid request.
For error responses (4xx and 5xx status codes), it's good practice to use standard HTTP status codes to indicate the nature of the error. For example:

400 Bad Request: The server cannot or will not process the request due to an apparent client error.
401 Unauthorized: Similar to 403 Forbidden, but specifically for authentication.
403 Forbidden: The server understood the request, but it refuses to authorize it.
404 Not Found: The requested resource could not be found on the server.
500 Internal Server Error: A generic error message returned when an unexpected condition was encountered.

## dependencies ##

1- @prisma/client: Prisma is an ORM (Object-Relational Mapping) tool for databases. It generates TypeScript/JavaScript code to interact with your database, making it easier to manage database queries and models.

2- @types/multer: This package provides TypeScript type definitions for the popular file upload middleware Multer. It helps handle file uploads in Express applications.

3- axios: A widely-used HTTP client for making requests to APIs or servers. It simplifies handling asynchronous requests and responses.

4- bcrypt: A library for hashing and salting passwords. It’s commonly used for securely storing user passwords in databases.

5- cors: Middleware for Cross-Origin Resource Sharing. It enables or restricts access to resources on a web page from different domains.

6- dotenv: A utility for loading environment variables from a .env file. Useful for managing configuration settings in your app.

7- express: A popular web application framework for Node.js. It simplifies building APIs, handling routes, and middleware.

8- express-rate-limit: Middleware to limit the rate of incoming requests to prevent abuse or DoS attacks.

9- handlebars: A templating engine that allows you to create dynamic HTML templates. Useful for rendering views in Express.

10- jsonwebtoken: A library for creating and verifying JSON Web Tokens (JWT). Commonly used for authentication and authorization.

11- multer: Middleware for handling file uploads in Express. It supports various storage options (e.g., disk storage, memory, S3).

12- node-cron: A package for scheduling cron jobs in Node.js. Useful for running tasks at specific intervals.

13- nodemailer: A library for sending email from Node.js applications. It simplifies email handling and supports various transports (SMTP, SendGrid, etc.).

14- pino: A fast and lightweight logging library for Node.js. It’s efficient and suitable for production use.

15- pino-pretty: A CLI tool for formatting Pino logs in a human-readable way during development.

16- prisma: The Prisma CLI for database migrations, schema management, and data modeling.

17- request-progress: A package for tracking the progress of HTTP requests. Useful for showing download/upload progress.

18- sanitize-filename: A utility for sanitizing file names to prevent issues with special characters or invalid paths.

19- save: A package manager command for saving dependencies to your package.json.

20- save-dev: Similar to save, but for development dependencies (used during development, not in production).