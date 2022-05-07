from flask import Flask, jsonify, request,send_file
import sys 
import tensorflow as tf
import keras
from keras.models import load_model
#from sklearn.preprocessing import StandardScaler
import numpy as np
from numpy import array,ndarray
import pandas as pd
import pandas 
import matplotlib.pyplot as plt
import pickle
import json
import csv
import datetime
import pymongo
from pymongo import MongoClient
import os
from PIL import Image
import base64
from base64 import encodebytes
import io
#sc_X = StandardScaler()

app = Flask(__name__)


@app.route('/')
def home():
    return 'Hello world'

@app.route('/predict/a')
def get_prediction():

    
    bus_limit=60
    static_model=load_model("model24hrspredict.h5")
    dynamic_model=load_model("model2hrspredict(6hrsinput).h5")
    static_scaler=pickle.load(open("scalernew.pkl",'rb'))
    dynamic_scaler=pickle.load(open("scaler6hrswala.pkl",'rb'))

    ##def dynamic_changes(data,sch,start_time):
    ##  pred=dynamic_model.predict(data)[0]
    ## pred=schedule(dynamic_scaler.inverse_transform(pred.reshape(-1,1)))
    ## temp=sch[start_time:start_time+2]
    ## sch[start_time:start_time+2]=list(map(lambda x:x[0],pred))
        ##return sch

    def schedule(prediction):
        sch=[]
        for i,j in enumerate(prediction):
            print(f"{int(round(j[0]/bus_limit))} AT {str(i).zfill(2)}:00")
            sch.append([int(round(j[0]/bus_limit)),i])
        return sch

    def special_events(prediction):
        start=prediction['START']
        stop=prediction['STOP']
        magnitude=prediction['MAGNITUDE']
        prediction['TIMESERIES'][start:stop]=prediction['TIMESERIES'][start:stop]*(1.0+magnitude/100)
        return prediction

    def get_encoded_img(image_path):
        img = Image.open(image_path, mode='r')
        img_byte_arr = io.BytesIO()
        img.save(img_byte_arr, format='PNG')
        my_encoded_img = base64.encodebytes(img_byte_arr.getvalue()).decode('ascii')
        return my_encoded_img

    def static_time_table(data,special_timeseries=None):
        y_pred=static_model.predict(data)[0]
        if special_timeseries!=None:
            special_timeseries['TIMESERIES']=y_pred[0]
            y_pred=special_events(special_timeseries)['TIMESERIES']
        y_pred=static_scaler.inverse_transform(y_pred.reshape(-1,1))
        number=schedule(y_pred)
        return [number,y_pred]

    def get_response_image(image_path):
        pil_img = Image.open(image_path, mode='r') # reads the PIL image
        byte_arr = io.BytesIO()
        pil_img.save(byte_arr, format='PNG') # convert the PIL image to byte array
        encoded_img = encodebytes(byte_arr.getvalue()).decode('ascii') # encode as base64
        return encoded_img

    myClient = MongoClient("mongodb+srv://Ammar:QweAsdZxc@testing.xymiw.mongodb.net/myFirstDatabase?retryWrites=true&w=majority")
    db = myClient["myFirstDatabase"]
    col = db["in/out datas"]
    cursor = col.find()
    print("total docs in collection: ", col.count_documents({}))
    mongo_docs = list(cursor)
    docs = pandas.DataFrame(columns=["_id", "user_id", "bus_id", "longitude", "latitude", "status", "createdAt", "__v"])
    for num, doc in enumerate(mongo_docs):
        doc["_id"] = str(doc["_id"])
        doc_id = doc["_id"]
        series_obj = pandas.Series(doc, name=doc_id)
        docs = docs.append(series_obj)


    csv_export = docs.to_csv(sep=",")
    print("\nCSV data: ", csv_export)
    docs.to_csv("export2.csv", index=False)


    Bus = "A103"
    Type = "IN"
    Date = "2022-04-21"
    data = pd.read_csv('export2.csv')
    print(data.head())
    data.drop(["user_id", "_id", "__v", "longitude", "latitude"], axis=1, inplace=True)
    print(data.head())
    data['createdAt'] = pd.to_datetime(data.createdAt)
    data['createdAt'] = data['createdAt'].dt.strftime('%m/%d/%Y %H:%M:%S')
    #data['date_time'] = data['createdAt']
    data['NOP'] = 1
    #data.set_index('createdAt', inplace=True)
    print(data.head())
    bus = dict(data['bus_id'].value_counts())
    #data.drop(data[(data['status'] == 'OUT')].index, inplace=True)
    #data.drop(data[(data['bus_id'] != Bus)].index, inplace=True)
    data['createdAt'] = pd.to_datetime(data.createdAt)
    df = data.resample('60min', on='createdAt').sum()

    df.reset_index(inplace = True, drop = False)
    data['createdAt'] = data['createdAt'].dt.strftime('%m/%d/%Y %H:%M:%S')
    csv_export = df.to_csv(sep=",")

    print("\nCSV data: ", csv_export)
    df.to_csv("df558.csv", index=False)    
         


    data=pd.read_csv("df558.csv")

    data['createdAt']=pd.to_datetime(data['createdAt'],infer_datetime_format=True)
    data=data.iloc[:,-2:]
    data=data.set_index('createdAt')

    #data['traffic_volume']=sc_X.fit_transform(data['traffic_volume'].values.reshape(-1,1))
    static_scaler.clip = False

    data['NOP']=static_scaler.fit_transform(data['NOP'].values.reshape(-1,1))

    data=pd.read_csv("df558.csv")
    S,pred=static_time_table(data['NOP'][-24:].values.reshape(1,-1,1))

    plt.plot(pred,label='Prediction')
    plt.xlabel("Hours")
    plt.ylabel("Expected Crowd")
    plt.legend()
    fig=plt.savefig('plotff')
    
    image_path = 'plotff.png' # point to your image location
    encoded_img = get_response_image(image_path)
    #my_message = 'here is my message' # create your message as per your need
    #response =  {  'ImageBytes': encoded_img}
    # return jsonify(response) # send the result to client
    
    #plt.show()
    #print(type(pred))
    #framework = mongo.db.framework 

    #output = []
    predplot=array(pred)
    #predlist=predplot.tolist()
    image = get_encoded_img("plotff.png")

    predjson=json.dumps(predplot.tolist())
    busarr=array(num)
    #buslist=busarr.tolist()
    
    busjson=json.dumps(busarr.tolist())
    
    #b=a.tolist()
    #print(type(b))
    



    #for q in framework.find():
     #   output.append({'name' : q['name'], 'language' : q['language']})

    return  jsonify({"bus":busjson,'ImageBytes': encoded_img,"pred":predjson})







if __name__ == '__main__':
    app.run(debug=False,host='0.0.0.0')

    
