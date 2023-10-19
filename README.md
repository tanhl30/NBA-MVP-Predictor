# NBA-MVP-Predictor

As a hardcore NBA fans and a Data Science enthusiast, coudpled with that fact that I am taking ST3248 (Statistical Learning) and ST3131 (Regression Analysis) right now in NUS, I want to get some hands on work by doing a simple NBA MVP prediction. 

# Linear Regression
### Introduction
Fully aware that the share of MVP voting is not linear, the goal is to create a linear regression model that can best predict the trend of MVP voting over the last 10 years (season 2012-13 to 2022-22), the stats from 2022-23 will be used as test set and I hope to utilise this model to predict upcoming MVP standing.

There has never been a definition for what a "MVP" is to a NBA team.  Before 2000s, MVPs were mostly dominated by centers ; in the last 10 years, we see historical great efficient scorer won multiple MVPS (Curry, Jokic, Embiid). The point is, NBA landscape changes quickly, and to predict the voting trend better, only statistics from the last 10 years were used.

Furthermore, narrative has always been a huge part of vote drivers in the last decade. Voter fatigue was suspect to be a thing but we would not take both of these factors into account in this model.

### Data Preprocessing 
All the data were taken from [Basketball Reference](https://www.basketball-reference.com/). Here are the statistics we considered in the model building:

| Traditional Stats  | Advanced Stats | Team Stats|
| ------------- | ------------- | ------------- |
|Games Played | WS  | Team Wins|
| MIN  | WS per 48  |
| PTS  | PER  |
| AST  | TS%  |
| STL  | OWS  |
| BLK  | DWS  |
| FG%  | OBPM  |
| 3P%  | DBPM  |
| FT%  | BPM  |
|   | VORP |

We will build our model using stats of the 5 players with the most MVP vote share in a season, do note that:
- The total vote share in a season is 2.6, only player who received unanimous first place vote (Steph Curry in 2016) has a vote share of 1
- Only the stat of a top 5 players are considered, as the rest received very minimal vote share but the statistical difference may not be huge, which introduces more bias into our model. 


### Feature Selection
1. Domain Knowledge
     - Remove WS per 48, OWS, DWS are just linear combination of WS
     - Keep VORP and remove BPM, OBPM, DBPM, which are included in VORP
     - Remove TS% as it is a linear combination of PTS, FG%, 3P% and FT%
2. VIF
   
   we can show the reduction collinearity using VIF
   ![image](https://github.com/tanhl30/NBA-MVP-Predictor/assets/73421294/a583f77b-72de-43b4-a1ef-18907e8a7bd6)
   Some VIF are still more than 5, suggesting we can still do better in selecting variables
4. k-fold Cross Validation
   
   Using 10-fold cross validation, we found that using 3 variables provide us the lowest test error
   ![image](https://github.com/tanhl30/NBA-MVP-Predictor/assets/73421294/adf0915f-4ffc-491a-ba11-7b2e3541bf9d)
6. Best Subset Selection
   
   Knowing that we should have 3 predictors, we perform best subset selection and got the following predictors:
   - PER
   - VORP
   - Team Wins
8. p-value for Linear Regression
   
   Finally, we conducted ??

### Prediction & Interpretation 

### Limitation 
