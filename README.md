<div align="center"><h1><u>Kickstarter MySQL Project</u></h1></div>

![image](https://github.com/user-attachments/assets/89897c3d-2b72-45f8-a9e5-1852da3cc6b9)

<h2><u></u>About the Company</u></h2>

![image](https://github.com/user-attachments/assets/4aead152-12fc-46f7-a772-096e9a9e689f)

<p>Kickstarter is a crowdfunding platform that helps creators secure funding for their projects through contributions from backers. It emphasizes creative fields such as art, technology, design, and entertainment.
</p>

<h2><u></u>Objectives:</u></h2>
<p>
  1. Provide strategic recommendations to Kickstarter stakeholders to enhance campaign success rates. <br>
  2. Identify key factors that attract backers and boost engagement.<br>
  3. Highlight growth opportunities to strengthen Kickstarter’s platform performance.<br>
</p>

<h2><u></u>Dataset</u></h2>
<p>
This dataset includes 12 columns, each capturing essential details about Kickstarter projects:

ID: A unique identifier for each project. This serves as the primary key for data reference.
name: The title of the project. This gives insights into how projects are marketed and named.
category: The specific niche or subcategory of the project (e.g., “Tabletop Games” or “Documentary”). 
main_category: The broader category under which the project falls (e.g., “Games” or “Film & Video”).
currency: The type of currency used for the project funding (e.g., USD, GBP, EUR).
deadline: The date when the campaign ended or was due to end.
goal: The funding goal set by the project creator (in the project’s respective currency).
launched: The date and time when the campaign was launched, indicating the start of the crowdfunding period.
pledged: The total amount of money pledged by backers at the end of the campaign (in the project’s respective currency).
usd_pledged: This column represents the amount of money pledged for a project, converted to US dollars by Kickstarter's internal currency conversion system.
usd_goal_real:  The total amount of money pledged by backers at the end of the campaign (in USD)
usd_pledged_real: This column represents the pledged amount, converted to US dollars using exchange rates provided by an external service, Fixer.io API.
state: The final status of the project, which can be:
  * successful: Fully funded or surpassed the goal.
  * failed: Did not meet the funding goal.
  * canceled: Campaign ended prematurely by the creator.
  * live: Campaign still ongoing (if any live campaigns exist in the dataset).
backers: The total number of individuals who pledged money to support the project.
country: The country of the project creator, indicating where the campaign originated.
</p>
