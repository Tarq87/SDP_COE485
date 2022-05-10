import pickle
import csv
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.tree import DecisionTreeRegressor
import pandas
from pymongo import MongoClient
import csv
import json
import datetime

myClient = MongoClient("mongodb+srv://Ammar:QweAsdZxc@testing.xymiw.mongodb.net/myFirstDatabase?retryWrites=true&w=majority")
db = myClient["MachineLearningData"]
col = db["Schedule"]
cursor = col.find()
print("total docs in collection: ", col.count_documents({}))
mongo_docs = list(cursor)
docs = pandas.DataFrame(columns=["_id", "ride_id", "travel_from", "date"])
for num, doc in enumerate(mongo_docs):
    doc["_id"] = str(doc["_id"])
    doc_id = doc["_id"]
    series_obj = pandas.Series(doc, name=doc_id)
    docs = docs.append(series_obj)
docs.drop(["_id"], axis=1, inplace=True)
csv_export = docs.to_csv(sep=",")
print("\nCSV data: ", csv_export)
docs.to_csv("schedule_exported.csv", index=False)
pd.set_option('display.max_columns', None)
pd.set_option('display.width', None)
pd.set_option('display.max_colwidth', None)

schedule = pd.read_csv('schedule_exported.csv')
Transport_df = schedule
def time_features(df):
    '''This function takes dataframe as an argument and extracts the
    different features from the date variable of the dataset and finaly returns the updated
    dataset'''

    df["date"] = pd.to_datetime(df["date"])
    df["day_of_week"] = df["date"].dt.dayofweek
    df["day_of_year"] = df["date"].dt.dayofyear
    df["hour"] = df["date"].dt.hour
    df["minute"] = df["date"].dt.minute
    df["is_weekend"] = df["day_of_week"].apply(lambda x: 1 if x in [5, 6] else 0)
    df["year"] = df["date"].dt.year
    df["quarter"] = df["date"].dt.quarter
    return df


Transport_df1 = time_features(Transport_df)
data = pd.get_dummies(Transport_df1, columns=['travel_from'])
data.drop(["date"], axis=1, inplace=True)
ride_ids = data["ride_id"]
data.drop(["ride_id"], axis=1, inplace=True)
filename = 'finalized_model.sav'
loaded_model = pickle.load(open(filename, 'rb'))
print(data)
result = loaded_model.predict(data)
#c = pd.concat([data, pd.DataFrame(ride_ids)], axis=1)
#c = pd.concat([c, pd.DataFrame(result)], axis=1)
schedule = pd.read_csv('schedule_exported.csv')
n = pd.to_datetime(schedule.date)
new_schedule = pd.concat([schedule, n.dt.day_name(), n.dt.isocalendar().week], axis=1)
new_schedule.columns = ["ride_id", "travel_from", "date", "Day", "Week No."]
new_schedule.to_json('schedule.json', orient='records')
print(new_schedule)
demand = pd.concat([schedule, n.dt.day_name(), n.dt.isocalendar().week, pd.DataFrame(result)], axis=1)
demand.columns = ["ride_id", "travel_from", "date", "Day", "Week No.", "number_of_passengers"]
print(demand)
demand.to_json('trip_demand.json', orient='records')

