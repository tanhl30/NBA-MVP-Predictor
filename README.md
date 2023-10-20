# NBA MVP Predictor with Linear Regression
### Introduction
The aim of this project is to develop a linear regression model capable of predicting the MVP voting trends over the past decade (from the 2012-13 season to the 2022-22 season). We will use statistics from the 2022-23 season as a test set and employ this model to forecast future MVP standings.

Defining an NBA Most Valuable Player (MVP) has always been a subjective matter. Historically, centers dominated MVP awards, but in the last ten years, highly efficient scorers like Curry, Jokic, and Embiid have won multiple MVPs. The NBA landscape evolves rapidly, so to enhance our voting trend predictions, we rely solely on statistics from the last decade.

### Data Preprocessing 
All the data were sourced from [Basketball Reference](https://www.basketball-reference.com/). The statistics we considered for our model include:

| Traditional Stats  | Advanced Stats | Team Stats|
| :---: | :---: | :---: |
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

Our model utilizes statistics from the top 5 players with the highest MVP vote share in a season. Due to the ranked voting system (similar to Oscar, where first place vote is 10 points, second place vote is 7 points .. ) ,the total vote share in a season is 2.6, and only unanimous first-place vote recipients, like Stephen Curry in 2016, have a vote share of 1. We restrict our focus to the top 5 players each year, as players outside this range receive minimal vote shares, which could introduce bias into our model. Furthermore, we adjusted statistics for the 2019-20 season to account for its reduced number of games (72, due to Covid-19), scaling them to reflect an 82-game season.


### Feature Selection
1. Domain Knowledge

   - We removed WS per 48, as it's a linear combination of WS.
   - We retained VORP and eliminated BPM, OBPM, DBPM, as they are included in VORP.
   - TS% was removed as it's a linear combination of PTS, FG%, 3P%, and FT%.
3. VIF
   
   We assessed collinearity using VIF, and although VIF values reduced significantly after removing some predictors in step 1, some VIF values are still larger than 5 , indicating collinearity, our faeture selection process continued.
   ![image](https://github.com/tanhl30/NBA-MVP-Predictor/assets/73421294/a583f77b-72de-43b4-a1ef-18907e8a7bd6)
   
4. k-fold Cross Validation
   
   Using 10-fold cross-validation, we identified that using 3 predictors yielded the lowest test error.
   ![Rplot](https://github.com/tanhl30/NBA-MVP-Predictor/assets/73421294/d680a408-d366-4e3e-8dfe-89380e0f1e72)

6. Best Subset Selection
   
   Given the decision to use 3 predictors, we conducted best subset selection and determined the following predictors:
   - PER
   - VORP
   - Team Wins
8. T-test
   
   Finally, We performed a t-test for our linear model, which resulted in a good adjusted R^2 and all coefficients having small p-values.
   
   ![image](https://github.com/tanhl30/NBA-MVP-Predictor/assets/73421294/afbdd8cd-b2fd-4a2c-ae0a-6f095f34c47b)


### Result

| Player  | Predicted Vote Share | Actual Vote Share| Achievement | 
| ------------- | :---: | :---: |------------- |
| Nikola Jokić | 0.779  | 0.674 | Champion, Final MVP, All-NBA 2nd Team  |  
| **Joel Embiid**  | 0.626  | **0.915** | MVP, All-NBA 1st Team  |
| Giannis Antetokounmpo  |0.512 | 0.606  | All-NBA 1st Team | 
| Luka Dončić | 0.335  | 0.010 | All-NBA 1st Team  |
| Jimmy Butler | 0.310 | 0.002 | Runner up, All-NBA 2nd Team | 
| Jayson Tatum | 0.267 | 0.280 |All-NBA 1st Team |

### How should we interpret the linear regression modedl?

1. The relationship between a player's ability and the vote share they received is **never linaer**. In most year, the player ranked fifth in vote share only received <10% of the total vote share. But Joel Embiid (0.915 vote share) is not 100 times better than Luka Doncic (0.01 vote share).
2. Human bias such as media narrative, voter fatigue, historical performance and popularity significantly influence the voting process
3. More advanced statistics such as RAPTOR, LEBRON and team expected wins were not used in this model but could provide a more accurate assessment of a player's value.

Despite that, the linear regression model still produced good result (provided that you have the domain knowledge)

1. Nikola Jokic is ranked higher than Joel Embiid: It is widely agreed that Joel Embiid received a boost from narrative and voter fatigue (Nikola Jokic won the previous two MVPs), and that Jokic is the better player in that season
2. The top 6 players from the prediction closely match the actual top performers of the season, each achieving other notable achievements, as shown in the table above
3. The features selected are all very notably sound:
   - PER (Player Efficiency Rating): A comprehensive metric that amalgamates a player's positive contributions while subtracting the negative ones, resulting in a per-minute rating of a player's performance.
   - VORP (Value Over Replacement Player): This quantifies how many points per 100 TEAM possessions a player has contributed above a replacement-level player, defined as one with a rating of -2.0.
   - Team Wins: Only three MVPs in the past have hailed from teams with fewer than 50 wins (60% win rate), emphasizing the significance of a strong win rate in MVP candidacy.


### Conclusion
In terms of assessing a player's value to a teams independent of human bias, the model perform well.
Moving forward, I would very much like to fit this model with new season's data and explore other Machien Learning project as well.
