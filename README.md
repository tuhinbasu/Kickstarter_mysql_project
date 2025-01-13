<div align="center"><h1><u>Kickstarter MySQL Project</u></h1></div>

![image](https://github.com/user-attachments/assets/89897c3d-2b72-45f8-a9e5-1852da3cc6b9)

<h2><u>About the Company</u></h2>

![image](https://github.com/user-attachments/assets/4aead152-12fc-46f7-a772-096e9a9e689f)

<p>Kickstarter is a crowdfunding platform that helps creators secure funding for their projects through contributions from backers. It emphasizes creative fields such as art, technology, design, and entertainment.
</p>

<h2><u>Objectives:</u></h2>
<p>
  1. Provide strategic recommendations to Kickstarter stakeholders to enhance campaign success rates. <br>
  2. Identify key factors that attract backers and boost engagement.<br>
  3. Highlight growth opportunities to strengthen Kickstarter’s platform performance.<br>
</p>

<h2><u>Dataset</u></h2>

[Kickstarter Projects](https://www.kaggle.com/datasets/kemical/kickstarter-projects)
<p>
<h3>This dataset includes 15 columns, each capturing essential details about Kickstarter projects:</h3>

1. ID: A unique identifier for each project. This serves as the primary key for data reference.
2. name: The title of the project. This gives insights into how projects are marketed and named.
3. category: The specific niche or subcategory of the project (e.g., “Tabletop Games” or “Documentary”). 
4. main_category: The broader category under which the project falls (e.g., “Games” or “Film & Video”).
5. currency: The type of currency used for the project funding (e.g., USD, GBP, EUR).
6. deadline: The date when the campaign ended or was due to end.
7. goal: The funding goal set by the project creator (in the project’s respective currency).
8. launched: The date and time when the campaign was launched, indicating the start of the crowdfunding period.
9. pledged: The total amount of money pledged by backers at the end of the campaign (in the project’s respective currency).
10. usd_pledged: This column represents the amount of money pledged for a project, converted to US dollars by Kickstarter's internal currency conversion system.
11. usd_goal_real:  The total amount of money pledged by backers at the end of the campaign (in USD)
12. usd_pledged_real: This column represents the pledged amount, converted to US dollars using exchange rates provided by an external service, Fixer.io API.
13. state: The final status of the project, which can be:
  * successful: Fully funded or surpassed the goal.
  * failed: Did not meet the funding goal.
  * canceled: Campaign ended prematurely by the creator.
14. backers: The total number of individuals who pledged money to support the project.
15. country: The country of the project creator, indicating where the campaign originated.</p>

<h2><u>Potential Applications of the Dataset</u></h2>
<p>
<h3>This dataset allows us to analyze trends and patterns across Kickstarter projects, such as:</h3>

1. Understanding the characteristics of successful campaigns.
2. Exploring category and country-specific performance.
3. Analyzing seasonal trends in project launches and success.
4. Evaluating the impact of funding goals, backers, and project timelines on success rates.
5. Identifying underperforming categories or regions that may need additional support.</p>

<h2><u>Implementation</u></h2>
Language: MySQL<br>
Platform: MySQL Workbench 8.0 and PowerBI (for visualization)<br>
Presentation & Documentation: MS PowerPoint Presentation and Google Doc<br>

<h2><u>Visualization</u></h2>
<p>1. Which are the high and low-performing categories?</p>

![image](https://github.com/user-attachments/assets/8bdc48bf-4f9d-4810-9b4d-a10f652b3808)

<p>2. Which categories have significant pledged amounts and a high number of backers?</p>

![image](https://github.com/user-attachments/assets/8b2121d1-dbed-41b8-bd55-b181c92056fa)

<p>3. Analyse & identify the relationship between the backers and the categories.</p>

![image](https://github.com/user-attachments/assets/f0f9b7b2-695e-4a93-916a-6acad020c6de)

<p>4. Which countries have the highest number of successful projects?</p>

![image](https://github.com/user-attachments/assets/5097275a-8a0b-4057-86b0-7df2f521d58d)

<p>5. How can we identify the categories that exceed their project goals and determine the average pledged amount by backers?</p>

![image](https://github.com/user-attachments/assets/6d0d4b3a-064d-4817-954e-ca0482e86690)

<p>6. How can the optimal project duration and months with high success rates be identified?</p>

![image](https://github.com/user-attachments/assets/3d98f22b-eda6-4368-ad51-5a68481c50a1)

<p>7. How can analyzing category trends over the years, based on success, failure, and cancellation rates, help identify top-performing categories and those with untapped potential?</p>

![image](https://github.com/user-attachments/assets/bf473d3f-b378-4df3-9cde-d292ac58e2b5)

<h2><u>Optimization</u></h2>
I utilized CTEs to create temporary tables, improving the readability, reusability, and efficiency of the queries. Additionally, I incorporated the LIMIT clause to enhance query performance. Redundant and inaccurate columns, such as goal, pledged, and usd_pledged, were removed, reducing the total number of rows from 15 to 12.

<h2>Feedback</h2>
If you have any feedback, please reach out to 

[tuhinbasu97@gmail.com](tuhinbasu97@gmail.com) or 

[linkedIn](https://www.linkedin.com/in/tuhinbasu)</p>
<h2>About Me</h2>
<p>Hello, My name is Tuhin Basu.<br>
I am a Data Analyst in training.</p>





