var User = require('../models/user')
var Ticket = require('../models/tickets')
var R_Ticket = require('../models/Reserverd_ticket')
var Activated_Ticket = require('../models/Ticket_activated')
const mongoose = require('mongoose')



var jwt = require('jwt-simple')
var config = require('../config/dbconfig')
const { db } = require('../models/user')

var functions = {
    addNew: function (req, res) {
        // If the name or the password is not provided
        if ((!req.body.name) || (!req.body.password)) {
            res.json({status: false, msg: 'Enter all fields'})
        }
        else {
            var newUser = User({
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
                            var id = jwt.encode(user, config.secret)
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
            var id = req.headers.authorization.split(' ')[1]
            var decoded_id = jwt.decode(id, config.secret)
            return res.json({status: true, msg: 'Hello ' + decoded_id.name})
        }
        else {
            return res.json({status: false, msg: 'No Headers'})
        }
    },

    //From the scanner 
    check_ticket: function (req, res){
        var ticket_data = Ticket({
            // Extract data from the body
            ticket_id: req.body.ticket_id,
            Bus_id: req.body.Bus_id,
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
                                        var one_hour = Activated_Ticket ({
                                            _id: result1.id,
                                            user_id:result1.user_id
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

    R_ticket: function (req, res){
        var R_ticket = R_Ticket({
            // Extract data from the body
            user_id: req.body.user_id
        });
        R_ticket.save(function (err, ticket) {
            if (err) {
                res.json({status: false, msg: 'Failed to save'})
            }
            else {
                //id will be generated from the MongoDB 
                res.json({status: true, msg: 'Your ticket has Successfully saved', id: ticket.id})
            }
        })
    },

    
}


module.exports = functions