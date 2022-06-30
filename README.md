# colombo_rocco



# APPREDICT

This application is made for developers and researchers, but also could be used by common users.

This project is also a starting point for a more advanced application.

## DESCRIPTION

1. What is about?
    - It could be useful for tracking your sleep phases data collected by Fitbit 
    - It allows to predict your sleep efficiency based on the calories you spent during the day
    - Since it shows the relation between calories and sleep efficiency it could be used for research purpouse as well 
2. What pages are implemented in the app?
    - Custom login 
    - HomePage: button for fetching your data and insert them in the database
                displayed data (calories, sleep duration, time spent for each phase, sleep efficiency) and circular chart showing the different sleep phases 
    - ProfilePage: button for fetching your profile data (username, birthdate, gender, height and weight) and data persistence thanks to Shared Preferences
    - Calendar/Archive: button for day selection thanks to DataPicker widget, for each day is shown a circular chart displaying the different sleep phases with a brief         description including the prediction about the sleep efficiency.
    - Relation: In this page is shown a scatter graph with the relation between calories and sleep efficiency (effective and predicted).
 3. For whom is it?
    - Common users who want to track their sleep phases and sleep efficiency
    - Research project based on the relation between spent calories during the day and sleep quality
    - Developers for other uses

## REFERENCES

https://github.com/gcappon/bwthw
https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types
