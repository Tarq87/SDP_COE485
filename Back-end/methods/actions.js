let User = require('../models/user')
let Ticket = require('../models/tickets')
let R_Ticket = require('../models/Reserverd_ticket')
let Activated_Ticket = require('../models/Ticket_activated')
let Location_Bus_Station = require('../models/Bus_Station')
let Capacity = require('../models/Capacity')
let Bus_Location = require('../models/BusLocation')
let Points = require('../models/Points')
let Driver = require('../models/Drivers')
let Ticket_history = require('../models/Ticket_history')
let moment = require('moment')






const mongoose = require('mongoose')


let jwt = require('jwt-simple')
let config = require('../config/dbconfig')
const { db } = require('../models/user')
const Bus_Station = require('../models/Bus_Station')
const { eventNames } = require('npmlog')
const BusLocation = require('../models/BusLocation')
const { timeout } = require('nodemon/lib/config')
const { stringify } = require('nodemon/lib/utils')


let functions = {
    addNew: function (req, res) {
        let points_var = Points({

            user_id: req.body.name,

            points: 50

        })

        points_var.save()
        // If the name or the password is not provided
        if ((!req.body.name) || (!req.body.password)) {
            res.json({status: false, msg: 'Enter all fields'})
        }
        else {
            let newUser = User({
                // Extract the name and password from the
                // body of the request
                name: req.body.name,
                email: req.body.email,
                password: req.body.password
            });
            newUser.save(function (err, newUser) {
                if (err) {
                    res.json({status: false, msg: 'Failed to save'})
                }
                else {
                    res.json({status: true, msg: 'Successfully saved'})
                }
            })
        }
    },

    authenticate: function (req, res) {
        User.findOne({
            name: req.body.name
        }, function (err, user) {
                if (err) throw err
                if (!user) {
                    res.status(403).send({status: false, msg: 'Authentication Failed, User not found'})
                }

                else {
                    // After verifying that the username does exist
                    // check whether the password is right or not
                    user.comparePassword(req.body.password, function (err, isMatch) {
                        if (isMatch && !err) {
                            let id = jwt.encode(user, config.secret)
                            // return to the front-end the id
                            res.json({id: id, status: true})
                        }
                        else {
                            return res.status(403).send({status: false, msg: 'Authentication failed, wrong password'})
                        }
                    })
                }
        }
        )
    },
    getinfo: function (req, res) {
        if (req.headers.authorization && req.headers.authorization.split(' ')[0] === 'Bearer') {
            let id = req.headers.authorization.split(' ')[1]
            let decoded_id = jwt.decode(id, config.secret)
            return res.json({status: true, msg: 'Hello ' + decoded_id.name})
        }
        else {
            return res.json({status: false, msg: 'No Headers'})
        }
    },

    //From the scanner 
    check_ticket: function (req, res,next){
        let ticket_data = Ticket({
            // Extract data from the body
            ticket_id: req.body.ticket_id,
            bus_id: req.body.bus_id,
            longitude: req.body.longitude,
            latitude: req.body.latitude,
        });
        
        ticket_data.save(function (err, ticket_data) {
            if (err) {
                res.json({status: false, msg: 'Failed to save'})
            }
            else {
                check = req.body.ticket_id
                //first: check if the data are found in the activated ticekt
                Activated_Ticket.findById(check,function (err,result) {
                    if (err){
                        console.log(err);
                    }
                    else{
                        if (result == null){
                            //if ticket not found in the activated ticket, check the reserved ticket 
                            R_Ticket.findById(check,function (err,result1) {
                                if (err){
                                    console.log(err);
                                }
                                else{
                                    if (result1 == null){                            
                                        res.status(404).json({status: false, msg: 'Not valid'})
                                    }else {
                                        //found in reserved ticket? add the ticket to the activated ticket and remove it from reserved ticket 
                                        let one_hour = Activated_Ticket ({
                                            _id: result1.id,
                                            user_id:result1.user_id,
                                            type:result1.type
                                        })
                                        one_hour.save()
                                        result1.remove() //remove
                                        res.status(200).json({status: true, msg: 'valid'})
                                    }
                                }
                                
                            })

                        }else {
                            //console.log("Result : ",result );                          
                            res.status(200).json({status: true, msg: 'valid!'})
                        }
                    }
                    
                    
                })

            }
        })

    },
 
    R_ticket: async function (req, res){
        let R_ticket = R_Ticket({
            // Extract data from the body
            user_id: req.body.user_id,
            type: req.body.type

        });
        let returned_points = await Points.findOne({user_id: req.body.user_id})
        R_ticket.save(function (err, ticket) {
            if (err) {
                res.json({status: false, msg: 'Failed to save'})
            }
            else {
                // add 10 points for every ticket bought.
                let points_score = returned_points.points + 10
                console.log(">>>> " + returned_points)
                console.log(">>>> " + points_score)
                if(returned_points != null){
                    if(1<2){
                        const filter = { user_id: req.body.user_id }
                        const update = { points: points_score }
                        const options = { upsert: true }
                        Points.findOneAndUpdate(filter, update, 
                            options, function (err, docs){
                                if(err){
                                    res.json({status: false, msg: 'Failed to change the points'})
                                }else{
                                    Points.findOne({user_id: req.body.user_id}, function (err, docs){
                                        if(err){
                                            //res.json({status: false, msg: 'Failed to change the points'})
                                        }else{
                                            //res.json({points: docs.points})
                                        }
                                    })
                                }
                            }
                        )
                    }else{
                        //res.json({points: returned_points.points})
                    }
                }
                //id will be generated from the MongoDB 
                res.json({status: true, msg: 'Your ticket has Successfully saved', id: ticket.id})
            }
        })
    },

    Bus_Stops_List: async function (req, res){
        const all =  await Location_Bus_Station.find();
        let names = []
        let longitudes = []
        let latitudes = []

        for (i = 0 ; i < all.length ; i++) {
            names.push(all[i].name)
            longitudes.push(all[i].location.coordinates[0])
            latitudes.push(all[i].location.coordinates[1])
            
        }
        res.send({name:names, longitude:longitudes, latitude:latitudes})
    },
    
	Update_Tickets: async function (req, res){
        
        
         const Reserved = await R_Ticket.find({user_id:req.body.user_id});
         const activated = await Activated_Ticket.find({user_id:req.body.user_id});

         console.log(Reserved)
         console.log("Activated")
         console.log(activated)

         let ticket_ids = [];
         let ticket_types = [];
        
         for (i = 0 ; i < Reserved.length ; i++) {
             ticket_ids.push(Reserved[i]._id)
             ticket_types.push(Reserved[i].type)
         }

         for (i = 0 ; i < activated.length ; i++) {
            ticket_ids.push(activated[i]._id)
            ticket_types.push(activated[i].type)
        }



         res.send({ticket_id:ticket_ids, ticket_type:ticket_types}) 
         
    },
    BusLocation: async function (req,res) { 
            await Bus_Location.find({
                location: {
                    $near: {
                        $geometry: {
                            type: "Point",
                            coordinates: [req.body.lng,req.body.lat]
                        },
                       $maxDistance: 14,
                    }
                }
            }).find((err, results) => {
                if (err) { console.log(err) }
                console.log(JSON.stringify(results))
                res.json(results)

            }).catch((err) => {
                console.log(err)
            });
                    
    }, 
    addlocations: async function (req,res) {
        let bus_location = Bus_Location({
            // Extract data from the body
            bus_id: req.body.bus_id,
            location: req.body.location
        });
        bus_location.save()
        res.send("DONE")
    },

    request_buses_location: async function (req,res) {
        // MCS_Bus <=> Bus_Location FIX IT.
        const all = await Bus_Location.find();
        let bus_ids = []
        let longitudes = []
        let latitudes = []

        for (i = 0 ; i < all.length ; i++) {
            bus_ids.push(all[i].bus_id)
            longitudes.push(all[i].location.coordinates[0])
            latitudes.push(all[i].location.coordinates[1])
            
        }
        res.send({bus_id:bus_ids, longitude:longitudes, latitude:latitudes})
    },


    //This function takes in latitude and longitude of two location and returns the distance between them as the crow flies (in km)
    calcCrow: function (lat1, lon1, lat2, lon2) 
    {
        
        let R = 6371; // km
        let dLat = this.toRad(lat2-lat1);
        let dLon = this.toRad(lon2-lon1);
        let lat1 = this.toRad(lat1);
        let lat2 = this.toRad(lat2);

        let a = Math.sin(dLat/2) * Math.sin(dLat/2) +
        Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(lat1) * Math.cos(lat2); 
        let c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
        let d = R * c;
        return d*1000;
    },

    // Converts numeric degrees to radians
    toRad: function (Value) 
    {
        return Value * Math.PI / 180;
    },

        
    points: async function (req,res) {
        // let points_var = Points({
        //     user_id: req.body.user_id,
        //     points: req.body.points
        // })
        // points_var.save()
        let returned_points = await Points.findOne({user_id: req.body.user_id})
        if(returned_points != null){
            if(Number(returned_points.points)<50){
                const filter = { user_id: req.body.user_id }
                const update = { points: '50' }
                const options = { upsert: true }
                Points.findOneAndUpdate(filter, update, 
                    options, function (err, docs){
                        if(err){
                            res.json({status: false, msg: 'Failed to change the points'})
                        }else{
                            Points.findOne({user_id: req.body.user_id}, function (err, docs){
                                if(err){
                                    res.json({status: false, msg: 'Failed to change the points'})
                                }else{
                                    res.json({points: docs.points})
                                }
                            })
                        }
                    }
                )
            }else{
                res.json({points: returned_points.points})
            }
        }else{
            res.json({msg: "Cannot find the points of this user"})
        }
    },

    Bus_Capacity: async function (req,res) {
        const buses_capacity = await Capacity.find();
        console.log(stringify(buses_capacity))
        let bus_ids = []
        let capacity = []


        for (i = 0 ; i < buses_capacity.length ; i++) {
            bus_ids.push({bus_id:buses_capacity[i].bus_id, capacity: buses_capacity[i].capacity})
        }

    
        res.send(bus_ids)
    },

    get_users: async function (req, res){
        const all = await User.find()
        let users_info = []
        for (i = 0 ; i < all.length ; i++) {
            users_info.push({username:all[i].name, email: all[i].email})
        }
        res.send(users_info)
    },

    get_tickets: async function (req, res){
        const Reserved = await R_Ticket.find()
        const activated = await Activated_Ticket.find()
        let ticket_ids = []
        for (i = 0 ; i < Reserved.length ; i++) {
             ticket_ids.push({user_id: Reserved[i].user_id, ticket_id: Reserved[i]._id, ticket_type: Reserved[i].type, Date:  Reserved[i].createdAt})
        }
        for (i = 0 ; i < activated.length ; i++) {
            ticket_ids.push({user_id: activated[i].user_id, ticket_id: activated[i]._id, ticket_type: activated[i].type, Date:  activated[i].createdAt})
        }
        res.send(ticket_ids) 
    },

    get_driver: async function(req,res) {
        /*
        let driver_var = Driver({

            driver_name: req.body.driver_name,
            bus_id: req.body.bus_id

        })

        driver_var.save()
        res.send("DONE")
        */

        const all_drivers = await Driver.find()
        let drivers = []

        for (i = 0 ; i < all_drivers.length ; i++) {
            drivers.push({id:all_drivers[i].driver_id ,driver_name:all_drivers[i].driver_name, bus_id: all_drivers[i].bus_id})
        }
        res.send(drivers)

    },

    tickets_sales: async function (req,res){ 

        const first_day_week = moment().startOf("isoweek")
        const last_day_week = moment().endOf("isoweek")

        let all = await Ticket_history.find({
            createdAt: {
              $gte: first_day_week,
              $lte: last_day_week
            }
        })

        let today = moment();
        let yesterday = moment().add(-1,'days');
        let before0_yesterday = moment().add(-2,'days');
        let before1_yesterday = moment().add(-3,'days');
        let before2_yesterday = moment().add(-4,'days');
        let before3_yesterday = moment().add(-5,'days');

        let today_ticket = 0 
        let yesterday_ticket = 0 
        let yesterday0_ticket = 0 
        let yesterday1_ticket = 0 
        let yesterday2_ticket = 0 
        let yesterday3_ticket = 0 

        console.log (all)
        for (i = 0 ; i < all.length ; i++) {
            if (moment(today).isAfter(all[i].createdAt) && moment(yesterday).isBefore(all[i].createdAt)){
                console.log ("111111")
                today_ticket = today_ticket + 1
            }else if (moment(yesterday).isAfter(all[i].createdAt) && moment(before0_yesterday).isBefore(all[i].createdAt)){
                yesterday_ticket = yesterday_ticket +1
            }else if (moment(before0_yesterday).isAfter(all[i].createdAt) && moment(before1_yesterday).isBefore(all[i].createdAt)){
                yesterday0_ticket = yesterday0_ticket +1
            }else if (moment(before1_yesterday).isAfter(all[i].createdAt) && moment(before2_yesterday).isBefore(all[i].createdAt)){
                yesterday1_ticket = yesterday1_ticket +1
            }else if (moment(before2_yesterday).isAfter(all[i].createdAt) && moment(before3_yesterday).isBefore(all[i].createdAt)){
                yesterday2_ticket = yesterday2_ticket +1
            }else if (moment(before3_yesterday).isAfter(all[i].createdAt)){
                yesterday3_ticket = yesterday3_ticket +1
            }
        }

        let arr = [{ticket_sales: today_ticket, Date: today.format('LL')},{ticket_sales:yesterday_ticket, Date:yesterday.format('LL')},{ticket_sales:yesterday0_ticket, Date:before0_yesterday.format('LL')},{ticket_sales:yesterday1_ticket, Date: before1_yesterday.format('LL')},{ticket_sales:yesterday2_ticket, Date:before2_yesterday.format('LL')},{ticket_sales:yesterday3_ticket, Date: before3_yesterday.format('LL')}]
        res.send(arr)

    }

}

        




module.exports = functions